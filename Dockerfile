FROM node:22-bullseye

# Instalar FFmpeg e dependências de vídeo
RUN apt-get update && apt-get install -y ffmpeg git curl

WORKDIR /app

EXPOSE 10000

CMD ["tail", "-f", "/dev/null"]
