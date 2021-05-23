//
//  WashingtonParkOverlay.swift
//  SoundWalk2021
//
//  Created by Joseph Simeone on 5/20/21.
//

import Foundation
import MapKit

class WashingtonParkOverlay: MKTileOverlay {
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let tileURL = "https://tile.openstreetmap.org/\(path.z)/\(path.x)/\(path.y).png"
        print("requested tile\tz:\(path.z)\tx:\(path.x)\ty:\(path.y)")
        return URL(string: tileURL)!
    }
}
