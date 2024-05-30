//
//  MVVMB.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Baris Karalar on 29.05.24.
//

import SwiftUI

final class MyManagerClassB {
    
    func getData() async throws -> String {
        "Some data"
    }
}

actor MyManagerActorB {
    
    func getData() async throws -> String {
        "Some data"
    }
}

@MainActor
final class MVVMBViewModel: ObservableObject {
    
    let managerClass = MyManagerClassB()
    let managerActor = MyManagerActorB()
    
    @Published private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        
        let task = Task {
            do {
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()

            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

struct MVVMB: View {
    
    @StateObject var vm = MVVMBViewModel()
    
    var body: some View {
        VStack {
            Button("Click me") {
                vm.onCallToActionButtonPressed()
            }
        }
        .onDisappear {
            vm.cancelTasks()
        }
    }
}

#Preview {
    MVVMB()
}
