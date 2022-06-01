//
//  SignIn.swift
//  Demo
//
//  Created by tingyang on 2022/5/30.
//

import SwiftUI
import FirebaseAuth

func createAccount(email: String, password: String){
    Auth.auth().createUser(withEmail: "peter@neverland.com", password: "123456") { result, error in
                
         guard let user = result?.user,
               error == nil else {
             print(error?.localizedDescription)
             return
         }
         print(user.email, user.uid)
    }
    Auth.auth().addStateDidChangeListener { auth, user in
       if let user = user {
           print("\(user.uid) login")
       } else {
           print("not login")
       }
    }
}

func sign(){
    Auth.auth().signIn(withEmail: "peter@neverland.com", password: "123456") { result, error in
         guard error == nil else {
            print(error?.localizedDescription)
            return
         }
    }
    Auth.auth().addStateDidChangeListener { auth, user in
       if let user = user {
           print("\(user.uid) login")
       } else {
           print("not login")
       }
    }
}

func logout(){
    do {
       try Auth.auth().signOut()
    } catch {
       print(error)
    }
    Auth.auth().addStateDidChangeListener { auth, user in
       if let user = user {
           print("\(user.uid) login")
       } else {
           print("not login")
       }
    }
}

struct SignIn:View{
    
    var body: some View{
        Button("register"){
            createAccount(email: "i", password: "u")
        }
        
        Button("sign In"){
            sign()
        }
        
        Button("log out"){
            logout()
        }
        
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
