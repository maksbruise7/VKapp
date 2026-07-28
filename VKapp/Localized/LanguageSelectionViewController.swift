import UIKit

class LanguageSelectionViewController: UIViewController {
    
    private let languages: [(code: String, name: String, flag: String)] = [
        ("ru", "Русский", "🇷🇺"),
        ("en", "English", "🇬🇧")
    ]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
        return table
    }()
    
    private let currentLanguageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateLocalization()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocalization),
            name: Notification.Name("LanguageChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(currentLanguageLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            currentLanguageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currentLanguageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentLanguageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: currentLanguageLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func updateLocalization() {
        title = "language".localized
        // 🔧 Устанавливаем текст здесь, когда self уже доступен
        currentLanguageLabel.text = "Language".localized + ": \(getCurrentLanguageName())"
    }
    
    private func getCurrentLanguageName() -> String {
        let currentCode = LocalizationManager.shared.currentLanguage
        return languages.first(where: { $0.code == currentCode })?.name ?? "English"
    }
    
    private func showRestartAlert() {
        let alert = UIAlertController(
            title: "success".localized,
            message: "language changed".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default) { _ in
            self.restartApp()
        })
        present(alert, animated: true)
    }
    
    private func restartApp() {
        // Способ 1: Перезапустить приложение
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}

extension LanguageSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        let language = languages[indexPath.row]
        
        cell.textLabel?.text = "\(language.flag) \(language.name)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        
        let currentCode = LocalizationManager.shared.currentLanguage
        cell.accessoryType = language.code == currentCode ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let language = languages[indexPath.row]
        let currentCode = LocalizationManager.shared.currentLanguage
        
        if language.code == currentCode {
            return
        }
        
        LocalizationManager.shared.currentLanguage = language.code
        tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
        showRestartAlert()
    }
}
