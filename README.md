# Dotfiles

# Bootstrap

- install git
- run `git clone --bare https://github.com/DragosRotaru/dotfiles.git "$HOME/.cfg"`
- run `echo ".cfg" >> .gitignore` (im not entirely sure if this is necessary)
- run `git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`
- close the shell and open a new one

