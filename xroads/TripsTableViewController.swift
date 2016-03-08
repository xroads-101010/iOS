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
    
    var TableData = [Trip]()
    let tripSegueIdentifier = "ShowDetailsSegue"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.tableView.rowHeight = 70
        
        get_data_from_url(ApiEndPoints().upcomingTripEndPoint!);
        
        //makeHTTPGetRequest("https://0761c8ea.ngrok.io/xroads-app/trip/champion?id=4")
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
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions()) as? NSDictionary
                
                if let reposArray = json!["trips"] as? [NSDictionary] {
                    
                    for trip in reposArray {
                        TableData.append(Trip(json: trip))
                    }
                }
                
                print(json)
            } catch {
                print("error serializing JSON: \(error)")
            }
            
        }
    }
    
    func makeHTTPGetRequest(path: String)
    {
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
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
            
            // parse the result as JSON, since that's what the API provides
            let json: NSDictionary
            do {
                json = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: NSJSONReadingOptions()) as! NSDictionary
                
                if let reposArray = json["trips"] as? [NSDictionary] {
                    
                    for trip in reposArray {
                        self.TableData.append(Trip(json: trip))
                    }
                    
                    self.tableView.reloadData()
                }

            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            // now we have the post, let's just print it to prove we can access it
            print("The post is: " + json.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let postTitle = json["title"] as? String {
                print("The title is: " + postTitle)
            }
        })
        task.resume()
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
