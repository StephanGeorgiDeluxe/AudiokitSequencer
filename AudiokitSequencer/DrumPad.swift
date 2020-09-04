//
//  DrumPad.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 18.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import AudioKit

class DrumPad {
    let output: AKMixer
    let drum: Drums

    private var player: AKAppleSampler?

    init(audioFile: AKAudioFile, drumType: Drums) {
        guard let player = audioFile.sampler else {
            print("Error can't init sampler")
            output = AKMixer()
            drum = drumType
            return
        }

        self.player = player
        output = AKMixer([player])
        drum = drumType
    }

    func play(_ velocity: MIDIVelocity = 127) {
        guard let player = player else {
            print ("Error: can't play sampler")
            return
        }
        try? player.play(noteNumber: drum.note().noteNumber, velocity: velocity)
    }

    func stop() {
        try? player?.stop()
    }
}
