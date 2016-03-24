//
//  CreateTripViewController.swift
//  xroads
//
//  Created by Abin Anto on 03/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateTripViewController: UIViewController {
    @IBOutlet var createTripButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var startPointTextField: UITextField!
    var startplace: String = ""
    var startplaceLat: String = ""
    var startplaceLon: String = ""
    var destination: String = ""
    var destinationLat: String = ""
    var destinationLon: String = ""
    var isStartPlace:Bool = false
    var isStartDate:Bool = false
    @IBOutlet var trip: UITextField!
    @IBOutlet var startDate: UITextField!
    @IBOutlet var endDate: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let textfieldBorderColor: CGColor = UIColor(hue: 0.025, saturation: 0.3, brightness: 0.93, alpha: 1.0).CGColor
        
        trip.layer.cornerRadius = 8.0
        trip.layer.masksToBounds = true
        trip.layer.borderColor = textfieldBorderColor
        trip.layer.borderWidth = 2.0
        
        startDate.layer.cornerRadius = 8.0
        startDate.layer.masksToBounds = true
        startDate.layer.borderColor = textfieldBorderColor
        startDate.layer.borderWidth = 2.0
        
        endDate.layer.cornerRadius = 8.0
        endDate.layer.masksToBounds = true
        endDate.layer.borderColor = textfieldBorderColor
        endDate.layer.borderWidth = 2.0
        
        startPointTextField.layer.cornerRadius = 8.0
        startPointTextField.layer.masksToBounds = true
        startPointTextField.layer.borderColor = textfieldBorderColor
        startPointTextField.layer.borderWidth = 2.0
        
        destinationTextField.layer.cornerRadius = 8.0
        destinationTextField.layer.masksToBounds = true
        destinationTextField.layer.borderColor = textfieldBorderColor
        destinationTextField.layer.borderWidth = 2.0
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func startDateEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        isStartDate = true
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func endDateEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        isStartDate = false
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        if(isStartDate){
            startDate.text = dateFormatter.stringFromDate(sender.date)
        }
        else{
             endDate.text = dateFormatter.stringFromDate(sender.date)
        }
        
    }
    func viewController(viewController: GMSAutocompleteViewController!, didFailAutocompleteWithError error: NSError!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickCreateTripButton(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func clickCloseButton() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func touchDestination(sender: UITextField) {
        isStartPlace = false
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    @IBAction func touchStartPoint(sender: UITextField) {
        isStartPlace = true
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    @IBAction func CreateTrip(sender: UIButton) {
        
        LoadingOverlay.shared.showOverlay(self.view)
        dispatch_async(dispatch_get_main_queue(), {
            self.createTrip()
        })
        
        
    }
    
    func createTrip(){
        
        if(trip.text == "" || startPointTextField.text == "" || destinationTextField.text == "" || startDate.text == "" || endDate.text == ""){
            let alert = UIAlertController(title: "All fields are mandatory", message: "Some of the mandatory fields are missing.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            LoadingOverlay.shared.hideOverlayView()
            return
        }
        
        let path: String = ApiEndPoints().createTrip!
        let request = NSMutableURLRequest(URL: NSURL(string: path)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        let t: Float64 = 1457433251000
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(trip.text!, forKey: "tripName")
        para.setValue(destination, forKey: "tripDestination")
        para.setValue(destinationLat, forKey: "tripDestinationLat")
        para.setValue(destinationLon, forKey: "tripDestinationLong")
        para.setValue(startplace, forKey: "startLocationForCurrentUser")
        para.setValue(startplaceLat, forKey: "startLocationForCurrentUserLat")
        para.setValue(startplaceLon, forKey: "startLocationForCurrentUserLong")
        para.setValue(UserModel.sharedManager.userId, forKey: "championUserId")
        para.setValue("false", forKey: "hasTripStarted")
        para.setValue(t, forKey: "startTime")
        para.setValue(t, forKey: "endTime")
        para.setValue(AllMembersTableViewController.Static.memberArr, forKey: "tripMembers")
        
        let jsonData: NSData
        var jsonString:String="";
        do{
            jsonData = try NSJSONSerialization.dataWithJSONObject(para, options: NSJSONWritingOptions())
            jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            print("json string = \(jsonString)")
            
        }
        catch{
            LoadingOverlay.shared.hideOverlayView()
            print ("UH OOO")
        }
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send the request
        do {
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            // use jsonData
        }
        catch {
            LoadingOverlay.shared.hideOverlayView()
            // report error
        }
        
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse
        {
            if(httpResponse.statusCode == 201)
            {
//                let alert = UIAlertController(title: "Success", message: "Trip created successfully.", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
                
                let tripView = self.storyboard!.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                self.navigationController!.pushViewController(tripView, animated: true)
            }
            else
            {
                LoadingOverlay.shared.hideOverlayView()
            }
            print("HTTP response: \(httpResponse.statusCode)")
        }
        else
        {
            print("No HTTP response")
            let alert = UIAlertController(title: "Failure", message: "Trip creation failed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            LoadingOverlay.shared.hideOverlayView()
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
extension CreateTripViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithPlace place: GMSPlace!) {
        // The user has selected a place.
        self.dismissViewControllerAnimated(true, completion: nil)
        // Do something with the selected place.
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        print("Coordinate: ", place.coordinate)
        
        if(isStartPlace){
            startPointTextField.text = place.name
            startplace = String(place.name)
            startplaceLat = String(place.coordinate.latitude)
            startplaceLon = String(place.coordinate.longitude)
        }
        else{
            destinationTextField.text = place.name
            destination = String(place.name)
            destinationLat = String(place.coordinate.latitude)
            destinationLon = String(place.coordinate.longitude)
        }
    }
    
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithError error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func wasCancelled(viewController: GMSAutocompleteViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}