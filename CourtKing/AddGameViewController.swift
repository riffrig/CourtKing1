//
//  AddGameViewController.swift
//  CourtKing
//
//  Created by MU IT Program on 11/7/16.
//  Copyright © 2016 MU IT Program. All rights reserved.
//

import UIKit
import CoreData

class AddGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var teamName: UITextField!
    
    @IBOutlet weak var teamCaptain: UITextField!
    
    @IBOutlet weak var teammate1: UITextField!
    
    @IBOutlet weak var teammate2: UITextField!
    
    @IBOutlet weak var teammate3: UITextField!
    
    @IBOutlet weak var teammate4: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?
    
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Add Information"
        
        if let team = team {
            title = "Edit Team"
            teamName.text = team.teamName
            teamCaptain.text = team.teamCaptain
            teammate1.text = team.teamMember1
            teammate2.text = team.teamMember2
            teammate3.text = team.teamMember3
            teammate4.text = team.teamMember4

        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        guard let managedObjectContext = managedObjectContext else {return}
        
        //create quote or update if already exists
        if team == nil {
            //create quote
            let newTeam = Team(context: managedObjectContext)
            
            //configureQuote
            newTeam.createdAt = Date().timeIntervalSince1970
            
            //set team
            team = newTeam
        }
        
        if team == team {
            //configure Quote
            team?.teamName = teamName.text
            team?.teamCaptain = teamCaptain.text
            team?.teamMember1 = teammate1.text
            team?.teamMember2 = teammate2.text
            team?.teamMember3 = teammate3.text
            team?.teamMember4 = teammate4.text

        }
        
        
        //pop view controller
        _ = navigationController?.popViewController(animated: true)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}