// Copyright © 2025 Alexander Schmutz
//
// MIT License (with no advertisement clause)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Except as contained in this notice, the name of Sebastian Matusik shall not
// be used in advertising or otherwise to promote the sale, use or other
// dealings in this Software without prior written authorization from
// Sebastian Matusik.
//
// NO GENERATIVE AI TRAINING USE.
//
// For avoidance of doubt, Sebastian Matusik reserves the rights, and any person
// obtaining a copy of this software and associated documentation files has no
// rights to, reproduce and/or otherwise use the Work in any manner for purposes
// of training artificial intelligence technologies to generate text, including
// without limitation, technologies that are capable of generating works in
// the same style or genre as the Work, unless such person obtains Sebastian
// Matusik’s specific and express permission to do so. Nor does any person
// obtaining a copy of this software and associated documentation files have
// the right to sublicense others to reproduce and/or otherwise use the Work in
// any manner for purposes of training artificial intelligence technologies to
// generate text without Sebastian Matusik’s specific and express permission.
//
// Created by Alexander Schmutz
// Modified by Sebastian Matusik
//

// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces a peer struct which implements the builder pattern
///
///     @Buildable
///     struct Person {
///         let name: String
///         let age: Int
///         let photoURL: URL?
///     }
///
///  will expand to
///
///     final class PersonBuilder {
///         private var name: String
///         private var age: Int
///         private var photoURL: URL?
///
///         init(name: String, age: Int, photoURL: URL? = nil) {
///             self.name = name
///             self.age = age
///             self.photoURL = photoURL
///         }
///
///         convenience init(_ person: Person) {
///             self.init(
///                 name: person.name,
///                 age: person.age,
///                 photoURL: person.photoURL
///             )
///         }
///
///         @discardableResult func set(name: String) -> Self {
///             self.name = name
///             return self
///         }
///
///         @discardableResult func set(age: Int) -> Self {
///             self.age = age
///             return self
///         }
///
///         @discardableResult func set(photoURL: URL?) -> Self {
///             self.photoURL = photoURL
///             return self
///         }
///
///         public func build() -> Person {
///             return Person(
///                 name: name,
///                 age: age,
///                 photoURL: photoURL
///             )
///         }
///     }
///
/// - Parameters:
///   - accessLevel: The access level (e.x. `.private`, `.public`, etc.), which the generated Builder will have. If you set the value to nil, the generated Builder has the same access level as the original struct/class to which the macro was applied to. The default value of this parameter is nil.
@attached(peer, names: suffixed(Builder))
public macro Buildable(accessLevel: AccessLevel? = nil) =
    #externalMacro(
        module: "BuildableMacro",
        type: "BuildableMacroType"
    )
