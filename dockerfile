# set the base image to build from 
FROM node:alpine
# set the working directory
WORKDIR /app

COPY . . 

RUN npm install

FROM nginx:apline

WORKDIR /usr/share/nginx/html

COPY --from=stage /app/build .

CMD [ "gnix", "-g", "deamin off;" ]
