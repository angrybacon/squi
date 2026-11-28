# Design Intent and Philosophy

- **Reproducibility**: two users running Squi, regardless of any hand-made
  customization they've already done in-game previously, should end up with
  almost identical results
- **Predictability**: never read back or preserve existing account, CVar, or API
  state to decide what value to set. Always pass an explicit, hardcoded value,
  even when that value is `nil` or a no-op. Essentially, the outcome should
  never depend on what a user already had
- **Simplicity**: prefer small changes line-wise and hook on existing APIs.
  Bespoke code comes with bigger maintenance
- **Security**: with great limitation within the client, Blizzard largely
  protects frames and data in combat. Always prefer and volonteer overly safe
  and taint-free choices when configuring the built-in frames

# Game Directory

World of Warcraft is installed at `~/Games/battlenet/drive_c/Program Files
(x86)/World of Warcraft`.

# Debugging

When the user needs help debugging, read these sources first:

- Saved variable `SquiErrors`: errors and blocked actions with stacks stored in
  the game directory. The client only writes it on `/reload` or logout, so ask
  the user to reload first
- Taint log: `_forever_/Logs/taint.log` in the game directory. Squi sets the
  `taintLog` CVar to `2` at login. The client appends to it live while playing,
  no reload needed

# Coding Conventions

## Practices

- Ad-hoc cookie fields stashed on Blizzard frames or objects should be
  namespaced as `__Squi_<Feature>_<name>`, where `Feature` is the owning Lua
  module and `name` is what the field holds

## Style

- Constants use UPPER_CASE at the top of the file, alpha-sorted
- Functions use PascalCase, alpha-sorted
- Local variable use camelCase, alpha-sorted
- Each module registers configure functions, alpha-sorted
- Use `stylua` to format code

# Coding References

The maintainer of the project may provide well established community addons in
their user directory to serve as reference for specific features. In case of
confusing or unexpected logic in those repository, ask the user to check for
outdated repositories.

Look in `~/Workspace/curse/` when the user attempts at referring to such
projects. The official UI source `wow-ui-source` is also maintained in this
directory by the user and each flavor of the client uses its own Git branch.

# Typings

Use [`wowlua-ls`][github:wowlua-ls]. The maintainer of the project manually
manages this dependency in `~/Workspace/wowlua-ls` and plugs it through Emacs's
`dir-locals` API.

```lisp
((lua-ts-mode
  . ((eglot-server-programs
      . ((lua-ts-mode
          . ("~/Workspace/wowlua-ls/target/release/wowlua_ls")))))))
```

Use `wowlua_ls check .` to validate typings.

[github:wowlua-ls]: https://github.com/TradeSkillMaster/wowlua-ls
