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
        stackView.spacing = PadButtonFactory.spacing
    }

    func updateButtons() {
        buttons = viewModel.buttons
    }
}

class TrackViewModel {
    let drumType: Drums
    var activeNotePositions: [Int]
    var length: Int
    var buttons: [PadButton] = []

    init(drumsType: Drums, positions: [Int], loopLength: Int) {
        drumType = drumsType
        activeNotePositions = positions
        length = loopLength

        setUpButtons()
    }

    private func setUpButtons() {

        var buttons: [PadButton] = []
        for _ in 0..<length {
            buttons.append(PadButtonFactory.button(state: .idle))
        }

        for position in activeNotePositions {
            buttons[position].padState = .active
        }

        self.buttons = buttons
    }
}
