public struct FlattenWorkspaceTreeCmdArgs: CmdArgs {
    /*conforms*/ public var commonState: CmdArgsCommonState
    public init(rawArgs: StrArrSlice) { self.commonState = .init(rawArgs) }
    public static let parser: CmdParser<Self> = .init(
        kind: .flattenWorkspaceTree,
        help: flatten_workspace_tree_help_generated,
        flags: [
            "--workspace": workspaceSubArgParser(),
            "--sort-by-window-id": trueBoolFlag(\.sortByWindowId),
        ],
        posArgs: [],
    )

    public var sortByWindowId: Bool = false
}
