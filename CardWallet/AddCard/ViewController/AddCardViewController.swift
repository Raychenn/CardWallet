import UIKit

protocol AddCardViewControllerDelegate: AnyObject {
    func didAddNewCard(_ card: Card)
} 

class AddCardViewController: UIViewController {
    
    // MARK: Properties
    
    weak var delegate: AddCardViewControllerDelegate?
    
    let viewModel: AddCardViewModel = AddCardViewModel()
    
    private lazy var fieldMapping: [UITextField: (AddCardViewModel.TextFieldType, UILabel)] = [
        cardNameField: (.cardName, cardNameErrorLabel),
        nameOnCardField: (.nameOnCard, nameOnCardErrorLabel),
        cardNumberField: (.cardNumber, cardNumberErrorLabel),
        monthField: (.month, expirationErrorLabel),
        yearField: (.year, expirationErrorLabel),
        securityCodeField: (.cvv, securityCodeErrorLabel)
    ]
    
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
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let expirationDateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let cardNameField: UITextField = UITextField.defaultTextField(placeholder: "Card Name")
    
    private let nameOnCardField: UITextField = UITextField.defaultTextField(placeholder: "Name on Card")
    
    private let cardNumberField: UITextField = UITextField.defaultTextField(placeholder: "0000 0000 0000 0000", keyboardType: .numberPad)
    
    private let monthField: UITextField = UITextField.defaultTextField(placeholder: "Month")
    
    private let yearField: UITextField = UITextField.defaultTextField(placeholder: "Year")
    
    private let securityCodeField: UITextField = UITextField.defaultTextField(
        placeholder: "Security Code",
        isSecure: true,
        keyboardType: .numberPad,
        returnKeyType: .done
    )
    
    private let cardNameErrorLabel = UILabel().makeErrorLabel()
    private let nameOnCardErrorLabel = UILabel().makeErrorLabel()
    private let cardNumberErrorLabel = UILabel().makeErrorLabel()
    private let expirationErrorLabel = UILabel().makeErrorLabel()
    private let securityCodeErrorLabel = UILabel().makeErrorLabel()
    
    private let addCardButton: AddCardButton = {
        let button = AddCardButton(type: .system)
        button.setTitle("Add Card", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
        setupTextFieldDelegates()
    }
    
    // MARK: Helpers
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Add fields to stack view
        stackView.addArrangedSubview(createFieldStack(text: "Card Name*", field: cardNameField, errorLabel: cardNameErrorLabel))
        stackView.addArrangedSubview(createFieldStack(text: "Name on Card*", field: nameOnCardField, errorLabel: nameOnCardErrorLabel))
        stackView.addArrangedSubview(createFieldStack(text: "Card Number*", field: cardNumberField, errorLabel: cardNumberErrorLabel))
        
        // Add expiration date fields
        let expDateStack = createFieldStack(text: "Exp Date*", field: expirationDateStack, errorLabel: expirationErrorLabel)
        expirationDateStack.addArrangedSubview(monthField)
        expirationDateStack.addArrangedSubview(yearField)
        stackView.addArrangedSubview(expDateStack)
        
        stackView.addArrangedSubview(createFieldStack(text: "Card Security Code*", field: securityCodeField, errorLabel: securityCodeErrorLabel))
        stackView.addArrangedSubview(addCardButton)
        addCardButton.isEnabled = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            addCardButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        addCardButton.addTarget(self, action: #selector(addCardButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        title = "New Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func createFieldStack(text: String, field: UIView, errorLabel: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(field)
        stack.addArrangedSubview(errorLabel)
        
        return stack
    }

    private func setupTextFieldDelegates() {
        [
            cardNameField,
            nameOnCardField,
            cardNumberField,
            monthField,
            yearField,
            securityCodeField
        ].forEach { field in
            field.delegate = self
            field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    private func validate(textField: UITextField) {
        guard let (type, errorLabel) = fieldMapping[textField] else { return }
        
        let isValid = viewModel.validateField(type: type, value: textField.text)
        errorLabel.text = isValid ? nil : viewModel.errorMessage(for: type)
        errorLabel.isHidden = isValid
        textField.highlightError(!isValid)

        let allFields: [(AddCardViewModel.TextFieldType, String?)] = [
            (.cardName, cardNameField.text),
            (.nameOnCard, nameOnCardField.text),
            (.cardNumber, cardNumberField.text),
            (.month, monthField.text),
            (.year, yearField.text),
            (.cvv, securityCodeField.text)
        ]
        let (formValid, _) = viewModel.validateAllFields(allFields)
        addCardButton.isEnabled = formValid
    }
    
    private func nextTextField(after textField: UITextField) -> UITextField? {
        let fields = [cardNameField, nameOnCardField, cardNumberField, monthField, yearField, securityCodeField]
        guard let index = fields.firstIndex(of: textField), index < fields.count - 1 else { return nil }
        return fields[index + 1]
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validate(textField: textField)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addCardButtonTapped() {
        let card = Card(
            id: UUID().uuidString,
            cardName: cardNameField.text ?? "",
            nameOnCard: nameOnCardField.text ?? "",
            cardNumber: cardNumberField.text?.replacingOccurrences(of: " ", with: "") ?? "",
            expirationMonth: monthField.text ?? "",
            expirationYear: yearField.text ?? "",
            cvv: securityCodeField.text ?? "",
            cardType: viewModel.detectCardBrandRegex(cardNumber: cardNumberField.text ?? "")
        )
        
        delegate?.didAddNewCard(card)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UITextFieldDelegate

extension AddCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch textField {
        case cardNumberField:
            let filtered = updatedText.replacingOccurrences(of: " ", with: "")
            
            // Limit to 16 digits
            guard filtered.count <= 16,
                  CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }

            // Insert space every 4 digits
            var formatted = ""
            for (index, char) in filtered.enumerated() {
                if index != 0 && index % 4 == 0 {
                    formatted += " "
                }
                formatted.append(char)
            }

            textField.text = formatted
            return false
        case monthField:
            return updatedText.count <= 2 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
            
        case yearField:
            return updatedText.count <= 2 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
            
        case securityCodeField:
            return updatedText.count <= 3 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
            
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let (type, errorLabel) = fieldMapping[textField] else { return true }
        
        let isValid = viewModel.validateField(type: type, value: textField.text)
        errorLabel.text = isValid ? nil : viewModel.errorMessage(for: type)
        errorLabel.isHidden = isValid
        textField.highlightError(!isValid)
        
        if isValid {
            // Move to next responder if available
            if let next = nextTextField(after: textField) {
                next.becomeFirstResponder()
            } else {
                textField.resignFirstResponder() // Last field
            }
        } else {
            // Stay on current invalid field
            textField.becomeFirstResponder()
        }
    
        return true
    }
}
