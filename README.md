[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FNimer-88%2FSwiftBuildableMacro%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Nimer-88/SwiftBuildableMacro)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FNimer-88%2FSwiftBuildableMacro%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Nimer-88/SwiftBuildableMacro)

# `@Buildable` Swift Macro
`@Buildable` is an attached swift macro for structs and classes, which produces a peer class implementing the builder pattern. Based on [SwiftBuildableMacro](https://github.com/alschmut/SwiftBuildableMacro) by [Alexander Schmutz](https://github.com/alschmut).
```swift
import Buildable

@Buildable
struct Person {
    let name: String
    let age: Int
    let photoURL: URL?
}

let charles = PersonBuilder(name:"Charles", age: 42).build()
let newCharles = PersonBuilder(from: charles)
                    .with(photoURL: URL(string: "https://picsum.photos/200"))
                    .build()
```

> **Important!**
    <br>- The repo started as a clone of [SwiftBuildableMacro](https://github.com/alschmut/SwiftBuildableMacro) authored by [Alexander Schmutz](https://github.com/alschmut) which I've heavily edited to fit my own needs. I never met Alexander, but I would like to express my thanks to him for providing such a great learning material and a starting point under MIT license. Kudos!
    <br>- This repo is licensed under MIT license with no advertisement clause and no AI training clause. Use of this software for the purpose of any machine learning algorithms is strictly forbidden.
    <br>- This macro is intended to be used for simple structs and classes, preferably immutable (see below limitations)
    <br>- Please report any issues you might encounter
    <br>- Please star this repository, if your project makes use of it :)

### Table of Contents
- [Detailed Example with generated builder](#Detailed-Example-with-generated-builder)
- [Installation](#Installation)
- [Motivation](#Motivation)
- [Limitations](#Limitations)
- [Builder default values](#Builder-default-values)
- [Roadmap](#Roadmap)

## Detailed Example with generated builder
```swift
import Buildable

@Buildable
struct Person {
    let name: String
    let age: Int
    let photoURL: URL?
}

```
Expanded macro
```swift
final class PersonBuilder {
    private var name: String
    private var age: Int
    private var photoURL: URL?

    init(name: String, age: Int, photoURL: URL? = nil) {
        self.name = name
        self.age = age
        self.photoURL = photoURL
    }

    convenience init(from person: Person) {
        self.init(
            name: person.name,
            age: person.age,
            photoURL: person.photoURL
        )
    }

    @discardableResult func with(name: String) -> Self {
        self.name = name
        return self
    }

    @discardableResult func with(age: Int) -> Self {
        self.age = age
        return self
    }

    @discardableResult func with(photoURL: URL?) -> Self {
        self.photoURL = photoURL
        return self
    }

    public func build() -> Person {
        return Person(
            name: name,
            age: age,
            photoURL: photoURL
        )
    }
}
```

## Installation
The library can be installed using Swift Package Manager.


## Features
- The macro can be applied to `struct` and `class` definitions to generate a builder

## Limitations
- If a builder for a specific declaration can not be generated, you can always choose to create it yourself by following the below builder naming pattern:
    ```swift
    struct <MyType>Builder {

        func build() -> <MyType> {
            return ...
        }
    }
    ```
- If a class or a struct has one or more initializers, the macro will use the one with greatest amount of arguments required. If two initializers declare the same amount of parameters, the one declared first will be used. Convenienve initializers of classes are skipped from consideration
- As of Swift 6.2.0 and Xcode 26.0 (02.10.2025) it is not possible to use the generated builders inside the SwiftUI `#Preview` closure


## Roadmap

The `@Buildable` macro was created out of personal interest to reduce repetitive code in my own projects. I might continue developing the macro depending on use cases I stumble across, though, I do not guarantee to keep the project up to date myself. Please create GitHub issues for any feature or bugfix you would like to see within the macro. Contributions or fixes from the Community are most welcome.
