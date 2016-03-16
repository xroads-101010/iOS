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
        
        userId.text = "abc1";
        password.text = "passwd";
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
    
    
    func login(path: String)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(userId.text!, forKey: "userName")
        para.setValue(password.text!, forKey: "password")
        
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
            print("HTTP response: \(httpResponse.statusCode)")
        } else {
            print("No HTTP response")
        }

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
