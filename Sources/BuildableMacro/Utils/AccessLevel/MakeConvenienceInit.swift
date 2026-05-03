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

func makeConvenienceInit(
    parameters: [InitParameter],
    originalTypeName: TokenSyntax,
    accessLevel: AccessLevel,
    hasCustomInitializer: Bool,
) -> InitializerDeclSyntax {
    let originalTypeNameTrimmed = originalTypeName.trimmed
    let camelCaseName = toCamelCase(originalTypeNameTrimmed.text)

    return InitializerDeclSyntax(
        modifiers: makeInnerDeclAccessModifierList(for: accessLevel) + [
            DeclModifierSyntax(name: .keyword(.convenience))
        ],
        initKeyword: .keyword(.`init`),
        signature: FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(
                leftParen: .leftParenToken(),
                parameters: FunctionParameterListSyntax {
                    FunctionParameterSyntax(
                        firstName: .identifier("_"),
                        secondName: .identifier(camelCaseName),
                        type: TypeSyntax(
                            stringLiteral: originalTypeNameTrimmed.text
                        )
                    )
                },
                rightParen: .rightParenToken()
            )
        ),
        bodyBuilder: {
            CodeBlockItemListSyntax {
                makeConvenienceInitBody(
                    parameters: parameters,
                    baseName: camelCaseName
                )
            }
        }
    )
}

private func toCamelCase(_ name: String) -> String {
    guard !name.isEmpty else { return name }
    return String(name.prefix(1).lowercased()) + name.dropFirst()
}

private func makeConvenienceInitBody(
    parameters: [InitParameter],
    baseName: String
) -> CodeBlockItemSyntax {
    let labeledExprs: [LabeledExprSyntax] = parameters.enumerated().map {
        index,
        parameter in
        let label =
            if parameter.alias?.text == "_" { parameter.identifier }
            else { parameter.alias ?? parameter.identifier }
        var labeledExpr = LabeledExprSyntax(
            label: label,
            colon: TokenSyntax(TokenKind.colon, presence: .present),
            expression: MemberAccessExprSyntax(
                base: DeclReferenceExprSyntax(baseName: .identifier(baseName)),
                name: parameter.identifier
            )
        )
        if index < parameters.count - 1 {
            labeledExpr.trailingComma = .commaToken(
                trailingTrivia: .newlines(1)
            )
        }
        return labeledExpr
    }
    let arguments = LabeledExprListSyntax(labeledExprs)

    let selfInitCall = FunctionCallExprSyntax(
        calledExpression: MemberAccessExprSyntax(
            base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
            name: .keyword(.`init`)
        ),
        leftParen: .leftParenToken(trailingTrivia: .newlines(1)),
        arguments: arguments,
        rightParen: .rightParenToken(leadingTrivia: .newlines(1))
    )

    return CodeBlockItemSyntax(
        item: CodeBlockItemSyntax.Item(selfInitCall)
    )
}

private func makeConvenienceInitDirectAssignment(
    parameter: InitParameter,
    baseName: String
) -> CodeBlockItemSyntax {
    CodeBlockItemSyntax(
        item: CodeBlockItemSyntax.Item(
            InfixOperatorExprSyntax(
                leftOperand: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(
                        baseName: .keyword(.`self`)
                    ),
                    name: parameter.identifier
                ),
                operator: AssignmentExprSyntax(),
                rightOperand: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(
                        baseName: .identifier(baseName)
                    ),
                    name: parameter.identifier
                )
            )
        )
    )
}
