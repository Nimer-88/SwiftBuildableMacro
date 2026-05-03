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

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func makeSetFunction(
    parameter: InitParameter,
    accessLevel: AccessLevel
) -> FunctionDeclSyntax {
    var function = FunctionDeclSyntax(
        modifiers: {
            return makeInnerDeclAccessModifierList(for: accessLevel)
        }(),
        name: .keyword(.set),
        signature: FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(
                parameters: FunctionParameterListSyntax {
                    let firstName: TokenSyntax =
                        if let alias = parameter.alias {
                            alias
                        } else {
                            parameter.identifier
                        }
                    let secondName: TokenSyntax? =
                        if parameter.alias != nil {
                            parameter.identifier
                        } else {
                            nil
                        }
                    FunctionParameterSyntax(
                        firstName: firstName,
                        secondName: secondName,
                        type: parameter.type.trimmed,
                    )
                }
            ),
            returnClause: ReturnClauseSyntax(
                type: IdentifierTypeSyntax(name: .keyword(.Self))
            )
        ),
        body: CodeBlockSyntax(
            statements: CodeBlockItemListSyntax {
                CodeBlockItemSyntax(
                    item: CodeBlockItemSyntax.Item(
                        InfixOperatorExprSyntax(
                            leftOperand: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(
                                    baseName: .keyword(.self)
                                ),
                                name: parameter.identifier
                            ),
                            operator: AssignmentExprSyntax(),
                            rightOperand: DeclReferenceExprSyntax(
                                baseName: .identifier(parameter.identifier.text)
                            )
                        )
                    )
                )
                CodeBlockItemSyntax(
                    item: CodeBlockItemSyntax.Item(
                        ReturnStmtSyntax(
                            expression: DeclReferenceExprSyntax(
                                baseName: .keyword(.self)
                            )
                        )
                    )
                )
            }
        )
    )

    function.attributes = AttributeListSyntax(
        arrayLiteral: .attribute(
            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(
                    name: .identifier("discardableResult")
                )
            )
        )
    )

    return function
}
