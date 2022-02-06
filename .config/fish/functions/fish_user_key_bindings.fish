function fish_user_key_bindings
  # peco
  bind \cr _fzf_search_history # Bind for peco select history to Ctrl+R
  bind \ct frepo #

  # vim-like
  bind \cn forward-word
  bind \cb backward-word

  bind \cx kill-word
end
