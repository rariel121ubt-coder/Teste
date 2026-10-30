FROM node:18-alpine

WORKDIR /app

EXPOSE 10000

CMD ["tail", "-f", "/dev/null"]
