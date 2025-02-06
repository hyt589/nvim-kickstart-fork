-- bootstrap new projects

local os = require 'common.os'
local utils = require 'common.utils'

local slash = os.os_type() == os.OS.Windows and '\\' or '/'
local log_trace = utils.log_trace
local log_info = utils.log_info
local log_error = utils.log_error

local function is_directory(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == 'directory'
end

local function prompt_for_parent_path(callback)
  vim.ui.input({
    prompt = 'Select parent path for new project',
    default = vim.fn.getcwd(),
    completion = 'file',
  }, function(parent_path)
    callback(parent_path)
  end)
end

local function create_baseline_cmake_project(project_path)
  local config_dir = vim.fn.stdpath 'config'
  local resource_dir = config_dir .. slash .. 'resources'
  local cmake_templates_dir = resource_dir .. slash .. 'cmake_templates'
  local cpp_templates_dir = resource_dir .. slash .. 'cpp_templates'

  local cmakelist_src = cmake_templates_dir .. slash .. 'root_baseline.cmake'
  local cmakelist_dst = project_path .. slash .. 'CMakeLists.txt'
  log_trace 'Creating top level CMakeLists.txt'
  utils.copy_file(cmakelist_src, cmakelist_dst)

  local cmake_preset_src = cmake_templates_dir .. slash .. 'cmake_presets_baseline.json'
  local cmake_preset_dst = project_path .. slash .. 'CMakePresets.json'
  log_trace 'Creating CMakePresets.json'
  utils.copy_file(cmake_preset_src, cmake_preset_dst)

  local cmake_module_dir = project_path .. slash .. 'cmake'
  log_trace 'Creating ./cmake directory'
  utils.mkdir(cmake_module_dir)

  local src_dir = project_path .. slash .. 'src'
  log_trace 'Creating ./src directory'
  utils.mkdir(src_dir)

  local src_cmakelist_src = cmake_templates_dir .. slash .. 'src_baseline.cmake'
  local src_cmakelist_dst = src_dir .. slash .. 'CMakeLists.txt'
  log_trace 'Creating ./src/CMakeLists.txt'
  utils.copy_file(src_cmakelist_src, src_cmakelist_dst)

  local hello_world_src = cpp_templates_dir .. slash .. 'hello_world.cpp'
  local hello_world_dst = src_dir .. slash .. 'main.cpp'
  log_trace 'Creating ./src/main.cpp'
  utils.copy_file(hello_world_src, hello_world_dst)
end

local function create_vcpkg_project(project_path)
  create_baseline_cmake_project(project_path)

  local config_dir = vim.fn.stdpath 'config'
  local resource_dir = config_dir .. slash .. 'resources'
  local cmake_templates_dir = resource_dir .. slash .. 'cmake_templates'
  local cmake_module_dir = project_path .. slash .. 'cmake'

  local module_vcpkg_src = cmake_templates_dir .. slash .. 'module_vcpkg.cmake'
  local module_vcpkg_dst = cmake_module_dir .. slash .. 'vcpkg.toolchain.cmake'
  log_trace 'Creating ./cmake/vcpkg.toolchain.cmake'
  utils.copy_file(module_vcpkg_src, module_vcpkg_dst)

  local cmakelist_src = cmake_templates_dir .. slash .. 'root_vcpkg.cmake'
  local cmakelist_dst = project_path .. slash .. 'CMakeLists.txt'
  log_trace 'Adding vcpkg config to top level CMakeLists.txt'
  utils.copy_file(cmakelist_src, cmakelist_dst)

  local cmake_preset_src = cmake_templates_dir .. slash .. 'cmake_presets_vcpkg.json'
  local cmake_preset_dst = project_path .. slash .. 'CMakePresets.json'
  log_trace 'Overriding default CMakePresets.json with vcpkg options'
  utils.copy_file(cmake_preset_src, cmake_preset_dst)
end

local ProjectTypes = {
  CMakeSimple = {
    name = 'Simple CMake Project',
    initializer = function(project_path)
      create_baseline_cmake_project(project_path)
      log_info 'done'
    end,
  },
  CMakeVcpkg = {
    name = 'CMake with Vcpkg',
    initializer = function(project_path)
      create_vcpkg_project(project_path)
      log_info 'done'
    end,
  },
  CMakeCPM = {
    name = 'CMake with CPM',
    initializer = function(project_path)
      log_info 'Unimplmented'
    end,
  },
}

local function table_values(t)
  local result = {}
  for _, v in pairs(t) do
    result[#result + 1] = v
  end
  return result
end

local function bootstrap()
  vim.ui.select(table_values(ProjectTypes), {
    prompt = 'Select a project type',
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    prompt_for_parent_path(function(parent_path)
      if not is_directory(parent_path) then
        log_error(parent_path .. ' is not a directory')
        return
      end
      vim.ui.input({ prompt = 'Enter a name for the project' }, function(name)
        local project_path = parent_path .. slash .. name
        if not utils.mkdir(project_path) then
          log_error(project_path .. ' already exists! Use a different name or path.')
          return
        end
        choice.initializer(project_path)
        vim.fn.chdir(project_path)
      end)
    end)
    -- return choice.initializer()
  end)
end

vim.api.nvim_create_user_command('ProjectInit', bootstrap, {})
vim.keymap.set('n', '<leader>pg', bootstrap, { desc = 'Generate a new project' })
