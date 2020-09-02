//
//  ViewController.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 23.07.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    let env = AKAmplitudeEnvelope()
    let note = MIDINoteNumber(40)

    let drums = Sampler()
    let sequencer = Sequencer()

    let drumSet = DrumSet()

    var padButtons: [PadButton] = []

    @IBOutlet weak var tracksStackView: TracksStackView!
    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var loopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        AudioKit.output = drumSet.mixer
        setUpSequencer()
        try? AudioKit.start()
    }

    func setUpSequencer() {
        sequencer.callBack = { (statusByte, note, velocity) in
            self.drumSet.receivedMidiCallBack(statusByte: statusByte, note: note, velocity: velocity)
            self.tracksStackView.receivedMidiCallBack(statusByte: statusByte, note: note, velocity: velocity)
        }

        sequencer.enableLooping()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillTracks()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    func fillTracks() {
        tracksStackView.fillTracks(sequencer: sequencer,
                                   tracks: [.bdrum,
                                            .sdrum,
                                            .clap,
                                            .hhClosed,
                                            .hhOpen,
                                            .tomHi,
                                            .tomMid,
                                            .tomLow ])

    }

    @IBAction func didTouchUpInside(_ sender: Any) {
        if sequencer.isPlaying() {
            sequencer.stop()
            startButton.setTitle("Play", for: .normal)
        } else {
            sequencer.play()
            startButton.setTitle("Stop", for: .normal)
        }

    }
    @IBAction func didTouchLoopButton(_ sender: Any) {
        if sequencer.loopEnabled() {
            loopButton.setTitle("loop off", for: .normal)
            sequencer.toggleLoop()
        } else {
            loopButton.setTitle("loop on", for: .normal)
            sequencer.toggleLoop()
        }
    }
    @IBAction func didTouchRemoveButton(_ sender: Any) {
        sequencer.remove(drumNote: .tomHi, position: 0.25)
    }

    @IBAction func didTouchAddButton(_ sender: Any) {
        sequencer.add(drumNote: .tomHi, position: 0.25)
    }
}

