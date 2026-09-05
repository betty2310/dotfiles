$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"

$env.GOPATH = $"($env.HOME)/Developer/Packages/go"
$env.BUN_INSTALL = $"($env.HOME)/.bun"
$env.DOTNET_ROOT = "/usr/local/share/dotnet"

$env.PATH ++= ["/usr/local/bin"]
$env.PATH ++= ["/opt/local/bin", "/opt/local/sbin"]
$env.PATH ++= [$"($env.HOME)/.dotnet/tools"]
$env.PATH ++= ["/Users/betty/Library/Python/3.9/bin"]
$env.PATH ++= ["/Users/betty/Developer/gnss-tools/gnss-sdr/install"]
$env.PATH ++= ["/Users/betty/Developer/gnss-tools/gps-sdr-sim/"]
$env.PATH ++= [$"($env.BUN_INSTALL)/bin"]
$env.PATH ++= [$env.DOTNET_ROOT]
$env.PATH ++= ["/Users/betty/.orbstack/bin"]


alias g = git
alias vi = nvim
alias lg = lazygit


# Filename colors and styles for ls.
source ls-colors.nu

# alias the built-in ls command to ls-builtins
alias ls-builtin = ls

def ls [
    --all (-a),         # Show hidden files
    --long (-l),        # Get all available columns for each entry (slower; columns are platform-dependent)
    --short-names (-s), # Only print the file names, and not the path
    --full-paths (-f),  # display paths as absolute paths
    --du (-d),          # Display the apparent directory size ("disk usage") in place of the directory metadata size
    --directory (-D),   # List the specified directory itself instead of its contents
    --mime-type (-m),   # Show mime-type in type column instead of 'file' (based on filenames only; files' contents are not examined)
    --threads (-t),     # Use multiple threads to list contents. Output will be non-deterministic.
    ...pattern: glob,   # The glob pattern to use.
]: [ nothing -> table ] {
    let pattern = if ($pattern | is-empty) { [ '.' ] } else { $pattern }
    (ls-builtin
        --all=$all
        --long=$long
        --short-names=$short_names
        --full-paths=$full_paths
        --du=$du
        --directory=$directory
        --mime-type=$mime_type
        --threads=$threads
        ...$pattern
    ) | sort-by type name -i
}

alias core-ssh = ssh

def --wrapped ssh [...args: string] {
    ^ghostty +ssh -- ...$args
}

source ~/.zoxide.nu

if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use --install-if-missing --silent-if-unchanged}
        }
    )
}

$env.PATH = ($env.PATH | uniq)
