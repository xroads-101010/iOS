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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated: true)
        // Do any additional setup after loading the view.
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
        doUserLogin2(ApiEndPoints().loginEndPoint!);
    }
    
    /*func doUserLogin(path: String)
    {
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        var response: NSURLResponse?
        
        let userInputData:NSMutableDictionary = NSMutableDictionary()
        userInputData.setValue(userId.text!, forKey: "userName")
        userInputData.setValue(password.text!, forKey: "password")
        
        let json: NSData
        var jsonString:String="";
        
        do {
           // json = try NSJSONSerialization.dataWithJSONObject(userInputData, options: NSJSONReadingOptions())
            json = try NSJSONSerialization.dataWithJSONObject(userInputData, options: NSJSONWritingOptions())
            jsonString = NSString(data: json, encoding: NSUTF8StringEncoding) as! String
            
                        
        } catch  {
            print("error trying to convert data to JSON")
            return
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
            print(httpResponse)
            print("HTTP response: \(httpResponse.statusCode)")
        } else {
            print("No HTTP response")
        }
        
    }*/
    
    func doUserLogin2(path: String)
    {
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let userInputData:NSMutableDictionary = NSMutableDictionary()
        userInputData.setValue(self.userId.text!, forKey: "userName")
        userInputData.setValue(self.password.text!, forKey: "password")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(userInputData, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
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
            
            let json: NSDictionary
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: NSJSONReadingOptions()) as! NSDictionary
                
                /*if let reposArray = json["trips"] as? [NSDictionary] {
                    
                    for trip in reposArray {
                        self.TableData.append(Trip(json: trip))
                    }
                    
                    self.tableView.reloadData()
                }*/
                
                 print(json);
                
            } catch  {
                print("error trying to convert data to JSON")
                return
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
