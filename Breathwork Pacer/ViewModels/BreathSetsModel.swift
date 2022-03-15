//
//  BreathSetsModel.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import Foundation
import CoreData

class BreathSetsModel: ObservableObject {
    
    private let storageProvider:StorageProvider
    private let viewContext:NSManagedObjectContext
    private var jsonBreathSets = [BreathSetJSON]()
    @Published private(set) var breathSets:[BreathSet]?
    
    init(storageProvider:StorageProvider = StorageProvider()) {
        
        self.storageProvider = storageProvider
        self.viewContext = self.storageProvider.persistentContainer.viewContext
        
        preloadData()
        fetchBreathSets()
    }
    
    func preloadData() {
        
        // Reset the store with preloaded data
        if false {
            
            func batchDeleteEntityName(_ entityName:String) {
            
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try PersistenceController.shared.container.persistentStoreCoordinator.execute(deleteRequest, with: viewContext)
                } catch {
                    print(error)
                }
            }
            
            batchDeleteEntityName("BreathSet")
            batchDeleteEntityName("BreathStep")
            
            UserDefaults.standard.setValue(false, forKey: Constants.dataIsPreloadedKey)
        }
        
        
        let status = UserDefaults.standard.bool(forKey: Constants.dataIsPreloadedKey)
       
        if !status {
            self.storageProvider.loadAndParseJSONOnSuccess {
                UserDefaults.standard.setValue(true, forKey: Constants.dataIsPreloadedKey)
                print("Successfully preloaded and saved data into core data store upon first run.")
                self.fetchBreathSets()
                print(self.breathSets!)
            }
        }
    }
    
    func fetchBreathSets() {

//      will need to change this. Move to the storage provider potentially.
        self.breathSets = self.storageProvider.breathSets
    }
    
    
}