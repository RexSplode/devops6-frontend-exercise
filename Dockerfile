FROM node:8.11.2-alpine as build
RUN apk add --no-cache python2 g++ make
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm i
RUN npm install node-sass@4.5.3
COPY . .
ARG base_url
RUN sed -i 's|https://backend_url|'${base_url}'|g' /usr/src/app/src/app/services/token-interceptor.service.ts

RUN npm run build

FROM nginx:1.17.1-alpine
WORKDIR /usr/share/nginx/html
COPY --from=build /usr/src/app/dist/eSchool .
