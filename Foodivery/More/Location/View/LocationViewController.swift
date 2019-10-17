//
//  LocationViewController.swift
//  Foodivery
//
//  Created by Admin on 1/9/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON


class LocationViewController: UIViewController {

    @IBOutlet var googleView: GMSMapView!
    var locationMgr: CLLocationManager?
    
    var viewModel: LocationViewModel?
   
    
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//
//
//        mapView.settings.myLocationButton = true
//    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationMgr = CLLocationManager()
        self.locationMgr?.startUpdatingLocation()
        
        self.viewModel = LocationViewModelImp()
        self.viewModel?.httpResponseHandler = self
        
        
        // Create a GMSCameraPosition that tells the map to display the
        
        let camera = GMSCameraPosition.camera(withLatitude: 28.524555,
                                              longitude: 77.275111,
                                              zoom: 10.0,
                                              bearing: 30,
                                              viewingAngle: 40)
        //Setting the googleView
        self.googleView.camera = camera
        //self.googleView.delegate = self as? GMSMapViewDelegate
        self.googleView?.isMyLocationEnabled = true
        self.googleView.settings.myLocationButton = true
        self.googleView.settings.compassButton = true
        self.googleView.settings.zoomGestures = true
        self.googleView.animate(to: camera)
        
        
        
        // Do any additional setup after loading the view.
        //Setting the start and end location
        let origin = "\(28.524555),\(77.275111)"
        let destination = "\(28.643091),\(77.218280)"
        
        Loader.showLoader(viewController: self)
       self.viewModel?.getDistanceInfo(origin: origin, destination: destination )

      
        
//        //Rrequesting Alamofire and SwiftyJSON
//        Alamofire.request(url).responseJSON { response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // HTTP URL response
//            print(response.data as Any)     // server data
//            print(response.result)   // result of response serialization
//
//            do {
//
//                let json = try JSON(data: response.data!)
//                print("json : \(json)")
//                let routes = json["routes"].arrayValue
//                print(routes)
//                for route in routes
//                {
//                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                    let path = GMSPath.init(fromEncodedPath: points!)
//                    let polyline = GMSPolyline.init(path: path)
//                    polyline.strokeColor = UIColor.blue
//                    polyline.strokeWidth = 2
//                    polyline.map = self.googleView
//                }
//            }catch(let error){
//                print("JSON parsing error: \(error.localizedDescription)")
//            }
//            self.draw()
//
//        }
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 28.524555, longitude: 77.275111)
        marker.title = "Mobiloitte"
        marker.snippet = "India"
        marker.map = googleView
        
        //28.643091, 77.218280
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 28.643091, longitude: 77.218280)
        marker1.title = "NewDelhi"
        marker1.snippet = "India"
        marker1.map = googleView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Drawing straight line between two points.
    
        func draw() {
            let path = GMSMutablePath()
            path.addLatitude(28.524555, longitude:77.275111) //Mobiloitte
            path.addLatitude(28.643091, longitude:77.218280) // New Delhi
//                    path.addLatitude(21.291, longitude:-157.821) // Hawaii
//                    path.addLatitude(37.423, longitude:-122.091) // Mountain View
    
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .blue
            polyline.strokeWidth = 3.0
            polyline.map = self.googleView
    
    
        }
    
    
}

extension LocationViewController {
    
    func drawRoot(polyline: String){
        //Draw root
        let path = GMSPath.init(fromEncodedPath: polyline)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.red
        polyline.strokeWidth = 3.0
        polyline.map = self.googleView
    }

   
    func addMarker(location: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = location
        //marker.icon = #imageLiteral(resourceName: "locationmarker_icon").getOverlayImage(withColor: AppColor.primaryColor)
        marker.snippet = ""
        marker.map = self.googleView
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
}


//MARK: - HTTPResponseDelegate
extension LocationViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        //self.activityIndicator.isHidden = true
        Loader.dismissLoader(viewController: self)
        if service == .googleDistanceApi {
            if let location = response as? Location {
                AppDefaults.location = location
                self.drawRoot(polyline: location.polyline)
            }else{
                Alert.showAlert(vc: self, title: "No route found!", message: "No route found between Your Location and Location")
            }
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        //self.activityIndicator.isHidden = true
        Loader.dismissLoader(viewController: self)
        if service == .googleDistanceApi {
            Alert.showAlert(vc: self, title: "Error!", message: message)
        }
    }
    
}
