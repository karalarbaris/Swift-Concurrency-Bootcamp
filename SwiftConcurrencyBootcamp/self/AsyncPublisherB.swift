//
//  AsyncPublisherB.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Baris Karalar on 01.06.24.
//

import SwiftUI

actor AsyncPublisherBDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("apple")
        try? await Task.sleep(for: .seconds(2))
        myData.append("banana")
        try? await Task.sleep(for: .seconds(2))
        myData.append("orange")
        try? await Task.sleep(for: .seconds(2))
        myData.append("cherry")
    }
}

@MainActor
class AsyncPublisherBViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    let manager = AsyncPublisherBDataManager()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        Task {
            for await value in await manager.$myData.values {
                self.dataArray = value
            }
        }
//        await manager.$myData.values
    }
    
    func start() async {
        await manager.addData()
    }

}

struct AsyncPublisherB: View {
    
    @StateObject private var vm = AsyncPublisherBViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.start()
        }
    }
}

#Preview {
    AsyncPublisherB()
}
