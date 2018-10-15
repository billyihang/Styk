//
//  File.swift
//  Styk
//
//  Created by William Yang on 8/17/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import Foundation

public class DataManager {
    
    //get document directory
    static fileprivate func getDocumentDirectory() -> URL
    {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
            
        } else {
            fatalError("Unable to access document directory")
        }
    }
    
    //save codable object
    static func save <T: Encodable> (_ object: T, with fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        do{
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path)
            {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    // load codable object
    static func load <T: Decodable> (_ fileName: String, with type: T.Type) -> T
    {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("File not found at path \(url.path)")
        }
        if let data = FileManager.default.contents(atPath: url.path){
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    
    // load data from file
    static func loadData (_ fileName: String) -> Data?
    {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("File not found at path \(url.path)")
        }
        if let data = FileManager.default.contents(atPath: url.path){
            return data
        } else {
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    // load all files from directory
    static func loadAll <T: Decodable> (_ type: T.Type) -> [T]
    {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            var modelObjects = [T]()
            
            for fileName in files
            {
                modelObjects.append(load(fileName, with: type))
            }
            
            return modelObjects
        } catch {
            fatalError("Could not load any files")
        }
    }
    // delete file
    static func delete(fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        if FileManager.default.fileExists(atPath: url.path)
        {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}




/*
public class DataManager {
    
    var dbRef: DatabaseReference?
    var user: User?
    
    init() {
        // TODO: - import user UID after auth
        dbRef = Database.database().reference().child("users").child(globalUserUid)
        
    }
    
    
    func startObservingDatabase() {
        dbRef?.observe(.value, with: { (snapshot: DataSnapshot) in
            
            var newProjects = [Project]()
            
            for item in snapshot.children {
                guard let item = item as? DataSnapshot
                    else {return}
                let itemKey = item.key
                if itemKey == "name" {
                    self.user?.name = item.value as? String
                } else if itemKey == "email" {
                    self.user?.email = item.value as? String
                } else if itemKey == "color" {
                    self.user?.color = item.value as? String
                } else if itemKey == "projects" {
                    let itemProject = item.value as? [String: Any ]
                }
            }
            
            
            var newSweets = [Sweet]()
            
            for sweet in snapshot.children {
                let sweetObject = Sweet(snapshot: sweet as! DataSnapshot)
                print(sweetObject.content)
                newSweets.append(sweetObject)
            }
            
            self.sweets = newSweets
            self.tableView.reloadData()
            
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
 
        })
 
    }
 
 
}
*/


/*
 var globalProjects: [Project]
 
 static func getProjects() -> [Project] {
 return globalProjects
 }
 
 mutating func addProject(_ project: Project) {
 globalProjects.append(project)
 }
 */
