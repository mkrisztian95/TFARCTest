import UIKit

class SecondaryButton: RoundedButton {
    override func setup() {
        titleLabel?.font = .titleSemiBold
        accentColor = .primary600
        accentDisabledColor = .clear
        isFilled = false
    }

    func fixed() -> Self {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56)
        ])

        return self
    }
}
