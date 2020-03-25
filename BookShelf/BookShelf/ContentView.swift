//
//  ContentView.swift
//  bookshelf
//
//  Created by ChelseaAnne Castelli on 3/24/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct ContentView: View {
    
    init() {
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font : UIFont(name:"Charter", size: 40)!
        ]
        
    }
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        VStack {
        
            if status {
                
                NavigationView {
                    
                    Home()
                        .navigationBarTitle("bookshelf.")
                
                }
                
            } else {
                
                Login()
            }
            
        }.animation(.spring())
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                    
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    self.status = status
                    
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Login: View {
    
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    
    var body: some View {
        
        VStack{
            
            Text("bookshelf.").font(.custom("Charter", size: 40)).padding(.bottom, 40)
            
            //sign up
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Username", text: $user)
                            
                            if user != "" {
                                
                                Image("check").foregroundColor(Color.init(.label))
                                
                            }
    
                        }
                        
                        Divider()
                    
                }.padding(.bottom, 20)
                
                VStack(alignment: .leading){
                                
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                    SecureField("Enter Password", text: $pass)
                    
                    Divider()
                    
                }
                    
            }.padding(.horizontal, 6)
                
            Button(action: {
                
                signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified {
                        
                        self.msg = status
                        self.alert.toggle()
                        
                    } else {
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        
                    }
                    
                }
                                       
            }) {
                    
                Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width-120).padding()
                
            }.background(Color(.black))
            .clipShape(Capsule())
            .padding(.top, 45)
                
            bottomView()
                
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
                
        }
    }
}

struct bottomView: View {
    
    @State var show = false
    
    var body: some View {
        
        VStack{
            
            Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top, 20)
        
            GoogleSignView().frame(width: 150, height: 55)
            
            HStack(spacing: 8) {
                
                Text("Don't Have An Account?").foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    
                    self.show.toggle()
                    
                    
                }) {
                    
                    Text("Sign Up")
                    
                }.foregroundColor(.blue)
                
            }.padding(.top, 20)
            
        }.sheet(isPresented: $show) {
            
            SignUp(show: self.$show)
            
        }
    }
}

struct SignUp: View {
    
    @State var user = ""
    @State var pass = ""
    @State var alert = false
    @State var msg = ""
    @Binding var show: Bool
    
    var body: some View {
        
        VStack {
            
            Text("bookshelf.").font(.custom("Charter", size: 40)).padding(.bottom, 40)
                       
            //sign up

            VStack(alignment: .leading){
               
               VStack(alignment: .leading){
                   Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                       
                       HStack{
                           
                           TextField("Enter Username", text: $user)
                           
                           if user != "" {
                               
                               Image("check").foregroundColor(Color.init(.label))
                               
                           }

                       }
                       
                       Divider()
                   
               }.padding(.bottom, 20)
               
               VStack(alignment: .leading){
                               
                   Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                           
                   SecureField("Enter Password", text: $pass)
                   
                   Divider()
                   
               }
                   
            }.padding(.horizontal, 6)
               
            Button(action: {
               
                signUpWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified {
                        
                        self.msg = status
                        self.alert.toggle()
                        
                    } else {
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        self.show.toggle()
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        
                    }
                    
                }
                                      
            }) {
                   
               Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width-120).padding()
               
            }.background(Color(.black))
            .clipShape(Capsule())
            .padding(.top, 45)
            
        }.padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        
    }
    
}


struct GoogleSignView : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
        
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {
        
    }
}

func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
        
        if err != nil {
            completion(false, (err?.localizedDescription)!)
            return
        }
        
        completion(true, (res?.user.email)!)
    }
}


func signUpWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    
    Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
        if err != nil {
            completion(false, (err?.localizedDescription)!)
            return
        }
               
        completion(true, (res?.user.email)!)
    }
}


struct Home: View {
    
    @ObservedObject var Books = getData()
    @State var show = false
    @State var url = ""
    
    var body: some View {
        
        VStack {
            
            List(Books.data) { i in
                
                HStack {
                    
                    if i.imurl != "" {
                    
                        WebImage(url: URL(string: i.imurl)!).resizable().frame(width: 120, height: 170).cornerRadius(10)
                    
                    } else {
                        
                        Image("books").resizable().frame(width: 120, height: 170).cornerRadius(10)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(i.title).fontWeight(.bold)
                        Text(i.authors)
                        Text(i.desc).font(.caption).lineLimit(4)
                            .multilineTextAlignment(.leading)
                        
                    }
        
                }
                .onTapGesture {
                    
                    self.url = i.url
                    self.show.toggle()
                    
                }
                
            }.sheet(isPresented: self.$show) {
                
                WebView(url: self.url)
                
            }
            
            Button(action: {
                
                try! Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                
            }) {
                
                Text("Logout").padding([.top,.bottom], 10)
                
            }
        }
    }
}

class getData: ObservableObject {
    
    @Published var data = [Book]()
    
    init() {
        
        let url = "https://www.googleapis.com/books/v1/volumes?q=computer+science"
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
                
            }
            
            let json = try! JSON(data: data!)
            let items = json["items"].array!
            
            for i in items {
                
                let id = i["id"].stringValue
                let title = i["volumeInfo"]["title"].stringValue
                
                let authors = i["volumeInfo"]["authors"].array!
                var author = ""
                
                for a in authors {
                    
                    author += "\(a.stringValue)"
                    
                }
                
                let description = i["volumeInfo"]["description"].stringValue
                let imurl = i["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
                let url1 = i["volumeInfo"]["previewLink"].stringValue
                
                DispatchQueue.main.async {
                    
                    self.data.append(Book(id: id, title: title, authors: author, desc: description, imurl: imurl, url: url1))
                    
                }
                
            }
            
        }.resume()
        
    }
    
    
}

struct Book: Identifiable {
    
    var id, title, authors, desc, imurl, url: String
    
}

struct WebView: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
        
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
        
        
    }
    
}
