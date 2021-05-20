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
    @IBOutlet weak var bottomAnimateLabel: UILabel!
    @IBOutlet weak var blurLayer: UIVisualEffectView!
    
    
    
    //MARK: Variables
    var timer:Timer?
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check if user is in dark mode to determine blur style
        if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
            blurLayer.effect = UIBlurEffect(style: .regular)
            } else {
                print("Dark mode")
                blurLayer.effect = UIBlurEffect(style: .dark)
            }
        
        //Call to LocationService class to begin handling location stuff. Keep calculations for distance from places there?
        LocationService.sharedInstance.startUpdatingLocation()


        //Initialize GPS sesssion and begin collecting points. For the most part, copy code from initial 'RunningMates' project for the LocationData class. Send start signal to above and begin to poll locations with frequencies of a couple seconds. When this happens, run function that gathers the average of the first three returned points. This is sent to the main view controller which decides which cloud the coordinates belong to (if any). Sidenote: if the user is not within a certain radius of the park at all, present an error message that displays this.
        
      //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "initialBackground.png")!)
       // let blurEffect = UIBlurEffect(style: .light)
        //let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.frame = view.frame
        //view.addSubview(blurEffectView)
        //view.sendSubviewToBack(blurEffectView)

        
        
        //MARK: Observers for events taking place elsewhere
        NotificationCenter.default.addObserver(self, selector: #selector(showTurnOnLocationServicesAlert(notification:)), name: Notification.Name(rawValue: "showTurnOnLocationServicesAlert"), object: nil)
    } //end viewDidLoad
    
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        //Assuming everything is good, send the user to the home screen and their first piece of music. Add haptics for good vibes and a little tangible feedback because why not 🤷🏻‍♂️
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animateLabel), userInfo: nil, repeats: true)
        timer?.fire()
        
       //After set delay, animate to the next screen and invalidate animation timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            performSegue(withIdentifier: "entranceSegue", sender: self)
            timer?.invalidate()
        }
    }
    
    //Animate triple dots above and below label
    var animationCounter = 0
    let animateArray = [".", "..", "..."]
    @objc func animateLabel() {
        bottomAnimateLabel.text = animateArray[animationCounter]
        animationCounter += 1
        if animationCounter >= 3 {
            animationCounter = 0
        }
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
