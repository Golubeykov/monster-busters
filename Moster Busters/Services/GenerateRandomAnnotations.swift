//
//  GenerateRandomAnnotations.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import MapKit

enum RandomCoordinatesGenerator {
    
    static func generate(min: UInt32, max: UInt32, currentLocation: CLLocation) -> CLLocationCoordinate2D {
        //Получаем текущее местоположение
        let currentLong = currentLocation.coordinate.longitude
        let currentLat = currentLocation.coordinate.latitude
        
        //1 километр = 0.00900900900901° поэтому, 1 метр = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000
        
        //Генерируем рандомные метры в указанном промежутке
        let randomMeters = UInt(arc4random_uniform(max) + min)
        
        //Генерируем рандомные числа для разных направления
        let randomPM = arc4random_uniform(6)
        
        //Конвертируем метры в координаты
        let metersCordN = meterCord * Double(randomMeters)
        
        //Генерируем координаты на основании полученного рандомного числа
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        } else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        } else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        } else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        } else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        } else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }
        
    }
}


