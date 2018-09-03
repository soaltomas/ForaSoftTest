import UIKit

protocol Animations {
    func songCellAnimation(cell: UITableViewCell)
}

extension Animations {
    func songCellAnimation(cell: UITableViewCell) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
        },completion: { finished in
            UIView.animate(withDuration: 0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
        })
    }
}
