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
    var tracksStackViewModel: TracksStackViewModel? {
        didSet {
            updateTracks()
        }
    }

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

    func updateTracks() {
        guard let stackViewModel = tracksStackViewModel else {
            print("error: tracksStackViewModel is nil")
            return
        }
        tracks = SequencerFactory.trackViews(tracksViewModel: stackViewModel)
        for trackView in tracks {
            addArrangedSubview(trackView.stackView)
            trackView.updateButtons()
        }
    }
}
