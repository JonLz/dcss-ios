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
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack(alignment: isExpanded ? .bottom : .top) {
            VStack {
                HStack(spacing: 8) {
                    ForEach(keyCommands, id: \.id) { keyCommand in
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
                }
            }.padding(4)
            GrabberView() { swipeDirection in
                switch swipeDirection {
                case .up:
                    isExpanded = true
                case .down:
                    isExpanded = false
                }
            }
        }
    }
    
    private var keyCommands: [KeyCommand] {
        isExpanded ? secondaryKeyCommands : defaultKeyCommands
    }
    
    private let defaultKeyCommands: [KeyCommand] = [
        KeypressCommand.o,
        KeydownCommand.tab,
        KeypressCommand.five,
        KeydownCommand.leftArrow,
        KeydownCommand.upArrow,
        KeydownCommand.rightArrow,
        KeydownCommand.downArrow,
        KeydownCommand.escape
    ]
    
    private let secondaryKeyCommands: [KeyCommand] = [
        KeypressCommand.o,
        KeydownCommand.tab,
        KeypressCommand.five,
        KeypressCommand.y,
        KeypressCommand.u,
        KeypressCommand.b,
        KeypressCommand.n,
        KeydownCommand.escape
    ]
}

private struct GrabberView: View {
    enum SwipeDirection {
        case down
        case up
    }
    
    let onSwipe: (SwipeDirection) -> Void
    
    var body: some View {
        Capsule()
            .fill(Color.gray)
            .frame(width: 24, height: 6)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                    // left-swipe
                    // no-op
                } else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                    // right-swipe
                    // no-op
                } else if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                    // up-swipe
                    onSwipe(.up)
                } else if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                    // down-swipe
                    onSwipe(.down)
                }
            }))
    }
}
