//
//  RegisterController.swift
//  xroads
//
//  Created by Abin Anto on 18/02/16.
//  Copyright (c) 2016 lister. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    @IBOutlet var mobileNumber: UITextField!
    @IBOutlet var emailId: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var registerButton: UIButton!

    @IBAction func clickRegisterButton(sender: AnyObject) {
        
        LoadingOverlay.shared.showOverlay(self.view)
        dispatch_async(dispatch_get_main_queue(), {
            self.register()
        })
    }
    
    func register(){
        if(mobileNumber.text == "" || emailId.text == "" || name.text == "" || password.text == "" || confirmPassword == "")
            
        {
            let alert = UIAlertController(title: "All fields are mandatory", message: "Some of the mandatory fields are missing.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            LoadingOverlay.shared.hideOverlayView()
            return
        }
        
        let path: String = ApiEndPoints().registrationEndPoint!
        let request = NSMutableURLRequest(URL: NSURL(string: path)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(emailId.text, forKey: "email")
        para.setValue(mobileNumber.text, forKey: "userMobile")
        para.setValue(name.text, forKey: "userName")
        para.setValue(password.text, forKey: "password")
        para.setValue("true", forKey: "isRegistered")
        
        let jsonData: NSData
        var jsonString:String="";
        do{
            jsonData = try NSJSONSerialization.dataWithJSONObject(para, options: NSJSONWritingOptions())
            jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            print("json string = \(jsonString)")
            
        } catch _ {
            print ("UH OOO")
        }
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send the request
        do {
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            // use jsonData
        } catch {
            // report error
        }
        
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse {
            if(httpResponse.statusCode == 200)
            {
                
                let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                self.navigationController!.pushViewController(loginView, animated: true)
                
                print("HTTP response: \(httpResponse.statusCode)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let alert = UIAlertController(title: "Success", message: "User created successfully.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
                
            }
            else
            {
                let alert = UIAlertController(title: "Failure", message: "User creation failed.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                LoadingOverlay.shared.hideOverlayView()
            }
            
        }
        else
        {
            print("No HTTP response")
            
            let alert = UIAlertController(title: "Failure", message: "User creation failed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated: true)
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let textfieldBorderColor: CGColor = UIColor(hue: 0.025, saturation: 0.3, brightness: 0.93, alpha: 1.0).CGColor
        
        mobileNumber.layer.cornerRadius = 8.0
        mobileNumber.layer.masksToBounds = true
        mobileNumber.layer.borderColor = textfieldBorderColor
        mobileNumber.layer.borderWidth = 2.0
        
        emailId.layer.cornerRadius = 8.0
        emailId.layer.masksToBounds = true
        emailId.layer.borderColor = textfieldBorderColor
        emailId.layer.borderWidth = 2.0
        
        name.layer.cornerRadius = 8.0
        name.layer.masksToBounds = true
        name.layer.borderColor = textfieldBorderColor
        name.layer.borderWidth = 2.0
        
        password.layer.cornerRadius = 8.0
        password.layer.masksToBounds = true
        password.layer.borderColor = textfieldBorderColor
        password.layer.borderWidth = 2.0
        
        confirmPassword.layer.cornerRadius = 8.0
        confirmPassword.layer.masksToBounds = true
        confirmPassword.layer.borderColor = textfieldBorderColor
        confirmPassword.layer.borderWidth = 2.0
    
    }
    
    @IBAction func confirmPasswordDidEndEditing(sender: AnyObject) {
        
        if(confirmPassword.text != password.text){
            let alert = UIAlertController(title: "Password Mismatch", message: "Passwords you have entered does'nt match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
