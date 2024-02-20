//
//  TimeModel.swift
//  MyDua
//
//  Created by IB Arts Mac on 13/02/24.
//

import Foundation

struct AzanTime {
    
    var Fajr: String?
    var Sunrise: String?
    var Dhuhr: String?
    var Sunset: String?
    var Maghrib: String?
    
    init(Fajr: String? = nil, Sunrise: String? = nil, Dhuhr: String? = nil, Sunset: String? = nil, Maghrib: String? = nil) {
        self.Fajr = Fajr
        self.Sunrise = Sunrise
        self.Dhuhr = Dhuhr
        self.Sunset = Sunset
        self.Maghrib = Maghrib
    }
    
    
}
