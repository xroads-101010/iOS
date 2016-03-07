//
//  TripDetailsViewController.swift
//  xroads
//
//  Created by Abdul on 04/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit
import MapKit

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
        
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
    }
}
