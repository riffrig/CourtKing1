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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        setupMessageLabel()
        
        
        updateView()
    }
    
    private func setupMessageLabel() {
        messageLabel.text = "No Games Reserved Currently."
    }
    
    fileprivate func updateView() {
        
        var hasGames = false
        
        if let games = fetchedResultsController.fetchedObjects {
            hasGames = games.count > 0
            
        }

        tableView.isHidden = !hasGames
        team1Button.isHidden = !hasGames
        team2Button.isHidden = !hasGames
        vsButton.isHidden = !hasGames
        
        //reserveGameButton.center = self.view.center = !hasGames

        messageLabel.isHidden = hasGames

        
        
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationViewController = segue.destination as? AddGameViewController else {return}
        
        //configure view controller
        destinationViewController.managedObjectContext = persistentContainer.viewContext
        
        /*if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == segueEditQuoteViewController {
            //configure view controller
            destinationViewController.quote = fetchedResultsController.object(at: indexPath)
        }*/
        
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
        //fetch quote
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
        //cell.dateCreated.text = DateInFormat
        
        
        
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

extension ReserveGameViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //let teams = fetchedResultsController.fetchedObjects
        
        /*switch (mySegmentedControl.selectedSegmentIndex)
        {
        case 0:
            guard let teams = fetchedResultsController.fetchedObjects else {return 0}
            return teams.count
        case 1:
            guard let teams = fetchedResultsController.fetchedObjects else {return 0}
            return teams.count
        case 2:
            guard let teams = fetchedResultsController.fetchedObjects else {return 0}
            return teams.count
        case 3:
            guard let teams = fetchedResultsController.fetchedObjects else {return 0}
            return teams.count
        default:
            break
        }*/
        
        guard let teams = fetchedResultsController.fetchedObjects else {return 0}
        //return teams.count
        
        
        return teams.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
            fatalError("Unexpected Index Path")
        }
        
        //configure cell
       /* switch (mySegmentedControl.selectedSegmentIndex)
        {
        case 0:
            configure(cell, at: indexPath)
            return cell
        case 1:
            configure(cell, at: indexPath)
            return cell
        case 2:
            configure(cell, at: indexPath)
            return cell
        case 3:
            configure(cell, at: indexPath)
            return cell
        default:
            break
        }*/
        
        
        configure(cell, at: indexPath)
        
        /*//fetch quote
         let quote = fetchedResultsController.object(at: indexPath)
         
         //configure cell
         cell.authorLabel.text = quote.author
         cell.contentsLabel.text = quote.contents*/
        
        return cell
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

extension ReserveGameViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    //inserting into the fetched controller
    //deleting inserts
    //if cell is clicked, update
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ReservationCell {
                configure(cell, at: indexPath)
            }
            break
            
        default:
            print("...")
        }
    }
}
