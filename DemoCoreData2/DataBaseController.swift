//
//  DataBaseController.swift
//  DemoCoreData2
//
//  Created by Derbalil on 2017-10-04.
//  Copyright © 2017 Derbalil. All rights reserved.
//

import Foundation
import CoreData


class DataBaseController{
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
              let container = NSPersistentContainer(name: "DataBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Get Context
    func getContext() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = self.getContext()
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Get all students
    func getStudents() -> [Student]{
        
        let context = self.getContext()
        
        //fetch all Students
        let request : NSFetchRequest<Student> = Student.fetchRequest()
        
        //sort records according age then fullName
        let sortDesriptor1 = NSSortDescriptor(key: "age", ascending: true)
        let sortDesriptor2 = NSSortDescriptor(key: "fullName", ascending: true)
        
        request.sortDescriptors = [sortDesriptor1, sortDesriptor2]
        
        //request.returnsObjectsAsFaults = false
        
        do{
            
            let students = try context.fetch(request)
            
            if students.count > 0 {
                    return students as [Student]
            }
        }catch{
            print("Error")
        }
        return []
    }
    
    
    // MARK: - Add new student
    func addStudent(fullName: String, age:Int){
        let context = self.getContext()
        
        let newStudent = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context)
        
        newStudent.setValue(fullName, forKey: "fullName")
        newStudent.setValue(age, forKey: "age")
        
        do{
            try context.save()
            print("New Student added")
        }
        catch{
            print("Error: \(error)")
        }
    }

    // MARK: - Delete existed student
    func deleteStudent(fullName: String, age:Int16){
        let context = self.getContext()
        
        //fetch all Students
        let request : NSFetchRequest<Student> = Student.fetchRequest()
        
        //filters
        let predicate1 = NSPredicate(format: "fullName == %@", fullName)
        let predicate2 = NSPredicate(format: "age == %@", String(age))
        let andPrediacte = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        request.predicate = andPrediacte
        
        do{
            
            let students = try context.fetch(request)
            
            if students.count > 0 {
                for student in students as [Student]{
                    context.delete(student)
                    
                }
                try context.save()
            }
        }
        catch{
            print("Error: \(error)")
        }


    }
    
    // MARK: - Update existed student
    func updateStudent(fullNameOld: String, ageOld:Int, fullNameNew: String, ageNew:Int){
        let context = self.getContext()
        
        //fetch all Students
        let request : NSFetchRequest<Student> = Student.fetchRequest()
        
        //filters
        let predicate1 = NSPredicate(format: "fullName == %@", fullNameOld)
        let predicate2 = NSPredicate(format: "age == %@", String(ageOld))
        let andPrediacte = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        request.predicate = andPrediacte
        do{
            
            let students = try context.fetch(request)
            
            if students.count > 0 {
                for student in students as [Student]{
                    student.setValue(fullNameNew, forKey: "fullName")
                    student.setValue(ageNew, forKey: "age")
                }
                try context.save()
            }
        }
        catch{
            print("Error: \(error)")
        }
        
        
    }
    
}
