//
//  InitialViewController.swift
//  SoundWalk2021
//
//  Created by Joseph Simeone on 5/16/21.
//

import UIKit

class InitialViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call to LocationService class to begin handling location stuff. Keep calculations for distance from places there?
        LocationService.sharedInstance.startUpdatingLocation()


        //Initialize GPS sesssion and begin collecting points. For the most part, copy code from initial 'RunningMates' project for the LocationData class. Send start signal to above and begin to poll locations with frequencies of a couple seconds. When this happens, run function that gathers the average of the first three returned points. This is sent to the main view controller which decides which cloud the coordinates belong to (if any). Sidenote: if the user is not within a certain radius of the park at all, present an error message that displays this.
        
        //Animate the three dots in 'welcomeMessageLabel' while the GPS class loads.
        
        //MARK: Observers for events taking place elsewhere
        NotificationCenter.default.addObserver(self, selector: #selector(showTurnOnLocationServicesAlert(notification:)), name: Notification.Name(rawValue: "showTurnOnLocationServicesAlert"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewLocation), name: Notification.Name(rawValue: "didUpdateLocation"), object: nil)

    }
    
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        //Assuming everything is good, send the user to the home screen and their first piece of music. Add haptics for good vibes and a little tangible feedback because why not 🤷🏻‍♂️
        performSegue(withIdentifier: "entranceSegue", sender: self)
    }
    
    @objc func handleNewLocation() {
        
    }
    
    
    //MARK: Location permissions issues
        @objc func showTurnOnLocationServicesAlert(notification: NSNotification) {
            let alert = UIAlertController(title: "Location access is required to use this app!", message: "Please navigate to your settings and enable location services in order to use this app.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsURL = URL(string: UIApplication.openSettingsURLString)
                if let URL = settingsURL {
                    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
