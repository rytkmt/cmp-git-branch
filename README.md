# cmp-git-branch

gitブランチ名を補完する [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) ソース。

## インストール（lazy.nvim）

```lua
{
  "rytkmt/cmp-git-branch",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    require("cmp_git_branch").setup() -- ソース `git_branch` を登録
  end,
}
```

## 使い方

```lua
require("cmp").setup({
  sources = {
    {
      name = "git_branch",
      keyword_length = 2,
      option = { strip_remote = true },
    },
  },
})
```

## オプション

| 名前 | 既定値 | 説明 |
| --- | --- | --- |
| `strip_remote` | `false` | `true` でリモート名（`origin/` 等）を外し、ローカルと同名のブランチは1件にまとめる。`origin/HEAD` は常に除外 |

## 補足

- カレントディレクトリ（cwd）から上位に `.git` が見つかるときだけ有効。
- 補完ラベルの種別表示は既定で `Reference`。変更したい場合は `formatting.format` で差し替える。

```lua
formatting = {
  format = function(entry, item)
    if entry.source.name == "git_branch" then
      item.kind = "Branch"
    end
    return item
  end,
},
```
