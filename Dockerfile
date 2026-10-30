FROM node:22-alpine

RUN apk update && apk add --no-cache ffmpeg git

WORKDIR /app

RUN echo 'const http = require("http"); \
const { exec } = require("child_process"); \
const html = ` \
<!DOCTYPE html> \
<html lang="pt"> \
<head> \
  <meta name="viewport" content="width=device-width, initial-scale=1.0"> \
  <title>Hypit AI Video</title> \
  <style> \
    body { font-family: -apple-system, sans-serif; padding: 20px; background: #121212; color: #fff; } \
    h1 { color: #007aff; } \
    input, button { width: 100%; padding: 12px; margin: 8px 0; border-radius: 8px; border: none; font-size: 16px; box-sizing: border-box; } \
    input { background: #222; color: #fff; border: 1px solid #444; } \
    button { background: #007aff; color: white; font-weight: bold; } \
    #status { margin-top: 15px; color: #ff9500; font-weight: bold; } \
  </style> \
</head> \
<body> \
  <h1>Hypit Video AI</h1> \
  <p>Cola o link do vídeo do Instagram:</p> \
  <input type="text" id="url" placeholder="https://instagram.com/..." /> \
  <input type="text" id="prompt" placeholder="O que queres alterar?" /> \
  <button onclick="processar()">Processar Vídeo</button> \
  <div id="status"></div> \
  <script> \
    async function processar() { \
      const url = document.getElementById("url").value; \
      const prompt = document.getElementById("prompt").value; \
      const status = document.getElementById("status"); \
      if(!url) { alert("Insere um link!"); return; } \
      status.innerText = "A processar vídeo na nuvem..."; \
      const res = await fetch("/clone", { \
        method: "POST", \
        headers: {"Content-Type": "application/json"}, \
        body: JSON.stringify({ url, prompt }) \
      }); \
      const data = await res.json(); \
      status.innerText = data.mensagem; \
    } \
  </script> \
</body> \
</html> \
`; \
\
const server = http.createServer((req, res) => { \
  if (req.method === "POST" && req.url === "/clone") { \
    let body = ""; \
    req.on("data", chunk => { body += chunk; }); \
    req.on("end", () => { \
      const data = JSON.parse(body); \
      console.log("A receber link:", data.url); \
      res.writeHead(200, {"Content-Type": "application/json"}); \
      res.end(JSON.stringify({ mensagem: "Vídeo recebido! O motor do Hypit está a executar na nuvem para o link: " + data.url })); \
    }); \
  } else { \
    res.writeHead(200, {"Content-Type": "text/html"}); \
    res.end(html); \
  } \
}); \
server.listen(10000);' > server.js

EXPOSE 10000

CMD ["node", "server.js"]
