#!/bin/bash
START_STRING='define( '
END_STRING=' \);'
echo $START_STRING
echo $END_STRING
WORDPRESS_KEYS="$(curl 'https://api.wordpress.org/secret-key/1.1/salt/')"

sudo sed -i -e "/{$START_STRING},/$END_STRING/{/{$STARTSTRING}/n;/{$END_STRING}/{$WORDPRESS_KEYS}/g}" wp01
