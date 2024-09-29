//
//  GameInputView.swift
//  NerdleGame
//
    
import SwiftUI

struct GameInputView: View {
    var onKeyPressed: (InputKeyType) -> Void
    @Binding var enableEnter: Bool
    @Binding var enableDelete: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                ForEach(1...9, id: \.self) { digit in
                    KeyboardButton(
                        keyType: .digit(digit),
                        action: onKeyPressed
                    )
                }
                
                KeyboardButton(
                    keyType: .digit(0),
                    action: onKeyPressed)
            }
            
            HStack(spacing: 4) {
                KeyboardButton(keyType: .plus, action: onKeyPressed)
                KeyboardButton(keyType: .minus, action: onKeyPressed)
                KeyboardButton(keyType: .multiply, action: onKeyPressed)
                KeyboardButton(keyType: .divide, action: onKeyPressed)
                KeyboardButton(keyType: .equal, action: onKeyPressed)
                KeyboardButton(
                    keyType: .enter,
                    action: onKeyPressed,
                    enable: $enableEnter
                )
                KeyboardButton(
                    keyType: .delete,
                    action: onKeyPressed,
                    enable: $enableDelete
                )
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct KeyboardButton: View {
    let keyType: InputKeyType
    var action: (InputKeyType) -> Void
    @Binding var enable: Bool
    
    init(
        keyType: InputKeyType,
        action: @escaping (InputKeyType) -> Void,
        enable: Binding<Bool> = .constant(true)
    ) {
        self.keyType = keyType
        self.action = action
        self._enable = enable
    }
    
    var body: some View {
        Button(
            action: { action(keyType) },
            label: {
            Text(keyType.symbol)
                .padding(.horizontal, 12)
                .frame(height: 50)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .font(.system(.title2))
                .foregroundStyle(.white)
        })
        .buttonStyle(.plain)
        .disabled(!enable)
        .keyboardShortcut(keyType.keyEquivalent, modifiers: [])
    }
}

#Preview {
    GameInputView(
        onKeyPressed: { key in
            print("key pressed:", key)
        },
        enableEnter: .constant(true),
        enableDelete: .constant(
            true
        ))
}
