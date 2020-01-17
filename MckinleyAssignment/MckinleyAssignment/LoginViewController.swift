//
//  ViewController.swift
//  MckinleyAssignment
//
//  Created by Saurabh Borate on 17/01/20.
//  Copyright © 2020 Phynart. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    var apiURL = "https://reqres.in/api/login"
    @IBOutlet weak var scrollView: UIScrollView!
        var activityIndicator : UIActivityIndicatorView?
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var idTextfield: UITextField!
    @IBOutlet weak var scrollViewHeightConstraints: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        if idTextfield.text == "" || passwordTextField.text == "" {
            let alert = UIAlertController.init(title: "Error", message: "Please enter user name and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            DispatchQueue.main.async {
                self.activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
                self.activityIndicator?.center = self.view.center
                self.view.addSubview(self.activityIndicator!)
                self.view.bringSubviewToFront(self.activityIndicator!)
                self.activityIndicator?.color = .black
                self.activityIndicator?.startAnimating()
                self.loginRequest()
            }
            
        }
    }
    func loginRequest(){
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        
        let postData = NSMutableData(data: "email=\(idTextfield.text!)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(passwordTextField.text!)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            self.activityIndicator?.stopAnimating()
            if let error = error {
                print("error: \(error)")
                let alert = UIAlertController.init(title: "Error", message: "Invalid Login", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let response = response as? HTTPURLResponse {
                    
                    
                    if response.statusCode == 200 {
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            
                            if let dict = self.convertToDictionary(text: dataString) {
                                print(dict)
                                if let token = dict["token"] as? String {
                                    
                                    UserDefaults.standard.setValue(token, forKey: "LoginToken")
                                    DispatchQueue.main.async {
                                        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebsiteViewController") as! WebsiteViewController
                                        self.present(webVC, animated: true, completion: nil)
                                    }
                                    
                                }
                            }
                            
                        }
                    }else {
                        let alert = UIAlertController.init(title: "Error", message: "Invalid Login", preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
}
