//
//  KeyCommandsView.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/27/21.
//

import SwiftUI

struct KeyCommandsView: View {
    enum LayoutConstants {
        static let padding: CGFloat  = 4
        static let iconSize: CGFloat = 32
        static let height: CGFloat = padding * 2 + iconSize
    }
    
    let onKeyCommandTapped: (KeyCommand) -> Void
    let onKeyboardTapped: () -> Void
    @State private var isLongPressing: Bool = false
    @State private var longPressTimer: Timer?
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack(spacing: LayoutConstants.padding * 2) {
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
                                .frame(width: LayoutConstants.iconSize, height: LayoutConstants.iconSize)
                        })
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.2, maximumDistance: LayoutConstants.iconSize).onEnded { _ in
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
                            .frame(width: LayoutConstants.iconSize, height: LayoutConstants.iconSize)
                    })
                }
                Spacer()
            }
            Capsule()
                .fill(Color.gray)
                .frame(width: LayoutConstants.iconSize, height: 6)
        }.swipeRecognizing { swipeDirection in
            switch swipeDirection {
            case .up:
                isExpanded.toggle()
            case .down:
                // no-op
                break
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        
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

private extension View {
    func swipeRecognizing(onSwipe: @escaping (SwipeRecognizing.SwipeDirection) -> Void) -> some View {
        modifier(SwipeRecognizing(onSwipe: onSwipe))
    }
}

private struct SwipeRecognizing: ViewModifier {
    enum SwipeDirection {
        case down
        case up
    }
    
    let onSwipe: (SwipeDirection) -> Void
    
    func body(content: Content) -> some View {
        content
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
