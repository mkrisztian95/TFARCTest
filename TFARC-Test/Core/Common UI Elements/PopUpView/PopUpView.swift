import CombinePlus
import FoundationPlus
import UIKitPlus

class PopUpView: UIView {

    enum PopUpButtonType {
        case primary
        case secondary

        var metaType: UIButton.Type {
            switch self {
            case .primary:
                PrimaryButton.self
            case .secondary:
                SecondaryButton.self
            }
        }
    }

    struct PopUpButtonViewState {
        let title: String
        let type: PopUpButtonType
        let action: () -> Void
    }

    struct ViewState {
        let icon: UIImage?
        let title: String
        let subtitle: String?
        let showCloseButton: Bool
        let buttons: [PopUpButtonViewState]

        init(
            title: String,
            subtitle: String? = nil,
            icon: UIImage? = nil,
            showCloseButton: Bool = false,
            @PopUpButtonBuilder builder: () -> [PopUpButtonViewState]
        ) {
            self.title = title
            self.subtitle = subtitle
            self.icon = icon
            self.showCloseButton = showCloseButton
            self.buttons = builder()
        }
    }

    private var bag = CancelBag()

    private lazy var buttonStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 12.0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var headerStack = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 12.0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var closeButton = CloseButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .black200
        $0.imageEdgeInsetsIgnoreDeprecated = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        $0.addAction { [unowned self] in
            dismissPopUp()
        }
    }

    private lazy var iconImageView = UIImageView()

    private lazy var headerTopConstraint = headerStack.topAnchor.constraint(
        equalTo: popUpContainerView.topAnchor,
        constant: 32.0
    )

    var closeButtonTappedPublisher: AnyPublisher<Void, Never> {
        closeButton.tapPublisher
    }

    var emptySpaceTappedPublisher: AnyPublisher<Void, Never> {
        dismissView.tapGesturePublisher.void().eraseToAnyPublisher()
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private lazy var popUpContainerView = UIView().then { containerView in
        containerView.backgroundColor = .backgroundSecondary
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 24.0
    }

    private lazy var dismissView = UIView().then { view in
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopUp)))
    }

    private func configureUI() {
        backgroundColor = .clear

        addSubviews(popUpContainerView, dismissView)
        popUpContainerView.addSubviews(buttonStack, headerStack, closeButton)

        NSLayoutConstraint.activate {
            dismissView.topAnchor.constraint(equalTo: topAnchor)
            dismissView.leadingAnchor.constraint(equalTo: leadingAnchor)
            dismissView.trailingAnchor.constraint(equalTo: trailingAnchor)
            dismissView.bottomAnchor.constraint(equalTo: popUpContainerView.topAnchor)

            popUpContainerView.leadingAnchor.constraint(equalTo: leadingAnchor)
            popUpContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
            popUpContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)

            closeButton.topAnchor.constraint(equalTo: popUpContainerView.topAnchor, constant: 32.0)
            closeButton.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -28.0)

            headerTopConstraint
            headerStack.leadingAnchor.constraint(equalTo: popUpContainerView.leadingAnchor, constant: 24.0)
            headerStack.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -24.0)

            buttonStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 24.0)
            buttonStack.leadingAnchor.constraint(equalTo: popUpContainerView.leadingAnchor, constant: 24.0)
            buttonStack.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -24.0)
            buttonStack.bottomAnchor.constraint(
                equalTo: popUpContainerView.bottomAnchor,
                constant: -20 - (UIWindow.safeAreaHeight?.bottom ?? 0.0)
            )
        }
    }

    func apply(with innerView: UIView, and title: String) {
        headerStack.removeAllArrangedSubviews()
        buttonStack.removeLastArrangedSubview()

        let titleLabel = UILabel().then {
            $0.textColor = .black900
            $0.font = .headingsH4SemiBold
            $0.text = title
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        headerStack.addArrangedSubview(titleLabel)

        buttonStack.addArrangedSubview(innerView)
    }

    func apply(_ viewState: ViewState) {
        headerStack.removeAllArrangedSubviews()
        buttonStack.removeLastArrangedSubview()

        closeButton.isHidden = !viewState.showCloseButton

        if let icon = viewState.icon {
            iconImageView.image = icon
            headerStack.addArrangedSubview(iconImageView)
            headerStack.setCustomSpacing(24.0, after: iconImageView)
            headerTopConstraint.constant = 16.0
        }

        let titleLabel = UILabel().then {
            $0.textColor = .black900
            $0.font = .headingsH4SemiBold
            $0.text = viewState.title
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        headerStack.addArrangedSubview(titleLabel)

        if let subtitle = viewState.subtitle {
            let subtitleLabel = UILabel().then {
                $0.attributedText = subtitle.mutableAttributedString
                    .setFont(.captionLRegular)
                    .setTextColor(.black500)
                    .setAlignment(.center)
                    .setLineHeightMultiple(1.29)
                $0.numberOfLines = 0
            }
            headerStack.addArrangedSubview(subtitleLabel)
        }

        buttonStack.removeAllArrangedSubviews()
        buttonStack.addArrangedSubviews(
            viewState.buttons.map { btn in

                let button = btn.type.metaType.init()
                button.setTitle(btn.title)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 48).isActive = true

                button.addAction(btn.action)

                return button
            }
        )
    }

    @objc private func dismissPopUp() {
        setHidden(true, withDuration: 0.5)
    }
}
