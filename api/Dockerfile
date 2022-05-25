# FROM node:12

# # Create app directory
# WORKDIR /home/node/app

# # Install app dependencies
# # A wildcard is used to ensure both package.json AND package-lock.json are copied
# # where available (npm@5+)
# COPY package*.json ./

# RUN npm install
# # If you are building your code for production
# # RUN npm ci --only=production

# # Bundle app source
# COPY . .

# #EXPOSE 8080
# #CMD [ "node", "src/index.js" ]
# CMD npm start
FROM node:latest
WORKDIR /home/node/app
COPY package.json ./
RUN npm install
COPY . .

ARG MYSQL_HOST
ENV MYSQL_HOST=$MYSQL_HOST

RUN echo "----- key is 1 $MYSQL_HOST"
RUN echo "----- key is 11 $(ipMysql)"
RUN echo "----- key is 111 ${MYSQL_HOST}"

CMD npm start