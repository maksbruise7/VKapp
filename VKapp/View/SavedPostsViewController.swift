import UIKit

class SavedPostsViewController: UIViewController {
    
    private var savedPosts: [SavedPost] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedPosts()
        updateLocalization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalization), name: Notification.Name("LanguageChanged"), object: nil)
        }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedPosts()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        updateLocalization()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "SavedPostCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func updateLocalization() {
        title = "saved_title".localized
    }
    
    private func loadSavedPosts() {
        savedPosts = CoreDataManager.shared.fetchSavedPosts()
        tableView.reloadData()
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
