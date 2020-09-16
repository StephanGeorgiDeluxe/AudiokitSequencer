//
//  TracksStackViewModel.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 03.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import AudioKit

class TracksStackViewModel {
    private let sequencer: Sequencer
    private var drumTypes: [Drums] = []
    var trackViewModels: [TrackViewModel] = []

    init(sequencer: Sequencer, drumTypes: [Drums]) {
        self.sequencer = sequencer
        self.drumTypes = drumTypes

        setUpTracks(sequencer: sequencer, drums: drumTypes)

        self.sequencer.didToggleNote = { [weak self] (drumType, index, active) in
            self?.updateButtonState(drumType: drumType, index: index, isActive: active)
        }

        self.sequencer.didChangeVelocity = { [weak self] (drumType, index, level) in
            self?.updateButtonLevel(drumType: drumType, index: index, level: level)
        }
    }

    private func updateButtonState(drumType: Drums, index: Int, isActive: Bool) {
        guard let trackViewModel = trackViewModels.first(where: { $0.drumType == drumType } ) else { return }
        let button = trackViewModel.buttons[index]
        let buttonState = button.padState
        switch(buttonState, isActive) {
        case (.idle, true):
            button.padState = .active
            button.level = 1
        case (.active, false):
            button.padState = .idle
            button.level = 0
        case (_, _):
            break
        }
    }

    private func updateButtonLevel(drumType: Drums, index: Int, level: NoteVelocity) {
        guard let trackViewModel = trackViewModels.first(where: { $0.drumType == drumType } ) else { return }
        let button = trackViewModel.buttons[index]
        let buttonState = button.padState
        let isActive = level != .zero

        switch(buttonState, isActive) {
        case (.idle, true):
            button.padState = .active
        case (.active, false):
            button.padState = .idle
        case (_, _):
            break
        }
    }

    private func setUpTracks(sequencer: Sequencer, drums: [Drums]? = nil) {
        var drumTypes: [Drums] = self.drumTypes
        if let types = drums {
            drumTypes = types
        }

        for drum in drumTypes {
            let trackViewModel = createTrackViewModel(drum: drum, sequencer: sequencer)
            trackViewModels.append(trackViewModel)
            trackViewModel.didPressButton = { [weak self] (index) in
                guard let self = self else { return }
                self.sequencer.toggleNote(index: index,
                                          drumType: trackViewModel.drumType)
            }

            trackViewModel.buttonLevelChanged = { [weak self] (index, level) in
                guard let self = self else { return }
                let velocity = MIDIVelocity(abs(level * 127))
                let noteVelocity = NoteVelocity.velocityStage(from: velocity)
                self.sequencer.changeNote(index: index,
                                          drumType: trackViewModel.drumType,
                                          veloctiy: noteVelocity)
            }
        }
    }

    private func createTrackViewModel(drum: Drums, sequencer: Sequencer) -> TrackViewModel {
        let activeNotes = sequencer.activeNotes(drum)
        let positions = sequencer.activeIndexes(notes: activeNotes, quantisizeUnit: .quarter)
        let trackViewModel = TrackViewModel(drumsType: drum,
                                            activeNotes: activeNotes,
                                            positions: positions,
                                            loopLength: sequencer.looplength)
        return trackViewModel
    }

    func receivedMidiCallBack(statusByte: MIDIByte,
                              note: MIDIByte,
                              velocity: MIDIByte) {

        guard let status = AKMIDIStatus(byte: statusByte),
            let drum = Drums(rawValue: note),
            status.type == .noteOn,
            drum == .setUp else { return }

        highlightSequencePosition(note: note, velocity: velocity)
    }

    private func highlightSequencePosition(note: MIDIByte, velocity: MIDIByte) {
        let index = Int(velocity - 1)
        for trackViewModel in trackViewModels {
            trackViewModel.highlightButton(position: index)
        }
    }
}
