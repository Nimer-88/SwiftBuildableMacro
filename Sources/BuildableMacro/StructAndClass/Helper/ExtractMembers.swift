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
// Except as contained in this notice, the name of Sebastian Matusik shall not
// be used in advertising or otherwise to promote the sale, use or other
// dealings in this Software without prior written authorization from
// Sebastian Matusik.
//
// Created by Alexander Schmutz
// Modified by Sebastian Matusik
//

import Foundation
import SwiftSyntax

func extractMembersFrom(_ memberBlockItemList: MemberBlockItemListSyntax)
    -> [StructMember]
{
    memberBlockItemList
        .compactMap { $0.decl.as(VariableDeclSyntax.self) }
        .filter(\.isStoredProperty)
        .filter { !hasStaticModifier($0) }
        .filter { !hasPrivateModifier($0) }
        .filter { !isConstant($0) }
        .compactMap { variable in
            guard let patternBinding = variable.bindings.first else {
                return nil
            }
            guard let identifier = getIdentifierFromMember(patternBinding)
            else { return nil }
            guard let type = getTypeFromMember(patternBinding) else {
                return nil
            }
            return StructMember(
                identifier: identifier,
                alias: nil,
                type: type,
                value: getInitializerFromMember(patternBinding)
            )
        }
}

private func getIdentifierFromMember(_ patternBinding: PatternBindingSyntax)
    -> TokenSyntax?
{
    patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier
}

private func getTypeFromMember(_ patternBinding: PatternBindingSyntax)
    -> TypeSyntax?
{
    patternBinding.typeAnnotation?.type
}

private func getInitializerFromMember(_ patternBinding: PatternBindingSyntax)
    -> InitializerClauseSyntax?
{
    patternBinding.initializer
}

private func hasStaticModifier(_ variable: VariableDeclSyntax) -> Bool {
    variable.modifiers.contains(where: { $0.name.text.contains("static") })
}

private func hasPrivateModifier(_ variable: VariableDeclSyntax) -> Bool {
    variable.modifiers.contains(where: { $0.name.text == "private" })
}

private func isConstant(_ variable: VariableDeclSyntax) -> Bool {
    variable.bindingSpecifier.text == "let"
        && variable.bindings.first?.initializer != nil
}

// SOURCE: https://github.com/apple/swift-syntax/tree/main/Examples
extension VariableDeclSyntax {
    /// Determine whether this variable has the syntax of a stored property.
    ///
    /// This syntactic check cannot account for semantic adjustments due to,
    /// e.g., accessor macros or property wrappers.
    fileprivate var isStoredProperty: Bool {
        if bindings.count != 1 {
            return false
        }

        switch bindings.first!.accessorBlock?.accessors {
        case .none:
            return true

        case .accessors(let accessors):
            for accessor in accessors {
                switch accessor.accessorSpecifier.tokenKind {
                case .keyword(.willSet), .keyword(.didSet):
                    // Observers can occur on a stored property.
                    break

                default:
                    // Other accessors make it a computed property.
                    return false
                }  // switch accessor.accessorSpecifier.tokenKind
            }

            return true

        case .getter:
            return false
        }  // switch bindings.first!.accessorBlock?.accessors
    }
}
