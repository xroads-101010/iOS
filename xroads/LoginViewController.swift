//
//  LoginViewController.swift
//  xroads
//
//  Created by Abin Anto on 18/02/16.
//  Copyright (c) 2016 lister. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var userId: UITextField!
    @IBOutlet var password: UITextField!
    
    var userData = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated: true)
        // Do any additional setup after loading the view.
        
        //userId.text = "abin";
        //password.text = "123";
        
        let textfieldBorderColor: CGColor = UIColor(hue: 0.025, saturation: 0.3, brightness: 0.93, alpha: 1.0).CGColor
        
        userId.layer.cornerRadius = 8.0
        userId.layer.masksToBounds = true
        userId.layer.borderColor = textfieldBorderColor
        userId.layer.borderWidth = 2.0
        
        password.layer.cornerRadius = 8.0
        password.layer.masksToBounds = true
        password.layer.borderColor = textfieldBorderColor
        password.layer.borderWidth = 2.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginClick(sender: AnyObject)
    {
        if(userId.text == "" || password.text == "" ){
            let alert = UIAlertController(title: "Warning", message: "UserName and Password mandatory.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        doUserLogin(ApiEndPoints().loginEndPoint!);
    }
    
    func doUserLogin(path: String)
    {
        LoadingOverlay.shared.showOverlay(self.view)
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let userInputData:NSMutableDictionary = NSMutableDictionary()
        userInputData.setValue(userId.text!, forKey: "userName")
        userInputData.setValue(password.text!, forKey: "password")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(userInputData, options: NSJSONWritingOptions())
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            
            let jsonData: NSDictionary
            
            let httpResponse = response as? NSHTTPURLResponse
            
            if(httpResponse?.statusCode == 200)
            {
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(responseData,
                        options: NSJSONReadingOptions()) as! NSDictionary
                    
                    
                    
                    UserModel.sharedManager.jsonParse(jsonData)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let tripView = self.storyboard!.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                        
                        self.navigationController!.pushViewController(tripView, animated: true)
                    })
                    
                    /*dispatch_async(dispatch_get_main_queue(), {
                        
                        let tripView = self.storyboard!.instantiateViewControllerWithIdentifier("AllMembersTableViewController") as! AllMembersTableViewController
                        
                        self.navigationController!.pushViewController(tripView, animated: true)
                    })*/
                    
                    print(jsonData)
                    
                } catch  {
                    print("error trying to convert data to JSON")
                    LoadingOverlay.shared.hideOverlayView()
                    let alert = UIAlertController(title: "Error", message: "Login Failed.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
            }
            else
            {
                LoadingOverlay.shared.hideOverlayView()
            }
           
        })
        
        task.resume()
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
