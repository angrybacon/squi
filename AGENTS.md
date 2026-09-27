# Game Directory

World of Warcraft is installed at `~/Games/battlenet/drive_c/Program Files
(x86)/World of Warcraft`.

# Typings

The vscode-wow-api annotations used for typing are at
`~/Workspace/vscode-wow-api`. They might be outdated, ask the user to pull new
code if that is found to be true.

If `vscode-wow-api` is stale on something specific (e.g. a CVar or setting
that's missing), fall back to a targeted lookup against the actual upstream
Blizzard UI source at `Gethe/wow-ui-source:live`.

Clean up the temporary clone afterward. This is raw, unannotated source, so it's
for verifying ground truth such as CVar names or current behavior, not a
replacement for `vscode-wow-api`'s typed annotations.

Given how slow the Lua language server is, the list of annotation sources is
kept short in `.luarc.json`. Adding or removing features should come with an
update to the list.
