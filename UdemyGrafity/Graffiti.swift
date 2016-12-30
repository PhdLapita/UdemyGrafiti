//
//  Graffiti.swift
//  UdemyGrafity
//
//  Created by Bear on 30/12/16.
//  Copyright © 2016 BearCreekMining. All rights reserved.
//

import UIKit

class Graffiti: NSObject {
    let graffitiAddress : String
    let graffitiLatitud: Double
    let graffitiLongitud : Double
    let graffitiImageName : String

    init(address: String, latitude: Double, longitude: Double, image:String) {
        self.graffitiAddress = address
        self.graffitiLatitud = latitude
        self.graffitiLongitud = longitude
        self.graffitiImageName = image
    }
}
