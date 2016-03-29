//
//  TripsTableViewController.swift
//  xroads
//
//  Created by Abin Anto on 02/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit

class TripsTableViewController: UITableViewController {

    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var busyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    var TableData = [Trip]()
    let tripSegueIdentifier = "ShowDetailsSegue"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingOverlay.shared.showOverlay(self.view)
        dispatch_async(dispatch_get_main_queue(), {
            self.get_data_from_url(ApiEndPoints().upcomingTripEndPoint! + String(UserModel.sharedManager.userId!))
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.tableView.rowHeight = 70
     
        let redColor: UIColor = UIColor(hue: 0.025, saturation: 0.3, brightness: 0.93, alpha: 1.0)
        let fab = KCFloatingActionButton()
        fab.buttonColor = redColor
        fab.addItem("Create Trip", icon: UIImage(named: "Trip")!, handler: {
            item in
            
            let createtrip : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("CreateTrip")
            self.showViewController(createtrip as! UIViewController, sender: createtrip)
            
            fab.close()
        })
        self.view.addSubview(fab)
    }

    @IBAction func menuButtonClick(sender: UIBarButtonItem) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath)
        
        let trip = TableData[indexPath.row]
        
        if let nameLabel = cell.viewWithTag(100) as? UILabel { //3
            nameLabel.text = trip.tripName
        }
        if let gameLabel = cell.viewWithTag(101) as? UILabel {
            gameLabel.text = trip.tripDestination
        }
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "Upcoming Trips"
        self.tabBarController?.navigationItem.leftBarButtonItem = menuButton
        self.tabBarController?.navigationItem.rightBarButtonItem = addButton
        
    }
    
    func get_data_from_url(url:String)
    {
        
        if let JSONData = NSData(contentsOfURL: NSURL(string: url)!)
        {
            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions()) as? NSDictionary
                
                if let reposArray = json!["trips"] as? [NSDictionary] {
                    
                    for trip in reposArray {
                        TableData.append(Trip(json: trip))
                    }
                }
                
                print(json)
            }
            catch
            {
                print("error serializing JSON: \(error)")
            }
            
        }
         self.tableView.reloadData()
        LoadingOverlay.shared.hideOverlayView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == tripSegueIdentifier
        {
            if let destination = segue.destinationViewController as? TripDetailsViewController
            {
                LoadingOverlay.shared.showOverlay(self.view)
                
                if let tripIndex = tableView.indexPathForSelectedRow?.row
                {
                    var tripName = String()
                    var startDate = NSDate()
                    var endDate = NSDate()
                    var destinationPlace = String()
                    //var startpont = String()
                    var createdBy = Int()
                    
                    tripName = TableData[tripIndex].tripName!
                    startDate = NSDate(timeIntervalSince1970: NSTimeInterval(TableData[tripIndex].startTime!))
                    endDate = NSDate(timeIntervalSince1970: NSTimeInterval(TableData[tripIndex].endTime!))
                    destinationPlace = TableData[tripIndex].tripDestination!
                    createdBy = TableData[tripIndex].tripChampion!
                    //startpont = TableData[tripIndex].startLocationForCurrentUser!
                    
                    
                    destination.tripNameValue = String(tripName)
                    
                    var tripDetails:String = "Trip starts on " + String(startDate)
                    //tripDetails = tripDetails + " from " + String(startpont)
                    tripDetails = tripDetails + ", and is planned to reach "
                    tripDetails = tripDetails + String(destinationPlace)
                    tripDetails = tripDetails + " by "
                    tripDetails = tripDetails + String( endDate)
                    tripDetails = tripDetails + "."
                    tripDetails = tripDetails + "Trip Coordinator - "
                    tripDetails = tripDetails + String(createdBy)
                    tripDetails = tripDetails + "."
                    
                    destination.tripDetailsValue = tripDetails
                    
                    destination.tripId = TableData[tripIndex].tripId!
                    
                }
            }
            
            
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
