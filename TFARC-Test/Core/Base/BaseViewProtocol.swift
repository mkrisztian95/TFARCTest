import Combine
import UIKit

protocol BaseViewProtocol: AnyObject {

    var viewDidLoadPublisher: AnyPublisher<Void, Never> { get }
    var viewIsAppearingPublisher: AnyPublisher<Void, Never> { get }
    var viewWillAppearPublisher: AnyPublisher<Void, Never> { get }
    var viewDidAppearPublisher: AnyPublisher<Void, Never> { get }
    var viewWillDisappearPublisher: AnyPublisher<Void, Never> { get }
    var viewDidDisappearPublisher: AnyPublisher<Void, Never> { get }
    var viewDidLayoutSubviewsPublisher: AnyPublisher<Void, Never> { get }

    func displayPopUp(with viewState: PopUpView.ViewState)
    func hidePopUp()

    var isLoading: Bool { get set }
}

extension BaseViewProtocol {
    func childProtocolType<T>() -> T {
        guard let view = self as? T else {
            fatalError("\(type(of: self)) is not \(T.self)")
        }
        return view
    }
}
