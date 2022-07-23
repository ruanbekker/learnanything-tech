FROM node:16.15.1 as build
WORKDIR /src
ADD . .
RUN npm install

ARG APP_URL
ENV APP_URL=$APP_URL
RUN bin/hugo/hugo  --print-mem --gc --minify --baseURL "$APP_URL" --environment production

FROM  nginx:alpine
LABEL maintainer Ruan
COPY  nginx/config/nginx.conf /etc/nginx/nginx.conf
COPY  nginx/config/app.conf /etc/nginx/conf.d/app.conf
COPY  --from=build /src/public /usr/share/nginx/app
