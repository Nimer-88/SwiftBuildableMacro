// swift-tools-version: 6.2

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
// Created by Alexander Schmutz on 09.02.24
// Modified by Sebastian Matusik on 02.05.26
//

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Buildable",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6),
        .macCatalyst(.v13),
    ],
    products: [
        .library(name: "Buildable", targets: ["Buildable"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            "600.0.0"..<"603.0.0"
        )
    ],
    targets: [
        .macro(
            name: "BuildableMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(name: "Buildable", dependencies: ["BuildableMacro"]),
        .executableTarget(name: "BuildableClient", dependencies: ["Buildable"]),
        .testTarget(
            name: "BuildableMacroTests",
            dependencies: [
                "BuildableMacro",
                .product(
                    name: "SwiftSyntaxMacrosGenericTestSupport",
                    package: "swift-syntax"
                ),
            ]
        ),
    ]
)

// See also `swift -print-supported-features`
package.targets.forEach {
    $0.swiftSettings = [
        .enableUpcomingFeature("ImmutableWeakCaptures"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("ExistentialAny"),
    ]
}
