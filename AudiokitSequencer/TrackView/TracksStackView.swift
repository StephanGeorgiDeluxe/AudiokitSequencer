//
//  TracksStackView.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 01.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit
import AudioKit

class TracksStackView: UIStackView {
    var tracks: [TrackView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        axis = .vertical
        alignment = .fill
        spacing = 8
    }

    func fillTracks(sequencer: Sequencer, tracks: [Drums]) {
        for drum in tracks {
            let track = PadButtonFactory.trackView(drum: drum, sequencer: sequencer)
            self.tracks.append(track)
            addArrangedSubview(track.stackView)
            track.updateButtons()
        }
    }

    func receivedMidiCallBack(statusByte: MIDIByte,
                              note: MIDIByte,
                              velocity: MIDIByte) {

        guard let status = AKMIDIStatus(byte: statusByte),
            let drum = Drums(rawValue: note),
            status.type == .noteOn,
            drum == .setUp else { return }

        showHighlight(note: note, velocity: velocity)
    }

    func showHighlight(note: MIDIByte, velocity: MIDIByte) {
        let index = Int(velocity - 1)
        for track in tracks {
            track.viewModel.showHighlight(position: index)
        }
    }
}
