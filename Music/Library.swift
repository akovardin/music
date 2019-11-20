//
//  Library.swift
//  Music
//
//  Created by Artem Kovardin on 13/11/2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    var trackDetailAnimateDelegate: TrackAnimateDelegate?
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack (spacing: 20) {
                        Button(action: {
                            self.track = self.tracks[0]
                            self.trackDetailAnimateDelegate?.maximizeTrackDetail(model: self.track)
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(#colorLiteral(red: 0.994628489, green: 0.1682385504, blue: 0.3304626942, alpha: 1)))
                                .background(Color(#colorLiteral(red: 0.9625768065, green: 0.9524751306, blue: 0.9698902965, alpha: 1)))
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
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
                    ForEach(tracks) { track in
                        Cell(cell: track)
                            .gesture(LongPressGesture().onEnded({ _ in
                                self.showingAlert = true
                                self.track = track
                            })
                                .simultaneously(with: TapGesture().onEnded({ _ in
                                    self.track = track
                                    self.trackDetailAnimateDelegate?.maximizeTrackDetail(model: self.track)
                                })))
                    }.onDelete(perform: delete)
                }
            }
            .actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(
                    title: Text("Are you sure u want to delete this track?"),
                    buttons: [.destructive(Text("Delete"), action: {
                        self.delete(track: self.track)
                    }), .cancel()]
                )
            })
                .navigationBarTitle("Library")
        }
    }
    
    func delete(ar offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            UserDefaults.standard.set(savedData, forKey: UserDefaults.favouritesTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        guard let index = tracks.firstIndex(of: track) else {return}
        tracks.remove(at: index)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            UserDefaults.standard.set(savedData, forKey: UserDefaults.favouritesTrackKey)
        }
    }
}

struct Cell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!,
                     content: {
                        $0.image
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(2)                // Make it resizable
            })
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
