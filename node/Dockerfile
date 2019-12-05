FROM node:12.10-alpine
RUN rm -rf /home/user \
    && mkdir /home/user \
    && chmod 777 /home/user
WORKDIR /app
RUN yarn global add @quasar/cli
COPY ./frontend/package*.json ./
RUN yarn install
