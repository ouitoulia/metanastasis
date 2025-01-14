#!/bin/bash
################################################################################
#
#  Questo è uno script che installa Ouitoulìa CMS
#
#  Author: Pietro Arturo Panetta
#  Site: https://www.drupal.org/u/arturopanetta
#  Copyright: @arturu 2023
#  License: AGPL-3.0-only
#
################################################################################

# La cartella base dove si trova questo script
if [[ -L "${BASH_SOURCE[0]}" ]]; then
  symlink_path=$(readlink -f "${BASH_SOURCE[0]}")
  folderBase=$(dirname "$symlink_path")
else
  folderBase="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fi

source "${folderBase}"/.env

rsync -avz --progress \
    --exclude '00file_caricati' \
    --exclude 'bootstrap' \
    --exclude 'corsi-di-formazione' \
    --exclude 'css' \
    --exclude 'ctools' \
    --exclude 'curriculum' \
    --exclude 'default_images' \
    --exclude 'honeypot' \
    --exclude 'js' \
    --exclude 'languages' \
    --exclude 'less' \
    --exclude 'media-icons' \
    --exclude 'modelli' \
    --exclude 'pictures' \
    --exclude 'prepro' \
    --exclude 'private' \
    --exclude 'slideshow' \
    --exclude 'styles' \
    --exclude 'support' \
    --exclude 'translations' \
    --exclude 'user' \
    --exclude 'adminimal-custom.css' \
    --exclude '.htaccess' \
    "${METANASTASIS_REMOTE_FILE_PATH}" \
    "${METANASTASIS_LOCAL_FILE_PATH}"
