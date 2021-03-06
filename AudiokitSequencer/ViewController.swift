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
    let sequencer = Sequencer()
    let drumSet = DrumSet()

    @IBOutlet weak var tracksStackView: TracksStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        AudioKit.output = drumSet.mixer
        try? AudioKit.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let tracksViewModel = TracksStackViewModel(sequencer: sequencer,
                                                   drumTypes: [.bdrum,
                                                               .sdrum,
                                                               .clap,
                                                               .hhClosed,
                                                               .hhOpen,
                                                               .tomHi,
                                                               .tomMid,
                                                               .tomLow])
        tracksStackView.tracksStackViewModel = tracksViewModel

        sequencer.callBack = { (statusByte, note, velocity) in
            self.drumSet.receivedMidiCallBack(statusByte: statusByte, note: note, velocity: velocity)
            tracksViewModel.receivedMidiCallBack(statusByte: statusByte, note: note, velocity: velocity)
        }

        sequencer.enableLooping()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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
}

