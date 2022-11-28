//
//  GenerateRandomAnnotations.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import MapKit

enum GenerateRandomAnnotations {

    static func generateAnnoLoc(for mapView: MKMapView, currentLocation: CLLocation) {
        //Get the Current Location's longitude and latitude
        let currentLong = currentLocation.coordinate.longitude
        let currentLat = currentLocation.coordinate.latitude

        var num = 0
        //First we declare While to repeat adding Annotation
        while num != 6 {
            num += 1

            //Add Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = generateRandomCoordinates(min: 70, max: 150) //this will be the maximum and minimum distance of the annotation from the current Location (Meters)
            annotation.title = "Annotation Title"
            annotation.subtitle = "SubTitle"
            mapView.addAnnotation(annotation)

        }

        func generateRandomCoordinates(min: UInt32, max: UInt32) -> CLLocationCoordinate2D {

            //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
            let meterCord = 0.00900900900901 / 1000

            //Generate random Meters between the maximum and minimum Meters
            let randomMeters = UInt(arc4random_uniform(max) + min)

            //then Generating Random numbers for different Methods
            let randomPM = arc4random_uniform(6)

            //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
            let metersCordN = meterCord * Double(randomMeters)

            //here we generate the last Coordinates
            if randomPM == 0 {
                return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
            }else if randomPM == 1 {
                return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
            }else if randomPM == 2 {
                return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
            }else if randomPM == 3 {
                return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
            }else if randomPM == 4 {
                return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
            }else {
                return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
            }

        }
    }

}
