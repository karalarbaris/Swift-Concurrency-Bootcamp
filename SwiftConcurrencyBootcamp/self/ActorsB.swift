//
//  ActorsB.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Baris Karalar on 27.05.24.
//

import SwiftUI

actor MyActorDataManagerB {
    static let instance = MyActorDataManagerB()
    private init() {}
    
    var data: [String] = []
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
}

struct HomeViewB: View {
    
    let manager = MyActorDataManagerB.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
            Task {
                if let data = await manager.getRandomData() {
                    self.text = data
                }
            }
        })
    }
}

struct BrowseViewB: View {
    
    let manager = MyActorDataManagerB.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
            Task {
                if let data = await manager.getRandomData() {
                    self.text = data
                }
            }
        })
    }
}

struct ActorsB: View {
    var body: some View {
        TabView {
            HomeViewB()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseViewB()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsB()
}
