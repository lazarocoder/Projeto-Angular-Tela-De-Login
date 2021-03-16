FROM node:alpine as build
COPY package.json package-lock.json ./
RUN npm i && mkdir /ng-app && cp -R ./node_modules ./ng-app
WORKDIR /ng-app
COPY . .
RUN npm run build-prod

FROM nginx:alpine
COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /ng-app/dist/desafio /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]