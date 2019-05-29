# dotfiles

Repository for my configurations, particularly for Vim.

## Notes

**Vundle quick installation**

1. Run `git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim`
2. Insert the lines below into your `.vimrc` file
3. Find the plugins you want to install and insert `Plugin 'repo_name/plugin_name'`
4. Run :PluginInstall in vim after sourcing the `.vimrc`

```vimscript
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')
" Plugin calls here
call vundle#end()
```

Alternatively, you can just run `curl https://git.io/vundle-install | sh` for
the same effect.
