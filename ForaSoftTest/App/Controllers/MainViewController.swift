import UIKit

/// Displays album list
class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    enum Constants {
        static let cellEdge: CGFloat = 10
        static let collectionXCoordinate: CGFloat = 0
        static let collectionYCoordinate: CGFloat = 60
        static let searchBarXCoordinate: CGFloat = 0
        static let searchBarYCoordinate: CGFloat = 0
        static let searchBarHeight: CGFloat = 56
        static let cellIdentifier: String = "AlbumCell"
    }

    var albumCollectionView: UICollectionView!
    
    var searchBar: UISearchBar!
    
    let requestFactory = AlbumRequestFactory()
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var albums: [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let albumLayout = UICollectionViewFlowLayout()
        albumLayout.sectionInset = UIEdgeInsets(top: Constants.cellEdge,
                                                left: Constants.cellEdge,
                                                bottom: Constants.cellEdge,
                                                right: Constants.cellEdge)
        
        albumLayout.itemSize = CGSize(width: self.view.frame.width/3 - 14,
                                      height: self.view.frame.width/2)

        albumCollectionView = UICollectionView(frame: CGRect(x: Constants.collectionXCoordinate,
                                                             y: Constants.collectionYCoordinate,
                                                             width: view.frame.width,
                                                             height: view.frame.height - 2*Constants.collectionYCoordinate),
                                               collectionViewLayout: albumLayout)
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(UINib.init(nibName: Constants.cellIdentifier, bundle: nil),
                                     forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        albumCollectionView.backgroundColor = Colors.background.color

        searchBar = UISearchBar(frame: CGRect(x: Constants.searchBarXCoordinate,
                                              y: Constants.searchBarYCoordinate,
                                              width: view.frame.size.width,
                                              height: Constants.searchBarHeight))
        
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search in iTunes..."
        searchBar.isTranslucent = false
        self.edgesForExtendedLayout = []
        searchBar.delegate = self
        navigationItem.title = "Albums"
        self.view.addSubview(searchBar)
        self.view.addSubview(albumCollectionView)
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        activityIndicator.startAnimating()
        
        requestFactory.getAlbums() { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.albums = value.results
                self?.albums.forEach( { $0.artwork?.load(url: $0.artworkUrl) } )
                self?.activityIndicator.stopAnimating()
                self?.albumCollectionView.reloadData()
            case .failure(let error):
                print("Error: \(String(describing: self?.viewErrorMessage(title: "Error!", error: error)))")
            }
        }
        albums.sort { (a, b) -> Bool in
            return a.name < b.name
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? AlbumCell
        else {
            return AlbumCell()
        }
        albumCell.albumNameLabel.text = albums.element(at: indexPath.row)?.name
        albumCell.artistLabel.text = albums.element(at: indexPath.row)?.artistName
        let image = albums.element(at: indexPath.row)?.artwork?.image
        albumCell.artwork.image = image
        return albumCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumViewController = AlbumViewController()
        albumViewController.album = albums.element(at: indexPath.row)
        self.navigationController?.pushViewController(albumViewController, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            requestFactory.getAlbums(query: searchText) { [weak self] response in
                switch response.result {
                case .success(let value):
                    self?.albums = value.results
                    self?.albums.forEach( { $0.artwork?.loadAsync(url: $0.artworkUrl,
                                                                  completion: {
                                                                    self?.albums.sort { (a, b) -> Bool in
                                                                        return a.name < b.name
                                                                    }
                                                                    self?.activityIndicator.stopAnimating()
                                                                    self?.albumCollectionView.reloadData()
                                                                    
                                                                    })
                        
                    } )
                case .failure(let error):
                    print("Error: \(String(describing: self?.viewErrorMessage(title: "Error!", error: error)))")
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension UIViewController {
    
    /// Displays popup messages when network error occur
    ///
    /// - Parameters:
    ///   - title: message header
    ///   - error: occured error
    /// - Returns: error message
    func viewErrorMessage(title: String, error: Error) -> String {
        let networkError = error as? NetworkError
        if networkError == nil {
            return "No NetworkError!"
        }
        if networkError != .serializationFailed {
            let alert = UIAlertController(title: title, message: error.message(), preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
        return error.message()
    }
}



