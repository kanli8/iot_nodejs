FROM node:14.17.2

# Create app directory
# WORKDIR /usr/src/app
WORKDIR /root/simApi


# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
# COPY package*.json ./
# COPY . /root/simApi

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 8008
CMD [ "node", "/root/simApi/bin/www" ]