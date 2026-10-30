FROM node:18-alpine

# Instalar o git
RUN apk update && apk add --no-cache git

WORKDIR /app

# Clonar o repositório oficial do Hypit diretamente
RUN git clone https://github.com/hypit-ai/hypit.git /app/hypit

WORKDIR /app/hypit
RUN npm install

# Criar o servidor web simples para manter o Render ativo na porta 10000
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200, {"Content-Type": "text/plain"}); \
  res.end("Hypit Ready\\n"); \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
