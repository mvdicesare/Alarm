import UIKit

var str = "Hello, playground"



// MARK: - Alarm

let currentTime = Date()
    
    //Calendar.current.dateComponents(in: .autoupdatingCurrent, from: Date()).hour!



class Alarm: Codable {
    
    var name: String?
    var isOn: Bool
    var fireDate: Date
    var UUID: String
    var fireTimeAsString: String {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateStyle = .medium
        return newDateFormatter.string(from: fireDate)
    }
    
    init(name: String?, enabled: Bool = true, fireDate: Date, UUID: String) {
        self.name = name
        self.isOn = enabled
        self.fireDate = fireDate
        self.UUID = UUID
    }
}

extension Alarm: Equatable {
static func == (lhs: Alarm, rhs: Alarm) -> Bool {
    if lhs.name != rhs.name { return false }
    if lhs.isOn != rhs.isOn { return false }
    if lhs.fireDate != rhs.fireDate { return false }
    if lhs.UUID != rhs.UUID { return false }

    return true
}

}



// MARK: - Model controllers
// Alarm List
    class AlarmListTableViewController: UITableViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

        }
        
        var alarm: [Alarm?] = []
        
        
        // MARK: - Table view data source


        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return alarm.count
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addAlarm", for: indexPath)

            // Configure the cell...

            return cell
        }
        

     
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let alarm = AlarmController.shared.alarms[indexPath.row]
                AlarmController.shared.deleteAlarm(alarm: alarm)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }

      // MARK: - switch
        
      //  func switchCellSwitvhValueChanged(cell: ) {
            
        //}

        
        // MARK: - Navigation

       
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toAlarmSetting"{
                guard let destination = segue.destination as? AlarmDetailTableViewController,
                    let index = tableView.indexPathForSelectedRow else { return }
                let tappedOnEntry = AlarmController.shared.alarms[index.row]
                destination.reciever = tappedOnEntry
                
            }
        }
        

    }



// AlarmDetail

class AlarmDetailTableViewController: UITableViewController {

var reciever: Alarm?

  
override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    @IBAction func savedButtonTapped(_ sender: Any) {
        guard setTitleTextField.text != nil else { return }
        if let alarm = reciever {
            AlarmController.shared.updateAlarm(alarm: alarm, enabled: true, fireDate: Date, name: <#String#>) } else { let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AlarmListTableViewController: UITableViewDelegate, UITableViewDataSource {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }
    func tableview(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)) as? AlarmListTableViewController
        
        let setting = AlarmController.shared.alarms[indexPath.row]
        
        cell?.setting = setting
        
        cell?.delegate = self
        return cell ?? UITableViewCell
    }
}



// MARK: - Model Controllers
//Switch Table

protocol SettingTableViewCellDelegate: class {
func settingValueChanged(_ cell: AlarmListTableViewController, selected: Bool)
}

class SwitchTableViewCell: UITableViewCell {

  var reciever: Alarm?
    // MARK: - IBO Outlets
    
    
    weak var delegate: AlarmDetailTableViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


// Alarm Controller
class AlarmController {
    
    static let shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    func addAlarm(name: String, enabled: Bool, fireDate: Date, UUID: String) {
     let newAlarm = Alarm(name: name, enabled: enabled, fireDate: fireDate, UUID: UUID)
        alarms.append(newAlarm)
        saveToPersistentStore()
        
    }

    func deleteAlarm(alarm: Alarm) {
        guard alarms.firstIndex(of: alarm) != nil else { return }
        saveToPersistentStore()
            
        
    }
//    var mockAlarm: [Alarm] {
//        self.alarms = self.mockAlarm
//    }
    
    func updateAlarm(alarm: Alarm, enabled: Bool, fireDate: Date, name: String) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.isOn = enabled
        saveToPersistentStore()
       
    }


    func createFuleURLForPersistence() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let fileURL = urls[0].appendingPathComponent("Alarm.json") // *** CHANGE FILE NAME HERE ***
        
        return fileURL
    }
    
    
    func saveToPersistentStore() {
        // Creating an instance of the JSONEncoder class
        let jsonEncoder = JSONEncoder()
        
        do {
            // Access the JSONEncoder class to encode our Source of Truth and turn it tnto JSON
            let crayonJSON = try jsonEncoder.encode(alarms)
            // Write that JSON to our fileURL for local storage
            try crayonJSON.write(to: createFuleURLForPersistence())
        } catch {
            // IF THAT FAILS, we catch the error
            print("Error encoding alarm: \(error.localizedDescription) \n ----- \n \(error)")
        }
    }
    
    
    func loadFromPersistentStore() {
        
        let jsonDecoder = JSONDecoder()
        
        do {
            // attempt to find file
            let jsonData = try Data(contentsOf: createFuleURLForPersistence())
            
            let decodedCrayons = try jsonDecoder.decode([Alarm].self, from: jsonData)
            
            // update source of truth with decoded crayons
            alarms = decodedCrayons
            
            // catch errors
        } catch {
            print("Error decoding Crayons: \(error.localizedDescription) \n ----- \n \(error)")
        }
    }


}
