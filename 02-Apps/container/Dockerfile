FROM node:alpine

WORKDIR /app

COPY package.json .
RUN npm install

COPY . .

RUN npm run build
#RUN npm test

ENV NODE_ENV=production
ENV NODE_PORT=3000
EXPOSE 3000
ENV DYNAMODB_TABLE_NAME=""

CMD ["npm", "start"]
