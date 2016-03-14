//
//  UserTableViewController.swift
//  xroads
//
//  Created by Abdul on 11/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit

class AllMembersTableViewController: UITableViewController {
    
    var tripMembers = [AllUsersModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = ApiEndPoints().allMembersEndPoint!
        
        getAllMembers(url);
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
        return tripMembers.count
    }
    
    func getAllMembers(url:String)
    {
        
        if let JSONData = NSData(contentsOfURL: NSURL(string: url)!)
        {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions()) as? NSDictionary
                
                if let reposArray = json!["trips"] as? [NSDictionary] {
                    
                    for trip in reposArray {
                        
                        tripMembers.append(AllUsersModel(json: trip))
                    }
                }
                
                print(json)
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
    }
    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == tripSegueIdentifier {
            if let destination = segue.destinationViewController as? TripDetailsViewController {
                if let tripIndex = tableView.indexPathForSelectedRow?.row {
                    destination.tripName = TableData[tripIndex].tripName!
                    destination.startDate = NSDate(timeIntervalSince1970: NSTimeInterval(TableData[tripIndex].startTime!))
                    destination.endDate = NSDate(timeIntervalSince1970: NSTimeInterval(TableData[tripIndex].endTime!))
                    destination.destination = TableData[tripIndex].tripDestination!
                    destination.createdBy = TableData[tripIndex].tripChampion!
                }
            }
        }
    }*/
    
    
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
