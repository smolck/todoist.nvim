package.loaded['nvim-todoist'] = nil
local vim = vim
local rapidjson = require('rapidjson')
local base_uri = 'https://api.todoist.com/rest/v1'
local api = {}

local function auth_str(api_key)
  return '"Authorization: Bearer ' .. api_key .. '"'
end

function api.fetch_active_tasks(api_key, cb)
  vim.fn.jobstart(
    string.format('curl -X GET "%s" -H %s', base_uri .. '/tasks', auth_str(api_key)),
    {
      stdout_buffered = true,
      on_stdout =
        function(_, d, _)
          local json = rapidjson.decode(table.concat(d))
          cb(json)
        end,
    }
  )
end

function api.fetch_projects(api_key, cb)
  vim.fn.jobstart(
    string.format('curl -X GET "%s" -H %s', base_uri .. '/projects', auth_str(api_key)),
    {
      stdout_buffered = true,
      on_stdout =
        function(_, d, _)
          local json = rapidjson.decode(table.concat(d))
          cb(json)
        end,
    }
  )
end

function api.update_task(api_key, task_id, data)
  vim.fn.jobstart(
    string.format(
      'curl -X POST "%s" -H %s --data \'%s\'',
      base_uri .. '/tasks/' .. tostring(task_id),
      auth_str(api_key),
      rapidjson.encode(data)
    )
  )
end

function api.close_task(api_key, task_id)
  vim.fn.jobstart(
    string.format(
      'curl -X POST "%s" -H %s',
      base_uri .. '/tasks/' .. tostring(task_id) .. '/close',
      auth_str(api_key)
    )
  )
end

function api.reopen_task(api_key, task_id)
  vim.fn.jobstart(
    string.format(
      'curl -X POST "%s" -H %s',
      base_uri .. '/tasks/' .. tostring(task_id) .. '/reopen',
      auth_str(api_key)
    )
  )
end

return api
