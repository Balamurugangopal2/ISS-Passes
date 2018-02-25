//
//  IssPassesListViewModel.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation
import CoreLocation

// TODO: presenlty just handled 2 common errors and need to handle specific service errors
enum IssPassesListError: Error {
    
    case ServiceError
    case LocationError
    
}

protocol IssPassesListViewDelegate: class {
    
    // This delegate method will invoked once device gets Passes and delegate class should implement this method to update UI
    func updateIssPassesList()
    // This delegate method to ask user to enable location service
    func requestUserToEnableLocation()
    //This delegate method to display error
    func handleError(error: IssPassesListError)
    
}

class IssPassesListViewModel: NSObject {
    
    let issApi : IssApi = IssApi()
    var issPasses: IssPasses?
    weak var delegate: IssPassesListViewDelegate?
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
        return issPasses?.response?.count ?? 0
    }
    
    func titleForItemAtIndexPath(indexPath: IndexPath) -> String {
        if let time = issPasses?.response?[indexPath.row].risetime {
            return Util.getFormatedDate(date: Date(timeIntervalSince1970: time))
        } else {
            return ""
        }
    }
    
    func subTitleForItemAtIndexPath(indexPath: IndexPath) -> String {
        if let time = issPasses?.response?[indexPath.row].risetime {
            return Util.getFormatedTime(date: Date(timeIntervalSince1970: time))
        } else {
            return ""
        }
    }
    
    func fetchPasses(completion: @escaping ()->()) {
        //Latitude and Longitue needs to be passed to ISS Passes API to get the passes details
        let parameter = "lat=\(latitude)&lon=\(longitude)"
        issApi.fetchIssPassesList(parameter: parameter) { (issPasses, error) in
            if (error !=  nil) {
                self.delegate?.handleError(error: .ServiceError)
            } else {
                self.issPasses = issPasses
                completion()
            }
        }
    }
    
    func getLatitude() -> String {
        if let latitude = issPasses?.request?.latitude {
            return "\(latitude)"
        }
        return "0.0"
    }
    
    func getLongitude() -> String {
        if let longitude = issPasses?.request?.longitude {
            return "\(longitude)"
        }
        return "0.0"
    }
    
    func getAltitude() -> String {
        if let altitude = issPasses?.request?.altitude {
            return "\(altitude)"
        }
        return "0.0"
    }
    
    func getNoOfPasses() -> String {
        if let noOfPasses = issPasses?.request?.passes {
            return "\(noOfPasses)"
        }
        return "0"
    }
    
}

extension IssPassesListViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latitude = locations.last?.coordinate.latitude, let longitude = locations.last?.coordinate.longitude {
            self.latitude = latitude
            self.longitude = longitude
            //Once lattitue and longitude available then invoke the ISS Passes API
            fetchPasses { [weak self] in
                self?.delegate?.updateIssPassesList()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.handleError(error: .LocationError)
        NSLog("\(error.localizedDescription)")
    }
    
}
