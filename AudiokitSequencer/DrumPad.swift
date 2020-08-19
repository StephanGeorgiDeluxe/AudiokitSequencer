//
//  DrumPad.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 18.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import AudioKit

class DrumPad {
    let player: AKNode

    init(audioFile: AKAudioFile) {
        player = try! AKAudioPlayer(file: audioFile)
    }

    func play(_ velocity: MIDIVelocity = 127) {
        guard let player = player as? AKAudioPlayer else { return }
        let volume = Double(min(Double(velocity), Double(127)) / Double(127))
        player.volume = volume
        player.play()
    }

    func stop() {
        guard let player = player as? AKAudioPlayer else { return }
        player.stop()
    }
}
