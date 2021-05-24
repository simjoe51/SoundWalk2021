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
import MapKit

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var blurLayer: UIVisualEffectView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    //MARK: Variables
    var audioPlayer = AVAudioPlayer()
    var delayTimer:Timer?
    
    let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    var tempLocationArray:[CLLocation] = []
    
    //User's current region. Check against this while assigning for both haptic feedback and music switching
    var currentRegion:String?
    
    //MARK: Map Variables
    var tileRenderer: MKTileOverlayRenderer!
    
    let soundReferences:[String] = ["thrumming", "desiredDay", "aprilSketch", "willow", "fortOrange", "quartet"]
    var playerLoopCount = 0
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Check if user is in dark mode to determine blur style
        if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
            blurLayer.effect = UIBlurEffect(style: .regular)
            } else {
                print("Dark mode")
                blurLayer.effect = UIBlurEffect(style: .dark)
            }
        
        //MARK: Old Audio Stuff for Reuse
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
       // mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.delegate = self
       // let location = CLLocation(latitude: 42.657066, longitude: -73.771605)
      //  let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 130)!, longitudinalMeters: CLLocationDistance(exactly: 130)!)
       // mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.setUserTrackingMode(.followWithHeading, animated: true)

        
        //Call handleNewLocation function when LocationServices class sends good location
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewLocation(_:)), name: Notification.Name(rawValue: "didUpdateLocation"), object: nil)
        
    } //end viewDidLoad
    
    //MARK: Handle New Location Input and Assign Region
    @objc func handleNewLocation(_ notification: NSNotification) {
        
        print("HANDLE NEW LOCATION")
        
        //Unwrap notification into its coordinate thing and append the location to the tempArray
        if let userInfo = notification.userInfo{
            if let newLocation = userInfo["location"] as? CLLocation{
                
               // let region = MKCoordinateRegion( center: newLocation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 130)!, longitudinalMeters: CLLocationDistance(exactly: 130)!)
                //mapView.setRegion(mapView.regionThatFits(region), animated: true)
                
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
                    if (haversine(lat1: 42.656092, lon1: -73.771669, lat2: averagedCoordinate.coordinate.latitude, lon2: averagedCoordinate.coordinate.longitude) <= 8) {
                        //Thrumming.
                        playAudio(reference: soundReferences[0])
                    } else if (haversine(lat1: 42.656800, lon1: -73.772339, lat2: averagedCoordinate.coordinate.latitude, lon2: averagedCoordinate.coordinate.longitude) <= 8) {
                        //DesiredDay
                        playAudio(reference: soundReferences[1])
                    } else if (haversine(lat1: 42.656800, lon1: -73.772339, lat2: averagedCoordinate.coordinate.latitude, lon2: averagedCoordinate.coordinate.longitude) <= 8) {
                        
                    }
                    
                    //Make sure the user is actually in the park first though. Put this at the end of the list to avoid unneeded repition of code.
                    //Need to hang out with jared in the park for this bit
                }
            }
        }

        
    } //end handleNewLocation
    
    //Play selected audio track and handle switching between depending on how many loops have been played already
    private func playAudio(reference:String) {
        let file = Bundle.main.path(forResource: reference, ofType: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file!))
             audioPlayer.numberOfLoops = -1
        } catch {
            print(error)
        }
    }
    
    func  audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            playerLoopCount += 1
            //MARK: MAKE SURE THIS FIRES WHEN THE PIECE LOOPS
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
            
            return (r * c) * 1000
        }


} //end main class

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return tileRenderer
    }
    
    //Alter user annotation in map
    func mapView( _ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let user as MKUserLocation:
            if let existingView = mapView
                .dequeueReusableAnnotationView(withIdentifier: "user") {
                return existingView
            } else {
                let view = MKAnnotationView(annotation: user, reuseIdentifier: "user")
                view.image = #imageLiteral(resourceName: "user")
                return view
            }
        default:
            return nil
        }
    }
}



