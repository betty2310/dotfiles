local cmd = vim.cmd
local ok, packer = pcall(require, "packer")

if not ok then
    local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
    print "Cloning packer..."
    vim.fn.delete(packer_path, "rf")
    vim.fn.system {
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        "--depth",
        "20",
        packer_path,
    }

    cmd "packadd packer.nvim"
    is_exist_packer, packer = pcall(require, "packer")

    if is_exist_packer then
        print "Packer cloned successfully."
    else
        error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
    end
end

packer.init {
    compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    display = {
        open_fn = function()
            return require("packer.util").float { border = "single" }
        end,
        prompt_border = "single",
    },
    git = {
        clone_timeout = 600,
    },
    auto_clean = true,
    compile_on_sync = true,
    auto_reload_compiled = true,
}

return packer
