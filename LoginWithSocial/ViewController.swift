//
//  ViewController.swift
//  LoginWithSocial
//
//  Created by musharraf on 12/23/16.
//  Copyright © 2016 Stars Developer. All rights reserved.
//

import UIKit
import LinkedinSwift
import FBSDKLoginKit
import FBSDKCoreKit
import Fabric
import TwitterKit
import TwitterCore

var x: Int?

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    /*************Self Created Var*************/
    let loginManager = FBSDKLoginManager()
    var fbData = [String: AnyObject]()
    var twiData = [String: AnyObject]()
    var lnData = [String: AnyObject]()
    var gData = [String: AnyObject]()
    var image: String?
    var name: String?
    var email: String?
    
    
    /*************LinkedIN*************/
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "816cxw8hlemshm", clientSecret: "T538JCaSvEijyQao", state: "linkedin\(Int(Date().timeIntervalSince1970))", permissions: ["r_basicprofile", "r_emailaddress", "rw_company_admin"], redirectUrl: "https://t.starsfun.com/"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginWithLn(_ sender: Any) {
        
        linkedinHelper.authorizeSuccess({(lsToken) -> Void in
            
            print("Login success lsToken: \(lsToken)")
            
                self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                print("Request success with response: \(response)")
                    let a = response.jsonObject
//                    jsonObject: [AnyHashable : Any]
//                    let data = response["LSResponse - data"]
                    
                    self.lnData.updateValue(a?["emailAddress"] as AnyObject, forKey: "email")
                    let name = "\(a?["firstName"] as AnyObject) \(a?["lastName"] as AnyObject)"
                    self.lnData.updateValue(name as AnyObject, forKey: "name")
                    self.lnData.updateValue(a?["pictureUrl"] as AnyObject, forKey: "image")
                    print(self.lnData)
                    
                }) {(error) -> Void in
                
                print("Encounter error: \(error.localizedDescription)")
                }
            
            }, error: {(error) -> Void in
                
                print("Encounter error: \(error.localizedDescription)")
            }, cancel: {() -> Void in
                
                print("User Cancelled")
        })
        
    }

    @IBAction func loginWithTwitter(_ sender: Any) {
        
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { (session, error) in
            
            
            
            if (session != nil) {
                
                print(session as Any)
                print("signed in as \(session!.userName)");
                
                
                let client = TWTRAPIClient.withCurrentUser()
                
                let request = client.urlRequest(withMethod: "GET", url: "https://api.twitter.com/1.1/account/verify_credentials.json", parameters: ["include_entities": "false", "include_email": "true", "skip_status": "true"], error: nil)
                
                client.sendTwitterRequest(request) { response, data, connectionError in
                    
                    print(response as Any)
                    print(data as Any)
                    
                    if connectionError != nil {
                        print("Error: \(connectionError)")
                        
                    }else{
                        do {
                            let twitterJson = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                            print("json: \(twitterJson)")
                            let name = twitterJson["name"]
                            print(name as Any)
                            self.twiData.updateValue(twitterJson["name"]!, forKey: "name")
                            self.twiData.updateValue(twitterJson["profile_image_url"]!, forKey: "image")
                   
                            print(self.twiData)
                         
                        } catch let jsonError as NSError {
                            print("json error: \(jsonError.localizedDescription)")
                            
                        }
                    }
                    
                }
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
            
            
        }

        
        
    }
   
    @IBAction func loginWithFb(_ sender: Any) {
        x = 1
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            
            if error != nil
            {
                print("error occured with login \(error?.localizedDescription)")
            }
                
            else if (result?.isCancelled)!
            {
                print("login canceled")
            }
                
            else
            {
                if FBSDKAccessToken.current() != nil
                {
                    
                    FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, userResult, error) in
                        
                        
                        if error != nil
                        {
                            print("error occured \(error?.localizedDescription)")
                        }
                        else if userResult != nil
                        {
                            print("Login with FB is success")
                            print(userResult! as Any)
//                            let email = userResult["email"] as? String
                            let email = userResult as? [String:[AnyObject]]
//                             let email = result?["email"]
                            print(email as Any)
                            //
//                    let img_URL: String = (userResult.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                            //
                            //                            let email = (userResult.objectForKey("email") as? String)!
                            //                            //                            let password = "1234567890" //(userResult.objectForKey("id") as? String)!
                            //                            let password =  (userResult.objectForKey("id") as? String)!
                            //
                            //                            let name = (userResult.objectForKey("name") as? String)!
                            
                        }
                        
                    })
                }
                
            }
            
        }
        
    }
    @IBAction func loginWithGoogle(_ sender: Any) {
        x = 2
        loginManager.logOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    /******************************************************/
    /****************** Google Delegates *******************/
    /******************************************************/
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            
            let userId = user.userID                  // For client-side use only!
            let fullName = user.profile.name
            let email = user.profile.email
            let image = user.profile.imageURL(withDimension: 40)
            // [START_EXCLUDE]
            
            gData.updateValue(userId as AnyObject, forKey: "userId")
            gData.updateValue(fullName as AnyObject, forKey: "fullName")
            gData.updateValue(email as AnyObject, forKey: "email")
            gData.updateValue(image as AnyObject, forKey: "image")            
            
          print(gData)
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
            
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logOut(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        
    }

    
    
}
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
