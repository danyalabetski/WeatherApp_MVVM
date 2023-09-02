import UIKit

extension UILabel {
    func customLabel(nameFont: String, sizeFont: CGFloat) {
        textAlignment = .center
        font = UIFont(name: nameFont, size: sizeFont)
    }
}
