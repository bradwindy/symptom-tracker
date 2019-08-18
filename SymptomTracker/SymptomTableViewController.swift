import UIKit
import os.log

class SymptomTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var symptoms = [Symptom]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved symptoms, otherwise load sample data.
        if let savedSymptoms = loadSymptoms() {
            symptoms += savedSymptoms
        }
        else {
            // Load the sample data.
            loadSampleSymptoms()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptoms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SymptomTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SymptomTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SymptomTableViewCell.")
        }
        
        // Fetches the appropriate symptom for the data source layout.
        let symptom = symptoms[indexPath.row]
        
        cell.descLabel.text = symptom.desc
        cell.ratingControl.rating = symptom.rating
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            symptoms.remove(at: indexPath.row)
            saveSymptoms()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new symptom.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let symptomDetailViewController = segue.destination as? SymptomViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedSymptomCell = sender as? SymptomTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedSymptomCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSymptom = symptoms[indexPath.row]
            symptomDetailViewController.symptom = selectedSymptom
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    
    //MARK: Actions
    
    @IBAction func unwindToSymptomList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SymptomViewController, let symptom = sourceViewController.symptom {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing symptom.
                symptoms[selectedIndexPath.row] = symptom
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new symptom.
                let newIndexPath = IndexPath(row: symptoms.count, section: 0)
                
                symptoms.append(symptom)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the symptoms.
            saveSymptoms()
        }
    }
    
    //MARK: Private Methods
    private func loadSampleSymptoms() {
        

        guard let symptom1 = Symptom(desc: "Nausea", rating: 4) else {
            fatalError("Unable to instantiate symptom1")
        }

        guard let symptom2 = Symptom(desc: "Vomiting", rating: 2) else {
            fatalError("Unable to instantiate symptom2")
        }

        guard let symptom3 = Symptom(desc: "Aching", rating: 5) else {
            fatalError("Unable to instantiate symptom2")
        }

        symptoms += [symptom1, symptom2, symptom3]
    }
    
    private func saveSymptoms() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(symptoms, toFile: Symptom.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Symptoms successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save symptoms...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSymptoms() -> [Symptom]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Symptom.ArchiveURL.path) as? [Symptom]
    }

}
