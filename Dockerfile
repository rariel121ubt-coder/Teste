FROM node:22-alpine

WORKDIR /app

# Criar um servidor web completo que mantém o serviço ativo no Render
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200, {"Content-Type": "text/plain"}); \
  res.end("Hypit Environment Ready\\n"); \
}); \
server.listen(10000, () => { \
  console.log("Servidor a correr na porta 10000"); \
});' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
