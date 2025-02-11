# dotfiles

This repository contains my dotfiles and system configuration.

## Setting up a new machine

with the thumb drive:

```sh
bash /run/media/$USER/remo/setup/setup.sh
```

otherwise:

```sh
source <(curl -L raw.githubusercontent.com/senekor/dotfiles/main/.install_1password.sh)
BINDIR="$HOME/.local/bin" sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply senekor --source ~/repos/github/senekor/dotfiles
```

## Manual post-setup

- Firefox:
  - Login to sync
  - Toolbar:
    - 1Password
    - Checker Plus for Gmail
    - Dark Reader
    - Vimium
    - Undo Close Tab
    - Downloads
- Update gnome-keyring password
- syncthing
- Sign into Google (drive and calendar integration)

## Thoughts on chezmoi

I was sceptical of chezmoi at first, since my bash scripts and symlinks had been serving me well for a long time.

My experience _migrating_ was that for a small to moderate amount of initial effort, I got a small to moderate amount of lower complexity / more efficient workflow.
A good deal in my book, but nothing mind blowing.

That being said, I absolutely recommend _starting off_ with chezmoi right away when setting up your dotfiles.
That way the workflow will be smoother from the start and there won't be any migration work.

And here are the concrete reasons chezmoi is (in my opinion) an improvement once the investment of the setup / learning has been made:

- chezmoi can run your scripts only when their contents change.
  This makes it very easy to write setup scripts that don't do redundant work.
  I have dismissed this argument before, since "a simple if-statement in Bash does the trick".
  Turns out I was wrong.
  Immediately after migrating to chezmoi, my setup scripts were significantly quicker, just by _doing less_.

- Managing diverging configurations without branches.
  A typical use case: Personal computer, work computer, home server.
  Branches work fine if you're used to git and rebasing regularly isn't that bad either.
  But it doesn't scale well: More diverging configuration means more manual work.
  chezmoi templates are nice because you can see all the different versions of a configuration in a single spot.
  More templates don't imply more manual maintenance.

- Some (bad) tools may require credentials to be stored in config files / your home directory.
  chezmoi templates are integrated with your password manager, so you can keep your dotfiles public.
  Again, this _can_ be achieved with bash (as is always the case), but it would be so complex as to not be worth it.

Some small annoyances with chezmoi:

- Its behavior is largely driven by magical file pre- and suffixes.
  I think this makes sense, but the file structure of your dotfiles does become a little less readable.
  Turning a config file into a template breaks syntax highlighting, oh well...
  But turning a _script_ into a template breaks the LSP!
  When editing a templated script, one should remember to temporarily remove the `.tmpl` extension and comment out any template syntax.
  It might be possibe to fix this for bash scripts by [customizing the template delimiters](https://www.chezmoi.io/reference/templates/directives/).
  I have become quite reliant on shellcheck to not write terrible scripts.

- _By default_, chezmoi hides its internal state away in `~/.local/share/chezmoi`.
  It's documentation encourages you to interact with it through its own abstaction layer over git.
  I guess this makes sense for people how want to use chezmoi without prior experience with git?
  Personally, I don't like it.
  I had to twist chezmoi's arms a little bit to expose its state in my conventional `~/repos/dotfiles`.
  Nothing is stopping my from using plain git and only using the chezmoi command for _applying_ my configuration, which is good.
