# DOTFILES

## Disclaimer
The files inside the "/link" folder and the program inside "/linker" were tailored for my personal use, tested only on my systems(MacOS and whatever linux distro I'm using rn), feel free to copy some of these but I can't ensure they'll work on your system!!

## Setup

On the **link-map.txt**, write where your folder/file should be linked to like:

`RELATIVE_PATH_TO_FILE_OR_FOLDER:WHERE_THE_SYMLINK_SHOULD_BE_CREATED`

Eg.:

```bash
./link/nvim:~/.config/nvim  #folder
./link/.zsh:~/.zsh          #file
```

- the "link" folder is just a suggestion, you can rename the folder or use more than one, they just have to be properly writen at the link-map.txt

Also, notice that the `origin` path **should** be relative to the working diretory of this project while the `target` path **have** to be an absolute path starting from the user home path ("~/").

> check the functions **getTargetPath** and **getOriginPath** at `linker/src/main.zig` to know why.

## Run the linker program

run on your terminal when inside the project folder:

```bash
./dotfolder
```

### success

On success you'll see where each file/folder ended being liked to like this:

![](/examples/success%20example.png)

### error

On error, the program will tell you what could have gone wrong:

![](/examples/erros%20example.png)