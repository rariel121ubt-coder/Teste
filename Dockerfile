FROM node:22-alpine

# Instalar FFmpeg e Git (essenciais para vídeo e pacotes)
RUN apk update && apk add --no-cache ffmpeg git

WORKDIR /app

# Instalar a CLI do Hypit globalmente
RUN npm install -g hypit || npm install -g @hypit/cli || true

# Servidor de pé para o Render
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200, {"Content-Type": "text/plain"}); \
  res.end("Hypit Ready\\n"); \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
