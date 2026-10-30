FROM node:22-alpine

# Instalar FFmpeg e Git
RUN apk update && apk add --no-cache ffmpeg git

WORKDIR /app

# Criar uma página web simples para usar o Hypit pelo iPhone
RUN echo 'const http = require("http"); \
const html = ` \
<!DOCTYPE html> \
<html lang="pt"> \
<head> \
  <meta name="viewport" content="width=device-width, initial-scale=1.0"> \
  <title>Hypit AI Video</title> \
  <style> \
    body { font-family: -apple-system, sans-serif; padding: 20px; background: #121212; color: #fff; } \
    h1 { color: #007aff; } \
    input, button { width: 100%; padding: 12px; margin: 8px 0; border-radius: 8px; border: none; font-size: 16px; } \
    input { background: #222; color: #fff; border: 1px solid #444; } \
    button { background: #007aff; color: white; font-weight: bold; } \
  </style> \
</head> \
<body> \
  <h1>Hypit Video AI</h1> \
  <p>Cola o link do vídeo para clonar/alterar:</p> \
  <input type="text" id="url" placeholder="https://..." /> \
  <input type="text" id="prompt" placeholder="O que queres alterar no vídeo?" /> \
  <button onclick="alert(\"Pedido enviado com sucesso!\")">Processar Vídeo</button> \
</body> \
</html> \
`; \
const server = http.createServer((req, res) => { \
  res.writeHead(200, {"Content-Type": "text/html"}); \
  res.end(html); \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
