//
//  StudentsTableViewController.swift
//  DemoCoreData2
//
//  Created by Derbalil on 2017-10-04.
//  Copyright © 2017 Derbalil. All rights reserved.
//

import UIKit
import CoreData

var studentsList: [Student]  = []
let dataBaseController = DataBaseController()


class StudentsTableViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    let context = DataBaseController().getContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        //dataBaseController.addStudent(fullName: "Steve Blair", age: 26)
        //dataBaseController.addStudent(fullName: "Samy Raymmond", age: 35)
        //dataBaseController.addStudent(fullName: "Alain Jackson", age: 41)
        
        //dataBaseController.deleteStudent(fullName: "Michel Claude", age: 55)
        //dataBaseController.updateStudent(fullName: "Michel Claude", age: 55)
        
        if studentsList.count == 0 {
            for student in dataBaseController.getStudents(){
                studentsList.append(student)
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Click button Add Student
    @IBAction func btnAddStudent(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Student", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert in
          
            let fullNameField = alertController.textFields![0] as UITextField
            let ageField = alertController.textFields![1] as UITextField
            
            if fullNameField.text != "", ageField.text != "" {
                // add student to the database
                dataBaseController.addStudent(fullName: fullNameField.text!, age: Int(ageField.text!)!)
                let newStudent = NSEntityDescription.insertNewObject(forEntityName: "Student", into: self.context) as! Student
                newStudent.setValue(fullNameField.text!, forKey: "fullName")
                newStudent.setValue(Int16(ageField.text!)!, forKey: "age")
                studentsList.removeAll()
                for student in dataBaseController.getStudents(){
                    studentsList.append(student)
                }
                self.myTableView.reloadData()
                
            }else{
                //display error
                print("error")
            }
        }))
        
        // add text field
            alertController.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Full Name"
                textField.textAlignment = .center
            })
        
            alertController.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Age"
                textField.textAlignment = .center
            })
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellStudent", for: indexPath)

        // Configure the cell...
        let index = indexPath.row
        cell.textLabel?.text = studentsList[index].fullName
        cell.detailTextLabel?.text = String(studentsList[index].age)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let editAlert = UIAlertController(title: "Edit Student", message: nil, preferredStyle: .alert)
            editAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert in
                
                let fullNameField = editAlert.textFields![0] as UITextField
                let ageField = editAlert.textFields![1] as UITextField
                
                if fullNameField.text != "", ageField.text != "" {
                    
                    dataBaseController.updateStudent(fullNameOld: studentsList[indexPath.row].fullName!, ageOld: Int(studentsList[indexPath.row].age), fullNameNew: fullNameField.text!, ageNew: Int(ageField.text!)!)
                    studentsList.removeAll()
                    for student in dataBaseController.getStudents(){
                        studentsList.append(student)
                    }
                    self.myTableView.reloadData()
                    
                }else{
                    //display error
                    print("error")
                }
            }))
            /*alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                //self.list[indexPath.row] = alert.textFields!.first!.text!
                //self.tableView.reloadRows(at: [indexPath], with: .fade)
            }))*/
            editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // add text field
            editAlert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = studentsList[indexPath.row].fullName
                textField.textAlignment = .center
            })
            
            editAlert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = String(studentsList[indexPath.row].age)
                textField.textAlignment = .center
            })
            

            self.present(editAlert, animated: false)
        })
        
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "Delete \(studentsList[indexPath.row].fullName!) ?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (updateAction) in
                let index = indexPath.row
                dataBaseController.deleteStudent(fullName: studentsList[index].fullName!, age: studentsList[index].age)
                studentsList.remove(at: index)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let index = indexPath.row
            dataBaseController.deleteStudent(fullName: studentsList[index].fullName!, age: studentsList[index].age)
            studentsList.remove(at: index)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
