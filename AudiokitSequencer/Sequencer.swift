//
//  Sequencer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 18.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import AudioKit

enum Drums: UInt8, CaseIterable {
    case bdrum = 24
    case sdrum = 26
    case clap = 28
    case hhClosed = 25
    case hhOpen = 27
    case tomLow = 29
    case tomMid = 31
    case tomHi = 33

    func trackNumber() -> Int {
        switch self {
        case .bdrum: return 0
        case .sdrum: return 1
        case .clap: return 2
        case .hhClosed: return 3
        case .hhOpen: return 4
        case .tomLow: return 5
        case .tomMid: return 6
        case .tomHi: return 7
        }
    }

    func note(velocity: MIDIVelocity = 127, duration: AKDuration = AKDuration(beats: 1), position: AKDuration = AKDuration(beats: 0)) -> AKMIDINoteData {
        return AKMIDINoteData(noteNumber: self.rawValue,
                              velocity: velocity,
                              channel: 0,
                              duration: duration,
                              position: position)
    }
}

class Sequencer {
    let sequencer = AKAppleSequencer()
    var tracks: Array<AKMusicTrack> = []

    let callbackInstrument = AKMIDICallbackInstrument()
    var callBack: AKMIDICallback?

    init() {
        setUpCallBackInstrument()
        setUpSequncer()

    }

    func setUpCallBackInstrument() {
        callbackInstrument.callback = { (statusByte, note, velocity) in
            self.callBack?(statusByte, note, velocity)
        }
    }

    func setUpSequncer() {
        sequencer.clearRange(start: AKDuration(beats: 0), duration: AKDuration(beats: 100))

        sequencer.setTempo(130)

        for (index, _) in Drums.allCases.enumerated() {
            if let track = sequencer.newTrack("track_\(index)") {
                tracks.append(track)
            }
        }

        sequencer.setGlobalMIDIOutput(callbackInstrument.midiIn)

        add(note: Drums.bdrum.note(velocity: .max, duration: AKDuration.init(beats: 1), position: AKDuration.init(beats: 0)))
        add(note: Drums.bdrum.note(velocity: .max, duration: AKDuration.init(beats: 1), position: AKDuration.init(beats: 1)))
        add(note: Drums.bdrum.note(velocity: .max, duration: AKDuration.init(beats: 1), position: AKDuration.init(beats: 2)))
        add(note: Drums.bdrum.note(velocity: .max, duration: AKDuration.init(beats: 1), position: AKDuration.init(beats: 3)))

        add(note: Drums.sdrum.note(velocity: .max, duration: AKDuration.init(beats: 1), position: AKDuration.init(beats: 1)))
        add(note: Drums.sdrum.note(velocity: .max, duration: AKDuration.init(beats: 1), position: AKDuration.init(beats: 3)))

        add(note: Drums.hhOpen.note(velocity: 92, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 0.5)))
        add(note: Drums.hhOpen.note(velocity: 92, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 1.5)))
        add(note: Drums.hhOpen.note(velocity: 92, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 2.5)))
        add(note: Drums.hhOpen.note(velocity: 92, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 3.5)))

        add(note: Drums.hhClosed.note(velocity: 32, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 0)))
        add(note: Drums.hhClosed.note(velocity: 32, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 1)))
        add(note: Drums.hhClosed.note(velocity: 32, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 2)))
        add(note: Drums.hhClosed.note(velocity: 32, duration: AKDuration.init(beats: 0.5), position: AKDuration.init(beats: 3)))
    }

    func add(note: AKMIDINoteData) {
        guard let drum = Drums(rawValue: note.noteNumber) else { return }
        let trackIndex = drum.trackNumber()
        let track = sequencer.tracks[trackIndex]
        track.add(midiNoteData: note)
    }
}
