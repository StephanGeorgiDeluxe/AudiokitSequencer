//
//  TrackView.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 01.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit
import AudioKit

class TrackView {
    let viewModel: TrackViewModel
    let stackView = UIStackView()
    var buttons: [PadButton] = [] {
        didSet {
            for button in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(button)
            }
            for button in buttons {
                stackView.addArrangedSubview(button)
            }
        }
    }

    init(trackViewModel: TrackViewModel) {
        viewModel = trackViewModel
        stackView.axis = .horizontal
        stackView.spacing = SequencerFactory.spacing
    }

    func updateButtons() {
        buttons = viewModel.buttons
    }
}
