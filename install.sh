CS_HOME="$(pwd)"
DATE="$(date +%Y%m%d%H%M%S)"

if [ -f ~/.bashrc ]; then
  cp ~/.bashrc "$CS_HOME/backups/.bashrc.bak.$DATE"
  mv –-no-clobber ~/.bashrc "$CS_HOME/.bashrc" 2>/dev/null
  rm ~/.bashrc
fi
ln -s "$CS_HOME/.bashrc" ~/.bashrc

if [ -f ~/.vimrc ]; then
  cp ~/.vimrc "$CS_HOME/backups/.vimrc.bak.$DATE"
  mv –-no-clobber ~/.vimrc "$CS_HOME/.vimrc" 2>/dev/null
  rm ~/.vimrc
fi
ln -s "$CS_HOME/.vimrc" ~/.vimrc

rm -r ~/shell 2>/dev/null
ln -s "$CS_HOME/shell" ~/shell

rm -r ~/.vim 2>/dev/null
ln -s "$CS_HOME/.vim" ~/.vim
