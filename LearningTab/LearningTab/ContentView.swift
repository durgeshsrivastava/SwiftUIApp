//
//  ContentView.swift
//  LearningTab
//
//  Created by Durgesh on 10/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var items: [NoteItem] = {
        guard let data = UserDefaults.standard.data(forKey: "notes") else { return [] }
        if let json = try? JSONDecoder().decode([NoteItem].self, from: data) {
            return json
        }
        return []
    }()
    
    @State private var selection = 0
    @State var isUnlocked = false
    
    
    var body: some View {
        VStack {
            if isUnlocked {
                

        TabView(selection: $selection) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            SearchList()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            //            PhotosView()
            //                .tabItem {
            //                    Image(systemName: "photo.fill")
            //                    Text("Photos")
            //                }
            //                .tag(2)
            
            ListView()
                .tabItem {
                    Image(systemName: "list.star")
                    Text("List")
                }
                .tag(3)
            
            ProfileView(selection: {
                selection = (selection + 4) % 5
            })
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
            .tag(4)
            
        } //TabView
        .accentColor(.blue) //Active tab color
        
            }
        }
        .onAppear{
            Authentication().authenticate { success in
                isUnlocked = success
            }
        }
    } //body
    
    init() {
        //Set tab bar appearance
        UITabBar.appearance().barTintColor = UIColor.systemBlue //Tab bar color
        UITabBar.appearance().backgroundColor = UIColor.white //Tab bar color
        UITabBar.appearance().unselectedItemTintColor = UIColor.black //Tab item color when not selected
        UITabBar.appearance().isOpaque = false
    }
    
} //ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView: View { // HOME SCREEN
    
    @State private var half = false
    @State private var dim = false
    @State var message = ""
    @State var items: [NoteItem] = []
    @State private var presentAlert = false
    @State private var textFeildInput: String = ""
    @State private var password: String = ""
    @State private var isPresented: Bool = false
    @State private var text: String = ""
    @State private var itemsss = (1...5).map { "\($0)" }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: 5) {
                //NavigationLink {
                    // PopUpView(message: $message).environmentObject(ChecklistDocument())
                    // Trying Alert mechanism
                    Button {
                        presentAlert = true
                    } label: {
                        Image("IconWrite1")
                            .imageScale(.large)
                            .scaleEffect(0.15)
                            .position(x:200, y:60)
                    } // label
/* FUNCTIONING CODE - do not delete
                    .alert("Appreciate Yourself", isPresented: $presentAlert, actions: {
                       TextField("", text: $textFeildInput)
                        Button("Add", action: {handleAddButtonClick()})
                            .foregroundColor(.red)
                        Button("Cancel", role: .cancel, action: {})
                    }, message: {
                        Text("Enter what you like about yourself!")
                    } //message

                    ) //alert
*/
                //Button(action: { presentAlert = true }) {
                //    Text("Press")
                //}
 //Trying Custom Alert - didn't work. Need help from Ajay.
                    CustomAlert(title: "Add Item", isShown: $presentAlert, text: $textFeildInput, onDone: { text in
                        //self.text = text
                        handleAddButtonClick()
                        //self.itemsss.append(text)
                        }
                    )

                // DS: Adding GlassJar Image and positioning it
                Spacer()
                ZStack {
                    Image("GlassJar")
                        .resizable()
                    //Define which method to use to keep the original dimensions when resizing
                        .aspectRatio(contentMode: .fit)
                    //Declare the frame for your image
                        .frame(width: 250, height: 300)
                    
                        .foregroundColor(.accentColor)
                    Text("\(items.count)")
                        .font(.system(size: 40))
                        .offset(y: -60)
                        .foregroundColor(.red)
                    //let _ = print(items.count)
                    ForEach(0..<items.count, id:\.self) { i in
                        Image("Paper")
                            .font(.system(size: 30))
                            .offset(y: CGFloat(90-20*i/3))
                            .foregroundColor(.yellow)
                    } //ForEach
                } // ZStack
                Spacer()
                Text("Total messages = \(items.count)")
                // .rotationEffect(.radians(0))
                // .scaleEffect(0.6)
                //.position(x: 200, y: 130)
            }.padding(.bottom, 20) //Vstack - padding creates space from all directions
                .onAppear {
                    items = UserDefaultManager.shared.getNotesList()
                }
            
                .navigationBarTitle(Text("Self Appreciation Jar"))
                .navigationBarTitleDisplayMode(.large)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(
                    Color.pink,
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            
            ////        .navigationBarTitleDisplayMode(.inline)
            ////        .navigationBarItems(leading: Text("Lead"), trailing: Text("Trail")) // Testing Navigation bar
            //        .background(Color.blue) // Helps to check the VStack
        } // NavigationView
    } //body
    
    func handleAddButtonClick() {
        if !textFeildInput.isEmpty {
            items.append(NoteItem(id: UUID().uuidString, text: textFeildInput))
            UserDefaultManager.save(notes: items)
            textFeildInput = ""
        }
    }
    
} //HomeView


struct CustomAlert: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    
    var body: some View {
    
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            Text("Message")
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 20) {
                Button("Done") {
                    self.isShown = false
                    self.onDone(self.text)
                }
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.3)
        //.background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .background(Color.pink)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        //.animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)

    }
} // AZAlert

struct ListView: View {
    
    private var imageList = [
        "hare.fill",
        "tortoise.fill",
        "pawprint.fill",
        "ant.fill",
        "ladybug.fill"
    ]
    @State private var textField: String = "Tap the airplane to make it move!"
    @State var moveOnCircularPath: Bool = false
    @State var message = ""
    
    var body: some View {
        NavigationView {
            PopUpView(message: $message).environmentObject(ChecklistDocument())
        }
//        ZStack {
//            Text(textField)
//            Circle()
//                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: CGLineCap.round, dash: [8]))
//                .frame(width: 300, height: 300)
//                .foregroundColor(.purple)
//
//            Image(systemName: "airplane")
//                .font(.largeTitle)
//                .foregroundColor(.red)
//                .offset(y: -150)
//                .rotationEffect(.degrees(moveOnCircularPath ? 0 : -360))
//                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: moveOnCircularPath)
//            //.animation(.easeIn(duration: 5.0).repeatForever(autoreverses: false), value: show)
//                .onTapGesture {
//                    self.moveOnCircularPath.toggle()
//                    self.textField = ""
//                } //onTapGesture
//        }
        //ScrollView(showsIndicators: false) {
        //    ForEach(imageList, id: \.self) { index in
        //        Image(systemName: "\(index)")
        //            .font(.system(size: 150))
        //            .padding()
        //    }
        //}
        
    } //body
    
} //MessageView



struct ProfileView: View {
    
    @State private var bounceBall: Bool = false
    @State private var hiddenText: String = "Kick the ball!"
    
    var selection: () -> Void
    
    var body: some View {
        
        VStack {
            
            Image("Ball")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
            //.border(Color.pink)
                .clipped()
                .clipShape(Circle())
                .offset(y: bounceBall ? -40 : 0)
                .animation(Animation.interpolatingSpring(stiffness: 90, damping: 1.5).repeatForever(autoreverses: false), value: bounceBall)
                .onTapGesture {
                    self.bounceBall.toggle()
                    self.hiddenText = ""
                }
                .font(.system(size: 100))
                .padding()
            
            Button(action: selection) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 50))
            }
            .padding()
            
        } //ZStack
        
    } //body
    
} //ProfileView
