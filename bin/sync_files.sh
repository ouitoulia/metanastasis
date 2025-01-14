#!/bin/bash

source .env

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
