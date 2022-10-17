//
//  UserDefaultManager.swift
//  LearningTab
//
//  Created by Durgesh on 10/13/22.
//

import Foundation

class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    func getNotesList() -> [NoteItem] {
        
        var notesItems: [NoteItem] = []
        guard let data = UserDefaults.standard.data(forKey: "notes") else { return notesItems }
        if let list = try? JSONDecoder().decode([NoteItem].self, from: data) {
            notesItems = list
        }
        return notesItems
    }
    
    func saveNotes(key: String, checklist: Checklist, completion: ((Bool) -> ())?) {
        do {
            let data = try JSONEncoder().encode(checklist)
            UserDefaults.standard.set(data, forKey: key)
            completion?(true)
        } catch {
            print("Unable to Encode user (\(error))")
            completion?(false)
        }
    }
    func getExerciseList(id: String) -> Checklist? {
        if let data = UserDefaults.standard.data(forKey: id) {
            do {
                let exerciseList = try JSONDecoder().decode(Checklist.self, from: data)
                return exerciseList
            } catch {
                print("Unable to Found user (\(error))")
            }
        }
        return nil
    }
}
