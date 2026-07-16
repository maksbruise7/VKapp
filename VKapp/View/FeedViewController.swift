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
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Лента"
        
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
    }
    
    private func loadPosts() {
        // Загрузка тестовых постов
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
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else { return }
        
        let post = posts[indexPath.row]
        
        // Проверяем, сохранён ли уже пост
        if CoreDataManager.shared.isPostSaved(postId: post.id) {
            showAlert(title: "Информация", message: "Этот пост уже сохранён")
            return
        }
        
        // Сохраняем пост
        CoreDataManager.shared.savePost(post: post) { [weak self] success in
            if success {
                self?.showAlert(title: "Успех", message: "Пост сохранён!")
            } else {
                self?.showAlert(title: "Ошибка", message: "Не удалось сохранить пост")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
