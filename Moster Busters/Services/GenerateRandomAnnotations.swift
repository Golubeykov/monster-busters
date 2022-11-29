//
//  GenerateRandomAnnotations.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import MapKit

enum GenerateRandomAnnotations {

    static func generateAnnoLoc(for mapView: MKMapView, currentLocation: CLLocation) {
        //Получаем текущее местоположение
        let currentLong = currentLocation.coordinate.longitude
        let currentLat = currentLocation.coordinate.latitude

        //Создаем рандомных монстров из базы
        let monsters: [Monster] = MonstersDataBase.returnFiveRandomMonstersFromBase()
        for index in 0..<monsters.count {
            let monster = monsters[index]
            let annotation = ImageAnnotation()
            annotation.coordinate = generateRandomCoordinates(min: 50, max: 100)
            annotation.image = UIImage(named: monster.assetName)
            annotation.title = monster.name
            annotation.subtitle = "\(monster.lvl) lvl"
            annotation.monster = monster
            DispatchQueue.main.async {
                mapView.addAnnotation(annotation)
            }
        }

        func generateRandomCoordinates(min: UInt32, max: UInt32) -> CLLocationCoordinate2D {

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

}
