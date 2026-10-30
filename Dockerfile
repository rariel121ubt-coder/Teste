FROM node:18-alpine

WORKDIR /app

# Criar um servidor web simples em Node.js para o Render ficar feliz
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200, {"Content-Type": "text/plain"}); \
  res.end("Hypit Server Ready\\n"); \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
