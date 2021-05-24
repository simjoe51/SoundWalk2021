//
//  MenuViewController.swift
//  SoundWalk2021
//
//  Created by Joseph Simeone on 5/23/21.
//

import UIKit
import CoreLocation

class MenuViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: Variables
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)


    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        performSegue(withIdentifier: "startSegue", sender: self)
        mediumImpactGenerator.impactOccurred()
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
