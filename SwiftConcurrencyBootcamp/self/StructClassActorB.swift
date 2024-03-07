//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Nick Sarno on 3/31/22.
//

/*
 
 Links: 
 https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/
 https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
 https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
 https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
 https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
 https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
 https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
 https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
 
 VALUE TYPES:
 - Struct, Enum, String, Int, etc.
 - Stored in the Stack
 - Faster
 - Thread safe!
 - When you assign or pass value type a new copy of data is created
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Stored in the Heap
 - Slower, but synchronized
 - NOT Thread safe (by default)
 - When you assign or pass reference type a new reference to original instance will be created (pointer)
 
 - - - - - - - - - - - - - -
 
 STACK:
 - Stores Value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each thread has it's own stack!
 
 HEAP:
 - Stores Reference types
 - Shared across threads!
 
 - - - - - - - - - - - - - -
 
STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the Stack!
 
CLASS:
 - Based on REFERENCES (INSTANCES)
 - Stored in the Heap!
 - Inherit from other classes
 
ACTOR:
 - Same as Class, but thread safe!
 
 - - - - - - - - - - - - - -
 
Structs: Data Models, Views
Classes: ViewModels
Actors: Shared 'Manager' and 'Data Stores'

 */



import SwiftUI

struct StructClassActorB: View {
    

    var body: some View {
        Text("Hello, World!")
            .onAppear {
                runTest()
            }
    }
}

struct StructClassActorB_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorB()
    }
}

extension StructClassActorB {
    
    private func runTest() {
        print("Test started!")
        structTest1()
        printDivider()
        classTest1()
        
//        structTest2()
//        printDivider()
//        classTest2()
        
    }
    
    private func printDivider() {
        print("""
        
         - - - - - - - - - - - - - - - - -
        
        """)
    }
    
    private func structTest1() {
        print("structTest1")
        let objectA = MyStructB(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the VALUES of objectA to objectB.")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func classTest1() {
        print("classTest1")
        let objectA = MyClassB(title: "Starting title!")
        print("ObjectA: ", objectA.title)

        print("Pass the REFERENCE of objectA to objectB.")
        let objectB = objectA
        print("ObjectB: ", objectB.title)

        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
}


struct MyStructB {
    var title: String
}

// Immutable struct
struct CustomStructB {
    let title: String

    func updateTitle(newTitle: String) -> CustomStructB {
        CustomStructB(title: newTitle)
    }
}

struct MutatingStructB {
//    private(set) var title: String
//
//    init(title: String) {
//        self.title = title
//    }
//
//    mutating func updateTitle(newTitle: String) {
//        title = newTitle
//    }
    
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
    
    
}

extension StructClassActorB {
    
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        
        
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)

        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)

        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
    }
    
}

class MyClassB {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        self.title = newTitle
    }
    
}

actor MyActorB {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        self.title = newTitle
    }
    
}

extension StructClassActorB {
    
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClassB(title: "Title1")
        print("Class1: \(class1.title)")
        class1.title = "Title2"
        print("Class1: \(class1.title)")
        
        let class2 = MyClassB(title: "Title1")
        print("Class2: \(class2.title)")
        class2.updateTitle(newTitle: "Title2")
        print("Class2: \(class2.title)")
        
    }
}
