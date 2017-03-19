//
//  MapViewController.swift
//  ranked
//
//  Created by Nir Sela on 3/9/17.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var Map: MKMapView!
    
    let locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization();
        self.locationManager.startUpdatingLocation();
        
        PostModel.instance.getAllPosts(callback: self.addPostLocations)
                
        self.Map.showsUserLocation = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Delagate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0];
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude);
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1));
        self.Map.setRegion(region, animated: true);
        self.locationManager.stopUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription);
    }
    
    func addPostLocations(posts:[Post]){
        for post in posts {
            let location = CLLocationCoordinate2DMake(post.latitude, post.longitude)
            let annotation = MKPointAnnotation();
            annotation.coordinate = location;
            annotation.title = post.title;
            annotation.subtitle = post.authorNickname;
            self.Map.addAnnotation(annotation);
        }
    }

}
