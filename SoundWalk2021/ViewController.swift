//
//  ViewController.swift
//  SoundWalk2021
//
//  Created by Joseph Simeone on 5/16/21.
//

import UIKit
import AVFoundation
import AudioToolbox.AudioServices
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: Variables
    var audioPlayer = AVAudioPlayer()
    var delayTimer:Timer?
    
    let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    var tempLocationArray:[CLLocation] = []
    
    //User's current region. Check against this while assigning for both haptic feedback and music switching
    var currentRegion:String?
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //MARK: Old Audio Stuff for Reuse
        /*
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
               try? AVAudioSession.sharedInstance().setActive(true)
                
                let alarm = Bundle.main.path(forResource: "runningMatesAlarm", ofType: "mp3")
                
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: alarm!))
                     audioPlayer.numberOfLoops = -1
                } catch {
                    print(error)
                }
 */
    }
    
    //MARK: Handle New Location Input and Assign Region
    @objc func handleNewLocation(_ notification: NSNotification) {
        
        print("HANDLE NEW LOCATION")
        
        //Unwrap notification into its coordinate thing and append the location to the tempArray
        if let userInfo = notification.userInfo{
            if let newLocation = userInfo["location"] as? CLLocation{
                //Add location to array
                tempLocationArray.append(newLocation)
                //Check if array has more than three points in it. If so, calculate region.
                if tempLocationArray.count >= 3 {
                    let coordinate1 = tempLocationArray.last!.coordinate
                    let coordinate2 = tempLocationArray[tempLocationArray.count - 1].coordinate
                    let coordinate3 = tempLocationArray[tempLocationArray.count - 2].coordinate
                    
                    //TEST
                    print(coordinate1, coordinate2, coordinate3)
                    
                    let averagedCoordinate = averageCoordinates(lat1: coordinate1.latitude, lon1: coordinate1.longitude, lat2: coordinate2.latitude, lon2: coordinate2.longitude, lat3: coordinate3.latitude, lon3: coordinate3.longitude)
                    
                    //Compare this coordinate with a list of regions and their radii to assign the user to one.
                    //Make sure the user is actually in the park first though. Put this at the end of the list to avoid unneeded repition of code.
                    //Need to hang out with jared in the park for this bit
                }
            }
        }

        
    }
    
    private func averageCoordinates(lat1:Double, lon1:Double, lat2:Double, lon2:Double, lat3:Double, lon3:Double) -> CLLocation {
        let newLat = (lat1 + lat2 + lat3) / 3
        let newLon = (lon1 + lon2 + lon3) / 3
        
        return CLLocation(latitude: newLat, longitude: newLon)
    }
    
    private func haversine(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
            let lat1rad = lat1 * Double.pi/180
            let lon1rad = lon1 * Double.pi/180
            let lat2rad = lat2 * Double.pi/180
            let lon2rad = lon2 * Double.pi/180
            
            let dLat = lat2rad - lat1rad
            let dLon = lon2rad - lon1rad
            let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
            let c = 2 * asin(sqrt(a))
            let r = 6372.79
            
            return (r * c) / 1.609344
        }


}

