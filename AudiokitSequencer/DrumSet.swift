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
        return DrumPad(audioFile: file, drumType: .bdrum)
    }()
    let sdrum: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/sd01_D1.wav")
        return DrumPad(audioFile: file, drumType: .sdrum)
    }()

    let hhClosed: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/hh01_C#1.wav")
        return DrumPad(audioFile: file, drumType: .hhClosed)
    }()

    let hhOpen: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/oh01_D#1.wav")
        return DrumPad(audioFile: file, drumType: .hhOpen)
    }()

    let clap: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/cp01_E1.wav")
        return DrumPad(audioFile: file, drumType: .clap)
    }()

    let tomLow: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/lt01_F1.wav")
        return DrumPad(audioFile: file, drumType: .tomLow)
    }()
    let tomMid: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/mt01_G1.wav")
        return DrumPad(audioFile: file, drumType: .tomMid)
    }()
    let tomHi: DrumPad = {
        let file = try! AKAudioFile(readFileName: "Drums/ht01_A1.wav")
        return DrumPad(audioFile: file, drumType: .tomHi)
    }()

    lazy var mixer: AKMixer = {
        return AKMixer([bdrum.output,
                        sdrum.output,
                        clap.output,
                        hhClosed.output,
                        hhOpen.output,
                        tomLow.output,
                        tomMid.output,
                        tomHi.output])
    }()

    func receivedMidiCallBack(statusByte: MIDIByte, note: MIDIByte, velocity: MIDIByte) {
        guard let status = AKMIDIStatus(byte: statusByte) else { return }

        switch status.type {
        case .noteOn: play(note: note, velocity: velocity)
        case .noteOff: stop(note: note)
        default: break
        }
    }

    private func play(note: MIDIByte, velocity: MIDIByte) {
        guard let drum = Drums(rawValue: note) else {
            print( "Error playing note: \(note)")
            return
        }

        switch drum {
        case .setUp: break
        case .bdrum: bdrum.play(velocity)
        case .sdrum: sdrum.play(velocity)
        case .clap: clap.play(velocity)
        case .hhOpen: hhOpen.play(velocity)
        case .hhClosed: hhClosed.play(velocity)
        case .tomLow: tomLow.play(velocity)
        case .tomMid: tomMid.play(velocity)
        case .tomHi: tomHi.play(velocity)
        }
    }

    private func stop(note: MIDIByte) {
        switch Drums(rawValue: note) {
        case .bdrum: bdrum.stop()
        case .sdrum: sdrum.stop()
        case .hhOpen: hhOpen.stop()
        case .hhClosed: hhClosed.stop()
        case .tomLow: tomLow.stop()
        case .tomMid: tomMid.stop()
        case .tomHi: tomHi.stop()

        default: break
        }
    }
}
