//
//  TrackViewModel.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 01.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit
import AudioKit

class TrackViewModel {

    var didPressButton: ((Int) -> Void)?
    var buttonLevelChanged: ((Int, CGFloat) -> Void)?

    let drumType: Drums
    var activeNotePositions: [Int]
    var length: Int = 0
    var buttons: [PadButton] = []

    init(drumsType: Drums, activeNotes: [AKMIDINoteData], positions: [Int], loopLength: Int) {
        drumType = drumsType
        activeNotePositions = positions
        self.length = loopLength

        setUpButtons()
        updateButtons(notes: activeNotes)
    }

    private func setUpButtons() {
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

        self.buttons = buttons
    }

    func updateButtons(notes: [AKMIDINoteData]) {
        for (index, position) in activeNotePositions.enumerated() {
            let midiVelocity: MIDIVelocity = notes[index].velocity
            let velocity = CGFloat(NoteVelocity.velocityStage(from: midiVelocity).rawValue)
            let level = CGFloat(velocity / 127)
            buttons[position].level = level
            buttons[position].padState = .active
        }
    }
    
    func highlightButton(position: Int) {
        DispatchQueue.main.async {
            let button = self.buttons[position]
            button.showHighlight()
        }
    }
}
