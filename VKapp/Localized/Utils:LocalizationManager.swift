import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()
    
    private init() {}
    
    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: "app_language") ?? Locale.current.language.languageCode?.identifier ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "app_language")
            UserDefaults.standard.synchronize()
            setLanguage(newValue)
        }
    }
    
    func setLanguage(_ languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    func localizedString(forKey key: String, arguments: CVarArg...) -> String {
        return String(format: localizedString(forKey: key), arguments: arguments)
    }
}
