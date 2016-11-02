//
//  HomeViewController.swift
//  CourtKing
//
//  Created by MU IT Program on 11/1/16.
//  Copyright © 2016 MU IT Program. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    let court1:[String] = ["private 1", "private 2"]
    let court2:[String] = ["shit", "ass"]
    let court3:[String] = ["blues","deez nuts"]
    let court4:[String] = ["a;sldkfjadsl;fjkassd;flkasd;fljksf"]
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        
        switch(mySegmentedControl.selectedSegmentIndex)
        {
            case 0:
                returnValue =  court1.count
                print("Touched 0")
                print(court1.count)
                break
            case 1:
                returnValue =  court2.count
                break
            case 2:
                returnValue = court3.count
                break
            case 3:
                returnValue =  court4.count
                break
            default:
                break
        }
        
        
        return returnValue
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       // let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell")
    
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        myCell.separatorInset = UIEdgeInsets.zero
        myCell.layoutMargins = UIEdgeInsets.zero
        
        
        switch(mySegmentedControl.selectedSegmentIndex)
        {
            case 0:
                myCell.textLabel!.text =  court1[indexPath.row]
                break
            case 1:
                myCell.textLabel!.text =  court2[indexPath.row]
                break
            case 2:
                myCell.textLabel!.text =  court3[indexPath.row]
                break
            case 3:
                myCell.textLabel!.text =  court4[indexPath.row]
                break
            default:
                break
        }
        
        return myCell
    }

    @IBAction func segmentedControlActionChange(_ sender: Any) {
        myTableView.reloadData()
    
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
