//
//  TracksStackView.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 01.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

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

    func commonInit() {
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
}
