//
//  FirstViewController.swift
//  Styk
//
//  Created by William Yang on 8/1/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, CurrentTaskDelegate {

    // MARK: - IBOutlet properties
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var taskView: UIView!
    
    // MARK: - Variables
    var time: Float = 0
    
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounding corners of buttons
        calendarButton.layer.cornerRadius = calendarButton.frame.size.width/2
        
        // Notification for returning from home screen
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.setClock), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
        setClock()
    }

  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentTask" {
            let currentTaskController = segue.destination as? CurrentTaskViewController
            currentTaskController?.delegate = self
        }
    }
    
    
    // MARK: - Clock functions
    func startSpinning() {
        line.startRotating(duration: 24, start: time)
    }
    
    func setTime()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        time = (Float)(hour*60 + minute)*2*Float.pi/720
        line.transform = line.transform.rotated(by: CGFloat(time))
    }
    
    @objc func setClock()
    {
        setTime()
        startSpinning()
    }
    
    
}

