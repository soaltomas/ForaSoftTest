import Foundation
import UIKit

enum Colors {
    case albumArtwork
    case background
}

extension Colors {
    var color: UIColor {
        get {
            switch self {
            case .albumArtwork:
                return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
            case .background:
                return UIColor.white
            }
        }
    }
}
