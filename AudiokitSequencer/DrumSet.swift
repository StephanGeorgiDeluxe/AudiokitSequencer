//
//  DrumSet.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 19.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import AudioKit
class DrumSet: AKMIDIInstrument {
    
    let bdrum: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/bd01_C1.wav")
        return DrumPad(audioFile: file)
    }()
    let sdrum: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/sd01_D1.wav")
        return DrumPad(audioFile: file)
    }()

    let hhClosed: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/hh01_C#1.wav")
        return DrumPad(audioFile: file)
    }()

    let hhOpen: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/oh01_D#1.wav")
        return DrumPad(audioFile: file)
    }()

    let clap: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/cp01_E1.wav")
        return DrumPad(audioFile: file)
    }()

    let tomLow: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/lt01_F1.wav")
        return DrumPad(audioFile: file)
    }()
    let tomMid: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/mt01_G1.wav")
        return DrumPad(audioFile: file)
    }()
    let tomHi: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/ht01_A1.wav")
        return DrumPad(audioFile: file)
    }()

    lazy var mixer: AKMixer = {
        return AKMixer([bdrum.player,
                        sdrum.player,
                        clap.player,
                        hhClosed.player,
                        hhOpen.player,
                        tomLow.player,
                        tomMid.player,
                        tomHi.player])
    }()

    func receivedMidiCallBack(statusByte: MIDIByte, note: MIDIByte, velocity: MIDIByte) {
        if statusByte == 144 {
            switch note {
            case Drums.bdrum.rawValue: bdrum.play(velocity)
            case Drums.sdrum.rawValue: sdrum.play(velocity)
            case Drums.hhOpen.rawValue: hhOpen.play(velocity)
            case Drums.hhClosed.rawValue: hhClosed.play(velocity)
            case Drums.tomLow.rawValue: tomLow.play(velocity)
            case Drums.tomMid.rawValue: tomMid.play(velocity)
            case Drums.tomHi.rawValue: tomHi.play(velocity)

            default: break
            }
        }

        if statusByte == 128 {
            switch note {
            case Drums.bdrum.rawValue: bdrum.stop()
            case Drums.sdrum.rawValue: sdrum.stop()
            case Drums.hhOpen.rawValue: hhOpen.stop()
            case Drums.hhClosed.rawValue: hhClosed.stop()
            case Drums.tomLow.rawValue: tomLow.stop()
            case Drums.tomMid.rawValue: tomMid.stop()
            case Drums.tomHi.rawValue: tomHi.stop()

            default: break
            }
        }
    }

    override func receivedMIDINoteOn(_ noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, offset: MIDITimeStamp = 0) {
        super.receivedMIDINoteOn(noteNumber, velocity: velocity, channel: channel, offset: offset)
    }
}
