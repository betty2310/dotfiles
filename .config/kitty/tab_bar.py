"""Custom kitty tab bar — mirrors the tmux status style.

Left:  rounded chips, accent bg for the active tab, dim grey for inactive,
       with the foreground command and the active window's cwd basename.
Right: a rounded "kitty" chip in the theme's yellow.

Colors are pulled from the live kitty options on every draw so the bar
follows runtime theme swaps (`set_colors -a -c <theme>`) without any
manual reload.
"""

import os
import re
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb


LEFT_CAP  = ''  #
RIGHT_CAP = ''  #
ICON      = '󰄛'  # 󰄛 nerd-font kitty glyph
LABEL     = 'kitty'
TAB_GAP   = '  '          # space between tabs
EDGE_PAD  = '  '          # padding inside the bar at the far left/right

SHELL_EXES = {'fish', 'zsh', 'bash', 'sh', 'dash', 'ksh', 'tcsh', 'csh'}
CLAUDE_VERSION_RE = re.compile(r'^\d+(\.\d+)+$')

# SSH short options that consume the next argument as their value.
SSH_OPTS_WITH_VALUE = frozenset({
    '-b', '-B', '-c', '-D', '-E', '-e', '-F', '-I', '-i', '-J',
    '-L', '-l', '-m', '-O', '-o', '-p', '-Q', '-R', '-S', '-W', '-w',
})


def _color_int(c) -> int:
    """Convert a kitty Color (or already-int color) into a packed 0xRRGGBB int."""
    try:
        return int(c)
    except TypeError:
        return (c.red << 16) | (c.green << 8) | c.blue


def _palette() -> dict:
    """Chip palette derived from the current kitty options. Re-evaluated on
    every draw so the bar tracks runtime `set_colors` swaps between light
    and dark themes."""
    o = get_options()
    bg = as_rgb(_color_int(o.background))
    return {
        'bar_bg':  bg,                              # bar fill = terminal bg
        'chip_fg': bg,                              # chip text = bg → contrast vs accent
        'blue':    as_rgb(_color_int(o.color4)),   # active tab accent
        'yellow':  as_rgb(_color_int(o.color3)),   # right-side status accent
        'dim':     as_rgb(_color_int(o.color8)),   # inactive tab text
    }


def _exe_of(cmdline) -> str:
    if not cmdline:
        return ''
    exe = os.path.basename(cmdline[0])
    if exe.startswith('-'):  # login shell, e.g. "-fish"
        exe = exe[1:]
    return exe


def _ssh_host(cmdline) -> str:
    """Return the hostname argument from an ssh cmdline, '' if absent."""
    args = list(cmdline)[1:]
    i = 0
    while i < len(args):
        a = args[i]
        if a.startswith('-'):
            # `-p 22` consumes 2 args; `-p22` is one combined arg.
            if a in SSH_OPTS_WITH_VALUE and i + 1 < len(args):
                i += 2
            else:
                i += 1
            continue
        return a.split('@', 1)[-1]
    return ''


def _shorten_cwd(path: str) -> str:
    if not path:
        return ''
    home = os.path.expanduser('~')
    if path == home:
        return '~'
    base = os.path.basename(path.rstrip('/'))
    return base or path


def _active_window(tab: TabBarData):
    try:
        boss = get_boss()
        for t in boss.all_tabs:
            if t.id == tab.tab_id:
                return t.active_window
    except Exception:
        pass
    return None


def _active_cwd(tab: TabBarData) -> str:
    win = _active_window(tab)
    if win is None:
        return ''
    return _shorten_cwd(
        win.child.foreground_cwd or win.child.current_cwd or ''
    )


def _command_label(tab: TabBarData) -> str:
    """Return a short label for the foreground command, mirroring the
    tmux automatic-rename rules. Empty when only a bare shell is running.

    Scans every process in the foreground process group so Claude Code wins
    over child processes it spawns (e.g. `fff-mcp`).
    """
    win = _active_window(tab)
    if win is None:
        return ''
    try:
        procs = list(win.child.foreground_processes or [])
    except Exception:
        procs = []

    cmdlines = []
    for p in procs:
        cl = p.get('cmdline') if isinstance(p, dict) else getattr(p, 'cmdline', None)
        if cl:
            cmdlines.append(list(cl))
    if not cmdlines:
        return ''

    # 1) Claude Code — name is a version string like "1.0.5", or literally "claude".
    for cl in cmdlines:
        exe = _exe_of(cl)
        if exe == 'claude' or CLAUDE_VERSION_RE.match(exe):
            return 'claude'

    # 2) Codex.
    for cl in cmdlines:
        if 'codex' in _exe_of(cl).lower():
            return 'codex'

    # 3) SSH — show the hostname.
    for cl in cmdlines:
        if _exe_of(cl) == 'ssh':
            host = _ssh_host(cl)
            return f'ssh {host}' if host else 'ssh'

    # 4) First non-shell process.
    for cl in cmdlines:
        exe = _exe_of(cl)
        if exe and exe not in SHELL_EXES:
            return exe

    return ''


def _draw_chip(screen: Screen, text: str, fg: int, bg: int, cap_bg: int) -> None:
    screen.cursor.fg = bg
    screen.cursor.bg = cap_bg
    screen.draw(LEFT_CAP)
    screen.cursor.fg = fg
    screen.cursor.bg = bg
    screen.draw(text)
    screen.cursor.fg = bg
    screen.cursor.bg = cap_bg
    screen.draw(RIGHT_CAP)


def _draw_bar_fill(screen: Screen, text: str, bar_bg: int) -> None:
    screen.cursor.fg = bar_bg
    screen.cursor.bg = bar_bg
    screen.draw(text)


def _draw_right_status(screen: Screen, p: dict) -> None:
    body = f' {ICON}  {LABEL} '
    width = len(body) + 2 + len(EDGE_PAD)  # +2 caps, +trailing pad
    target_x = screen.columns - width
    if target_x <= screen.cursor.x:
        _draw_bar_fill(screen, EDGE_PAD, p['bar_bg'])
        return

    _draw_bar_fill(screen, ' ' * (target_x - screen.cursor.x), p['bar_bg'])
    _draw_chip(screen, body, p['chip_fg'], p['yellow'], p['bar_bg'])
    _draw_bar_fill(screen, EDGE_PAD, p['bar_bg'])


def _truncate(text: str, limit: int) -> str:
    if limit <= 0:
        return ''
    if len(text) <= limit:
        return text
    if limit == 1:
        return '…'
    return text[: limit - 1] + '…'


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData,
) -> int:
    p = _palette()

    if index == 1:
        _draw_bar_fill(screen, EDGE_PAD, p['bar_bg'])

    cwd = _active_cwd(tab)
    cmd = _command_label(tab)

    if cmd:
        body = f' {index} {cmd} [{cwd}] '
    else:
        body = f' {index} [{cwd}] ' if cwd else f' {index} '

    cap_cells = 2 if tab.is_active else 0
    body = _truncate(body, max(0, max_title_length - cap_cells))

    if tab.is_active:
        _draw_chip(screen, body, p['chip_fg'], p['blue'], p['bar_bg'])
    else:
        screen.cursor.fg = p['dim']
        screen.cursor.bg = p['bar_bg']
        screen.draw(body)

    if not is_last:
        _draw_bar_fill(screen, TAB_GAP, p['bar_bg'])
    else:
        _draw_right_status(screen, p)

    return screen.cursor.x
