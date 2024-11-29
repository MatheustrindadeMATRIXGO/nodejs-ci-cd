# Usando a imagem oficial do Node.js
FROM node:latest

# Cria o diretório da aplicação
WORKDIR /app

# Copia os arquivos do projeto
COPY package*.json ./
RUN npm install

# Copia o restante do código
COPY . .

# Expõe a porta que a aplicação irá rodar
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
