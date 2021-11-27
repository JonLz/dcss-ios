//
//  KeyCommandsView.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/27/21.
//

import SwiftUI

struct KeyCommandsView: View {
    
    let onKeyCommandTapped: (KeyCommand) -> Void
    let onKeyboardTapped: () -> Void
    @State private var isLongPressing: Bool = false
    @State private var longPressTimer: Timer?
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(defaultKeyCommands, id: \.id) { keyCommand in
                Button(action: {
                    if isLongPressing {
                        isLongPressing = false
                        longPressTimer?.invalidate()
                    } else {
                        onKeyCommandTapped(keyCommand)
                    }
                }, label: {
                    Image(systemName: keyCommand.symbolName)
                        .frame(width: 24, height: 24)
                })
                .simultaneousGesture(LongPressGesture(minimumDuration: 0.2, maximumDistance: 24).onEnded { _ in
                    isLongPressing = true
                    longPressTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
                        onKeyCommandTapped(keyCommand)
                    })
                })
            }
            Button(action: {
                onKeyboardTapped()
            }, label: {
                Image(systemName: "keyboard")
                    .frame(width: 24, height: 24)
            })
        }.padding(4)
    }
    
    private let defaultKeyCommands: [KeyCommand] = [
        KeypressCommand.o,
        KeydownCommand.tab,
        KeypressCommand.five,
        KeydownCommand.leftArrow,
        KeydownCommand.upArrow,
        KeydownCommand.rightArrow,
        KeydownCommand.downArrow,
        KeydownCommand.escape,
    ]
}
