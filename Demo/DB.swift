//
//  DB.swift
//  Demo
//
//  Created by tingyang on 2022/5/30.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Song: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let singer: String
    let rate: Int
}

func createSong() {
        let db = Firestore.firestore()
        
        let song = Song(name: "陪你很久很久", singer: "小球", rate: 5)
        do {
            let documentReference = try db.collection("songs").addDocument(from: song)
            print(documentReference.documentID)
        } catch {
            print(error)
        }
}

