//
//  DataController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/19/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import CoreData



class DataController
{
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext
    {
        return persistentContainer.viewContext
    }
    
    init(modelName:String)
    {
        persistentContainer = NSPersistentContainer(name: "VirtualTourist")
    }
    
    func load(completion: (() -> Void)? = nil)
    {
        persistentContainer.loadPersistentStores
            { storeDescription, error in
                guard error == nil else
                {
                    fatalError(error!.localizedDescription)
                }
                self.autoSaveViewContext()
                completion?()
        }
    }
    
}


extension DataController
{
    func autoSaveViewContext(interval: TimeInterval = 90)
    {
        print ("autosaving")
        guard interval > 0 else
        {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges
        {
            try?viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval){
            self.autoSaveViewContext(interval: interval)
        }
    }
}