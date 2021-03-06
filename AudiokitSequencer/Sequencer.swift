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

    static func velocityStage(from velocity: MIDIVelocity) -> NoteVelocity{
        switch velocity {
        case 0: return .zero
        case 1..<16: return .lower
        case 16..<32: return .low
        case 32..<48: return .lowHigh
        case 48..<64: return .mid
        case 64..<80: return .midHigh
        case 80..<96: return .high
        case 96..<112: return .higher
        case 112..<127: return .full
        default:
            return .full
        }
    }
}

enum Drums: UInt8, CaseIterable {
    case setUp = 0
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
        case .setUp: return 0
        case .bdrum: return 1
        case .sdrum: return 2
        case .clap: return 3
        case .hhClosed: return 4
        case .hhOpen: return 5
        case .tomLow: return 6
        case .tomMid: return 7
        case .tomHi: return 8
        }
    }

    func stackNumber() -> Int {
        switch self {
        case .setUp: return -1
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
    var preShiftBeats: Double = 1.0
    var looplength: Int = 16
    var grooveDelay: Double = 0.02
    private let sequencer = AKAppleSequencer()
    private var tracks: Array<AKMusicTrack> = []
    private let callbackInstrument = AKMIDICallbackInstrument()

    var didToggleNote: ((Drums, Int, Bool) -> Void)?
    var didChangeVelocity: ((Drums, Int, NoteVelocity) -> Void)?

    var callBack: AKMIDICallback?

    init() {
        setUpCallBackInstrument()
        setUpSequencer()
    }

    private func setUpCallBackInstrument() {
        callbackInstrument.callback = { (statusByte, note, velocity) in
            self.callBack?(statusByte, note, velocity)
        }
    }

    private func setUpSequencer() {
        sequencer.clearRange(start: AKDuration(beats: 0), duration: AKDuration(beats: 100))
        sequencer.setTempo(120)

        for (index, _) in Drums.allCases.enumerated() {
            if let track = sequencer.newTrack("track_\(index)") {
                tracks.append(track)
            }
        }

        sequencer.setGlobalMIDIOutput(callbackInstrument.midiIn)

        for index in 0..<16 {
            let pos = Double(index * 0.25)
            let velocity = index + 1
            addSetUpNote(position: pos, velocity: MIDIVelocity(velocity))
        }

        add(drumNote: .bdrum, position: 0)
        add(drumNote: .bdrum, position: 1)
        add(drumNote: .bdrum, position: 2)
        add(drumNote: .bdrum, position: 3)
        add(drumNote: .bdrum, position: 3.75)

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

        add(drumNote: .tomHi, position: 0.25)
        add(drumNote: .tomMid, position: 1.75)
        add(drumNote: .tomLow, position: 2.25)
        add(drumNote: .tomMid, position: 3.25)
        add(drumNote: .tomLow, position: 3.5, duration: .half)

        add(drumNote: .clap, position: 0.75)
        add(drumNote: .clap, position: 1, velocity: .lowHigh)
        add(drumNote: .clap, position: 2.25, velocity: .lower)

        sequencer.preroll()
    }

    func play() {
        sequencer.setLoopInfo(AKDuration(beats: 4), numberOfLoops: 100)
        sequencer.setLength(AKDuration(beats: 4 + preShiftBeats))
        sequencer.enableLooping(AKDuration(beats: 4))
        sequencer.play()
    }

    func stop() {
        sequencer.stop()
        sequencer.rewind()
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

    func toggleNote(index: Int, drumType: Drums) {
        let activePositionIndexes = activeNotePositions(drumType)
        let isActive = activePositionIndexes.filter({ $0 == index }).count > 0
        let position = Double(index * NoteLength.quarter.rawValue)
        remove(drumNote: drumType, position: position)

        if isActive == false {
            add(drumNote: drumType, position: position, velocity: .full)
        }

        didToggleNote?(drumType, index, isActive == false)
    }

    func changeNote(index: Int, drumType: Drums, veloctiy: NoteVelocity) {
        let activePositionIndexes = activeNotePositions(drumType)
        let isActive = activePositionIndexes.filter({ $0 == index }).count > 0
        let position = Double(index * NoteLength.quarter.rawValue)

        switch isActive {
        case true:
            edit(drumNote: drumType, position: position, velocity: veloctiy)
        case false:
            remove(drumNote: drumType, position: position)
            add(drumNote: drumType, position: position, velocity: veloctiy)
        }

        didChangeVelocity?(drumType, index, veloctiy)
    }

    func activeNotePositions(_ drum: Drums) -> [Int] {
        let midiData = activeNotes(drum)
        let positions = activeIndexes(notes: midiData, quantisizeUnit: .quarter)

        return positions
    }

    func activeIndexes(notes: [AKMIDINoteData], quantisizeUnit: NoteLength) -> [Int] {
        let positions = notes.map { (note) -> Int in
            let quantizised = Sequencer.processBackNotePosition(note.position.beats,
                                                                preShiftBeats: preShiftBeats,
                                                                grooveDelay: grooveDelay)
            let quantizisedNotePositions = Int(quantizised / quantisizeUnit.rawValue)
            return quantizisedNotePositions
        }

        return positions
    }

    func activeNotes(_ drum: Drums) -> [AKMIDINoteData] {
        let trackNumber = drum.trackNumber()
        let track = sequencer.tracks[trackNumber]
        let midiData = track.getMIDINoteData()
        return midiData
    }
}


extension Sequencer {

    private func addSetUpNote(position: Double, velocity: MIDIVelocity) {
        add(note: Drums.setUp.note(velocity: velocity,
                                   duration: NoteLength.quarter.duration(),
                                   position: AKDuration(beats: position)))
    }

    private func add(drumNote: Drums,
             position: Double,
             duration: NoteLength = .quarter,
             velocity: NoteVelocity = .full) {

        add(note: drumNote.note(velocity: velocity.rawValue,
                                duration: duration.duration(),
                                position: AKDuration(beats: position)))
    }

    private func add(note: AKMIDINoteData) {
        guard let drum = Drums(rawValue: note.noteNumber) else { return }
        let note = processNote(note,
                               preShiftBeats: preShiftBeats,
                               grooveDelay: grooveDelay)
        let trackIndex = drum.trackNumber()
        let track = sequencer.tracks[trackIndex]
        track.add(midiNoteData: note)
    }

    private func edit(drumNote: Drums,
              position: Double,
              duration: NoteLength = .quarter,
              velocity: NoteVelocity = .full) {
        remove(drumNote: drumNote,
               position: position)
        if (velocity != .zero) {
            add(drumNote: drumNote,
                position: position,
                velocity: velocity)
        }
    }

    private func remove(drumNote: Drums,
                position: Double) {
        remove(note: drumNote.note(velocity: 0,
                                   duration: AKDuration(beats: 1),
                                   position: AKDuration(beats: position)))
    }

    private func remove(note: AKMIDINoteData) {
        guard let drum = Drums(rawValue: note.noteNumber) else { return }
        let note = processNote(note,
                               preShiftBeats: preShiftBeats,
                               grooveDelay: grooveDelay)
        let trackIndex = drum.trackNumber()
        let track = sequencer.tracks[trackIndex]
        let midiNotes = track.getMIDINoteData()
        let nodes = midiNotes.filter({ !($0.position == AKDuration(beats: note.position.beats) &&  $0.noteNumber == note.noteNumber) })
        track.replaceMIDINoteData(with: nodes)
    }

    private func processNote(_ note: AKMIDINoteData, preShiftBeats: Double, grooveDelay: Double) -> AKMIDINoteData {
        let position = note.position.beats
        var processedPosition = position + preShiftBeats
        var processedDuration = note.duration.beats
        let remainder = position.truncatingRemainder(dividingBy: 1.0)

        switch remainder {
        case 0.25, 0.75:
            processedPosition = processedPosition + grooveDelay
            processedDuration = processedDuration - (grooveDelay + 0.01)
        default: break
        }

        var note = note
        note.position = AKDuration(beats: processedPosition)
        note.duration = AKDuration(beats: processedDuration)
        return note
    }

    static private func processBackNotePosition(_ position: Double, preShiftBeats: Double, grooveDelay: Double) -> Double {
        var processedPosition = position - preShiftBeats
        let remainder = position.truncatingRemainder(dividingBy: 1.0)
        switch remainder {
        case 0.25 + grooveDelay,
             0.75 + grooveDelay: processedPosition =  processedPosition - grooveDelay
        default: break
        }

        return processedPosition
    }
}
