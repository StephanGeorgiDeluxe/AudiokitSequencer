//
//  Sequencer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 18.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import AudioKit

enum NoteLength: Double {
    case whole = 1.0
    case half = 0.5
    case quarter = 0.25

    func duration() -> AKDuration {
        return AKDuration(beats: self.rawValue)
    }
}

enum NoteVelocity: MIDIVelocity {
    case full = 127
    case higher = 112
    case high  = 96
    case midHigh = 80
    case mid = 64
    case lowHigh = 48
    case low = 32
    case lower = 16
    case zero = 0
}

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

enum ShiftDirection {
    case fowards
    case backwards
}

class Sequencer {
    private let preShiftBeats: Double = 1.0

    private let sequencer = AKAppleSequencer()
    private var tracks: Array<AKMusicTrack> = []

    private let callbackInstrument = AKMIDICallbackInstrument()

    var callBack: AKMIDICallback?

    init() {
        setUpCallBackInstrument()
        setUpSequncer()
    }

    private func setUpCallBackInstrument() {
        callbackInstrument.callback = { (statusByte, note, velocity) in
            self.callBack?(statusByte, note, velocity)
        }
    }

    private func setUpSequncer() {
        sequencer.clearRange(start: AKDuration(beats: 0), duration: AKDuration(beats: 100))
        sequencer.setTempo(130)

        for (index, _) in Drums.allCases.enumerated() {
            if let track = sequencer.newTrack("track_\(index)") {
                tracks.append(track)
            }
        }

        sequencer.setGlobalMIDIOutput(callbackInstrument.midiIn)

        add(drumNote: .bdrum, position: 0)
        add(drumNote: .bdrum, position: 1)
        add(drumNote: .bdrum, position: 2)
        add(drumNote: .bdrum, position: 3)

        add(drumNote: .sdrum, position: 1)
        add(drumNote: .sdrum, position: 3)

        add(drumNote: .hhClosed, position: 0, velocity: .lower)
        add(drumNote: .hhClosed, position: 1, velocity: .low)
        add(drumNote: .hhClosed, position: 2, velocity: .lower)
        add(drumNote: .hhClosed, position: 3, velocity: .low)

        add(drumNote: .hhClosed, position: 0.5, velocity: .mid)
        add(drumNote: .hhClosed, position: 1.5, velocity: .mid)
        add(drumNote: .hhClosed, position: 2.5, velocity: .mid)

        add(drumNote: .hhOpen, position: 3.5, duration: .half, velocity: .mid)
    }

    private func add(note: AKMIDINoteData) {
        guard let drum = Drums(rawValue: note.noteNumber) else { return }
        let trackIndex = drum.trackNumber()
        let track = sequencer.tracks[trackIndex]
        track.add(midiNoteData: note)
    }

    private func remove(note: AKMIDINoteData) {
        guard let drum = Drums(rawValue: note.noteNumber) else { return }
        let trackIndex = drum.trackNumber()
        let track = sequencer.tracks[trackIndex]
        let midiNotes = track.getMIDINoteData()
        let nodes = midiNotes.filter({ !($0.position == AKDuration(beats: note.position.beats + preShiftBeats) &&  $0.noteNumber == note.noteNumber) })
        track.replaceMIDINoteData(with: nodes)

    }

    func add(drumNote: Drums,
             position: Double,
             duration: NoteLength = .whole,
             velocity: NoteVelocity = .full) {
        add(note: drumNote.note(velocity: velocity.rawValue,
                                duration: duration.duration(),
                                position: AKDuration(beats: position)))
    }

    func remove(drumNote: Drums,
                position: Double) {
        remove(note: drumNote.note(velocity: .max,
                                   duration: AKDuration(beats: 1),
                                   position: AKDuration(beats: position)))
    }

    func play() {
        shiftAllMidiNotes(.fowards)
        sequencer.preroll()
        sequencer.rewind()
        sequencer.play()
    }

    func shiftAllMidiNotes(_ direction: ShiftDirection) {
        for track in sequencer.tracks {
            let midiNotes = track.getMIDINoteData()
            let shiftedNotes = midiNotes.map { (note) -> AKMIDINoteData in
                var shiftedNote = note
                switch direction {
                case .fowards:
                    shiftedNote.position = AKDuration(beats: note.position.beats + preShiftBeats)
                case .backwards:
                    shiftedNote.position = AKDuration(beats: note.position.beats - preShiftBeats)
                }
                return shiftedNote
            }
            track.replaceMIDINoteData(with: shiftedNotes)
        }
    }

    func stop() {
        sequencer.stop()
    }

    func isPlaying() -> Bool {
        return sequencer.isPlaying
    }

    func enableLooping() {
        sequencer.enableLooping()
    }

    func toggleLoop() {
        sequencer.toggleLoop()
    }

    func loopEnabled() -> Bool {
        return sequencer.loopEnabled
    }
}
