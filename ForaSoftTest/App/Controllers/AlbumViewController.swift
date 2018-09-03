import UIKit

/// Displays information about the selected album
class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Animations {
    
    enum Constants {
        static let cellIdentifier: String = "SongCell"
    }
    
    let requestFactory = AlbumRequestFactory()
    
    var album: Album!
    
    lazy var songs: [Song] = []
    
    lazy var songTableView: UITableView = UITableView()
    
    lazy var artwork: UIImageView = {
        guard
            let imageView = album.artwork
        else {
            return UIImageView()
        }
        return imageView
    }()
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(album.name) (\(album.artistName))"
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "\(album.price) \(album.currency)"
        label.font = label.font.withSize(13)
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        guard
            let releaseDate = Date(string: album.releaseDate)
        else {
            return label
        }
       
        label.text = "\(album.genre),  \(String(releaseDate.year))"
        label.font = label.font.withSize(13)
        return label
    }()
    
    lazy var countTracksLabel: UILabel = {
        let label = UILabel()
        label.text = "\(album.trackCount) tracks"
        label.font = label.font.withSize(13)
        return label
    }()
    
    lazy var insideVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.addArrangedSubview(albumNameLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(countTracksLabel)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()
    
    lazy var insideHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.addArrangedSubview(artwork)
        stackView.addArrangedSubview(insideVerticalStackView)
        return stackView
    }()
    
    lazy var mainVerticalStackView: UIStackView = {
        let bounds = navigationController?.navigationBar.bounds
        let stackView = UIStackView(frame: view.frame)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.addArrangedSubview(insideHorizontalStackView)
        stackView.addArrangedSubview(songTableView)
        return stackView
    }()
    
    lazy var hArtworkConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: artwork,
                                            attribute: NSLayoutAttribute.height,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1,
                                            constant: 100)
        return constraint
    }()

    lazy var wArtworkConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: artwork,
                                            attribute: NSLayoutAttribute.width,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1,
                                            constant: 100)
        return constraint
    }()
    
    lazy var xArtWorkConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: artwork,
                                            attribute: NSLayoutAttribute.leading,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: insideHorizontalStackView,
                                            attribute: NSLayoutAttribute.leading,
                                            multiplier: 1,
                                            constant: 13)
        return constraint
    }()
    
    lazy var yArtWorkConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: artwork,
                                            attribute: NSLayoutAttribute.top,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: insideHorizontalStackView,
                                            attribute: NSLayoutAttribute.top,
                                            multiplier: 1,
                                            constant: 20)
        return constraint
    }()
    
    lazy var bottomTableViewConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: songTableView,
                                            attribute: NSLayoutAttribute.bottom,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: view,
                                            attribute: NSLayoutAttribute.bottom,
                                            multiplier: 1,
                                            constant: 0)
        return constraint
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.background.color
        self.view.addSubview(mainVerticalStackView)
        
        NSLayoutConstraint.activate([hArtworkConstraint, wArtworkConstraint, xArtWorkConstraint, yArtWorkConstraint, bottomTableViewConstraint])
        navigationItem.title = "Description"
        self.edgesForExtendedLayout = []
        
        artwork.layer.cornerRadius = 20
        artwork.layer.shadowRadius = 4.0
        artwork.layer.shadowOpacity = 0.6
        artwork.layer.shadowOffset = CGSize.zero
        artwork.layer.masksToBounds = true
        
        songTableView.delegate = self
        songTableView.dataSource = self
        songTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        activityIndicator.startAnimating()
        
        requestFactory.getAlbum(albumId: album.id) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.songs = value.results
                activityIndicator.stopAnimating()
                self?.songTableView.reloadData()
            case .failure(let error):
                print("Error: \(String(describing: self?.viewErrorMessage(title: "Error!", error: error)))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.filter { $0.id != nil }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = songs.filter { $0.id != nil }.element(at: indexPath.row)?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        songCellAnimation(cell: cell)
    }

}
