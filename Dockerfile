FROM node:22-alpine

# Instalar dependências essenciais do sistema
RUN apk update && apk add --no-cache git ffmpeg

WORKDIR /app

# Instalar a skill oficial do Hypit globalmente através do npx/npm
RUN npm install -g npx skills || true
RUN npx skills add hypit-ai/hypit -g || true

# Criar a nossa interface web ligada ao servidor para poderes dar ordens pelo telemóvel
RUN echo 'const http = require("http"); \
const { exec } = require("child_process"); \
const html = ` \
<!DOCTYPE html> \
<html lang="pt"> \
<head> \
  <meta name="viewport" content="width=device-width, initial-scale=1.0"> \
  <title>Hypit AI Control</title> \
  <style> \
    body { font-family: -apple-system, sans-serif; padding: 20px; background: #121212; color: #fff; } \
    h1 { color: #ff2d55; } \
    input, button { width: 100%; padding: 12px; margin: 8px 0; border-radius: 8px; border: none; font-size: 16px; box-sizing: border-box; } \
    input { background: #222; color: #fff; border: 1px solid #444; } \
    button { background: #ff2d55; color: white; font-weight: bold; } \
    #log { background: #000; padding: 10px; margin-top: 15px; border-radius: 5px; font-family: monospace; font-size: 14px; white-space: pre-wrap; color: #0f0; } \
  </style> \
</head> \
<body> \
  <h1>Hypit AI Control</h1> \
  <p>Comando / Prompt para a IA:</p> \
  <input type="text" id="prompt" placeholder="Ex: Clonar vídeo do Instagram..." /> \
  <button onclick="executar()">Executar Comando Hypit</button> \
  <div id="log">Aguardando comando...</div> \
  <script> \
    async function executar() { \
      const prompt = document.getElementById("prompt").value; \
      const log = document.getElementById("log"); \
      log.innerText = "A executar a skill do Hypit na nuvem..."; \
      const res = await fetch("/run", { \
        method: "POST", \
        headers: {"Content-Type": "application/json"}, \
        body: JSON.stringify({ prompt }) \
      }); \
      const data = await res.json(); \
      log.innerText = data.output; \
    } \
  </script> \
</body> \
</html> \
`; \
\
const server = http.createServer((req, res) => { \
  if (req.method === "POST" && req.url === "/run") { \
    let body = ""; \
    req.on("data", chunk => { body += chunk; }); \
    req.on("end", () => { \
      const data = JSON.parse(body); \
      exec("npx hypit " + (data.prompt || ""), (error, stdout, stderr) => { \
        res.writeHead(200, {"Content-Type": "application/json"}); \
        res.end(JSON.stringify({ output: stdout || stderr || error?.message || "Executado com sucesso!" })); \
      }); \
    }); \
  } else { \
    res.writeHead(200, {"Content-Type": "html" in req.url ? "text/html" : "text/html"}); \
    res.end(html); \
  } \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
