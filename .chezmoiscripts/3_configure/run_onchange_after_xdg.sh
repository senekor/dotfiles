#!/bin/bash
set -eo pipefail

# create xdg directories

old_dirs=(
    Desktop
    Documents
    Downloads
    Music
    Pictures
    Public
    Templates
    Videos
)

for old_dir in "${old_dirs[@]}"; do
    [ -d "$HOME/$old_dir" ] && rmdir "$HOME/$old_dir"
done

[ -d "$HOME/cloud" ] || mkdir "$HOME/cloud"

new_dirs=(
    desktop
    documents
    # downloads
    music
    pictures
    public
    templates
    videos
)

for new_dir in "${new_dirs[@]}"; do
    [ -d "$HOME/cloud/$new_dir" ] || mkdir "$HOME/cloud/$new_dir"
done

# downloads folder is separate so it won't be synced
[ -d "$HOME/downloads" ] || mkdir "$HOME/downloads"
