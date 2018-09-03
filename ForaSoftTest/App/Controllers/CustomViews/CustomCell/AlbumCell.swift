import UIKit

/// Collection view cell for displays album artwork
class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var artwork: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        artwork.layer.cornerRadius = 20
        artwork.layer.shadowRadius = 4.0
        artwork.layer.shadowOpacity = 0.6
        artwork.layer.shadowOffset = CGSize.zero
        artwork.layer.masksToBounds = true
        artwork.backgroundColor = Colors.albumArtwork.color
        
        contentView.backgroundColor = Colors.background.color
    }
}

extension UIImageView {
    
    /// Synchronous image loading
    ///
    /// - Parameter url: image url
    func load(url: URL) {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                self.image = image
            }
        }
    }
    
    /// Asynchronous image loading
    ///
    /// - Parameters:
    ///   - url: image url
    ///   - completion: code executed after image loading
    func loadAsync(url: URL, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion()
                    }
                }
            }
        }
    }
}
