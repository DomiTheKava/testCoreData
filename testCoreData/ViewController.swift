//
//  ViewController.swift
//  testCoreData
//
//  Created by Dominik Penkava on 10/28/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesAndDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        
        cell.textLabel?.text = timesAndDates[indexPath.row]
        
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel: NSManagedObjectContext!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    var times: [String] = []
    var dates: [String] = []
    
    var timesAndDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataModel = appDelegate.persistentContainer.viewContext
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        addData("14", "14/12/24")
        fetchData()
 
        print(times, dates)
    }
    
    func addData(_ time: String, _ date: String) {
        
        let newCell = NSEntityDescription.insertNewObject(forEntityName: "ItemEntity", into: dataModel)
        newCell.setValue(time, forKey: "time")
        newCell.setValue(date, forKey: "date")
        
        do {
            try self.dataModel.save()
            print("saved Date \(time), \(date)")
        } catch {
            print("Error saving data")
        }
        
        fetchData()
    }
    
    func fetchData() {
        let fetchRq = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        
        dates = []
        times = []
        
        do {
            let result = try dataModel.fetch(fetchRq) as! [NSManagedObject]

            for item in result {
                if let time = item.value(forKey: "time") as? String {
                    times.append(time)
                    print("fetched \(time)")
                }
                
                if let date = item.value(forKey: "date") as? String {
                    dates.append(date)
                    print("fetched \(date)")
                }
//                Wipe:
//                dataModel.delete(item)
//                
//                do {
//                    try self.dataModel.save()
//                } catch {
//                    print("Error saving data")
//                }

            }


        } catch {
            print("failed")
        }
        
        timesAndDates = []
        
        var count = 0
        for item in times {
            let newString = item + ", " + dates[count]
            timesAndDates.append(newString)
            count += 1
        }
        
        tableView.reloadData()
        print(timesAndDates)
    }

    @IBAction func addDataBtn(_ sender: Any) {
        if timeField.text != nil && dateField.text != nil {
            addData(timeField.text!, dateField.text!)
        }
        tableView.reloadData()
        print("btn clicked")
    }
    
}

