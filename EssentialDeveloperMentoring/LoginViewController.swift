//
//  LoginViewController.swift
//  EssentialDeveloperMentoring
//
//  Created by Derek Roberson on 11/17/21.
//

import UIKit

protocol Factory {
    static func makeLeadDetail() -> LeadDetailViewController
    static func makeLead() -> Lead
}

struct LeadDetailFactory: Factory {
    static func makeLeadDetail() -> LeadDetailViewController {
        let vc = LeadDetailViewController.instantiate()
        vc.title = "Test Lead"
        vc.lead = LeadDetailFactory.makeLead()
        return vc
    }

    static func makeLead() -> Lead {
        let lead = Lead(mdid: "MMA9F54AC8611C445382334164B772E4CE", hasAi: true, aiStatus: .active)
        return lead
    }
}

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginAction(_ sender: Any) {
        Networking.shared.login {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let detailVC = LeadDetailFactory.makeLeadDetail()
                self.show(detailVC, sender: self)
            }
        }
    }
}

