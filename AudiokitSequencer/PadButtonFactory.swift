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

    static func trackViews(tracksViewModel: TracksStackViewModel) -> [TrackView]{
        var trackViews: [TrackView] = []
        for trackViewModel in tracksViewModel.trackViewModels {
            let track = PadButtonFactory.trackView(viewModel: trackViewModel)
            trackViews.append(track)
        }
        return trackViews
    }

    static func trackView(viewModel: TrackViewModel) -> TrackView {
        let trackView = TrackView(trackViewModel: viewModel)

        return trackView
    }
}

