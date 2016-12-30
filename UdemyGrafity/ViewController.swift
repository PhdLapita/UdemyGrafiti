//
//  ViewController.swift
//  UdemyGrafity
//
//  Created by Bear on 30/12/16.
//  Copyright © 2016 BearCreekMining. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var btnAgregar: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btnFab: UIButton!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!

    var graffiti: Graffiti?
    let geocoder = CLGeocoder()
    
    let locationManager = CLLocationManager()
    
    var updatingLocation = false {
        didSet{
            if updatingLocation{
                btnFab.setImage(#imageLiteral(resourceName: "btn_localizar_off"), for: .normal)
                progressBar.isHidden = false
                progressBar.startAnimating()
                btnFab.isUserInteractionEnabled = false
            } else {
                btnFab.setImage(#imageLiteral(resourceName: "btn_localizar_on"), for: .normal)
                progressBar.isHidden = true
                progressBar.startAnimating()
                btnFab.isUserInteractionEnabled = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: image)
        updatingLocation = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clicFab(_ sender: Any) {
        startlocationManager()
    }
    
    func startlocationManager() {
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
        showLocationServiceDeniedAlert()
        default:
            if CLLocationManager.locationServicesEnabled() {
                self.updatingLocation = true
                self.btnAgregar.isEnabled = false
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
                
                //Hacemos zoom sobre la localizacion del usuario
                let region = MKCoordinateRegionMakeWithDistance(map.userLocation.coordinate, 1000, 1000)
                map.setRegion(map.regionThatFits(region), animated: true)
            }
        }
    }
    
    func showLocationServiceDeniedAlert(){
        let alert = UIAlertController(title: "Localizacion desactivada",
                                      message: "Por favor activa la localizacion para esta app",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String{
        var line1 = ""
        if let  s = placemark.thoroughfare{
            line1 += s + ", "
        }
        if let s = placemark.subThoroughfare{
            line1 += s
        }
        var line2 = ""
        if let  s = placemark.postalCode{
            line2 += s + ", "
        }
        if let s = placemark.locality{
            line2 += s
        }
        var line3 = ""
        if let  s = placemark.administrativeArea{
            line3 += s + ", "
        }
        if let s = placemark.subThoroughfare{
            line3 += s
        }
        return line1 + "\n" + line2 + "\n" + line3
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("*******************Errror en Core Location*****************")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {return}
        let latitude = Double(newLocation.coordinate.latitude)
        let longitude = Double(newLocation.coordinate.longitude)
        geocoder.reverseGeocodeLocation(newLocation){(placemarks, error) in
            if error == nil{
                var address = "No se ha podido determinar"
                if let placemark = placemarks?.last{
                    address = self.stringFromPlacemark(placemark: placemark)
                }
                self.graffiti = Graffiti(address: address, latitude: latitude, longitude: longitude, image: "")
            }
            self.updatingLocation = false
            self.btnAgregar.isEnabled = true
        }
    }
}

