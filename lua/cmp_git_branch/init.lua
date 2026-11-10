-- cmp-git-branch: gitブランチ名を補完する nvim-cmp ソース
--
-- source option:
--   strip_remote (default false): trueでリモート名(origin/等)を外し、
--                                 ローカルと同名のブランチは1件にまとめる
local M = {}

local source = {}

function source:is_available()
  local cwd = vim.fn.getcwd() .. ';'
  return vim.fn.finddir('.git', cwd) ~= '' or vim.fn.findfile('.git', cwd) ~= ''
end

function source:get_keyword_pattern()
  return [[\%(\k\|[/.-]\)\+]]
end

function source:complete(params, callback)
  local cmp = require('cmp')
  local option = vim.tbl_extend('force', { strip_remote = false }, params.option or {})
  vim.system(
    { 'git', 'for-each-ref', '--format=%(refname)', 'refs/heads', 'refs/remotes' },
    { text = true },
    vim.schedule_wrap(function(res)
      local items, seen = {}, {}
      for line in (res.stdout or ''):gmatch('[^\n]+') do
        local name = line:match('^refs/heads/(.+)$')
        if not name then
          local remote_name = line:match('^refs/remotes/(.+)$')
          if remote_name then
            local branch = remote_name:match('^[^/]+/(.+)$')
            if branch ~= 'HEAD' then -- origin/HEAD は除外
              name = option.strip_remote and branch or remote_name
            end
          end
        end
        if name and not seen[name] then
          seen[name] = true
          table.insert(items, { label = name, kind = cmp.lsp.CompletionItemKind.Reference })
        end
      end
      callback({ items = items, isIncomplete = false })
    end)
  )
end

-- cmp にソース `git_branch` を登録する
function M.setup()
  require('cmp').register_source('git_branch', source)
end

return M
