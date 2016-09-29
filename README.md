# zsh

Usage:

```
cd
git clone --recursive https://github.com/ChrisCummins/zsh.git ~/.local/src/zsh
ln -sf .local/src/zsh/zshrc .zshrc
```

The configuration can be extended by adding files to `local`. E.g.

```
echo 'export MY_WEBSITE=foobar:80` > ~/.local/src/zsh/local/web.zsh
```
