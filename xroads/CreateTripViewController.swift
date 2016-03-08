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
    var startplace: NSObject = []
    var destination: NSObject = []
    var isStartPlace:Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            startplace = place
        }
        else{
            destinationTextField.text = place.name
            destination = place
        }
    }
    
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithError error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func wasCancelled(viewController: GMSAutocompleteViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}