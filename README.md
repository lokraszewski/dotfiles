# dotfiles
My personal dotfile setup.

## Install
### Packages
This setup requires some packages to be installed, you can use the provided script:
```
sudo ./packages.sh
```

### stow
To create symlinks to  your dotfiles run:
```
./install.zsh
```

### change default shell
This setup uses `zsh` so I would recommend installing that:
```
chsh -s $(which zsh)
```

## docker
You can run this setup in a docker container to check it out. Build the image like so:
```
❯ docker-compose build
Successfully tagged lokraszewski.dotfiles:latest
```

Then run:
```
❯ docker run -it --rm dotfiles_dotfiles:latest /bin/zsh   
```

# LICENSE
All the source code in this repository is covered by the MIT license.
