//
//  GoogleMapViewController.swift
//  xroads
//
//  Created by Abin Anto on 07/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
    
    var mapView:GMSMapView = GMSMapView()
    var tripMembersDictionary = [NSDictionary]()
    var tripDestinationLat = NSNumber()
    var tripDestinationLong = NSNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.cameraWithLatitude(12.9696422, longitude: 80.2437093, zoom: 12)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        /*let path = GMSMutablePath()
        path.addCoordinate(CLLocationCoordinate2D(latitude: 12.9696422, longitude: 80.2437093))
        path.addCoordinate(CLLocationCoordinate2D(latitude: 12.9896222, longitude: 80.2498313))
        path.addCoordinate(CLLocationCoordinate2D(latitude: 13.0054322, longitude: 80.2464043))
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView*/
        
        //createMarkers(12.9696422, lon: 80.2437093)
        //createMarkers(12.9896222, lon: 80.2498313)
        //createMarkers(13.0054322, lon: 80.2464043)
        
        let locationManager = CLLocationManager()
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        for tripMember in tripMembersDictionary {
            createMarkers(tripMember["memberStartingLocationLat"] as! CLLocationDegrees, lon: tripMember["memberStartingLocationLong"] as! CLLocationDegrees, title: tripMember["memberName"] as! NSString, type: "member")
        }
        
        let MomentaryLatitude = String(tripDestinationLat)
        let MomentaryLongitude = String(tripDestinationLong)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double((MomentaryLatitude as NSString).doubleValue), longitude: Double((MomentaryLongitude as NSString).doubleValue))

        
        createMarkers( location.latitude, lon: location.longitude, title: "Destination", type: "destination")
        
    }
    
    func createMarkers(lan: CLLocationDegrees, lon: CLLocationDegrees, title: NSString, type: NSString){
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        let _position = CLLocationCoordinate2D(latitude: lan, longitude: lon)
        let marker = GMSMarker(position: _position)
        if(type == "destination")
        {
            marker.icon = UIImage(named: "finish_flag")
        }
        else
        {
             marker.icon = GMSMarker.markerImageWithColor(UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0))
        }
       
        marker.map = mapView;
        marker.title = title as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
