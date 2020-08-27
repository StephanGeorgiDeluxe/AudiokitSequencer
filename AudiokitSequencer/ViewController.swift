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
        }

        sequencer.enableLooping()
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
        sequencer.remove(drumNote: .bdrum, position: 0)
    }

    @IBAction func didTouchAddButton(_ sender: Any) {
        sequencer.add(drumNote: .bdrum, position: 0)
    }
}

