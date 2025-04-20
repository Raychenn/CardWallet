import UIKit

class CardsViewController: UIViewController {
    
    // MARK: Properties
    
    private var cardViews: [CardView] = []
    private var draggedCard: CardView?
    private var originalCardPosition: CGPoint?
    private var cardInitialCenter: CGPoint?
    private let cardLiftDistance: CGFloat = 20
    private let viewModel: CardsViewModel = CardsViewModel()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = -120 // Negative spacing for card stacking effect
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "no_credit_card")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Add credit, debit or store cards to make sure payments in apps."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dropdownButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "My Cards"
        config.baseForegroundColor = .label
        config.background.backgroundColor = .secondarySystemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        config.cornerStyle = .medium

        let button = UIButton(configuration: config, primaryAction: nil)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(dropdownButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dropdownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "drop_down_icon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .tertiaryLabel
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addFirstCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Your First Card", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(addFirstCardButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addCardButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "Add Card"
        config.image = UIImage(named: "credit_card_icon")
        config.baseBackgroundColor = .systemOrange
        config.baseForegroundColor = .white
        config.imagePadding = 8
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var updated = incoming
            updated.font = .systemFont(ofSize: 14, weight: .semibold)
            return updated
        }

        let button = UIButton(configuration: config, primaryAction: nil)
        button.addTarget(self, action: #selector(addCardButtonTapped), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        updateEmptyState()
    }
    
    // MARK: Helpers
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(dropdownButton)
        dropdownButton.addSubview(countLabel)
        dropdownButton.addSubview(dropdownImageView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        view.addSubview(emptyStateImageView)
        view.addSubview(emptyStateLabel)
        
        view.addSubview(addFirstCardButton)
        view.addSubview(addCardButton)
        
        NSLayoutConstraint.activate([
            dropdownButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dropdownButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dropdownButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dropdownButton.heightAnchor.constraint(equalToConstant: 44),
            
            countLabel.centerYAnchor.constraint(equalTo: dropdownButton.centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: dropdownButton.titleLabel?.trailingAnchor ?? dropdownButton.trailingAnchor, constant: 8),
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 23),
            countLabel.heightAnchor.constraint(equalToConstant: 16),
            
            dropdownImageView.centerYAnchor.constraint(equalTo: dropdownButton.centerYAnchor),
            dropdownImageView.trailingAnchor.constraint(equalTo: dropdownButton.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: dropdownButton.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 250),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 120),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            addFirstCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addFirstCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addFirstCardButton.heightAnchor.constraint(equalToConstant: 50),
            addFirstCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -230),
            
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCardButton.widthAnchor.constraint(equalToConstant: 120),
            addCardButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Card"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(menuButtonTapped))
        navigationItem.leftBarButtonItem = menuButton
        
        let languageButton = UIBarButtonItem(title: "LC",
                                           style: .plain,
                                           target: self,
                                           action: #selector(languageButtonTapped))
        navigationItem.rightBarButtonItem = languageButton
    }
    
    private func setupCardInteractions(_ cardView: CardView) {
        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        
        // Long press gesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        
        cardView.addGestureRecognizer(tapGesture)
        cardView.addGestureRecognizer(longPressGesture)
        cardView.isUserInteractionEnabled = true
    }
    
    private func updateCards(_ newCards: [Card]) {
        let cards = viewModel.cards
        countLabel.text = "\(cards.count)"
        
        // Remove existing card views
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()
        
        // Add new card views
        for card in cards {
            let cardView = CardView(frame: .zero)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.configure(with: card)
            setupCardInteractions(cardView)
            
            stackView.addArrangedSubview(cardView)
            cardViews.append(cardView)
            
            // Set height constraint for card view
            cardView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        if viewModel.isEmptyState {
            emptyStateLabel.isHidden = false
            emptyStateImageView.isHidden = false
            scrollView.isHidden = true
            countLabel.text = "0"
            addFirstCardButton.isHidden = false
            addCardButton.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            emptyStateImageView.isHidden = true
            scrollView.isHidden = false
            addFirstCardButton.isHidden = true
            addCardButton.isHidden = false
        }
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view as? CardView,
              let index = cardViews.firstIndex(of: cardView) else { return }
        
        let cards = viewModel.cards
        
        // Only animate if it's not the first card
        if index > 0 {
            // Animate card lift
            UIView.animate(withDuration: 0.2, animations: {
                cardView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                cardView.layer.shadowColor = UIColor.black.cgColor
                cardView.layer.shadowOpacity = 0.3
                cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
                cardView.layer.shadowRadius = 10
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cardView.transform = .identity
                    cardView.layer.shadowOpacity = 0
                }
            }
        }
        
        // Navigate to card details
        let selectedCard = cards[index]
        let detailsVC = CardDetailsViewController(card: selectedCard)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let cardView = gesture.view as? CardView,
              let index = cardViews.firstIndex(of: cardView) else { return }
        
        // Skip animation for the first card
        if index == 0 { return }
        
        switch gesture.state {
        case .began:
            // Store the initial position
            cardInitialCenter = cardView.center
            
            // Lift animation
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseOut) {
                cardView.center.y -= self.cardLiftDistance
                cardView.layer.shadowColor = UIColor.black.cgColor
                cardView.layer.shadowOpacity = 0.2
                cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
                cardView.layer.shadowRadius = 8
            }
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
        case .changed:
            // Allow slight vertical movement while holding
            let translation = gesture.location(in: view)
            let newY = (cardInitialCenter?.y ?? 0) - cardLiftDistance + translation.y
            
            // Limit the movement range
            let maxUpward = (cardInitialCenter?.y ?? 0) - cardLiftDistance - 10
            let maxDownward = (cardInitialCenter?.y ?? 0) - cardLiftDistance + 10
            
            cardView.center.y = min(max(newY, maxUpward), maxDownward)
            
        case .ended, .cancelled:
            // Return to original position with spring animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseOut) {
                cardView.center = self.cardInitialCenter ?? cardView.center
                cardView.layer.shadowOpacity = 0
            }
            
            cardInitialCenter = nil
            
        default:
            break
        }
    }
    
    @objc private func menuButtonTapped() {
        // Handle menu button tap
    }
    
    @objc private func languageButtonTapped() {
        // Handle language button tap
    }
    
    @objc private func addCardButtonTapped() {
        let addCardVC = AddCardViewController()
        addCardVC.delegate = self
        navigationController?.pushViewController(addCardVC, animated: true)
    }
    
    @objc private func addFirstCardButtonTapped() {
        let addCardVC = AddCardViewController()
        addCardVC.delegate = self
        navigationController?.pushViewController(addCardVC, animated: true)
    }
    
    @objc private func dropdownButtonTapped() {
        print("handle dropdown button tap")
    }
}

// MARK: - CardManagementDelegate
extension CardsViewController: AddCardViewControllerDelegate {
    func didAddNewCard(_ card: Card) {
        viewModel.add(card)
        updateCards(viewModel.cards)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CardsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
} 
