import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VKPostModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    func savePost(post: Post, completion: @escaping (Bool) -> Void) {
        let savedPost = SavedPost(context: context)
        savedPost.id = Int64(post.id)
        savedPost.author = post.author
        savedPost.date = post.date
        savedPost.descriptionText = post.descriptionText
        savedPost.imageURL = post.imageURL
        savedPost.likes = Int64(post.likes)
        savedPost.views = Int64(post.views)
        savedPost.savedDate = Date()
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save post: \(error)")
            completion(false)
        }
    }
    
    func fetchSavedPosts() -> [SavedPost] {
        let fetchRequest: NSFetchRequest<SavedPost> = SavedPost.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "savedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let savedPosts = try context.fetch(fetchRequest)
            return savedPosts
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }
    
    func deletePost(post: SavedPost, completion: @escaping (Bool) -> Void) {
        context.delete(post)
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to delete post: \(error)")
            completion(false)
        }
    }
    
    func isPostSaved(postId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<SavedPost> = SavedPost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", postId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check if post is saved: \(error)")
            return false
        }
    }
}
