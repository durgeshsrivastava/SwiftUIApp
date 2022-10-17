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
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            Text("Search view")
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

            MessageView()
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
        
    } //body
    
    init() {
        //Set tab bar appearance
        UITabBar.appearance().barTintColor = UIColor.systemBlue //Tab bar color
        UITabBar.appearance().backgroundColor = UIColor.lightGray //Tab bar color
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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack (alignment: .leading, spacing: 5) {
                    NavigationLink {
                        PopUpView(message: $message).environmentObject(ChecklistDocument())
                    } label: {
                        Image("IconWrite1")
                            .imageScale(.large)
                            .scaleEffect(0.15)
                            .position(x:200, y:60)
                    }
                    // DS: Adding GlassJar Image and positioning it
                    Image("GlassJar")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .rotationEffect(.radians(0))
                        .scaleEffect(0.6)
                        .position(x: 200, y: 130)
                }.padding(.bottom, 20) //Vstack - padding creates space from all directions
                
            } // ZStack
            
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
    
} //HomeView
struct MessageView: View {
    
    private var imageList = [
        "hare.fill",
        "tortoise.fill",
        "pawprint.fill",
        "ant.fill",
        "ladybug.fill"
    ]
    @State private var textField: String = "Tap the airplane to make it move!"
    @State var moveOnCircularPath: Bool = false

    var body: some View {
        ZStack {
            Text(textField)
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: CGLineCap.round, dash: [8]))
                .frame(width: 300, height: 300)
                .foregroundColor(.purple)
            
            Image(systemName: "airplane")
                .font(.largeTitle)
                .foregroundColor(.red)
                .offset(y: -150)
                .rotationEffect(.degrees(moveOnCircularPath ? 0 : -360))
                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: moveOnCircularPath)
            //.animation(.easeIn(duration: 5.0).repeatForever(autoreverses: false), value: show)
                .onTapGesture {
                    self.moveOnCircularPath.toggle()
                    self.textField = ""
                } //onTapGesture
        }
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
