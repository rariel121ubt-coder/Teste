FROM node:18-alpine

# Instalar o git para o npm conseguir descarregar pacotes externos
RUN apk update && apk add --no-cache git

WORKDIR /app

# Instalar o Hypit globalmente
RUN npm install -g npx skills add hypit-ai/hypit -g || true

# Criar o servidor web simples para manter o Render feliz
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200, {"Content-Type": "text/plain"}); \
  res.end("Hypit Ready\\n"); \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
