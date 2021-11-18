//
//  LeadDetailViewController.swift
//  EssentialDeveloperMentoring
//
//  Created by Derek Roberson on 11/17/21.
//

import UIKit

class LeadDetailViewController: UIViewController, Storyboardable {
    var lead: Lead!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loadMessagesButtonAction(_ sender: UIButton) {
        
        let textMessageVC = TextMessageViewController()
        show(textMessageVC, sender: self)
    }
}
