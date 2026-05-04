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
// Matusik's specific and express permission to do so. Nor does any person
// obtaining a copy of this software and associated documentation files have
// the right to sublicense others to reproduce and/or otherwise use the Work in
// any manner for purposes of training artificial intelligence technologies to
// generate text without Sebastian Matusik's specific and express permission.
//
// Created by Sebastian Matusik
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosGenericTestSupport
import Testing

@Test func test_should_apply_fileprivate_access_levels() {
    assertMacroExpansion(
        """
        @Buildable
        fileprivate struct Person {
            let firstName: String
            let lastName: String
        }
        """,
        expandedSource: """

            fileprivate struct Person {
                let firstName: String
                let lastName: String

                fileprivate final class Builder {
                    private var firstName: String
                    private var lastName: String

                    fileprivate init(
                        firstName: String,
                        lastName: String
                    ) {
                        self.firstName = firstName
                        self.lastName = lastName
                    }

                    fileprivate convenience init(from person: Person) {
                        self.init(
                            firstName: person.firstName,
                            lastName: person.lastName
                        )
                    }

                    @discardableResult fileprivate func with(firstName: String) -> Self {
                        self.firstName = firstName
                        return self
                    }

                    @discardableResult fileprivate func with(lastName: String) -> Self {
                        self.lastName = lastName
                        return self
                    }

                    fileprivate func build() -> Person {
                        return Person(
                            firstName: firstName,
                            lastName: lastName
                        )
                    }
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test
func test_should_apply_public_and_package_access_levels_with_init_for_struct() {
    let accessLevels = [
        "package",
        "public",
    ]
    for accessLevel in accessLevels {
        assertMacroExpansion(
            """
            @Buildable
            \(accessLevel) struct Person {
                let firstName: String
                let lastName: String

                init(
                    firstName: String = "",
                    lastName: String = ""
                ) {
                    self.firstName = firstName
                    self.lastName = lastName
                }
            }
            """,
            expandedSource: """

                \(accessLevel) struct Person {
                    let firstName: String
                    let lastName: String

                    init(
                        firstName: String = "",
                        lastName: String = ""
                    ) {
                        self.firstName = firstName
                        self.lastName = lastName
                    }

                    \(accessLevel) final class Builder {
                        private var firstName: String
                        private var lastName: String

                        \(accessLevel) init(
                            firstName: String = "",
                            lastName: String = ""
                        ) {
                            self.firstName = firstName
                            self.lastName = lastName
                        }

                        \(accessLevel) convenience init(from person: Person?) {
                            if let person {
                                self.init(
                                    firstName: person.firstName,
                                    lastName: person.lastName
                                )
                            } else {
                                self.init()
                            }
                        }

                        @discardableResult \(accessLevel) func with(firstName: String) -> Self {
                            self.firstName = firstName
                            return self
                        }

                        @discardableResult \(accessLevel) func with(lastName: String) -> Self {
                            self.lastName = lastName
                            return self
                        }

                        \(accessLevel) func build() -> Person {
                            return Person(
                                firstName: firstName,
                                lastName: lastName
                            )
                        }
                    }
                }

                """,
            macroSpecs: testMacros
        )
    }
}

@Test func test_should_not_print_internal_access_level_for_struct() {
    assertMacroExpansion(
        """
        @Buildable
        internal struct Person {
            let name: String
        }
        """,
        expandedSource: """

            internal struct Person {
                let name: String

                final class Builder {
                    private var name: String

                    init(
                        name: String
                    ) {
                        self.name = name
                    }

                    convenience init(from person: Person) {
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
            }

            """,
        macroSpecs: testMacros
    )
}

@Test
func
    test_should_apply_private_access_level_not_for_inner_properties_for_struct()
{
    assertMacroExpansion(
        """
        @Buildable
        private struct Person {
            let name: String
        }
        """,
        expandedSource: """

            private struct Person {
                let name: String

                final class Builder {
                    private var name: String

                    init(
                        name: String
                    ) {
                        self.name = name
                    }

                    convenience init(from person: Person) {
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
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_apply_custom_package_access_level_for_struct() {
    assertMacroExpansion(
        """
        @Buildable(accessLevel: .package)
        public struct Person {
            let name: String
            let age: Int
        }
        """,
        expandedSource: """

            public struct Person {
                let name: String
                let age: Int

                package final class Builder {
                    private var name: String
                    private var age: Int

                    package init(
                        name: String,
                        age: Int
                    ) {
                        self.name = name
                        self.age = age
                    }

                    package convenience init(from person: Person) {
                        self.init(
                            name: person.name,
                            age: person.age
                        )
                    }

                    @discardableResult package func with(name: String) -> Self {
                        self.name = name
                        return self
                    }

                    @discardableResult package func with(age: Int) -> Self {
                        self.age = age
                        return self
                    }

                    package func build() -> Person {
                        return Person(
                            name: name,
                            age: age
                        )
                    }
                }
            }

            """,
        macroSpecs: testMacros
    )
}
