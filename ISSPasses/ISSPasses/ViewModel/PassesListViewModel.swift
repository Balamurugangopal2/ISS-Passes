//
//  PassesListViewModel.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation
import CoreLocation

// TODO: presenlty just handled 2 common errors and need to handle specific service errors
enum PassesListError: Error {
    case ServiceError
    case LocationError
}

protocol PassesListViewDelegate: class {
    // This delegate method will invoked once device gets Passes and delegate class should implement this method to update UI
    func updatePassesList()
    // This delegate method to ask user to enable location service
    func requestUserToEnableLocation()
    //This delegate method to display error
    func handleError(error: PassesListError)
}

class PassesListViewModel: NSObject {
    
    let apiClient: ISSAPIClient = ISSAPIClient()
    var passes: Passes?
    weak var delegate: PassesListViewDelegate?
    let locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    
    func getCurrentLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied {
                self.delegate?.requestUserToEnableLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestLocation()
            }
        }
    }
    
    func numberofItemsInSection(section: Int) -> Int {
        return passes?.response.count ?? 0
    }
    
    func titleForItemAtIndexPath(indexPath: IndexPath) -> String {
        
        if let date = passes?.response[indexPath.row].risetime {
            return Util.getFormatedDate(date: date)
        } else {
            return ""
        }
    }
    
    func subTitleForItemAtIndexPath(indexPath: IndexPath) -> String {
        if let date = passes?.response[indexPath.row].risetime {
            return Util.getFormatedTime(date: date)
        } else {
            return ""
        }
    }
    
    func fetchPasses(completion: @escaping ()->()) {
        //Latitude and Longitue needs to passed to ISSPassesAPI to get the pass details
        let parameter = "lat=\(latitude)&lon=\(longitude)"
        apiClient.fetchISSPassesList(parameter: parameter) { (passes) in
            if (passes ==  nil) {
                self.delegate?.handleError(error: .ServiceError)
            } else {
                self.passes = passes
                completion()
            }
        }
    }
    
    func getLatitude() -> String {
        if let latitude = passes?.request.latitude {
            return "\(latitude)"
        }
        return "0.0"
    }
    
    func getLongitude() -> String {
        if let longitude = passes?.request.longitude {
            return "\(longitude)"
        }
        return "0.0"
    }
    
    func getAltitude() -> String {
        if let altitude = passes?.request.altitude {
            return "\(altitude)"
        }
        return "0.0"
    }
    
    func getNoOfPasses() -> String {
        if let noOfPasses = passes?.request.passes {
            return "\(noOfPasses)"
        }
        return "0"
    }
    
}

extension PassesListViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latitude = locations.last?.coordinate.latitude, let longitude = locations.last?.coordinate.longitude {
            self.latitude = latitude
            self.longitude = longitude
            //Once lattitue and longitude available the invok the ISS API client calls
            fetchPasses { [weak self] in
                self?.delegate?.updatePassesList()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.handleError(error: .LocationError)
        NSLog("\(error.localizedDescription)")
    }
    
}
