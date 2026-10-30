FROM node:18-alpine

WORKDIR /app

# Instalar o Hypit automaticamente no arranque do servidor
RUN npm install -g npx skills add hypit-ai/hypit -g || true

# Servidor web simples para manter o Render ativo
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200, {"Content-Type": "text/plain"}); \
  res.end("Hypit Ready\\n"); \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
