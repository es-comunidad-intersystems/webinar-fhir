# base image
FROM node:12.14.1-alpine

USER node

# download growth-chart-app
WORKDIR /tmp
RUN wget https://github.com/smart-on-fhir/growth-chart-app/archive/master.tar.gz
RUN tar -zxvf master.tar.gz
WORKDIR /tmp/growth-chart-app-master

# modify launch.html
COPY launch.html .

# install dependencies
RUN npm install

# run server
CMD ["npm", "start"]