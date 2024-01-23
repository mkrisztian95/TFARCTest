import Combine
import UIKit

class CameraFrameOverlay: UIView {

    private enum Corner: CaseIterable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    private enum Edge {
        case top
        case left
        case right
        case bottom

        var adjoinedCorners: [Corner] {
            switch self {
            case .left:
                [.topLeft, .bottomLeft]
            case .top:
                [.topLeft, .topRight]
            case .right:
                [.topRight, .bottomRight]
            case .bottom:
                [.bottomLeft, .bottomRight]
            }
        }
    }

    private enum SelectedSide {
        case corner(Corner)
        case edge(Edge)
    }

    private enum Constant {
        static let rectMinSize = CGSize(width: 104.0, height: 104.0)
        static let cornerLength: CGFloat = 52.0
        static let cornerCurvePointOffset: CGFloat = 26.0
        static let cornerCurveControlPointOffset: CGFloat = 12.7452
        static let edgeIndicatorLineWidth: CGFloat = 8.0

        static let yAxisMinimalLimit: CGFloat = 10.0
        static let xAxisMinimalLimit: CGFloat = 10.0

        static let bottomOffset: CGFloat = 32.0 + 48.0 + 20.0
    }

    // MARK: - Private Properties

    private lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePan(_:))
    )

    private var visibleAreaRect: CGRect!
    private var selectedSide: SelectedSide?

    private let cropFrameChangeSubject: PassthroughSubject<CGRect, Never> = PassthroughSubject()

    // MARK: - Public Properties

    var croppingEnabled = false

    var cropFrameChangePublisher: AnyPublisher<CGRect, Never> {
        cropFrameChangeSubject.eraseToAnyPublisher()
    }

    func set(_ rect: CGRect) {
        visibleAreaRect = rect
        setNeedsLayout()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(panGestureRecognizer)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        UIColor.alphaConstantBlack70064.setFill()
        UIRectFill(rect)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let visibleAreaRect else { return }

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.fillRule = .evenOdd
        maskLayer.strokeColor = UIColor.constantWhite.cgColor

        let path = UIBezierPath(rect: bounds)
        path.append(cropAreaPath(basedOn: visibleAreaRect))

        maskLayer.path = path.cgPath
        layer.mask = maskLayer

        if croppingEnabled {
            layer.sublayers?.removeAll()
            layer.insertSublayer(cornerFrameLayer(basedOn: visibleAreaRect), at: 0)
            cropFrameChangeSubject.send(visibleAreaRect)
        }
    }

    /// Returns a rounded rectangle path inside of a `rect` that indicates the cropping area

    private func cropAreaPath(basedOn rect: CGRect) -> UIBezierPath {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.fillColor = UIColor.clear.cgColor

        let x = rect.origin.x
        let y = rect.origin.y
        let width = rect.width
        let height = rect.height

        let topLeftX = x
        let topLeftY = y

        let topRightX = x + width
        let topRightY = y

        let bottomLeftX = x
        let bottomLeftY = y + height

        let bottomRightX = x + width
        let bottomRightY = y + height

        let path = UIBezierPath()

        path.move(to: CGPoint(
            x: topLeftX + Constant.cornerCurvePointOffset,
            y: topLeftY
        ))
        path.addCurve(
            to: CGPoint(
                x: topLeftX,
                y: topLeftY + Constant.cornerCurvePointOffset
            ),
            controlPoint1: CGPoint(
                x: topLeftX + Constant.cornerCurveControlPointOffset,
                y: topLeftY
            ),
            controlPoint2: CGPoint(
                x: topLeftX,
                y: topLeftY + Constant.cornerCurveControlPointOffset
            )
        )

        path.addLine(to: CGPoint(
            x: bottomLeftX,
            y: bottomLeftY - Constant.cornerCurvePointOffset
        ))

        path.addCurve(
            to: CGPoint(
                x: bottomLeftX + Constant.cornerCurvePointOffset,
                y: bottomLeftY
            ),
            controlPoint1: CGPoint(
                x: bottomLeftX,
                y: bottomLeftY - Constant.cornerCurveControlPointOffset
            ),
            controlPoint2: CGPoint(
                x: bottomLeftX + Constant.cornerCurveControlPointOffset,
                y: bottomLeftY
            )
        )

        path.addLine(to: CGPoint(
            x: bottomRightX - Constant.cornerCurvePointOffset,
            y: bottomRightY
        ))

        path.addCurve(
            to: CGPoint(
                x: bottomRightX,
                y: bottomRightY - Constant.cornerCurvePointOffset
            ),
            controlPoint1: CGPoint(
                x: bottomRightX - Constant.cornerCurveControlPointOffset,
                y: bottomRightY
            ),
            controlPoint2: CGPoint(
                x: bottomRightX,
                y: bottomRightY - Constant.cornerCurveControlPointOffset
            )
        )

        path.addLine(to: CGPoint(
            x: topRightX,
            y: topRightY + Constant.cornerCurvePointOffset
        ))

        path.addCurve(
            to: CGPoint(
                x: topRightX - Constant.cornerCurvePointOffset,
                y: topRightY
            ),
            controlPoint1: CGPoint(
                x: topRightX,
                y: topRightY + Constant.cornerCurveControlPointOffset
            ),
            controlPoint2: CGPoint(
                x: topRightX - Constant.cornerCurveControlPointOffset,
                y: topRightY
            )
        )

        return path
    }

    /// Draws 4 corner Indicators based on the given `rect`;
    /// Returns a merged CAShapeLayer that contains layers for each corner separately

    private func cornerFrameLayer(basedOn rect: CGRect) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.fillColor = UIColor.clear.cgColor

        maskLayer.addSublayers([
            drawCorner(
                rect: rect,
                corner: .topLeft
            ),
            drawCorner(
                rect: rect,
                corner: .topRight
            ),
            drawCorner(
                rect: rect,
                corner: .bottomLeft
            ),
            drawCorner(
                rect: rect,
                corner: .bottomRight
            )
        ])

        return maskLayer
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if !croppingEnabled { return }
        let startPoint = gestureRecognizer.location(in: gestureRecognizer.view)
        switch gestureRecognizer.state {
        case .began, .possible:
            selectedSide = detectSelectedSide(startPoint: startPoint)
            if let selectedSide {
                handleEdgePan(gestureRecognizer, side: selectedSide)
            }
        case .ended:
            selectedSide = nil
            setNeedsLayout()
        default:
            if isDraggingCroppingArea(in: startPoint) {
                handleRectPan(gestureRecognizer)
            } else {
                if let selectedSide {
                    handleEdgePan(gestureRecognizer, side: selectedSide)
                }
            }
        }
    }

    private func isDraggingCroppingArea(in startPoint: CGPoint) -> Bool {
        selectedSide == nil && visibleAreaRect.contains(startPoint)
    }

    private func draggableRect(in area: CGRect, for edge: Edge) -> CGRect {
        let gap = 20.0
        let doubleGap = gap * 2
        let x = area.origin.x
        let y = area.origin.y
        let height = area.height
        let width = area.width

        switch edge {
        case .left:
            return CGRect(x: x - gap, y: y - gap, width: doubleGap, height: height + doubleGap)
        case .right:
            return CGRect(x: x + width - gap, y: y - gap, width: doubleGap, height: height + doubleGap)
        case .top:
            return CGRect(x: x - gap, y: y - gap, width: width + doubleGap, height: doubleGap)
        case .bottom:
            return CGRect(x: x - gap, y: y + height - gap, width: width + doubleGap, height: doubleGap)
        }
    }

    private func detectSelectedSide(startPoint: CGPoint) -> SelectedSide? {
        switch (
            draggableRect(in: visibleAreaRect, for: .left).contains(startPoint),
            draggableRect(in: visibleAreaRect, for: .top).contains(startPoint),
            draggableRect(in: visibleAreaRect, for: .right).contains(startPoint),
            draggableRect(in: visibleAreaRect, for: .bottom).contains(startPoint)
        ) {
        case (true, false, false, false):
                .edge(.left)

        case (false, true, false, false):
                .edge(.top)

        case (false, false, true, false):
                .edge(.right)

        case (false, false, false, true):
                .edge(.bottom)

        case (true, true, false, false):
                .corner(.topLeft)

        case (false, true, true, false):
                .corner(.topRight)

        case (true, false, false, true):
                .corner(.bottomLeft)

        case (false, false, true, true):
                .corner(.bottomRight)

        default:
            nil
        }
    }

    private func translateEdges(_ edges: Edge..., from point: CGPoint) {
        for edge in edges {
            switch edge {
            case .top:
                topEdgeTranslation(translatedY: point.y)
            case .left:
                leftEdgeTranslation(translatedX: point.x)
            case .right:
                rightEdgeTranslation(translatedX: point.x)
            case .bottom:
                bottomEdgeTranslation(translatedY: point.y)
            }
        }
    }

    private func topEdgeTranslation(translatedY: CGFloat) {
        let preCalculatedY = visibleAreaRect.origin.y + translatedY
        let preCalculatedHeight = visibleAreaRect.size.height - translatedY

        if preCalculatedY <= Constant.yAxisMinimalLimit ||
            preCalculatedHeight <= Constant.rectMinSize.height {
            return
        }

        if visibleAreaRect.size.height >= Constant.rectMinSize.height {
            visibleAreaRect.size.height = preCalculatedHeight
            visibleAreaRect.origin.y = preCalculatedY
        } else {
            visibleAreaRect.size.height = Constant.rectMinSize.height
        }
    }

    private func bottomEdgeTranslation(translatedY: CGFloat) {
        let targetHeight = bounds.height - safeAreaInsets.bottom - Constant.bottomOffset

        let preCalculatedHeight = visibleAreaRect.size.height + translatedY
        if preCalculatedHeight + visibleAreaRect.origin.y >= targetHeight {
            return
        }

        if visibleAreaRect.size.height >= Constant.rectMinSize.height {
            visibleAreaRect.size.height = preCalculatedHeight
        } else {
            visibleAreaRect.size.height = Constant.rectMinSize.height
        }
    }

    private func leftEdgeTranslation(translatedX: CGFloat) {
        let preCalculatedX = visibleAreaRect.origin.x + translatedX
        let preCalculatedWidth = visibleAreaRect.width - translatedX

        if preCalculatedX <= Constant.xAxisMinimalLimit ||
            preCalculatedWidth <= Constant.rectMinSize.width {
            return
        }

        if visibleAreaRect.size.width >= Constant.rectMinSize.width {
            visibleAreaRect.origin.x = preCalculatedX
            visibleAreaRect.size.width = preCalculatedWidth
        } else {
            visibleAreaRect.size.width = Constant.rectMinSize.width
        }
    }

    private func rightEdgeTranslation(translatedX: CGFloat) {
        let calculatedWidth = visibleAreaRect.size.width + translatedX

        if calculatedWidth + visibleAreaRect.origin.x >= bounds.width - Constant.xAxisMinimalLimit {
            return
        }

        if visibleAreaRect.size.width >= Constant.rectMinSize.width {
            visibleAreaRect.size.width += translatedX
        } else {
            visibleAreaRect.size.width = Constant.rectMinSize.width
        }
    }

    private func handleRectPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)

        let preCalculatedX = visibleAreaRect.origin.x + translation.x
        if visibleAreaRect.width + preCalculatedX < bounds.width - Constant.xAxisMinimalLimit {
            visibleAreaRect.origin.x = preCalculatedX
        }

        let preCalculatedY = visibleAreaRect.origin.y + translation.y
        let targetHeight = bounds.height - safeAreaInsets.bottom - Constant.bottomOffset
        if visibleAreaRect.height + preCalculatedY < targetHeight - Constant.yAxisMinimalLimit {
            visibleAreaRect.origin.y = preCalculatedY
        }

        limitRectangleTransition()
        setNeedsLayout()
        gestureRecognizer.setTranslation(.zero, in: self)
    }

    private func handleEdgePan(_ gestureRecognizer: UIPanGestureRecognizer, side: SelectedSide) {
        let translation = gestureRecognizer.translation(in: self)

        switch side {

        case .edge(.left):
            translateEdges(.left, from: translation)
        case .edge(.right):
            translateEdges(.right, from: translation)

        case .edge(.top):
            translateEdges(.top, from: translation)

        case .edge(.bottom):
            translateEdges(.bottom, from: translation)

        case .corner(.topLeft):
            translateEdges(.top, .left, from: translation)

        case .corner(.topRight):
            translateEdges(.top, .right, from: translation)

        case .corner(.bottomLeft):
            translateEdges(.bottom, .left, from: translation)

        case .corner(.bottomRight):
            translateEdges(.bottom, .right, from: translation)
        }

        setNeedsLayout()
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)
    }

    private func limitRectangleTransition() {
        visibleAreaRect.origin.x = max(visibleAreaRect.origin.x, Constant.xAxisMinimalLimit)
        visibleAreaRect.origin.y = max(visibleAreaRect.origin.y, Constant.yAxisMinimalLimit)
        visibleAreaRect.size.width = min(visibleAreaRect.size.width, bounds.width - visibleAreaRect.origin.x)
        visibleAreaRect.size.height = min(
            visibleAreaRect.size.height,
            bounds.height - visibleAreaRect.origin.y - safeAreaInsets.bottom - Constant.bottomOffset
        )
    }

    private func createEdgeLayer(
        selected: Bool,
        startPoint: CGPoint,
        curveStartPoint: CGPoint,
        curveControlPoint1: CGPoint,
        curveControlPoint2: CGPoint,
        curveEndpoint: CGPoint,
        edgeEndPoint: CGPoint
    ) -> CAShapeLayer {
        let topLeftLayer = CAShapeLayer()
        topLeftLayer.frame = bounds
        topLeftLayer.fillColor = UIColor.clear.cgColor
        topLeftLayer.strokeColor = UIColor.constantWhite
            .withAlphaComponent(selected ? 1 : 0.5)
            .cgColor
        topLeftLayer.lineWidth = Constant.edgeIndicatorLineWidth

        let topLeftBezierPath = UIBezierPath()
        topLeftBezierPath.move(to: startPoint)
        topLeftBezierPath.addLine(to: curveStartPoint)
        topLeftBezierPath.addCurve(
            to: curveEndpoint,
            controlPoint1: curveControlPoint1,
            controlPoint2: curveControlPoint2
        )
        topLeftBezierPath.addLine(to: edgeEndPoint)

        topLeftLayer.path = topLeftBezierPath.cgPath

        return topLeftLayer
    }

    private func drawCorner(rect: CGRect, corner: Corner) -> CAShapeLayer {
        let width = rect.width
        let height = rect.height

        let cornersSelected: [Corner] = if let selectedSide {
            switch selectedSide {
            case .corner(let corner):
                [corner]
            case .edge(let edge):
                edge.adjoinedCorners
            }
        } else {
            Corner.allCases
        }

        let coordinates: (
            x: CGFloat,
            y: CGFloat,
            cornerLength: CGFloat,
            cornerCurvePointOffset: CGFloat,
            cornerCurveControlPointOffset1: CGFloat,
            cornerCurveControlPointOffset2: CGFloat,
            cornerCurvePointEndOffset: CGFloat,
            cornerEndLength: CGFloat
        ) = switch corner {
        case .topLeft:
            (
                rect.origin.x,
                rect.origin.y,
                Constant.cornerLength,
                Constant.cornerCurvePointOffset,
                Constant.cornerCurveControlPointOffset,
                Constant.cornerCurveControlPointOffset,
                Constant.cornerCurvePointOffset,
                Constant.cornerLength
            )

        case .topRight:
            (
                rect.origin.x + width,
                rect.origin.y,
                -Constant.cornerLength,
                 -Constant.cornerCurvePointOffset,
                 -Constant.cornerCurveControlPointOffset,
                 Constant.cornerCurveControlPointOffset,
                 Constant.cornerCurvePointOffset,
                 Constant.cornerLength
            )

        case .bottomLeft:
            (
                rect.origin.x,
                rect.origin.y + height,
                Constant.cornerLength,
                 Constant.cornerCurvePointOffset,
                 Constant.cornerCurveControlPointOffset,
                 -Constant.cornerCurveControlPointOffset,
                 -Constant.cornerCurvePointOffset,
                 -Constant.cornerLength
            )

        case .bottomRight:
            (
                rect.origin.x + width,
                rect.origin.y + height,
                -Constant.cornerLength,
                -Constant.cornerCurvePointOffset,
                -Constant.cornerCurveControlPointOffset,
                 -Constant.cornerCurveControlPointOffset,
                 -Constant.cornerCurvePointOffset,
                 -Constant.cornerLength
            )
        }

        return createEdgeLayer(
            selected: cornersSelected.contains(corner),
            startPoint: CGPoint(
                x: coordinates.x + coordinates.cornerLength,
                y: coordinates.y
            ),
            curveStartPoint: CGPoint(
                x: coordinates.x + coordinates.cornerCurvePointOffset,
                y: coordinates.y
            ),
            curveControlPoint1: CGPoint(
                x: coordinates.x + coordinates.cornerCurveControlPointOffset1,
                y: coordinates.y
            ),
            curveControlPoint2: CGPoint(
                x: coordinates.x,
                y: coordinates.y + coordinates.cornerCurveControlPointOffset2
            ),
            curveEndpoint: CGPoint(
                x: coordinates.x,
                y: coordinates.y + coordinates.cornerCurvePointEndOffset
            ),
            edgeEndPoint: CGPoint(
                x: coordinates.x,
                y: coordinates.y + coordinates.cornerEndLength
            )
        )
    }
}
