import UIKit

class CardDetailsViewController: UIViewController {
    private let card: Card
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cardNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "card_status_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nitraLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(named: "nitra_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cardNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "Card Number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expirationDateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.text = "Exp Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expirationDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cvvTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.text = "CVV"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cvvLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameOnCardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name on Card"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameOnCardLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var copyCardNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "copy_icon"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(copyCardNumber), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var copyExpiryDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "copy_icon"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(copyExpiryDate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var copyCVVCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "copy_icon"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(copyCVV), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(card: Card) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        configureWithCard()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(cardView)
        cardView.addSubview(cardNameLabel)
        cardView.addSubview(statusImageView)
        cardView.addSubview(nitraLogoImageView)
        cardView.addSubview(cardNumberTitleLabel)
        cardView.addSubview(cardNumberLabel)
        cardView.addSubview(copyCardNumberButton)
        cardView.addSubview(copyExpiryDateButton)
        cardView.addSubview(expirationDateTitleLabel)
        cardView.addSubview(expirationDateLabel)
        cardView.addSubview(copyCVVCodeButton)
        cardView.addSubview(cvvLabel)
        cardView.addSubview(cvvTitleLabel)
        cardView.addSubview(cardTypeImageView)
        
        view.addSubview(nameInfoView)
        nameInfoView.addSubview(nameOnCardTitleLabel)
        nameInfoView.addSubview(nameOnCardLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalToConstant: 200),
            
            statusImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            statusImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            
            cardNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            cardNameLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 8),
            
            nitraLogoImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            nitraLogoImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            nitraLogoImageView.widthAnchor.constraint(equalToConstant: 60),
            nitraLogoImageView.heightAnchor.constraint(equalToConstant: 24),
            
            cardNumberTitleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -32),
            cardNumberTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            cardNumberLabel.topAnchor.constraint(equalTo: cardNumberTitleLabel.bottomAnchor, constant: 2),
            cardNumberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            copyCardNumberButton.centerYAnchor.constraint(equalTo: cardNumberLabel.centerYAnchor),
            copyCardNumberButton.leadingAnchor.constraint(equalTo: cardNumberLabel.trailingAnchor, constant: 8),
            
            expirationDateTitleLabel.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 16),
            expirationDateTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            expirationDateLabel.topAnchor.constraint(equalTo: expirationDateTitleLabel.bottomAnchor, constant: 2),
            expirationDateLabel.leadingAnchor.constraint(equalTo: expirationDateTitleLabel.leadingAnchor),
            
            copyExpiryDateButton.centerYAnchor.constraint(equalTo: expirationDateLabel.centerYAnchor),
            copyExpiryDateButton.leadingAnchor.constraint(equalTo: expirationDateLabel.trailingAnchor, constant: 2),
            
            cvvTitleLabel.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 16),
            cvvTitleLabel.leadingAnchor.constraint(equalTo: expirationDateLabel.trailingAnchor, constant: 64),
            
            cvvLabel.topAnchor.constraint(equalTo: cvvTitleLabel.bottomAnchor, constant: 2),
            cvvLabel.leadingAnchor.constraint(equalTo: cvvTitleLabel.leadingAnchor),
            
            copyCVVCodeButton.centerYAnchor.constraint(equalTo: cvvLabel.centerYAnchor),
            copyCVVCodeButton.leadingAnchor.constraint(equalTo: cvvLabel.trailingAnchor, constant: 2),
            
            cardTypeImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            cardTypeImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            cardTypeImageView.widthAnchor.constraint(equalToConstant: 50),
            cardTypeImageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameInfoView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            nameInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameInfoView.heightAnchor.constraint(equalToConstant: 60),
            
            nameOnCardTitleLabel.topAnchor.constraint(equalTo: nameInfoView.topAnchor, constant: 8),
            nameOnCardTitleLabel.leadingAnchor.constraint(equalTo: nameInfoView.leadingAnchor, constant: 8),
            
            nameOnCardLabel.topAnchor.constraint(equalTo: nameOnCardTitleLabel.bottomAnchor, constant: 8),
            nameOnCardLabel.leadingAnchor.constraint(equalTo: nameInfoView.leadingAnchor, constant: 8),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Card Details"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func showCopyConfirmation() {
        let alert = UIAlertController(title: nil, message: "Copied to clipboard", preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
    
    private func configureWithCard() {
        cardNameLabel.text = card.cardName
        cardNumberLabel.text = card.cardNumber.groupedEvery4Digits
        expirationDateLabel.text = card.expirationDate
        cvvLabel.text = card.cvv
        cardTypeImageView.image = UIImage(named: card.cardType.rawValue.lowercased())
        nameOnCardLabel.text = card.nameOnCard
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func copyCardNumber() {
        UIPasteboard.general.string = card.cardNumber
        showCopyConfirmation()
    }
    
    @objc private func copyName() {
        UIPasteboard.general.string = card.nameOnCard
        showCopyConfirmation()
    }
    
    @objc private func copyCVV() {
        UIPasteboard.general.string = card.cvv
        showCopyConfirmation()
    }
    
    @objc private func copyExpiryDate() {
        UIPasteboard.general.string = card.expirationDate
        showCopyConfirmation()
    }
}
