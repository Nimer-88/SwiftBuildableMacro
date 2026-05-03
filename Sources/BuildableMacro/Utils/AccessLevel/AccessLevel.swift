// Copyright © 2025 Alexander Schmutz
//
// MIT License
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
// Created by Alexander Schmutz
//

enum AccessLevel: String, CaseIterable {
    case `private`
    case `fileprivate`
    case `internal`
    case `package`
    case `public`

    var orderIndex: Int {
        switch self {
        case .private: 0
        case .fileprivate: 1
        case .internal: 2
        case .package: 3
        case .public: 4
        }  // switch self
    }

    var needsExplicitInit: Bool {
        switch self {
        case .private: false
        case .fileprivate: false
        case .internal: false
        case .package: true
        case .public: true
        }  // switch self
    }
}

extension AccessLevel: Comparable {
    static func < (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        lhs.orderIndex < rhs.orderIndex
    }
}
