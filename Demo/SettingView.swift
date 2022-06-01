//
//  SettingView.swift
//  Demo
//
//  Created by tingyang on 2022/5/31.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

struct Data: Codable, Identifiable{
    @DocumentID var id: String?
    let name: String
    let joinTime: String
    let gender: String
    let email: String
    let money: Int
    let image: String
    
}
struct SettingView: View{
    @Binding var User:Int
    @Binding var email:String
    @State private var name = ""
    @State private var joinTime = Date()
    let genders = ["男","女"]
    let hairs = ["捲毛", "三根毛","長髮","短髮"]
    let glasses = ["不戴眼鏡","戴眼鏡"]
    @State private var GenderselectedIndex = 0
    @State private var HairselectedIndex = 0
    @State private var GlassSelectedIndex = 0
    @State private var feeling: Double = 1
    @State private var image = ""
    
    func create() {
        let db = Firestore.firestore()
        if(genders[GenderselectedIndex] == "男"){
            image =  "\(GenderselectedIndex)\(HairselectedIndex)\(GlassSelectedIndex)\(Int(feeling))"
        }
        else{
            image = "\(GenderselectedIndex)\(HairselectedIndex+2)\(GlassSelectedIndex)\(Int(feeling))"
        }
        let data = Data(name:"\(name)",joinTime:"\(joinTime)",gender:"\(genders[GenderselectedIndex])", email: "\(email)", money: 1000, image: "\(image)" )
        do {
            let documentReference = try db.collection("datas").addDocument(from: data)
                print(documentReference.documentID)
        } catch {
            print(error)
        }
    }
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
            
            let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
            if let data = image.jpegData(compressionQuality: 0.9) {
                
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success(_):
                         fileReference.downloadURL(completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }
    func createImage(){
        var name = ""
        if(genders[GenderselectedIndex] == "男"){
            name =  "\(GenderselectedIndex)\(HairselectedIndex)\(GlassSelectedIndex)\(Int(feeling))"
        }
        else{
            name = "\(GenderselectedIndex)\(HairselectedIndex+2)\(GlassSelectedIndex)\(Int(feeling))"
        }
        print(name)
        let uiImage = UIImage(named: "\(name)")
        uploadPhoto(image: uiImage!) { result in
            switch result {
            case .success(let url):
               print(url)
            case .failure(let error):
               print(error)
            }
        }
    }
    
    var body: some View{
     
        
        Group{
            if(genders[GenderselectedIndex] == "男"){
                Image("\(GenderselectedIndex)\(HairselectedIndex)\(GlassSelectedIndex)\(Int(feeling))")
                    .resizable()
                    .frame(width: 300, height: 500)
                    .scaledToFill()
            }
            else{
                
                Image("\(GenderselectedIndex)\(HairselectedIndex+2)\(GlassSelectedIndex)\(Int(feeling))")
                    .resizable()
                    .frame(width: 300, height: 500)
                    .scaledToFill()
            }
           
            
            HStack{
                Text("姓名：")
                TextField("姓名", text: $name)
            }
            
            DatePicker("加入時間", selection: $joinTime,displayedComponents: .date)
            
            
            HStack{
                Text("性別：")
                Picker(selection: $GenderselectedIndex) {
                    ForEach(genders.indices) { item in
                        Text(genders[item])
                    }
                } label: {
                    Text("選擇性別")
                }
                .pickerStyle(.segmented)
            }
            HStack{
                Text("髮型：")
                Picker(selection: $HairselectedIndex) {
                    if(GenderselectedIndex == 0){
                        ForEach(0..<2){ index in
                            Text(hairs[index])
                        }
                    }
                    else{
                        ForEach(2..<4){ index in
                            Text(hairs[index])
                        }
                    }
                } label: {
                    Text("選擇髮型")
                }
                .pickerStyle(.segmented)
            }
            
            HStack{
                Text("眼鏡：")
                Picker(selection: $GlassSelectedIndex) {
                    ForEach(glasses.indices){ index in
                        Text(glasses[index])
                        
                    }
                } label: {
                    Text("選擇眼鏡")
                }
                .pickerStyle(.segmented)
            }
            
            
            VStack{
                Text("心情：")
                HStack{
                    Text("😡")
                    Slider(value: $feeling, in: 0...2,step: 1)
                    Text("😄")
                }
            }
            Button{
                create()
                createImage()
                User = 0
            }label: {
                Text("Save")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.orange)
                    .italic()
            }
            .background(.blue)
            
        }
        
        
    }
}
