# Game Directory

World of Warcraft is installed at `~/Games/battlenet/drive_c/Program Files
(x86)/World of Warcraft`.

# Coding Guidelines and References

This assumes the user clones and maintains the following repositories up to date
on their own. Prompt the user to pull or clone the missing repositories when
relevant.

- `~/Workspace/wow-ui-source`: a mirror of the official UI code
- `~/Workspace/realui`: UI replacement found next to the official UI source
- `~/Workspace/ellesmereui`: UI replacement designed for optimization
- `~/Workspace/wowlua-ls`: a mature WoW-oriented Lua language server
- `~/Workspace/vscode-wow-api`: a less maintained repository of type annotations

The 2 UI replacement addons mentioned are well established in the community and
should serve as documentation on how to do X or Y.

# Typings

The project currently subscribes to `vscode-wow-api` typing annotations.

Given how slow the Lua language server is, the list of annotation sources is
kept short in `.luarc.json`. Adding or removing features should come with an
update to the list.

When `vscode-wow-api` is stale on something specific (e.g. a CVar or setting
that's missing), fall back to a targeted lookup against the actual upstream
Blizzard UI source. See `wow-ui-source` in the previous section.
