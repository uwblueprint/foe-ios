import Foundation

import Alamofire
import SwiftKeychainWrapper

class ServerGateway {
    static func authenticatedRequest(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        success: @escaping (DataResponse<Any>) -> Void,
        failure: @escaping (DataResponse<Any>) -> ()
    ) {
        let headers: HTTPHeaders = [
            "access-token": KeychainWrapper.standard.string(forKey: "accessToken")!,
            "token-type": "Bearer",
            "client": KeychainWrapper.standard.string(forKey: "client")!,
            "uid": KeychainWrapper.standard.string(forKey: "uid")!
        ]
        
        Alamofire.request(
            "\(API_URL)\(url)",
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseJSON { response in
            rotateTokens(response)

            switch response.result {
            case .success:
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }

                success(response)
            case .failure(let error):
                print("Validation failure on login")
                print(error)

                failure(response)
            }
        }
    }
    
    static func rotateTokens(_ response: (DataResponse<Any>)) {
        if
            let accessToken = response.response?.allHeaderFields["access-token"] as! String?,
            let client = response.response?.allHeaderFields["client"] as! String?,
            let uid = response.response?.allHeaderFields["uid"] as! String?
        {
            print("accessToken: \(accessToken)")
            KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
            KeychainWrapper.standard.set(client, forKey: "client")
            KeychainWrapper.standard.set(uid, forKey: "uid")
        }
    }
}
