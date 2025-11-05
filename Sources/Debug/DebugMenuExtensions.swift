import UIKit

extension UIViewController {
    var topMost: UIViewController {
        var top = self
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}
