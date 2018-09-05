import Configuration
import Core
import SwiftSyntax

private class FindChildScope: SyntaxVisitor {
  var found = false
  override func visit(_ node: CodeBlockSyntax) {
    found = true
  }
  override func visit(_ node: SwitchStmtSyntax) {
    found = true
  }
  func findChildScope(in items: CodeBlockItemListSyntax) -> Bool {
    for child in items {
      visit(child)
      if found { return true }
    }
    return false
  }
}

private let rangeOperators: Set = ["...", "..<"]

private final class TokenStreamCreator: SyntaxVisitor {
  private var tokens = [Token]()
  private var beforeMap = [TokenSyntax: [Token]]()
  private var afterMap = [TokenSyntax: [Token]]()
  private let config: Configuration

  private var defaultOpen: Token {
    return .open(config.indentation)
  }

  init(configuration: Configuration) {
    self.config = configuration
  }

  func makeStream(from node: Syntax) -> [Token] {
    visit(node)
    defer { tokens = [] }
    return tokens
  }

  var openings = 0

  func before(_ token: TokenSyntax?, _ preToken: Token) {
    guard let tok = token else { return }
    if case .open = preToken {
      openings += 1
    } else if case .close = preToken {
      assert(openings > 0)
      openings -= 1
    }
    beforeMap[tok, default: []].append(preToken)
  }

  func after(_ token: TokenSyntax?, _ postToken: Token) {
    guard let tok = token else { return }
    if case .open = postToken {
      openings += 1
    } else if case .close = postToken {
      assert(openings > 0)
      openings -= 1
    }
    afterMap[tok, default: []].append(postToken)
  }

  func openAfterKeyword(_ keyword: TokenSyntax) {
    after(keyword, .open(.spaces(keyword.text.count + 1)))
  }

  override func visitPre(_ node: Syntax) {
    // All nodes with trailing commas should have a space after if they aren't required to have a
    // newline after.
    if let withTrailingComma = node as? WithTrailingCommaSyntax,
       let trailingComma = withTrailingComma.trailingComma {
      after(trailingComma, .break(.consistent, spaces: 1))
    }
  }

  override func visit(_ node: DeclNameArgumentsSyntax) {
    super.visit(node)
  }

  override func visit(_ node: BinaryOperatorExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TupleExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ArrayExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DictionaryExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ImplicitMemberExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FunctionParameterSyntax) {
    super.visit(node)
  }

  override func visit(_ node: MemberAccessExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ClosureCaptureSignatureSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ClosureExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FunctionCallExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SubscriptExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ExpressionSegmentSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SwitchCaseLabelSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SwitchDefaultLabelSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ObjcKeyPathExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AssignmentExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ObjectLiteralExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ParameterClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ReturnClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IfConfigDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: MemberDeclBlockSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SourceFileSyntax) {
    super.visit(node)
  }

  override func visit(_ node: EnumDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: EnumCaseDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: OperatorDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IfConfigClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: EnumCaseElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ObjcSelectorExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: InfixOperatorGroupSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PrecedenceGroupDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PrecedenceGroupRelationSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PrecedenceGroupAssignmentSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PrecedenceGroupNameElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PrecedenceGroupAssociativitySyntax) {
    super.visit(node)
  }

  override func visit(_ node: AccessLevelModifierSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AccessorParameterSyntax) {
    super.visit(node)
  }

  func shouldAddOpenCloseNewlines(_ node: Syntax) -> Bool {
    if node is AccessorListSyntax { return true }
    guard let list = node as? CodeBlockItemListSyntax else {
      return false
    }
    if list.count > 1 { return true }
    return FindChildScope().findChildScope(in: list)
  }

  override func visit(_ node: AccessorBlockSyntax) {
    super.visit(node)
  }

  override func visit(_ node: CodeBlockSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SwitchCaseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: GenericParameterClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ArrayTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DictionaryTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TupleTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FunctionTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: GenericArgumentClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TuplePatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AsExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DoStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IfStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IsExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TryExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: CaseItemSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TypeExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ArrowExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AttributeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: BreakStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ClassDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DeferStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ElseBlockSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ForInStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: GuardStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: InOutExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ThrowStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: WhileStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ImportDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ReturnStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: StructDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SwitchStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: CatchClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DotSelfExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: KeyPathExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TernaryExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: WhereClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AccessorDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ArrayElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ClosureParamSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ContinueStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DeclModifierSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FunctionDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: MetatypeTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: OptionalTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ProtocolDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SequenceExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SuperRefExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TupleElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: VariableDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AsTypePatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: CodeBlockItemSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ExtensionDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: InheritedTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IsTypePatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ObjcNamePieceSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PoundFileExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PoundLineExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: StringSegmentSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SubscriptDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TypealiasDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AttributedTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ExpressionStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IdentifierExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: NilLiteralExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PatternBindingSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PoundErrorDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SpecializeExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TypeAnnotationSyntax) {
    super.visit(node)
  }

  override func visit(_ node: UnknownPatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: CompositionTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DeclarationStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: EnumCasePatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FallthroughStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ForcedValueExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: GenericArgumentSyntax) {
    super.visit(node)
  }

  override func visit(_ node: InitializerDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: OptionalPatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PoundColumnExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: RepeatWhileStmtSyntax) {
    super.visit(node)
  }

  override func visit(_ node: WildcardPatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ClosureSignatureSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ConditionElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DeclNameArgumentSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FloatLiteralExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: GenericParameterSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PostfixUnaryExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PoundWarningDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TupleTypeElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DeinitializerDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DictionaryElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ExpressionPatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ValueBindingPatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FunctionSignatureSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IdentifierPatternSyntax) {
    super.visit(node)
  }

  override func visit(_ node: InitializerClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PoundFunctionExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: StringLiteralExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AssociatedtypeDeclSyntax) {
    super.visit(node)
  }

  override func visit(_ node: BooleanLiteralExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ClosureCaptureItemSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ElseIfContinuationSyntax) {
    super.visit(node)
  }

  override func visit(_ node: GenericWhereClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: IntegerLiteralExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PoundDsohandleExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: PrefixOperatorExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AccessPathComponentSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SameTypeRequirementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TuplePatternElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: FunctionCallArgumentSyntax) {
    super.visit(node)
  }

  override func visit(_ node: MemberTypeIdentifierSyntax) {
    super.visit(node)
  }

  override func visit(_ node: OptionalChainingExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SimpleTypeIdentifierSyntax) {
    super.visit(node)
  }

  override func visit(_ node: AvailabilityConditionSyntax) {
    super.visit(node)
  }

  override func visit(_ node: DiscardAssignmentExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: EditorPlaceholderExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: SymbolicReferenceExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TypeInheritanceClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: TypeInitializerClauseSyntax) {
    super.visit(node)
  }

  override func visit(_ node: UnresolvedPatternExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: CompositionTypeElementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ConformanceRequirementSyntax) {
    super.visit(node)
  }

  override func visit(_ node: StringInterpolationExprSyntax) {
    super.visit(node)
  }

  override func visit(_ node: MatchingPatternConditionSyntax) {
    super.visit(node)
  }

  override func visit(_ node: OptionalBindingConditionSyntax) {
    super.visit(node)
  }

  override func visit(_ node: ImplicitlyUnwrappedOptionalTypeSyntax) {
    super.visit(node)
  }

  override func visit(_ token: TokenSyntax) {
    breakDownTrivia(token.leadingTrivia, before: token)
    if let before = beforeMap[token] {
      tokens += before
    }
    appendToken(.syntax(token))
    if var after = afterMap[token] {
      /// If a `break`, with any number of spaces, comes right after a token which has spaces
      /// in its trailing trivia, then remove the spaces from this break and keep the same style.
      if case .break(let style, _)? = after.first,
         token.trailingTrivia.hasSpaces {
        after[0] = .break(style, spaces: 0)
      }
      tokens += after
    }
    breakDownTrivia(token.trailingTrivia)
  }

  func appendToken(_ token: Token) {
    if let last = tokens.last {
      switch (last, token) {
      case (.comment(let c1, _), .comment(let c2, _))
        where c1.kind == .docLine && c2.kind == .docLine:
        var newComment = c1
        newComment.addText(c2.text)
        tokens[tokens.count - 1] = .comment(newComment, hasTrailingSpace: false)
        return
      default:
        break
      }
    }
    tokens.append(token)
  }

  private func shouldAddNewlineBefore(_ token: TokenSyntax?) -> Bool {
    guard let token = token, let before = beforeMap[token] else { return false }
    for item in before {
      if case .newlines = item { return false }
    }
    return true
  }

  private func breakDownTrivia(_ trivia: Trivia, before: TokenSyntax? = nil) {
    for (offset, piece) in trivia.enumerated() {
      switch piece {
      case .lineComment(let text):
        appendToken(.comment(Comment(kind: .line, text: text), hasTrailingSpace: false))
        if case .newlines? = trivia[safe: offset + 1],
           case .lineComment? = trivia[safe: offset + 2] {
          /* do nothing */
        } else {
          appendToken(.newline)
        }
      case .docLineComment(let text):
        appendToken(.comment(Comment(kind: .docLine, text: text), hasTrailingSpace: false))
        if case .newlines? = trivia[safe: offset + 1],
           case .docLineComment? = trivia[safe: offset + 2] {
          /* do nothing */
        } else {
          appendToken(.newline)
        }
      case .blockComment(let text), .docBlockComment(let text):
        var hasTrailingSpace = false
        var hasTrailingNewline = false

        // Detect if a newline or trailing space comes after this comment and preserve it.
        if let next = trivia[safe: offset + 1] {
          switch next {
          case .newlines, .carriageReturns, .carriageReturnLineFeeds:
            hasTrailingNewline = true
          case .spaces, .tabs:
            hasTrailingSpace = true
          default:
            break
          }
        }

        let commentKind: Comment.Kind
        if case .blockComment = piece {
          commentKind = .block
        } else {
          commentKind = .docBlock
        }
        let comment = Comment(kind: commentKind, text: text)
        appendToken(.comment(comment, hasTrailingSpace: hasTrailingSpace))
        if hasTrailingNewline {
          appendToken(.newline)
        }
      case .newlines(let n), .carriageReturns(let n), .carriageReturnLineFeeds(let n):
        if n > 1 {
          appendToken(.newlines(min(n - 1, config.maximumBlankLines)))
        }
      default:
        break
      }
    }
  }
}

extension Syntax {
  /// Creates a pretty-printable token stream for the provided Syntax node.
  func makeTokenStream(configuration: Configuration) -> [Token] {
    return TokenStreamCreator(configuration: configuration).makeStream(from: self)
  }
}

extension Collection {
  subscript(safe index: Index) -> Element? {
    return index < endIndex ? self[index] : nil
  }
}
