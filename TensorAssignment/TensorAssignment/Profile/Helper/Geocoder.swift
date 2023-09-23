//
//  Geocoder.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation
import CoreLocation

class Geocoder {
    let geocoder = CLGeocoder()
    
    func getCoordinatesForCity(cityName: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let placemark = placemarks?.first {
                let coordinates = placemark.location?.coordinate
                completion(coordinates, nil)
            } else {
                print("No coordinates found for city: \(cityName)")
                completion(nil, nil)
            }
        }
    }
}
