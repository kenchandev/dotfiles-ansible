# dotfiles-ansible

This repository contains my opinionated macOS dotfiles. With one single command, the `bin/bootstrap.sh` shell script uses Ansible Playbooks and Homebrew to provision brand new macOS machines into fully-configured development environments. The automated setup includes configurations for Zsh shell, Neovim, Kitty, Tmux, Git, and much more.

![Preview of Neovim](https://www.dl.dropboxusercontent.com/scl/fi/jv6u1vby53c0d6rd0xiuo/neovim-preview.png?rlkey=v7siycpact5z4yhx44d5xd1ow&raw=1)

![Preview of Neovim Telescope](https://www.dl.dropboxusercontent.com/scl/fi/02b2kykvxf1i0xw6jvb43/neovim-telescope-preview.png?rlkey=6qps0qrde65txts10r6j6adf5&raw=1)

![Preview of Kitty Terminal that's customized with Starship](https://www.dl.dropboxusercontent.com/scl/fi/voy3pt9xmai7gzaeou5yb/kitty-starship-preview.png?rlkey=iu0dh33yehbybr8wsmw9zv550&raw=1)

## Installation and Setup

> [!WARNING]
> Please don't blindly use these dotfiles. Before proceeding further, you should first fork this repository, review the code, and make any modifications based on your own set of preferences. 

1. Download this repository to your local machine.

2. Rename the `.env_sample` file to `.env`, and replace the example environment variable values with your actual configuration details.

3. Grant "Files & Folders" permissions to the "Terminal" application (`System Settings → Privacy & Security → Files & Folders`). This allows the `bin/bootstrap.sh` script to create a virtual environment for running Ansible. 

4. Open the "Terminal" application from the `~/Applications/Utilities` directory.

5. (Optional) Since several of the tools/utilities executed by the `bin/bootstrap.sh` script require elevated privileges, the `bin/bootstrap.sh` script will occassionally prompt you for your password as it runs. For a truly non-interactive experience (i.e., only entering your password just once when `bin/bootstrap.sh` begins execution and allowing the `bin/bootstrap.sh` script to run uninterrupted), you can run `sudo visudo` and add the following line to the sudoers file: 

  ```
  Defaults        timestamp_timeout = 180
  ```
  
  `timestamp_timeout` sets the sudo credential timeout to 180 minutes (3 hours). An extended timeout means you will only need to enter your password just once when `bin/bootstrap.sh` begins execution. This is particularly helpful when installing Xcode and other large packages that require significant download and installation time.

6. Within the root of this project directory, run the `bin/bootstrap.sh` script.

  ```shell
  $ sh bin/bootstrap.sh
  ```

  Feel free to walk away from your machine as the `bin/bootstrap.sh` script fully provisions your machine.

## Overriding Defaults

If you need to override any of the following installed items:

* Homebrew taps, packages, and casks
* macOS applications
* Neovim plugins
* Tmmux plugins
* VSCode plugins 
* Zsh plugins

Then modify the `group_vars/local.yml` file accordingly and re-run the appropriate Ansible tasks via Ansible playbook. For example, if you want to also install the GitHub Desktop client via Homebrew, then add it to the list of Homebrew casks under `homebrew.cask_applications`. Lastly, run the Ansible tasks that are tagged with "homebrew," like so:

```shell
$ ansible-playbook -v -i "./hosts" "./local_env.yml" --tags "homebrew"
```

If you need to modify a specific dotfile, then...

1. Find it under the `templates` directory of the corresponding role. For example, the `.zshenv` dotfile can be found under the `roles/zsh/templates` directory.
2. Once you have modified the dotfile, re-run the appropriate Ansible tasks via Ansible playbook. For example, if you modified the `.zshenv` dotfile, then you can run the Ansible tasks that are tagged with "zsh," and the modified `.zshenv` dotfile will replace the previous `.zshenv` dotfile in your machine's `$HOME` directory. 