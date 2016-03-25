//
//  GoogleMapViewController.swift
//  xroads
//
//  Created by Abin Anto on 07/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate {
    
    var mapView:GMSMapView = GMSMapView()
    var tripMembersDictionary = [NSDictionary]()
    var tripDestinationLat = NSNumber()
    var tripDestinationLong = NSNumber()
    let locationManager = CLLocationManager()
    var latitude = ""
    var longitude = ""
    var currentLocation:CLLocation = CLLocation()
    var destinationLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var count = 1.0
    var destinationLatitude = ""
    var destinationLongitude = ""
    var locationArray: [CLLocationCoordinate2D] = []
    let path = GMSMutablePath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.cameraWithLatitude(12.9696422, longitude: 80.2437093, zoom: 1)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.delegate = self;
        }
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        destinationLatitude = String(tripDestinationLat)
        destinationLongitude = String(tripDestinationLong)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    // must be internal or public.
    func update() {
        
        mapView.clear()
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        locationArray.append(CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude  + (0.000100 * count), longitude: currentLocation.coordinate.longitude + (0.000100 * count)))
        
        for tripMember in tripMembersDictionary
        {
            let memberLatitude = tripMember["memberStartingLocationLat"] as! CLLocationDegrees  + (0.000100 * count)
            let memberLongitude = tripMember["memberStartingLocationLong"] as! CLLocationDegrees + (0.000100 * count)
            
            createMarkers(memberLatitude, lon: memberLongitude, title: tripMember["memberName"] as! NSString, type: "member")
        }
        
        destinationLocation = CLLocationCoordinate2D(latitude: Double((destinationLatitude as NSString).doubleValue), longitude: Double((destinationLongitude as NSString).doubleValue))
        
        createMarkers( destinationLocation.latitude, lon: destinationLocation.longitude, title: "Destination", type: "destination")
        count = count + 1
        
        let polyline = GMSPolyline(path: path)
        for current in locationArray
        {
            path.addCoordinate(CLLocationCoordinate2D(latitude: current.latitude, longitude: current.longitude))
        }
        polyline.map = mapView

    }
    
    func createMarkers(lan: CLLocationDegrees, lon: CLLocationDegrees, title: NSString, type: NSString){
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        let _position = CLLocationCoordinate2D(latitude: lan, longitude: lon)
        let marker = GMSMarker(position: _position)
        
        if(type == "destination"){
            marker.icon = UIImage(named: "finish_flag")
        }
        else{
            marker.icon = GMSMarker.markerImageWithColor(UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0))
        }
        

       
        marker.map = mapView;
        marker.title = title as String
        
        let myTimer : NSTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("myPerformeCode:"), userInfo: nil, repeats: true)
        myTimer.fire()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        print ("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)---description : \(newLocation.description)")
        
        if(latitude == ""){
            
           currentLocation =  newLocation
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error with Server");
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            print (placemark.locality)
            print(placemark.postalCode)
            print(placemark.administrativeArea)
            print(placemark.country)
    }
    
    func myPerformeCode(timer : NSTimer) {
        
        //updateUserCurrentLocaion(latitude, lon: longitude)
    }
    
    func updateUserCurrentLocaion(lat: String, lon: String){
        
        let path: String = ApiEndPoints().updateUserLocation!
        let request = NSMutableURLRequest(URL: NSURL(string: path)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(UserModel.sharedManager.userId, forKey: "userId")
        para.setValue("", forKey: "location")
        para.setValue(lat, forKey: "locationLat")
        para.setValue(lon, forKey: "locationLong")
        
        let jsonData: NSData
        var jsonString:String="";
        do{
            jsonData = try NSJSONSerialization.dataWithJSONObject(para, options: NSJSONWritingOptions())
            jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            print("json string = \(jsonString)")
            
        } catch _ {
            print ("UH OOO")
        }
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "PUT"
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
            print("HTTP response: \(httpResponse.statusCode)")
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
