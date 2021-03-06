//
//  TripDetailsViewController.swift
//  xroads
//
//  Created by Abdul on 04/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class TripDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tripName: UILabel!
    
    @IBOutlet var tripDetails: UILabel!
    
    @IBOutlet var tripMembers: UITableView!
    
    var tripNameValue = String()
    var tripDetailsValue = String()
    var tripId:Int = Int()
    var TableData = [TripMember]()
    var tripMembersDictionary = [NSDictionary]()
    var tripDestinationLat = NSNumber()
    var tripDestinationLong = NSNumber()
    
    override func viewWillAppear(animated: Bool) {
        
        tripName.text = tripNameValue
        tripDetails.text = tripDetailsValue
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TripMemberCell", forIndexPath: indexPath)
        
        let tripmember = TableData[indexPath.row]
        
        if let nameLabel = cell.viewWithTag(200) as? UILabel { //3
            nameLabel.text = tripmember.memberName
        }
        
        return cell
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tripDetails.numberOfLines = 0
        
        self.tripMembers.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        tripMembers.delegate = self
        tripMembers.dataSource = self
        
        LoadingOverlay.shared.showOverlay(self.view)
        dispatch_async(dispatch_get_main_queue(), {
            self.getTripDetails()
        })
    }
    
    func getTripDetails()
    {
        LoadingOverlay.shared.showOverlay(self.view)
        var path: String = ApiEndPoints().createTrip!
            path = path + "?tripId="
            path = path + String(tripId)
            path = path + "&&userId="
            path = path + String(UserModel.sharedManager.userId!)
        
        if let JSONData = NSData(contentsOfURL: NSURL(string: path)!)
        {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions()) as? NSDictionary
                

                var dataString = NSString(data: JSONData, encoding: NSUTF8StringEncoding)
                
                let _tripDestinationLat:NSNumber = (json!["trip"]?["tripDestinationLat"]!)! as! NSNumber
                let _tripDestinationLong:NSNumber = (json!["trip"]?["tripDestinationLong"]!)! as! NSNumber
                
                tripDestinationLat =  _tripDestinationLat
                tripDestinationLong = _tripDestinationLong
                
                if let _tripMembersDictionary = json!["trip"]?["tripMembers"] as? [NSDictionary] {
                    
                    
                    for tripMember in _tripMembersDictionary {
                        TableData.append(TripMember(json: tripMember))
                    }
                    tripMembersDictionary = _tripMembersDictionary as [NSDictionary]
                    
                    
                }
                
                print(json)
            } catch {
                print("error serializing JSON: \(error)")
            }
            tripMembers.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        }
        
        let mapWidth: CGFloat = view.bounds.width
        let mapHeight: CGFloat = 350//view.bounds.height - (tripMembers.frame.origin.y + tripMembers.frame.height + 90)
        let mapViewFrame: CGRect = CGRectMake(0, (view.bounds.height/2) - 65, mapWidth, mapHeight)
        
        let map = storyboard?.instantiateViewControllerWithIdentifier("GoogleMapViewController") as! GoogleMapViewController
        map.tripMembersDictionary = tripMembersDictionary
        map.tripDestinationLat = tripDestinationLat
        map.tripDestinationLong = tripDestinationLong
        
        self.addChildViewController(map)
        map.view.frame = mapViewFrame
        view.addSubview(map.view)
        map.didMoveToParentViewController(self)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "update", userInfo: nil, repeats: false)
        
    }
    
    // must be internal or public.
    func update() {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let redColor: UIColor = UIColor(hue: 0.025, saturation: 0.3, brightness: 0.93, alpha: 1.0)
            let fab = KCFloatingActionButton()
            fab.buttonColor = redColor
            fab.addItem("Map fullscreen", icon: UIImage(named: "fullScreen")!, handler: {
                item in
                
                let fullMap = self.storyboard!.instantiateViewControllerWithIdentifier("GoogleMapViewController") as! GoogleMapViewController
                fullMap.tripMembersDictionary = self.tripMembersDictionary
                fullMap.tripDestinationLat = self.tripDestinationLat
                fullMap.tripDestinationLong = self.tripDestinationLong
                self.navigationController!.pushViewController(fullMap, animated: false)
                
                fab.close()
            })
            fab.addItem("Past Trips", icon: UIImage(named: "Trip")!, handler: {
                item in
                
                fab.close()
            })
            self.view.addSubview(fab)
        })
    }
}
