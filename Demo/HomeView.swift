//
//  HomeView.swift
//  Demo
//
//  Created by tingyang on 2022/5/31.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore


struct HomeView: View{
    @Binding var User:Int
    @Binding var email: String
    
    @State var name = ""
    @State var gender = ""
    @State var joinTime = ""
    @State var money = 0
    @State var image = ""
    
    func fetchData(email: String){
        let db = Firestore.firestore()
        db.collection("datas").whereField("email", isEqualTo: "\(email)").getDocuments { snapshot, error in

            snapshot!.documents.forEach { snapshot in
                name = snapshot.data()["name"] as! String
                joinTime = snapshot.data()["joinTime"] as! String
                gender = snapshot.data()["gender"] as! String
                money = snapshot.data()["money"] as! Int
                image = snapshot.data()["image"] as! String
            }
        }
    }
    
    var body: some View{
       
        NavigationView{
            VStack{
                List{
                    Image("\(image)")
                        .resizable()
                        .frame(width: 200, height: 300)
                        .scaledToFill()
                    Text("玩家暱稱 : \(name)")
                    Text("性別 : \(gender)")
                    Text("E-mail : \(email)")
                    Text("資產 : \(money)")
                    Text("加入時間 : \(joinTime)")
                }
                .onAppear{
                    fetchData(email: "\(email)")
                }
                Button{
                    do {
                        try Auth.auth().signOut()
                    } catch {
                    }
                    User = 0
                } label: {
                    Text("Log Out")
                        .frame(alignment: .topTrailing)
                }
            }
            
            
        }
    }
}


