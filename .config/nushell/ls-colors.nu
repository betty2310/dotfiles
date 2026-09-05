# ls filename styles, using the terminal's theme palette.
# Loaded by config.nu. Edit ls_styles below to change a category in one place.
#
# ANSI color reference:
# Color          Text (foreground)   Background
# Black          30                  40
# Red            31                  41
# Green          32                  42
# Yellow         33                  43
# Blue           34                  44
# Magenta        35                  45
# Cyan           36                  46
# White          37                  47
# Default        39                  49
# Bright colors: text 90-97, backgrounds 100-107, in the same order.
# These names refer to palette slots; Ghostty's active theme decides their shades.
#
# Attributes: 0 = reset, 1 = bold, 2 = dim, 3 = italic, 4 = underline.
# Combine attributes, text and background with semicolons:
#   "0;30;43" = black text on yellow
#   "0;37;42" = white text on green
#   "1;97;44" = bold bright-white text on blue
#   "3;36"    = italic cyan, default background
# Edit a project_* style below to change that ecosystem, e.g. project_node: "0;37;42".

let ls_styles = {
    normal: "0"                         # Default terminal text
    directory: "1;36"                   # Bold cyan
    alert: "0;30;41"                    # Black text on red
    symlink: "3;31"                     # Italic red
    char_device: "0;31;100"             # Red text on bright black
    executable: "1;31"                  # Bold red
    broken_symlink: "3;30;41"           # Italic black text on red
    block_device: "0;36;100"            # Cyan text on bright black
    generated: "0;90"                   # Bright black, usually gray
    pipe: "0;30;46"                     # Black text on cyan
    archive: "4;31"                     # Underlined red
    source_config: "0;32"               # Green
    document: "0;33"                    # Yellow
    media: "0;35"                       # Magenta
    todo: "1"                           # Bold default text
    readme: "0;30;43"                   # Black text on yellow
    license: "0;37"                     # White
    # Ecosystem-inspired accents using theme colors, not fixed brand RGB values.
    project_node: "0;30;42"             # JavaScript runtimes: black on green
    project_go: "0;30;46"               # Go: black on cyan
    project_dotnet: "0;30;44"           # .NET: white on blue
    project_python: "0;30;43"           # Python: black on yellow
    project_rust: "0;30;41"             # Rust: white on red, a warm ANSI accent
    project_jvm: "0;30;41"              # Java/Gradle: white on red
    project_kotlin: "0;30;45"           # Kotlin build scripts: white on magenta
    project_ruby: "0;30;41"             # Ruby: white on red
    project_php: "0;30;45"              # PHP: white on magenta
    project_swift: "0;30;41"            # Swift: white on red, a warm ANSI accent
    project_flutter: "0;30;46"          # Dart/Flutter: black on cyan
    project_elixir: "0;30;45"           # Elixir: white on magenta
    project_erlang: "0;30;41"           # Erlang: white on red
    project_container: "0;30;44"        # Container tooling: white on blue
    project_build: "0;30;43"            # Shared build tools: black on yellow
}

# Each rule maps an ls selector to a named style above.
# di = directory; ln = symlink; or = broken symlink; ex = executable;
# st/ow/tw = sticky or writable directories; fi/no = ordinary/default files;
# so = socket; pi = pipe; cd/bd = devices; mi = missing target.
# * patterns match filename suffixes. Later matches take precedence.
# File categories adapted from Nushell 0.115.1 defaults.
let ls_rules = [
    "st=directory:di=directory:so=alert:ln=symlink:cd=char_device:ex=executable:or=broken_symlink:fi=normal"
    "bd=block_device:ow=directory:mi=alert:*~=generated:no=normal:tw=directory:pi=pipe:*.z=archive"
    "*.t=source_config:*.o=generated:*.d=source_config:*.a=executable:*.c=source_config:*.m=source_config"
    "*.p=source_config:*.r=source_config:*.h=source_config:*.ml=source_config:*.ll=source_config"
    "*.gv=source_config:*.cp=source_config:*.xz=archive:*.hs=source_config:*css=source_config"
    "*.ui=source_config:*.pl=source_config:*.ts=source_config:*.gz=archive:*.so=executable:*.cr=source_config"
    "*.fs=source_config:*.bz=archive:*.ko=executable:*.as=source_config:*.sh=source_config:*.pp=source_config"
    "*.el=source_config:*.py=source_config:*.lo=generated:*.bc=generated:*.cc=source_config:*.pm=source_config"
    "*.rs=source_config:*.di=source_config:*.jl=source_config:*.rb=source_config:*.md=document"
    "*.js=source_config:*.cjs=source_config:*.mjs=source_config:*.go=source_config:*.vb=source_config"
    "*.hi=generated:*.kt=source_config:*.hh=source_config:*.cs=source_config:*.mn=source_config"
    "*.nb=source_config:*.7z=archive:*.ex=source_config:*.rm=media:*.ps=document:*.td=source_config"
    "*.la=generated:*.aux=generated:*.xmp=source_config:*.mp4=media:*.rpm=archive:*.m4a=media:*.zip=archive"
    "*.dll=executable:*.bcf=generated:*.awk=source_config:*.aif=media:*.zst=archive:*.bak=generated"
    "*.tgz=archive:*.com=executable:*.clj=source_config:*.sxw=document:*.vob=media:*.fsx=source_config"
    "*.doc=document:*.mkv=media:*.tbz=archive:*.ogg=media:*.wma=media:*.mid=media:*.kex=document"
    "*.out=generated:*.ltx=source_config:*.sql=source_config:*.ppt=document:*.tex=source_config:*.odp=document"
    "*.log=generated:*.arj=archive:*.ipp=source_config:*.sbt=source_config:*.jpg=media:*.yml=source_config"
    "*.txt=document:*.csv=document:*.dox=source_config:*.pro=source_config:*.bst=source_config:*TODO=todo"
    "*.mir=source_config:*.bat=executable:*.m4v=media:*.pod=source_config:*.cfg=source_config"
    "*.pas=source_config:*.tml=source_config:*.bib=source_config:*.ini=source_config:*.apk=archive"
    "*.h++=source_config:*.pyc=generated:*.img=archive:*.rst=document:*.swf=media:*.htm=document:*.ttf=media"
    "*.elm=source_config:*hgrc=source_config:*.bmp=media:*.fsi=source_config:*.pgm=media:*.dpr=source_config"
    "*.xls=document:*.tcl=source_config:*.mli=source_config:*.ppm=media:*.bbl=generated:*.lua=source_config"
    "*.asa=source_config:*.pbm=media:*.avi=media:*.def=source_config:*.mov=media:*.hxx=source_config"
    "*.tif=media:*.fon=media:*.zsh=source_config:*.png=media:*.inc=source_config:*.jar=archive:*.swp=generated"
    "*.pid=generated:*.gif=media:*.ind=generated:*.erl=source_config:*.ilg=generated:*.eps=media"
    "*.tsx=source_config:*.git=generated:*.inl=source_config:*.rtf=document:*.hpp=source_config"
    "*.kts=source_config:*.deb=archive:*.svg=media:*.pps=document:*.ps1=source_config:*.c++=source_config"
    "*.cpp=source_config:*.bsh=source_config:*.php=source_config:*.exs=source_config:*.toc=generated"
    "*.mp3=media:*.epp=source_config:*.rar=archive:*.wav=media:*.xlr=document:*.tmp=generated"
    "*.cxx=source_config:*.iso=archive:*.dmg=archive:*.gvy=source_config:*.bin=archive:*.wmv=media"
    "*.blg=generated:*.ods=document:*.psd=media:*.mpg=media:*.dot=source_config:*.cgi=source_config"
    "*.xml=document:*.htc=source_config:*.ics=document:*.bz2=archive:*.tar=archive:*.csx=source_config"
    "*.ico=media:*.sxi=document:*.nix=source_config:*.pkg=archive:*.bag=archive:*.fnt=media:*.idx=generated"
    "*.xcf=media:*.exe=executable:*.flv=media:*.fls=generated:*.otf=media:*.vcd=archive:*.vim=source_config"
    "*.sty=generated:*.pdf=document:*.odt=document:*.purs=source_config:*.h264=media:*.jpeg=media"
    "*.dart=source_config:*.pptx=document:*.lock=generated:*.bash=source_config:*.rlib=generated"
    "*.hgrc=source_config:*.psm1=source_config:*.toml=source_config:*.tbz2=archive:*.yaml=source_config"
    "*.make=source_config:*.orig=generated:*.html=document:*.fish=source_config:*.diff=source_config"
    "*.xlsx=document:*.docx=document:*.json=source_config:*.psd1=source_config:*.tiff=media:*.flac=media"
    "*.java=source_config:*.less=source_config:*.mpeg=media:*.conf=source_config:*.lisp=source_config"
    "*.epub=document:*.cabal=source_config:*.patch=source_config:*.shtml=document:*.class=generated"
    "*.xhtml=document:*.mdown=document:*.dyn_o=generated:*.cache=generated:*.swift=source_config"
    "*README=readme:*passwd=source_config:*.ipynb=source_config:*shadow=source_config:*.toast=archive"
    "*.cmake=source_config:*.scala=source_config:*.dyn_hi=generated:*.matlab=source_config"
    "*.config=source_config:*.gradle=source_config:*.groovy=source_config:*.ignore=source_config"
    "*LICENSE=license:*TODO.md=todo:*COPYING=license:*.flake8=source_config:*INSTALL=readme"
    "*setup.py=source_config:*.gemspec=source_config:*.desktop=source_config:*Makefile=source_config"
    "*Doxyfile=source_config:*TODO.txt=todo:*README.md=readme:*.kdevelop=source_config"
    "*.rgignore=source_config:*configure=source_config:*.DS_Store=generated:*.fdignore=source_config"
    "*COPYRIGHT=license:*.markdown=document:*.cmake.in=source_config:*.gitconfig=source_config"
    "*INSTALL.md=readme:*CODEOWNERS=source_config:*.gitignore=source_config:*Dockerfile=source_config"
    "*SConstruct=source_config:*.scons_opt=generated:*README.txt=readme:*SConscript=source_config"
    "*.localized=generated:*.travis.yml=document:*Makefile.in=generated:*.gitmodules=source_config"
    "*LICENSE-MIT=license:*Makefile.am=source_config:*INSTALL.txt=readme:*MANIFEST.in=source_config"
    "*.synctex.gz=generated:*.fdb_latexmk=generated:*CONTRIBUTORS=readme:*configure.ac=source_config"
    "*.applescript=source_config:*appveyor.yml=document:*.clang-format=source_config"
    "*.gitattributes=source_config:*LICENSE-APACHE=license:*CMakeCache.txt=generated"
    "*CMakeLists.txt=source_config:*CONTRIBUTORS.md=readme:*requirements.txt=source_config"
    "*CONTRIBUTORS.txt=readme:*.sconsign.dblite=generated:*package-lock.json=generated"
    "*.CFUserTextEncoding=generated:*.fb2=document:*.nu=source_config"

    # Project highlights override the general extension styles.
    # Match each file's ecosystem by filename; no directory/project inspection.
    # Shared build tools keep a neutral accent because they serve many languages.
    "*package.json=project_node:*deno.json=project_node:*deno.jsonc=project_node"
    "*pnpm-workspace.yaml=project_node:*bunfig.toml=project_node"
    "*go.mod=project_go:*go.work=project_go:*Cargo.toml=project_rust"
    "*pyproject.toml=project_python:*requirements.txt=project_python:*setup.py=project_python"
    "*setup.cfg=project_python:*Pipfile=project_python"
    "*.sln=project_dotnet:*.slnx=project_dotnet:*.csproj=project_dotnet:*.fsproj=project_dotnet"
    "*.vbproj=project_dotnet:*global.json=project_dotnet:*Directory.Build.props=project_dotnet"
    "*Directory.Build.targets=project_dotnet:*Directory.Packages.props=project_dotnet:*NuGet.Config=project_dotnet"
    "*pom.xml=project_jvm:*build.gradle=project_jvm:*settings.gradle=project_jvm"
    "*build.gradle.kts=project_kotlin:*settings.gradle.kts=project_kotlin"
    "*Makefile=project_build:*GNUmakefile=project_build:*CMakeLists.txt=project_build"
    "*meson.build=project_build:*justfile=project_build:*Taskfile.yml=project_build:*Taskfile.yaml=project_build"
    "*Gemfile=project_ruby:*composer.json=project_php:*Package.swift=project_swift"
    "*pubspec.yaml=project_flutter:*mix.exs=project_elixir:*rebar.config=project_erlang"
    "*Dockerfile=project_container:*Containerfile=project_container"
    "*compose.yaml=project_container:*compose.yml=project_container"
    "*docker-compose.yaml=project_container:*docker-compose.yml=project_container"
]

$env.LS_COLORS = (
    $ls_rules
    | str join ":"
    | split row ":"
    | each {|rule|
        let parts = ($rule | split row "=")
        $"($parts.0)=($ls_styles | get $parts.1)"
    }
    | str join ":"
)
