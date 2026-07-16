import UIKit

class SavedPostsViewController: UIViewController {
    
    private var savedPosts: [SavedPost] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "SavedPostCell")
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нет сохранённых постов"
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadSavedPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedPosts()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Сохранённые посты"
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadSavedPosts() {
        savedPosts = CoreDataManager.shared.fetchSavedPosts()
        updateUI()
    }
    
    private func updateUI() {
        if savedPosts.isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
            tableView.reloadData()
        }
    }
}

extension SavedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPostCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let savedPost = savedPosts[indexPath.row]
        // Конвертируем SavedPost в Post для отображения
        let post = Post(
            id: Int(savedPost.id),
            author: savedPost.author ?? "",
            date: savedPost.date ?? Date(),
            descriptionText: savedPost.descriptionText ?? "",
            imageURL: savedPost.imageURL ?? "",
            likes: Int(savedPost.likes),
            views: Int(savedPost.views)
        )
        cell.configure(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postToDelete = savedPosts[indexPath.row]
            CoreDataManager.shared.deletePost(post: postToDelete) { [weak self] success in
                if success {
                    self?.loadSavedPosts()
                }
            }
        }
    }
}
