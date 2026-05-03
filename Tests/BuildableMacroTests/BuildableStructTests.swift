// Copyright © 2025 Sebastian Matusik
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
// Created by Sebastian Matusik
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosGenericTestSupport
import Testing

@Test func test_should_create_builder_with_one_string_member() {
    assertMacroExpansion(
        """
        @Buildable
        struct Person {
            let name: String
        }
        """,
        expandedSource: """

            struct Person {
                let name: String
            }

            final class PersonBuilder {
                private var name: String

                init(
                    name: String
                ) {
                    self.name = name
                }

                convenience init(_ person: Person) {
                    self.init(
                        name: person.name
                    )
                }

                @discardableResult func with(name: String) -> Self {
                    self.name = name
                    return self
                }

                func build() -> Person {
                    return Person(
                        name: name
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_create_builder_with_two_string_members() {
    assertMacroExpansion(
        """
        @Buildable
        struct Person {
            let name: String
            let middleName: String
        }
        """,
        expandedSource: """

            struct Person {
                let name: String
                let middleName: String
            }

            final class PersonBuilder {
                private var name: String
                private var middleName: String

                init(
                    name: String,
                    middleName: String
                ) {
                    self.name = name
                    self.middleName = middleName
                }

                convenience init(_ person: Person) {
                    self.init(
                        name: person.name,
                        middleName: person.middleName
                    )
                }

                @discardableResult func with(name: String) -> Self {
                    self.name = name
                    return self
                }

                @discardableResult func with(middleName: String) -> Self {
                    self.middleName = middleName
                    return self
                }

                func build() -> Person {
                    return Person(
                        name: name,
                        middleName: middleName
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_create_builder_with_optional_types() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            let m1: String?
            let m2: [Int]?
        }
        """,
        expandedSource: """

            struct MyObject {
                let m1: String?
                let m2: [Int]?
            }

            final class MyObjectBuilder {
                private var m1: String?
                private var m2: [Int]?

                init(
                    m1: String? = nil,
                    m2: [Int]? = nil
                ) {
                    self.m1 = m1
                    self.m2 = m2
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m1: myObject.m1,
                        m2: myObject.m2
                    )
                }

                @discardableResult func with(m1: String?) -> Self {
                    self.m1 = m1
                    return self
                }

                @discardableResult func with(m2: [Int]?) -> Self {
                    self.m2 = m2
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1,
                        m2: m2
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_set_default_value_to_custom_type_builder() {
    assertMacroExpansion(
        """
        struct MyOtherObject {
            let unused: Int
        }

        @Buildable
        struct MyObject {
            let m1: MyOtherObject
        }
        """,
        expandedSource: """

            struct MyOtherObject {
                let unused: Int
            }
            struct MyObject {
                let m1: MyOtherObject
            }

            final class MyObjectBuilder {
                private var m1: MyOtherObject

                init(
                    m1: MyOtherObject
                ) {
                    self.m1 = m1
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m1: myObject.m1
                    )
                }

                @discardableResult func with(m1: MyOtherObject) -> Self {
                    self.m1 = m1
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_set_default_value_to_empty_collection() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            let m1: [String]
            let m2: [Int]
            let m3: [String: String]
        }
        """,
        expandedSource: """

            struct MyObject {
                let m1: [String]
                let m2: [Int]
                let m3: [String: String]
            }

            final class MyObjectBuilder {
                private var m1: [String]
                private var m2: [Int]
                private var m3: [String: String]

                init(
                    m1: [String],
                    m2: [Int],
                    m3: [String: String]
                ) {
                    self.m1 = m1
                    self.m2 = m2
                    self.m3 = m3
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m1: myObject.m1,
                        m2: myObject.m2,
                        m3: myObject.m3
                    )
                }

                @discardableResult func with(m1: [String]) -> Self {
                    self.m1 = m1
                    return self
                }

                @discardableResult func with(m2: [Int]) -> Self {
                    self.m2 = m2
                    return self
                }

                @discardableResult func with(m3: [String: String]) -> Self {
                    self.m3 = m3
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1,
                        m2: m2,
                        m3: m3
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test
func test_should_set_default_value_to_nil_for_implicitly_unwrapped_optional() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            let m1: String!
        }
        """,
        expandedSource: """

            struct MyObject {
                let m1: String!
            }

            final class MyObjectBuilder {
                private var m1: String!

                init(
                    m1: String!
                ) {
                    self.m1 = m1
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m1: myObject.m1
                    )
                }

                @discardableResult func with(m1: String!) -> Self {
                    self.m1 = m1
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_ignore_computed_variable() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            var unwantedComputedVariable: String {
                "myText"
            }
        }
        """,
        expandedSource: """

            struct MyObject {
                var unwantedComputedVariable: String {
                    "myText"
                }
            }

            final class MyObjectBuilder {
                func build() -> MyObject {
                    return MyObject()
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_ignore_static_variable() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            static let unwantedStaticVariable1: String = ""
            static var unwantedStaticVariable2: String = ""
        }
        """,
        expandedSource: """

            struct MyObject {
                static let unwantedStaticVariable1: String = ""
                static var unwantedStaticVariable2: String = ""
            }

            final class MyObjectBuilder {
                func build() -> MyObject {
                    return MyObject()
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_ignore_private_variables() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            let m1: String?
            private var m2: String? = nil
            public var m3: String?
            fileprivate var m4: String?

            init(
                m1: String?,
                m3: String?,
                m4: String?
            ) {
                self.m1 = m1
                self.m3 = m3
                self.m4 = m4
            }
        }
        """,
        expandedSource: """

            struct MyObject {
                let m1: String?
                private var m2: String? = nil
                public var m3: String?
                fileprivate var m4: String?

                init(
                    m1: String?,
                    m3: String?,
                    m4: String?
                ) {
                    self.m1 = m1
                    self.m3 = m3
                    self.m4 = m4
                }
            }

            final class MyObjectBuilder {
                private var m1: String?
                private var m3: String?
                private var m4: String?

                init(
                    m1: String? = nil,
                    m3: String? = nil,
                    m4: String? = nil
                ) {
                    self.m1 = m1
                    self.m3 = m3
                    self.m4 = m4
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m1: myObject.m1,
                        m3: myObject.m3,
                        m4: myObject.m4
                    )
                }

                @discardableResult func with(m1: String?) -> Self {
                    self.m1 = m1
                    return self
                }

                @discardableResult func with(m3: String?) -> Self {
                    self.m3 = m3
                    return self
                }

                @discardableResult func with(m4: String?) -> Self {
                    self.m4 = m4
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1,
                        m3: m3,
                        m4: m4
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_ignore_constant_variables() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            let m1: String?
            let myConstant: String = ""
        }
        """,
        expandedSource: """

            struct MyObject {
                let m1: String?
                let myConstant: String = ""
            }

            final class MyObjectBuilder {
                private var m1: String?

                init(
                    m1: String? = nil
                ) {
                    self.m1 = m1
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m1: myObject.m1
                    )
                }

                @discardableResult func with(m1: String?) -> Self {
                    self.m1 = m1
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_ignore_members_with_accessors() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            private var m1: String = ""
            var m2: String {
                get {
                    m1
                }
                set {
                    m1 = newValue
                }
            }

            init(
                m2: String
            ) {
                self.m2 = m2
            }
        }
        """,
        expandedSource: """

            struct MyObject {
                private var m1: String = ""
                var m2: String {
                    get {
                        m1
                    }
                    set {
                        m1 = newValue
                    }
                }

                init(
                    m2: String
                ) {
                    self.m2 = m2
                }
            }

            final class MyObjectBuilder {
                private var m2: String

                init(
                    m2: String
                ) {
                    self.m2 = m2
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m2: myObject.m2
                    )
                }

                @discardableResult func with(m2: String) -> Self {
                    self.m2 = m2
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m2: m2
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_not_make_builder_struct_sendable() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject: Sendable {
            let m1: String
        }
        """,
        expandedSource: """

            struct MyObject: Sendable {
                let m1: String
            }

            final class MyObjectBuilder {
                private var m1: String

                init(
                    m1: String
                ) {
                    self.m1 = m1
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m1: myObject.m1
                    )
                }

                @discardableResult func with(m1: String) -> Self {
                    self.m1 = m1
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_set_default_value_for_defined_types() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyObject {
            let m01: String
            let m02: Int
            let m03: Int8
            let m04: Int16
            let m05: Int32
            let m06: Int64
            let m07: UInt
            let m08: UInt8
            let m09: UInt16
            let m10: UInt32
            let m11: UInt64
            let m12: Bool
            let m13: Double
            let m14: Float
            let m15: Date
            let m16: UUID
            let m17: Data
            let m18: URL
        }
        """,
        expandedSource: """

            struct MyObject {
                let m01: String
                let m02: Int
                let m03: Int8
                let m04: Int16
                let m05: Int32
                let m06: Int64
                let m07: UInt
                let m08: UInt8
                let m09: UInt16
                let m10: UInt32
                let m11: UInt64
                let m12: Bool
                let m13: Double
                let m14: Float
                let m15: Date
                let m16: UUID
                let m17: Data
                let m18: URL
            }

            final class MyObjectBuilder {
                private var m01: String
                private var m02: Int
                private var m03: Int8
                private var m04: Int16
                private var m05: Int32
                private var m06: Int64
                private var m07: UInt
                private var m08: UInt8
                private var m09: UInt16
                private var m10: UInt32
                private var m11: UInt64
                private var m12: Bool
                private var m13: Double
                private var m14: Float
                private var m15: Date
                private var m16: UUID
                private var m17: Data
                private var m18: URL

                init(
                    m01: String,
                    m02: Int,
                    m03: Int8,
                    m04: Int16,
                    m05: Int32,
                    m06: Int64,
                    m07: UInt,
                    m08: UInt8,
                    m09: UInt16,
                    m10: UInt32,
                    m11: UInt64,
                    m12: Bool,
                    m13: Double,
                    m14: Float,
                    m15: Date,
                    m16: UUID,
                    m17: Data,
                    m18: URL
                ) {
                    self.m01 = m01
                    self.m02 = m02
                    self.m03 = m03
                    self.m04 = m04
                    self.m05 = m05
                    self.m06 = m06
                    self.m07 = m07
                    self.m08 = m08
                    self.m09 = m09
                    self.m10 = m10
                    self.m11 = m11
                    self.m12 = m12
                    self.m13 = m13
                    self.m14 = m14
                    self.m15 = m15
                    self.m16 = m16
                    self.m17 = m17
                    self.m18 = m18
                }

                convenience init(_ myObject: MyObject) {
                    self.init(
                        m01: myObject.m01,
                        m02: myObject.m02,
                        m03: myObject.m03,
                        m04: myObject.m04,
                        m05: myObject.m05,
                        m06: myObject.m06,
                        m07: myObject.m07,
                        m08: myObject.m08,
                        m09: myObject.m09,
                        m10: myObject.m10,
                        m11: myObject.m11,
                        m12: myObject.m12,
                        m13: myObject.m13,
                        m14: myObject.m14,
                        m15: myObject.m15,
                        m16: myObject.m16,
                        m17: myObject.m17,
                        m18: myObject.m18
                    )
                }

                @discardableResult func with(m01: String) -> Self {
                    self.m01 = m01
                    return self
                }

                @discardableResult func with(m02: Int) -> Self {
                    self.m02 = m02
                    return self
                }

                @discardableResult func with(m03: Int8) -> Self {
                    self.m03 = m03
                    return self
                }

                @discardableResult func with(m04: Int16) -> Self {
                    self.m04 = m04
                    return self
                }

                @discardableResult func with(m05: Int32) -> Self {
                    self.m05 = m05
                    return self
                }

                @discardableResult func with(m06: Int64) -> Self {
                    self.m06 = m06
                    return self
                }

                @discardableResult func with(m07: UInt) -> Self {
                    self.m07 = m07
                    return self
                }

                @discardableResult func with(m08: UInt8) -> Self {
                    self.m08 = m08
                    return self
                }

                @discardableResult func with(m09: UInt16) -> Self {
                    self.m09 = m09
                    return self
                }

                @discardableResult func with(m10: UInt32) -> Self {
                    self.m10 = m10
                    return self
                }

                @discardableResult func with(m11: UInt64) -> Self {
                    self.m11 = m11
                    return self
                }

                @discardableResult func with(m12: Bool) -> Self {
                    self.m12 = m12
                    return self
                }

                @discardableResult func with(m13: Double) -> Self {
                    self.m13 = m13
                    return self
                }

                @discardableResult func with(m14: Float) -> Self {
                    self.m14 = m14
                    return self
                }

                @discardableResult func with(m15: Date) -> Self {
                    self.m15 = m15
                    return self
                }

                @discardableResult func with(m16: UUID) -> Self {
                    self.m16 = m16
                    return self
                }

                @discardableResult func with(m17: Data) -> Self {
                    self.m17 = m17
                    return self
                }

                @discardableResult func with(m18: URL) -> Self {
                    self.m18 = m18
                    return self
                }

                func build() -> MyObject {
                    return MyObject(
                        m01: m01,
                        m02: m02,
                        m03: m03,
                        m04: m04,
                        m05: m05,
                        m06: m06,
                        m07: m07,
                        m08: m08,
                        m09: m09,
                        m10: m10,
                        m11: m11,
                        m12: m12,
                        m13: m13,
                        m14: m14,
                        m15: m15,
                        m16: m16,
                        m17: m17,
                        m18: m18
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_use_members_from_initializer() {
    assertMacroExpansion(
        """
        @Buildable
        struct MyClass {
            let m1: String
            var unused: String = ""

            init(m1: String = "") {
                self.m1 = m1
            }
        }
        """,
        expandedSource: """

            struct MyClass {
                let m1: String
                var unused: String = ""

                init(m1: String = "") {
                    self.m1 = m1
                }
            }

            final class MyClassBuilder {
                private var m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }

                convenience init(_ myClass: MyClass) {
                    self.init(
                        m1: myClass.m1
                    )
                }

                @discardableResult func with(m1: String) -> Self {
                    self.m1 = m1
                    return self
                }

                func build() -> MyClass {
                    return MyClass(
                        m1: m1
                    )
                }
            }

            """,
        macroSpecs: testMacros
    )
}
