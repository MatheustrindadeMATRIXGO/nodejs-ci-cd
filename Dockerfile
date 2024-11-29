# Usando a imagem oficial do Node.js , 
FROM node:latest

# Cria o diretório da aplicação no container 
WORKDIR /app

# Copia os arquivos do projeto que eu baixei
COPY package*.json ./
RUN npm install

# Copia o restante do código
COPY . .

# Expõe a porta que a aplicação irá rodar, para testar mais a porta tem que estar vazia.
EXPOSE 3000

# Comando para iniciar a aplicação, mais temos que configurar o test primeiro 
CMD ["npm", "start"]
