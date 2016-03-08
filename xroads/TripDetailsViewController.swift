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

class TripDetailsViewController: UIViewController {

    @IBOutlet var tripNameLabel: UILabel!
    
    
    @IBOutlet var startDateLabel: UILabel!
    
    @IBOutlet var createdByLabel: UILabel!
    
    @IBOutlet var destinationLabel: UILabel!
    
    @IBOutlet var endTimeLabel: UILabel!
    
    var tripName = String()
    
    var startDate = NSDate()
    
    var endDate = NSDate()
    
    var destination = String()
    
    var createdBy = Int()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        
        tripNameLabel.text = tripName
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        startDateLabel.text = dateFormatter.stringFromDate(startDate)
        
        endTimeLabel.text = dateFormatter.stringFromDate(endDate)
        
        destinationLabel.text = destination
        
        createdByLabel.text = String(createdBy)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailsWidth: CGFloat = view.bounds.width
        let detailsHeight: CGFloat = view.bounds.height - (createdByLabel.frame.origin.y + 100)
        let detailsViewFrame: CGRect = CGRectMake(0, createdByLabel.frame.origin.y + 100, detailsWidth, detailsHeight)
        
        let detailsController = storyboard?.instantiateViewControllerWithIdentifier("GoogleMapViewController") as! GoogleMapViewController
        
        self.addChildViewController(detailsController)
        detailsController.view.frame = detailsViewFrame
        view.addSubview(detailsController.view)
        detailsController.didMoveToParentViewController(self)
    }
}
