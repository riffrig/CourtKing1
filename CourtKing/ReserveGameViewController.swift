//
//  ReserveGameViewController.swift
//  CourtKing
//
//  Created by MU IT Program on 11/7/16.
//  Copyright © 2016 MU IT Program. All rights reserved.
//

import UIKit
import CoreData

class ReserveGameViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var team1Button: UIButton!
    
    @IBOutlet weak var vsButton: UIButton!
    
    @IBOutlet weak var team2Button: UIButton!
    
    @IBOutlet weak var reserveGameButton: UIButton!
    
    private let persistentContainer = NSPersistentContainer(name: "CourtKing")
    
    private let segueAddGameViewController = "SegueAddGameViewController"
    
    var managedObjectContext: NSManagedObjectContext?
    
    public var courtSelected = 0
    
    
    @IBAction func popoverOne(_ sender: Any) {
        
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popoverID") as! popoverViewController
        self.addChildViewController(popoverVC)
        popoverVC.view.frame = self.view.frame
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParentViewController: self)
        
        
    }
    
    
    
    //Action for when the segmented control is changed
    @IBAction func segmentChanged(_ sender: Any) {
        
        switch(self.mySegmentedControl.selectedSegmentIndex)
        {
            case 0:
                courtSelected = 0
                self.tableView.reloadData()
                messageLabel.text = "No Reservations on Court 7"
                break
            case 1:
                courtSelected = 1
                self.tableView.reloadData()
                messageLabel.text = "No Reservations on Court 8"
                break
            case 2:
                courtSelected = 2
                self.tableView.reloadData()
                messageLabel.text = "No Reservations on Court 9"
                break
            case 3:
                courtSelected = 3
                self.tableView.reloadData()
                messageLabel.text = "No Reservations on Court 10"
                break
            default:
                break
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.allowsSelection = false
        vsButton.isEnabled = false
        
        //Add logo in the top left corner of the navigation bar
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "logo.jpg"), for: UIControlState.normal)
        button.addTarget(self, action:Selector(("callMethod")), for: UIControlEvents.touchDragInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        //Giving segmented control segments attributes and bold text
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!, forKey: NSFontAttributeName as NSCopying)
        mySegmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        //Set up persistent store for core data
        //Update view accordingly and perform fetches
        persistentContainer.loadPersistentStores { (NSPersistentStoreDescription, error) in
            if let error = error {
                print("Unable to load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector (applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    //default method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //setup view with message label which changes as reservations are added
    private func setupView() {
        setupMessageLabel()
        updateView()
    }
    
    //Setting up message label
    //will be displayed when there are no Games reserved on any court
    private func setupMessageLabel() {
        messageLabel.text = "No Games Reserved Currently."
        tableView.reloadData()
    }
    
    //update view
    //show/hide elements depending on number of reservations
    fileprivate func updateView() {
        
        var hasGames = false
        
        if let games = self.fetchedResultsController.fetchedObjects {
            hasGames = games.count > 0
            print("Number of games = ",games.count)
            
        }

        tableView.isHidden = !hasGames
        team1Button.isHidden = !hasGames
        team2Button.isHidden = !hasGames
        vsButton.isHidden = !hasGames
        
        //reserveGameButton.center = self.view.center = !hasGames

        messageLabel.isHidden = hasGames

        
        
    }
    
    //make nsfetchedResultsController 
    //create fetch request for "Team" Core data entity and create sort descriptors for table view
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Team> = {
        //create fetch request
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        
        //configure fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        //create fetched results controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //configure fetched results controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    //prepare for segue to the add team information page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationViewController = segue.destination as? AddGameViewController else {return}
        
        //configure view controller
        destinationViewController.managedObjectContext = persistentContainer.viewContext
        
        if segue.identifier == segueAddGameViewController {
            if let destinationViewController = segue.destination as? AddGameViewController {
         //configure view controller
                destinationViewController.managedObjectContext = persistentContainer.viewContext
            }
         }
    }
    
    func applicationDidEnterBackground(_ notification: Notification)
    {
        do {
            try persistentContainer.viewContext.save()
        }
        catch {
            print("Unable to save changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    //used to help update tableview
    func configure(_ cell: ReservationCell, at indexPath: IndexPath) {
        //fetch team
        let team = fetchedResultsController.object(at: indexPath)
        
        /*let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
        print(DateInFormat)*/
        
        //configure cell
        
        cell.teamName.text = team.teamName
        cell.teamCaptain.text = team.teamCaptain
        cell.teammate1.text = team.teamMember1
        cell.teammate2.text = team.teamMember2
        cell.teammate3.text = team.teamMember3
        cell.teammate4.text = team.teamMember4
        
        
       if (indexPath.row == 0)
        {
            team1Button.setTitle(cell.teamName.text, for: .normal)
        }
        
        if (indexPath.row == 1)
        {
            team2Button.setTitle(cell.teamName.text, for: .normal)
            
        }
        
        print(tableView.numberOfRows(inSection: 0))
        
        if (tableView.numberOfRows(inSection: 0) == 1)
        {
            team2Button.setTitle("Empty", for: .normal)
            team2Button.reloadInputViews()
        }
        
       // team1Button.setTitle(team.teamName, for: .normal)
        //cell.dateCreated.text = DateInFormat
        
        
        
    }
    
    //trying to unwind segue on back button
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
    }



}

//Extension of View Controller to allow The table view to communicate with the datasource
extension ReserveGameViewController: UITableViewDataSource {
    
    
   /* func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
        if (indexPath.row == 0)
        {
            cell.contentView.backgroundColor = UIColor.cyan
            //cell.backgroundColor = UIColor.init(red: 59, green: 86, blue: 241, alpha: 1.0)
        }
        
        if (indexPath.row == 1)
        {
            cell.contentView.backgroundColor = UIColor.blue
            //self.cell.backgroundColor = UIColor.init(red: 59, green: 86, blue: 241, alpha: 1.0)
            
        }
    
    }*/

    
    //trying to add slide options to declare winner of the game
    private func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let declareWinner = UITableViewRowAction(style: .normal, title: "WINNER!") { action, index in print("Winner button tapped")
        }
        
        declareWinner.backgroundColor = UIColor.blue
        
        let declareLoser = UITableViewRowAction(style: .normal, title: "LOSER!") { action, index in print("Loser button tapped")
        }
        
        declareLoser.backgroundColor = UIColor.blue
            
        return [declareWinner, declareLoser]
    }

    

    //returns the number of rows in the table view based on the number of reservations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let teams = fetchedResultsController.fetchedObjects else {return 0}
        //return teams.count
        
        
        return teams.count
        
    }
    
    //************CORE DATA FETCH BY VALUE****************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
            fatalError("Unexpected Index Path")
        }
        
        configure(cell, at: indexPath)
        
        //setting colors to match up with the team name colors in the view
        if (indexPath.row == 0)
        {
            cell.contentView.backgroundColor = UIColor.black
            cell.teamName.textColor = UIColor.white
            cell.teamCaptain.textColor = UIColor.white
            cell.teammate1.textColor = UIColor.white
            cell.teammate2.textColor = UIColor.white
            cell.teammate3.textColor = UIColor.white
            cell.teammate4.textColor = UIColor.white
        }
        else if (indexPath.row == 1)
        {
            cell.contentView.backgroundColor = UIColor(red: 185/255.0, green: 185.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        }
        else
        {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        
        return cell
        //use enum to change variable based on the segment selected
        //then in ibaction for segmented control make sure you check the value and then
        //make sure you reload tableview data
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //fetch quote
            let team = fetchedResultsController.object(at: indexPath)
            
            //delete quote
            team.managedObjectContext?.delete(team)
        }
        
    }
    


}

//NSfetchedResultsController extension of view controller
extension ReserveGameViewController: NSFetchedResultsControllerDelegate {

    //starts updates for table view whenever controller is used to fetch
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    //ends updates for table view wheneber the content has changed and then view is updated
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    //inserting into the fetched controller
    //deleting inserts in the table view also
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
                print("Added reservation to table view")
            }
            break
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                team1Button.reloadInputViews()
                team2Button.reloadInputViews()
                
            }
            break
            
        case .move:
            break
        
            
        /*case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ReservationCell {
                //configure(cell, at: indexPath, team)
            }
            break*/
            
        default:
            print("...")
        }
    }
}
