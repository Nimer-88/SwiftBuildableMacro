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

@Test func test_should_apply_fileprivate_access_level() {
    assertMacroExpansion(
        """
        @Buildable
        fileprivate class MyClass {
            let m1: String
            let m2: String

            fileprivate init(
                m1: String,
                m2: String
            ) {
                self.m1 = m1
                self.m2 = m2
            }
        }
        """,
        expandedSource: """

            fileprivate class MyClass {
                let m1: String
                let m2: String

                fileprivate init(
                    m1: String,
                    m2: String
                ) {
                    self.m1 = m1
                    self.m2 = m2
                }

                fileprivate final class Builder {
                    private var m1: String
                    private var m2: String

                    fileprivate init(
                        m1: String,
                        m2: String
                    ) {
                        self.m1 = m1
                        self.m2 = m2
                    }

                    fileprivate convenience init(from myClass: MyClass) {
                        self.init(
                            m1: myClass.m1,
                            m2: myClass.m2
                        )
                    }

                    @discardableResult fileprivate func with(m1: String) -> Self {
                        self.m1 = m1
                        return self
                    }

                    @discardableResult fileprivate func with(m2: String) -> Self {
                        self.m2 = m2
                        return self
                    }

                    fileprivate func build() -> MyClass {
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

@Test func test_should_apply_public_and_package_access_levels_with_init() {
    let accessLevels = [
        "package",
        "public",
    ]
    for accessLevel in accessLevels {
        assertMacroExpansion(
            """
            @Buildable
            \(accessLevel) class MyClass {
                let m1: String
                let m2: String?

                \(accessLevel) init(
                    m1: String,
                    m2: String? = nil
                ) {
                    self.m1 = m1
                    self.m2 = m2
                }
            }
            """,
            expandedSource: """

                \(accessLevel) class MyClass {
                    let m1: String
                    let m2: String?

                    \(accessLevel) init(
                        m1: String,
                        m2: String? = nil
                    ) {
                        self.m1 = m1
                        self.m2 = m2
                    }

                    \(accessLevel) final class Builder {
                        private var m1: String
                        private var m2: String?

                        \(accessLevel) init(
                            m1: String,
                            m2: String? = nil
                        ) {
                            self.m1 = m1
                            self.m2 = m2
                        }

                        \(accessLevel) convenience init(from myClass: MyClass) {
                            self.init(
                                m1: myClass.m1,
                                m2: myClass.m2
                            )
                        }

                        @discardableResult \(accessLevel) func with(m1: String) -> Self {
                            self.m1 = m1
                            return self
                        }

                        @discardableResult \(accessLevel) func with(m2: String?) -> Self {
                            self.m2 = m2
                            return self
                        }

                        \(accessLevel) func build() -> MyClass {
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
}

@Test func test_should_not_print_internal_access_level() {
    assertMacroExpansion(
        """
        @Buildable
        internal class MyClass {
            let m1: String?

            init(
                m1: String? = nil
            ) {
                self.m1 = m1
            }
        }
        """,
        expandedSource: """

            internal class MyClass {
                let m1: String?

                init(
                    m1: String? = nil
                ) {
                    self.m1 = m1
                }

                final class Builder {
                    private var m1: String?

                    init(
                        m1: String? = nil
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

                    @discardableResult func with(m1: String?) -> Self {
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

@Test func test_should_apply_private_access_level_not_for_inner_properties() {
    assertMacroExpansion(
        """
        @Buildable
        private class MyClass {
            let m1: String

            init(
                m1: String
            ) {
                self.m1 = m1
            }
        }
        """,
        expandedSource: """

            private class MyClass {
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

@Test func test_should_apply_custom_package_access_level() {
    assertMacroExpansion(
        """
        @Buildable(accessLevel: .fileprivate)
        public class MyClass {
            let m1: String

            public init(
                m1: String
            ) {
                self.m1 = m1
            }
        }
        """,
        expandedSource: """

            public class MyClass {
                let m1: String

                public init(
                    m1: String
                ) {
                    self.m1 = m1
                }

                fileprivate final class Builder {
                    private var m1: String

                    fileprivate init(
                        m1: String
                    ) {
                        self.m1 = m1
                    }

                    fileprivate convenience init(from myClass: MyClass) {
                        self.init(
                            m1: myClass.m1
                        )
                    }

                    @discardableResult fileprivate func with(m1: String) -> Self {
                        self.m1 = m1
                        return self
                    }

                    fileprivate func build() -> MyClass {
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
