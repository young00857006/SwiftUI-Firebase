//
//  ContentView.swift
//  Demo
//
//  Created by tingyang on 2022/5/30.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth



struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var User = 0
    
    func sign(){
        Auth.auth().signIn(withEmail: "\(email)", password: "\(password)") { result, error in
             guard error == nil else {
                print(error?.localizedDescription)
                return
             }
        }
        Auth.auth().addStateDidChangeListener { auth, user in
           if let user = user {
               print("\(user.uid) login")
               User = 1
           } else {
               print("not login")
               User = 0
           }
        }
    }
    
    func createAccount(email: String, password: String){
        Auth.auth().createUser(withEmail: "\(email)", password: "\(password)") { result, error in
                    
             guard let user = result?.user,
                   error == nil else {
                 print(error?.localizedDescription)
                 return
             }
             print(user.email, user.uid)
        }
        Auth.auth().addStateDidChangeListener { auth, user in
           if let user = user {
               User = 2
               print("\(user.uid) login")
           } else {
               User = 0
               print("not login")
           }
        }
    }
        
    var body: some View {
        
        if(User == 0){
            Form {
                TextField("E-mail", text: $email)
                TextField("Password", text: $password)
                
               
                    Button("Sign In"){
                        sign()
                    }
                    
                    Button("Register"){
                        createAccount(email: email, password: password)
                    }
                
            }
        }
        else if(User == 1){
//            HomeView(User: $User,email: $email)
            HomeView(User: $User,email: $email)
        }
        else if(User == 2){
            SettingView(User: $User, email: $email)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

