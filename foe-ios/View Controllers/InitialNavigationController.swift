import SwiftKeychainWrapper
import UIKit

class InitialNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO(dinah): remove after testing
        // Programmatically remove accessToken to trigger login
        // KeychainWrapper.standard.remove(key: "accessToken")
        
        // TODO(dinah): ideally this should send a ping to server to verify
        // whether or not access token is valid
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        if (accessToken ?? "").isEmpty {
            perform(#selector(showLogin), with: nil, afterDelay: 0.01)
        }
    }
    
    func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(controller, animated: true, completion: nil)
        
        // TODO(dinah): present login controller without storyboard once mock
        // elements are removed
        /*
         let loginViewController = LoginViewController()
         present(loginViewController, animated: true, completion: nil)
         */
    }

}
