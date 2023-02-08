import UIKit

class ArticlesCell: UITableViewCell {
    
    var nameLabel : UILabel
    var descLabel : UILabel
    var loading : UIActivityIndicatorView
    var image: UIImageView
    
    var viewModel : ArticleDetailViewModel?{
        didSet{
                        
            nameLabel.text = viewModel?.article.title
            descLabel.text = viewModel?.article.description
            
            image.image = nil
            
            viewModel?.delegate = self
            viewModel?.loadImage()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel()
        descLabel = UILabel()
        loading = UIActivityIndicatorView(style: .large)
        image = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not In Storyboard")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupViews(){
        backgroundColor = .white
                
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.layer.borderWidth = 3
        container.layer.borderColor = UIColor.black.cgColor
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let frame  = UIView()
        frame.backgroundColor = .white
        container.addSubview(frame)
        frame.translatesAutoresizingMaskIntoConstraints = false
        frame.widthAnchor.constraint(equalToConstant: 100).isActive = true
        frame.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        frame.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        frame.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        frame.layer.cornerRadius = 10
        frame.layer.masksToBounds = true
        
        loading.color = .black
        frame.addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loading.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loading.centerXAnchor.constraint(equalTo: frame.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: frame.centerYAnchor).isActive = true
        loading.hidesWhenStopped = false
        loading.startAnimating()
        
        frame.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: frame.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: frame.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: frame.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: frame.bottomAnchor).isActive = true

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 3
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .left
        container.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: frame.trailingAnchor, constant: 5).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        descLabel.font = UIFont.boldSystemFont(ofSize: 14)
        descLabel.textColor = .black
        descLabel.numberOfLines = 0
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.textAlignment = .left
        container.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: frame.trailingAnchor, constant: 5).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        loading.isHidden = false
        loading.startAnimating()
    }
}

extension ArticlesCell : ArticleDetailDelegate {
    
    func imageLoaded(_ imageData: Data) {
        image.image = UIImage(data: imageData)
        loading.isHidden = true
    }
    
    func foundError(_ error: ApiError) {
        switch error {
        case .URL:
            print("URL Error")
        case .Connection:
            print("Connection Error")
        case .Json:
            print("JSON Error")
        }
    }
    
    
}
