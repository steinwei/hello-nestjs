FROM node:lts-alpine as builder

WORKDIR /hello-nestjs

# set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

# mirror acceleration
RUN npm config set registry https://r.npm.taobao.org/
RUN yarn config set registry https://r.npm.taobao.org/
# RUN npm config rm proxy && npm config rm https-proxy

# install & build
COPY . .

RUN yarn install
RUN yarn build
# clean dev dep
RUN yarn install --production
RUN yarn cache clean

RUN yarn global add pm2


# httpserver set port
EXPOSE 7001

# 容器启动时执行的命令，类似npm run start
# CMD ["yarn", "start:prod"]
CMD ["pm2-runtime", "ecosystem.config.js"]
