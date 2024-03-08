//
//  TaskB.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Baris Karalar on 08.03.24.
//

import SwiftUI

class TaskBViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var image2: UIImage?
    
    func fetchImage() async {
        try? await Task.sleep(for: .seconds(5))
        do {
            guard let url = URL(string: "https://picsum.photos/2000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("DEBUG: Image returned successfully")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/2000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBHomeView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Click me") {
                TaskB()
            }
        }
    }
}

struct TaskB: View {
    
    @StateObject private var vm = TaskBViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image2 = vm.image2 {
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await vm.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            self.fetchImageTask = Task {
////                print(Thread())
//                await vm.fetchImage()
//            }
//            Task {
//                print(Thread())
//                await vm.fetchImage2()
//            }
//        }
    }
}

#Preview {
    TaskB()
}
