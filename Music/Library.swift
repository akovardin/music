//
//  Library.swift
//  Music
//
//  Created by Artem Kovardin on 13/11/2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack (spacing: 20) {
                        Button(action: {
                            print("1234")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(#colorLiteral(red: 0.994628489, green: 0.1682385504, blue: 0.3304626942, alpha: 1)))
                                .background(Color(#colorLiteral(red: 0.9625768065, green: 0.9524751306, blue: 0.9698902965, alpha: 1)))
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            print("1234")
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(#colorLiteral(red: 0.994628489, green: 0.1682385504, blue: 0.3304626942, alpha: 1)))
                                .background(Color(#colorLiteral(red: 0.9625768065, green: 0.9524751306, blue: 0.9698902965, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                
                Divider().padding(.leading).padding(.trailing)
                Spacer()
                List {
                   Cell()
                }
            }
                
            .navigationBarTitle("Library")
        }
    }
}

struct Cell: View {
    var body: some View {
        HStack {
            Image("Image").resizable().frame(width: 60, height: 60).cornerRadius(2)
            VStack {
                Text("Track Name")
                Text("Artist Name")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
