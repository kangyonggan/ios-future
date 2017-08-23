//
//  DictionaryDao.swift
//  future
//
//  Created by kangyonggan on 8/9/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import CoreData

class DictionaryDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    let entityName = "TDictionary";
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 保存字典
    func save(dictionary: Dictionary) {
        let newDictionary = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
        
        newDictionary.setValue(dictionary.type, forKey: "type");
        newDictionary.setValue(dictionary.key, forKey: "key");
        newDictionary.setValue(dictionary.value, forKey: "value");
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError();
        }
    }
    
    // 删除字典
    func delete(type: String, key: String) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "type=%@ AND key=%@", type, key);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                managedObjectContext.delete(row);
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
    
    // 查找某类型的所有字典
    func findDictionariesBy(type: String) -> [Dictionary] {
        var dictionaries = [Dictionary]();
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "type=%@", type);
            request.predicate = predicate;
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let dict = Dictionary();
                dict.type = (row.value(forKey: "type") as? String)!;
                dict.key = (row.value(forKey: "key") as? String)!;
                dict.value = (row.value(forKey: "value") as? String)!;
                
                dictionaries.append(dict);
            }
        }catch{
            fatalError();
        }
        
        return dictionaries;
    }
    
    // 根据类型和关键字查找字典
    func findDictionaryBy(type: String, key: String) -> Dictionary? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "type=%@ AND key=%@", type, key);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let dict = Dictionary();
            for row in rows {
                dict.type = (row.value(forKey: "type") as? String)!;
                dict.key = (row.value(forKey: "key") as? String)!;
                dict.value = (row.value(forKey: "value") as? String)!;
                
                return dict;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
}

