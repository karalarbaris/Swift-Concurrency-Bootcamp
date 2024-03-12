//
//  TaskGroupB.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Baris Karalar on 12.03.24.
//

import SwiftUI

class TaskGroupBDataManager {

    let urlString = "https://picsum.photos/300"
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: urlString)
        async let fetchImage2 = fetchImage(urlString: urlString)
        async let fetchImage3 = fetchImage(urlString: urlString)
        async let fetchImage4 = fetchImage(urlString: urlString)
        
        let (img1, img2, img3, img4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        return [img1, img2, img3, img4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        
        let urlStrings = [
        "https://picsum.photos/300",
        "https://picsum.photos/300",
        "https://picsum.photos/300",
        "https://picsum.photos/300"
        ]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            // Optional, for performance improvement
            images.reserveCapacity(urlStrings.count)
            
            for urlStr in urlStrings {
                group.addTask {
                    try? await self.fetchImage(urlString: urlStr)
                }
            }
            
            // Does the same thing
//            group.addTask {
//                try await self.fetchImage(urlString: self.urlString)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: self.urlString)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: self.urlString)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: self.urlString)
//            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch  {
            throw error
        }
    }
}

class TaskGroupBViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupBDataManager()
    
    func getImages() async {
//        if let images = try? await manager.fetchImagesWithAsyncLet() {
//            self.images.append(contentsOf: images)
//        }
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroupB: View {
    
    @StateObject private var vm = TaskGroupBViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group 🥳")
        }
        .task {
            await vm.getImages()
        }
    }
}

#Preview {
    TaskGroupB()
}
