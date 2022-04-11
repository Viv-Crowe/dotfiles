# Dotfiles

# Bootstrap

- install git
- run `git clone --bare https://github.com/DragosRotaru/dotfiles.git "$HOME/.cfg"`
- run `echo ".cfg" >> .gitignore` (im not entirely sure if this is necessary)
- run `git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`
- run `source .bash_profile`
- run `dotfiles config --local status.showUntrackedFiles no`
