# Design Intent

Reproducibility: two users running Squi, regardless of any hand-made
customization they've already done in-game, should end up with identical
results. Never read back or preserve existing account, CVar, API state to decide
what value to set. Always pass an explicit, hardcoded value, even when that
value is `nil` or a no-op, so the outcome never depends on what a user already
had.

# Game Directory

World of Warcraft is installed at `~/Games/battlenet/drive_c/Program Files
(x86)/World of Warcraft`.

# Coding Conventions

- Constants are UPPER_CASE at the top of the file, alpha-sorted
- Functions are PascalCase, alpha-sorted
- Each module registers configure functions, alpha-sorted
- Use `stylua` to format code

# Coding Guidelines and References

The maintainer of the project may provide well established community addons in
their user directory to serve as reference for specific features. In case of
confusing or unexpected behaviors, ask the user to check for outdated
repositories.

Look in `~/Workspace/curse/` when the user is trying to refer to such
references. The official UI source `wow-ui-source` is also maintained in this
directory by the user.

# Typings

Use [`wowlua-ls`][github:wowlua-ls]. The maintainer of the project manually
manages this dependency in `~/Workspace/wowlua-ls` and plugs it through Emacs's
`dir-locals` API.

```lisp
((lua-ts-mode
  . ((eglot-server-programs
      . ((lua-ts-mode
          . ("/home/<user>/Workspace/wowlua-ls/target/release/wowlua_ls")))))))
```

Use `wowlua_ls check .` to validate typings.

[github:wowlua-ls]: https://github.com/TradeSkillMaster/wowlua-ls
