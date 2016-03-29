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
    var currentLocation:CLLocation = CLLocation()
    var destinationLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var count = 0
    var destinationLatitude = ""
    var destinationLongitude = ""
    var path = GMSMutablePath()
    var polyline = GMSPolyline()
    var routeArray:NSMutableArray = NSMutableArray()
    var locationCaptured:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingOverlay.shared.showOverlay(self.view)
        
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
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        if(locationCaptured == false){
            
            locationCaptured = true
            // Do any additional setup after loading the view.
            let camera = GMSCameraPosition.cameraWithLatitude(newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, zoom: 18)
            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            self.view = mapView
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.delegate = self
            
            currentLocation =  newLocation
            var url = "https://router.project-osrm.org/viaroute?loc="
            url = url + String(currentLocation.coordinate.latitude) + "," + String(currentLocation.coordinate.longitude) + "&loc="
            url = url + destinationLatitude + "," + destinationLongitude + "&compression=false"
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.getRoute(url)
            })
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error with Server");
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
    }
    
    func getRoute(url: String){
        
        if let JSONData = NSData(contentsOfURL: NSURL(string: url)!)
        {
            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions()) as? NSDictionary
                
                if let reposArray = json!["route_geometry"] as? NSMutableArray {
                    
                    routeArray = reposArray
                    startPlot()
                    LoadingOverlay.shared.hideOverlayView()
                    
                }
                
                print(json)
            }
            catch
            {
                LoadingOverlay.shared.hideOverlayView()
                print("error serializing JSON: \(error)")
            }
            
        }
        
    }
    
    func startPlot(){
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    // must be internal or public.
    func update() {
        
        mapView.clear()
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        var memberLatitude = CLLocationDegrees()
        var memberLongitude = CLLocationDegrees()
        
        for tripMember in tripMembersDictionary
        {
            if( count >= routeArray.count)
            {
                count = 1
                path.removeAllCoordinates()
            }
            else
            {
                memberLatitude =  (routeArray[count][0])! as! CLLocationDegrees
                memberLongitude = (routeArray[count][1])! as! CLLocationDegrees
                
                createMarkers(memberLatitude, lon: memberLongitude, title: tripMember["memberName"] as! NSString, type: "member")
                count = count + 1
            }
        }
        destinationLocation = CLLocationCoordinate2D(latitude: Double((destinationLatitude as NSString).doubleValue), longitude: Double((destinationLongitude as NSString).doubleValue))
        
        createMarkers( destinationLocation.latitude, lon: destinationLocation.longitude, title: "Destination", type: "destination")
        
        path.addCoordinate(CLLocationCoordinate2D(latitude: memberLatitude, longitude: memberLongitude))
        polyline = GMSPolyline(path: path)
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
        marker.snippet = title as String
        marker.map = mapView;
        marker.title = title as String
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUserCurrentLocaion(lat: String, lon: String){
        
        let url: String = ApiEndPoints().updateUserLocation!
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
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
