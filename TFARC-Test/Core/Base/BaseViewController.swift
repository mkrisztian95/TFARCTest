import CombinePlus
import Depin
import UIKitPlus

class BaseViewController: UIViewController {

    // MARK: - Private properties

    @Injected var i18n: I18n
    var bag = CancelBag()

    private lazy var popUpView = PopUpView().then { popUp in
        popUp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popUp)
        popUp.setHidden(true, withDuration: 0)
        NSLayoutConstraint.activate {
            popUp.topAnchor.constraint(equalTo: view.topAnchor)
            popUp.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            popUp.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            popUp.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
    }

    // MARK: - Public properties

    var isLoading = false

    // MARK: - Life cycle publishers

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let viewIsAppearingSubject = PassthroughSubject<Void, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let viewDidAppearSubject = PassthroughSubject<Void, Never>()
    private let viewWillDisappearSubject = PassthroughSubject<Void, Never>()
    private let viewDidDisappearSubject = PassthroughSubject<Void, Never>()
    private let viewDidLayoutSubviewsSubject = PassthroughSubject<Void, Never>()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
        viewDidLoadSubject.send()
        viewDidLoadSubject.send(completion: .finished)
        colorize()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        viewIsAppearingSubject.send()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSubject.send()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearSubject.send()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearSubject.send()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsSubject.send()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            colorize()
        }
    }
}

// MARK: - BaseViewProtocol

extension BaseViewController: BaseViewProtocol {
    var popUpCloseButtonTappedPublisher: AnyPublisher<Void, Never> {
        popUpView.closeButtonTappedPublisher
    }

    func hidePopUp() {
        popUpView.setHidden(true, withDuration: 0.5)
    }

    func displayPopUp(with viewState: PopUpView.ViewState) {
        popUpView.apply(viewState)
        popUpView.setHidden(false, withDuration: 0.5)
    }

    func displayPopUp(with innerView: UIView, and title: String) {
        popUpView.apply(with: innerView, and: title)
        popUpView.setHidden(false, withDuration: 0.5)
    }

    var viewWillAppearPublisher: AnyPublisher<Void, Never> {
        viewWillAppearSubject.eraseToAnyPublisher()
    }

    var viewDidAppearPublisher: AnyPublisher<Void, Never> {
        viewDidAppearSubject.eraseToAnyPublisher()
    }

    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        viewDidLoadSubject.eraseToAnyPublisher()
    }

    var viewIsAppearingPublisher: AnyPublisher<Void, Never> {
        viewIsAppearingSubject.eraseToAnyPublisher()
    }

    var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
        viewWillDisappearSubject.eraseToAnyPublisher()
    }

    var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
        viewDidDisappearSubject.eraseToAnyPublisher()
    }

    var viewDidLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        viewDidLayoutSubviewsSubject.eraseToAnyPublisher()
    }
}

extension BaseViewController: Colorizable {
    @objc func colorize() { }
}
