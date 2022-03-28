function frepo
  cd ~/ghq 
  cd (ghq list | fzf -e --prompt="הּ " --layout=reverse --height=50% --border --margin=1 --padding=1 --preview "ls -A1 {} | head -200")
end
