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

    let oscillator = AKOscillatorFilterSynth(waveform: AKTable.init(.sine, phase: 0, count: .bitWidth))
    let delay = AKDelay()

    let env = AKAmplitudeEnvelope()
    let note = MIDINoteNumber(40)

    let drums = Sampler()
    let sequencer = Sequencer()

    let drumSet = DrumSet()

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioKit.output = drumSet.mixer
        setUpSequencer()
        try? AudioKit.start()
    }

    func setUpOscillator() {
        oscillator.attackDuration = 0
        oscillator.decayDuration = 0.10
        oscillator.sustainLevel = 0
        oscillator.releaseDuration = 0.50

        oscillator.setOutput(to: delay)
    }

    func setUpSequencer() {
        sequencer.callBack = { (statusByte, note, velocity) in
            self.drumSet.receivedMidiCallBack(statusByte: statusByte, note: note, velocity: velocity)
        }
    }

    @IBAction func didTouchUpInside(_ sender: Any) {
//        oscillator.reset()
//        oscillator.play(noteNumber: note, velocity: 127, frequency: 90)
//        drumPad.play()
//         try? drums.sampler.play(noteNumber: 24, velocity: 127, channel: 0)
        sequencer.sequencer.preroll()
        sequencer.sequencer.rewind()
        sequencer.sequencer.play()
    }

}

