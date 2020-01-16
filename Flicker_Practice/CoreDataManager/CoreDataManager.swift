//
//  CoreDataManager.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let share = CoreDataManager()
    private let queue = DispatchQueue(label: "CoreDataManager")
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var managedContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    private init() {}
    
    func createData(photoCellVM:PhotoCollectionCellViewModel){
        queue.async { [weak self] in
            guard let self = self else {return}
            let userEntity = NSEntityDescription.entity(forEntityName: "MyFavorite", in: self.managedContext)!
            let user = NSManagedObject(entity: userEntity, insertInto: self.managedContext)
            
            user.setValue(photoCellVM.searchKey, forKeyPath: "searchKey")
            user.setValue(photoCellVM.title, forKey: "title")
            user.setValue(photoCellVM.imageUrl, forKey: "imageUrl")
            user.setValue(photoCellVM.identifier, forKey: "identifier")
            
            do {
                try self.managedContext.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func retrieveData(then:@escaping (([NSManagedObject]?)-> Void)) {
        queue.async { [weak self] in
            guard let self = self else {return}
            var result:[NSManagedObject]? = []
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyFavorite")
            
            do {
                result = try self.managedContext.fetch(fetchRequest) as? [NSManagedObject]
            } catch {
                
                print("Failed")
            }
            
            then(result)
        }
    }
    
    func deleteData(id:UUID){
        queue.async { [weak self] in
            guard let self = self else {return}
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyFavorite")
            fetchRequest.predicate = NSPredicate(format: "identifier = %@", id.description)
            
            do
            {
                let test = try self.managedContext.fetch(fetchRequest)
                let objectToDelete = test[0] as! NSManagedObject
                self.managedContext.delete(objectToDelete)
                
                do{
                    try self.managedContext.save()
                }catch {
                    print(error)
                }
                
            }catch {
                print(error)
            }
        }
    }
}
