//
//  PadButtonFactory.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 31.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

class PadButtonFactory {

    static let dimension: CGFloat = 32
    static let spacing: CGFloat = 8

    static func button(state: PadState) -> PadButton {
        let button = PadButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        button.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        button.padState = state
        return button
    }

    static func buttons(states: [PadState]) -> [PadButton] {
        var buttons: [PadButton] = []
        for state in states {
            let button = self.button(state: state)
            button.addTarget(self, action: #selector(didTouch(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }

    @objc static func didTouch(sender: UIControl) {
        guard let sender = sender as? PadButton else {
            return
        }

        sender.didTouchButton()
    }

    static func trackView(drum: Drums, sequencer: Sequencer) -> TrackView {
        let positions = sequencer.activeNotePositions(drum)
        let trackViewModel = TrackViewModel(drumsType: drum,
                                            positions: positions,
                                            loopLength: sequencer.looplength)
        let trackView = TrackView(trackViewModel: trackViewModel)

        return trackView
    }
}

