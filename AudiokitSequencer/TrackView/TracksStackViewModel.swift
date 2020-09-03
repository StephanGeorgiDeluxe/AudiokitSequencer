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
        self.sequencer.midiDataDidChange = { [weak self] (drumType, index, active) in
            self?.updateTrack(drumType: drumType, index: index, isActive: active)
        }
    }

    private func updateTrack(drumType: Drums, index: Int, isActive: Bool) {
        guard let trackViewModel = trackViewModels.first(where: { $0.drumType == drumType } ) else { return }
        let button = trackViewModel.buttons[index]
        let buttonState = button.padState
        switch buttonState {
        case .idle:
            button.padState = .active
        case .active:
            button.padState = .idle
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
            trackViewModel.didPressButton = { [weak self] (button, index) in
                guard let self = self else { return }
                self.updateSequencer(drumType: trackViewModel.drumType, index: index)
            }
        }
    }

    func updateSequencer(drumType: Drums, index: Int) {
        sequencer.toggleNote(index: index, drumType: drumType)
    }

    func createTrackViewModel(drum: Drums, sequencer: Sequencer) -> TrackViewModel {
        let positions = sequencer.activeNotePositions(drum)
        let trackViewModel = TrackViewModel(drumsType: drum,
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
