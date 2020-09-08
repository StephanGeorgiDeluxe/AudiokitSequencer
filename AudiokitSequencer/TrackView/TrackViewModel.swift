//
//  TrackViewModel.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 01.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

class TrackViewModel {

    var didPressButton: ((Int) -> Void)?
    var buttonLevelChanged: ((Int, CGFloat) -> Void)?

    let drumType: Drums
    var activeNotePositions: [Int]
    var length: Int = 0 {
        didSet {
            updateButtons()
        }
    }
    var buttons: [PadButton] = []

    init(drumsType: Drums, positions: [Int], loopLength: Int) {
        drumType = drumsType
        activeNotePositions = positions
        self.length = loopLength

        updateButtons()
    }

    private func updateButtons() {
        var buttons: [PadButton] = []
        for index in 0 ..< length {
            let button = SequencerFactory.button(state: .idle)
            button.addAction { [weak self] in
                guard let self = self else { return }
                self.didPressButton?(index)
            }
            button.levelChangeAction = { [weak self] (button, level) in
                guard let self = self else { return }
                self.buttonLevelChanged?(index, level) }

            buttons.append(button)
        }

        for position in activeNotePositions {
            buttons[position].padState = .active
        }

        self.buttons = buttons
    }
    
    func highlightButton(position: Int) {
        DispatchQueue.main.async {
            let button = self.buttons[position]
            button.showHighlight()
        }
    }
}
