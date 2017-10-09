//
//  ViewController.swift
//  DemoCoreData2
//
//  Created by Derbalil on 2017-10-04.
//  Copyright © 2017 Derbalil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dataBaseController = DataBaseController()
        
        //dataBaseController.addStudent(fullName: "Steve John", age: 23)
        //dataBaseController.addStudent(fullName: "Samy Raymmond", age: 35)
        //dataBaseController.addStudent(fullName: "Alain Jackson", age: 41)
        
        for student in dataBaseController.getStudents(){
            print("\(student.fullName!)  \(student.age)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

