//
//  Sequencer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 17.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import AudioKit

class Sampler {
    let sampler = AKMIDISampler()
    lazy var bdrum: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/bd01_C1.wav") }()
    lazy var hhClosed: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/hh01_C#1.wav") }()
    lazy var hhOpen: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/oh01_D#1.wav") }()
    lazy var sdrum: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/sd01_D1.wav") }()
    lazy var clap: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/cp01_E1.wav") }()
    lazy var tomLow: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/lt01_F1.wav") }()
    lazy var tomMid: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/mt01_G1.wav") }()
    lazy var tomHi: AKAudioFile = { return try! AKAudioFile(readFileName: "Drums/ht01_A1.wav") }()


    init() {
        setUpSampler()
    }

    func setUpSampler() {
        let files = [bdrum, sdrum, clap, hhClosed, hhOpen, tomHi, tomMid, tomLow]
        do {
            try sampler.loadAudioFiles(files)
        } catch {
            print("Error loading audio file to sampler")
        }
    }
}
