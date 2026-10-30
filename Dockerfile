FROM node:22-alpine

# Instalar Git e FFmpeg
RUN apk update && apk add --no-cache git ffmpeg

WORKDIR /app

# Criar o código do servidor diretamente limpo e sem erros de sintaxe
RUN echo 'const http = require("http"); \
const { exec } = require("child_process"); \
\
const html = `<!DOCTYPE html> \
<html lang="pt"> \
<head> \
  <meta name="viewport" content="width=device-width, initial-scale=1.0"> \
  <title>Hypit AI</title> \
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
  <h1>Hypit AI</h1> \
  <p>Insere o comando ou link do vídeo:</p> \
  <input type="text" id="prompt" placeholder="Ex: https://instagram.com/... " /> \
  <button onclick="executar()">Processar com IA</button> \
  <div id="log">Pronto para iniciar...</div> \
  <script> \
    async function executar() { \
      const prompt = document.getElementById("prompt").value; \
      const log = document.getElementById("log"); \
      if(!prompt) { alert("Escreve algo!"); return; } \
      log.innerText = "A processar na nuvem..."; \
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
</html>`; \
\
const server = http.createServer((req, res) => { \
  if (req.method === "POST" && req.url === "/run") { \
    let body = ""; \
    req.on("data", chunk => { body += chunk; }); \
    req.on("end", () => { \
      const data = JSON.parse(body); \
      exec("echo 'A executar comando para: " + data.prompt + "'", (error, stdout, stderr) => { \
        res.writeHead(200, {"Content-Type": "application/json"}); \
        res.end(JSON.stringify({ output: "Comando recebido com sucesso! Processado: " + data.prompt })); \
      }); \
    }); \
  } else { \
    res.writeHead(200, {"Content-Type": "text/html"}); \
    res.end(html); \
  } \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
