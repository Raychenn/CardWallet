import UIKit

class CardView: UIView {
    private let cardNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Physical • 1234"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nitraLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(named: "nitra_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cardTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "•••• 1234"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .black
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        
        addSubview(statusIndicator)
        addSubview(cardNameLabel)
        addSubview(cardTypeLabel)
        addSubview(nitraLogoImageView)
        addSubview(cardTypeImageView)
        addSubview(cardNumberLabel)
        
        NSLayoutConstraint.activate([
            statusIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            statusIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusIndicator.widthAnchor.constraint(equalToConstant: 8),
            statusIndicator.heightAnchor.constraint(equalToConstant: 8),
            
            cardNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cardNameLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 8),
            
            cardTypeLabel.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 4),
            cardTypeLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 8),
            
            nitraLogoImageView.centerYAnchor.constraint(equalTo: cardNameLabel.centerYAnchor),
            nitraLogoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nitraLogoImageView.widthAnchor.constraint(equalToConstant: 60),
            nitraLogoImageView.heightAnchor.constraint(equalToConstant: 24),
            
            cardTypeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardTypeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            cardTypeImageView.widthAnchor.constraint(equalToConstant: 50),
            cardTypeImageView.heightAnchor.constraint(equalToConstant: 16),
            
            cardNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with card: Card) {
        cardNameLabel.text = card.cardName
        cardTypeImageView.image = UIImage(named: card.cardType.rawValue.lowercased())
        cardNumberLabel.text = card.maskedCardNumber
    }
} 
