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

@Test func test_should_create_macro_from_class() {
    assertMacroExpansion(
        """
        @Buildable
        class MyClass {
            let m1: String

            init(
                m1: String
            ) {
                self.m1 = m1
            }
        }
        """,
        expandedSource: """

            class MyClass {
                let m1: String

                init(
                    m1: String
                ) {
                    self.m1 = m1
                }

                final class Builder {
                    private var m1: String

                    init(
                        m1: String
                    ) {
                        self.m1 = m1
                    }

                    convenience init(from myClass: MyClass) {
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
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_dont_use_blank_name_from_class() {
    assertMacroExpansion(
        """
        @Buildable
        class MyClass {
            let m1: String

            init(
                _ m1: String
            ) {
                self.m1 = m1
            }
        }
        """,
        expandedSource: """

            class MyClass {
                let m1: String

                init(
                    _ m1: String
                ) {
                    self.m1 = m1
                }

                final class Builder {
                    private var m1: String

                    init(
                        m1: String
                    ) {
                        self.m1 = m1
                    }

                    convenience init(from myClass: MyClass) {
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
                            m1
                        )
                    }
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_create_macro_from_class_with_various_default_values() {
    assertMacroExpansion(
        """
        @Buildable
        class MyClass {
            let m1: String
            let m2: URL?
            let m3: String?
            let m4: String!
            let m5: [String]

            init(
                firstName m1: String = "",
                m2: URL?,
                m3: String?,
                m4: String! = "",
                m5: [String] = []
            ) {
                self.m1 = m1
                self.m2 = m2
                self.m3 = m3
                self.m4 = m4
                self.m5 = m5
            }
        }
        """,
        expandedSource: """

            class MyClass {
                let m1: String
                let m2: URL?
                let m3: String?
                let m4: String!
                let m5: [String]

                init(
                    firstName m1: String = "",
                    m2: URL?,
                    m3: String?,
                    m4: String! = "",
                    m5: [String] = []
                ) {
                    self.m1 = m1
                    self.m2 = m2
                    self.m3 = m3
                    self.m4 = m4
                    self.m5 = m5
                }

                final class Builder {
                    private var m1: String
                    private var m2: URL?
                    private var m3: String?
                    private var m4: String!
                    private var m5: [String]

                    init(
                        firstName m1: String = "",
                        m2: URL? = nil,
                        m3: String? = nil,
                        m4: String! = "",
                        m5: [String] = []
                    ) {
                        self.m1 = m1
                        self.m2 = m2
                        self.m3 = m3
                        self.m4 = m4
                        self.m5 = m5
                    }

                    convenience init(from myClass: MyClass?) {
                        if let myClass {
                            self.init(
                                firstName: myClass.m1,
                                m2: myClass.m2,
                                m3: myClass.m3,
                                m4: myClass.m4,
                                m5: myClass.m5
                            )
                        } else {
                            self.init()
                        }
                    }

                    @discardableResult func with(firstName m1: String) -> Self {
                        self.m1 = m1
                        return self
                    }

                    @discardableResult func with(m2: URL?) -> Self {
                        self.m2 = m2
                        return self
                    }

                    @discardableResult func with(m3: String?) -> Self {
                        self.m3 = m3
                        return self
                    }

                    @discardableResult func with(m4: String!) -> Self {
                        self.m4 = m4
                        return self
                    }

                    @discardableResult func with(m5: [String]) -> Self {
                        self.m5 = m5
                        return self
                    }

                    func build() -> MyClass {
                        return MyClass(
                            firstName: m1,
                            m2: m2,
                            m3: m3,
                            m4: m4,
                            m5: m5
                        )
                    }
                }
            }

            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_set_use_longest_found_initializer() {
    assertMacroExpansion(
        """
        @Buildable
        class MyClass {
            let m1: String
            let m2: String

            var someValue: String? { nil }

            init(
                m1: String!
            ) {
                self.m1 = m1
                self.m2 = ""
            }

            init(
                m1: String,
                m2: String
            ) {
                self.m1 = m1
                self.m2 = m2
            }
        }
        """,
        expandedSource: """

            class MyClass {
                let m1: String
                let m2: String

                var someValue: String? { nil }

                init(
                    m1: String!
                ) {
                    self.m1 = m1
                    self.m2 = ""
                }

                init(
                    m1: String,
                    m2: String
                ) {
                    self.m1 = m1
                    self.m2 = m2
                }

                final class Builder {
                    private var m1: String
                    private var m2: String

                    init(
                        m1: String,
                        m2: String
                    ) {
                        self.m1 = m1
                        self.m2 = m2
                    }

                    convenience init(from myClass: MyClass) {
                        self.init(
                            m1: myClass.m1,
                            m2: myClass.m2
                        )
                    }

                    @discardableResult func with(m1: String) -> Self {
                        self.m1 = m1
                        return self
                    }

                    @discardableResult func with(m2: String) -> Self {
                        self.m2 = m2
                        return self
                    }

                    func build() -> MyClass {
                        return MyClass(
                            m1: m1,
                            m2: m2
                        )
                    }
                }
            }
            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_set_skip_convenience_initializers() {
    assertMacroExpansion(
        """
        @Buildable
        class MyClass {
            let m1: String

            var someValue: String? { nil }

            init(
                m1: String!
            ) {
                self.m1 = m1
            }

            convenience init(
                m1: String,
                unused: String
            ) {
                self.init(
                    m1: m1
                )
            }
        }
        """,
        expandedSource: """

            class MyClass {
                let m1: String

                var someValue: String? { nil }

                init(
                    m1: String!
                ) {
                    self.m1 = m1
                }

                convenience init(
                    m1: String,
                    unused: String
                ) {
                    self.init(
                        m1: m1
                    )
                }

                final class Builder {
                    private var m1: String!

                    init(
                        m1: String!
                    ) {
                        self.m1 = m1
                    }

                    convenience init(from myClass: MyClass) {
                        self.init(
                            m1: myClass.m1
                        )
                    }

                    @discardableResult func with(m1: String!) -> Self {
                        self.m1 = m1
                        return self
                    }

                    func build() -> MyClass {
                        return MyClass(
                            m1: m1
                        )
                    }
                }
            }
            """,
        macroSpecs: testMacros
    )
}

@Test func test_should_not_make_builder_class_sendable() {
    assertMacroExpansion(
        """
        @Buildable
        final class MyClass: Sendable {
            let m1: String

            init(
                m1: String = ""
            ) {
                self.m1 = m1
            }
        }
        """,
        expandedSource: """

            final class MyClass: Sendable {
                let m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }

                final class Builder {
                    private var m1: String

                    init(
                        m1: String = ""
                    ) {
                        self.m1 = m1
                    }

                    convenience init(from myClass: MyClass?) {
                        if let myClass {
                            self.init(
                                m1: myClass.m1
                            )
                        } else {
                            self.init()
                        }
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
            }

            """,
        macroSpecs: testMacros
    )
}
