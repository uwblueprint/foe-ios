import Alamofire
import SwiftKeychainWrapper
import UIKit

class InitialNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO(dinah): remove after testing
        // Programmatically remove accessToken to trigger login
         KeychainWrapper.standard.remove(key: "accessToken")
        
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        if (accessToken ?? "").isEmpty {
            perform(#selector(showLogin), with: nil, afterDelay: 0.01)
        } else {
            ServerGateway.validateAccessToken(accessToken: accessToken!, failureCallback: { self.perform(#selector(self.showLogin), with: nil, afterDelay: 0.01) })
        }
    }
    
    func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(controller, animated: true, completion: nil)
    }
}
