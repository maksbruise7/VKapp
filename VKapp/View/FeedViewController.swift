import UIKit

class FeedViewController: UIViewController {
    
    private var posts: [Post] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadPosts()
        setupDoubleTapGesture()
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
        view.backgroundColor = .appBackground
        updateLocalization()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.backgroundColor = .appBackground
        tableView.separatorColor = .appSeparator
    }
    
    private func loadPosts() {
        posts = [
            Post(id: 1, author: "Алексей", date: Date(), descriptionText: "Первый пост! Сегодня отличная погода!", imageURL: "", likes: 10, views: 100),
            Post(id: 2, author: "Мария", date: Date(), descriptionText: "Второй пост. Изучаю SwiftUI и CoreData", imageURL: "", likes: 25, views: 200),
            Post(id: 3, author: "Иван", date: Date(), descriptionText: "Третий пост. Наконец-то разобрался с двойным кликом!", imageURL: "", likes: 5, views: 50)
        ]
        tableView.reloadData()
    }
    
    private func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func updateLocalization() {
        title = "feed_title".localized
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else { return }
        
        let post = posts[indexPath.row]
        
        if CoreDataManager.shared.isPostSaved(postId: post.id) {
            showAlert(title: "info".localized, message: "alert_post_already_saved".localized)
            return
        }
        
        CoreDataManager.shared.savePost(post: post) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.showAlert(title: "success".localized, message: "alert_post_saved".localized)
                } else {
                    self?.showAlert(title: "error".localized, message: "alert_save_error".localized)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}
