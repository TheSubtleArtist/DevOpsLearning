# docker build -t thesubtleartist/vprofileweb:tag01 web/

FROM nginx

LABEL "project"="vprofile"
LABEL "author"="nobody_important"

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY nginvproapp.conf /etc/nginx/conf.d/vproapp.conf
