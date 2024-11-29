const express = require('express'); // Importa o módulo Express
const path = require('path'); // Importa o módulo Path
const app = express(); // Cria uma instância do aplicativo Express
const port = 3000; // Define a porta em que o servidor irá escutar

// Middleware para processar dados do formulário temporarios que eu criei
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Servir arquivos estáticos da pasta 'public' mais posso direcionar até outro diretorio
app.use(express.static('public'));

// Rota principal para servir o formulário HTML, 
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Rota para processar o formulário
app.post('/submit', (req, res) => {
    const { nome, email, assunto, mensagem } = req.body;
    res.send(`
        <h1>Formulário Recebido!</h1>
        <p>Nome: ${nome}</p>
        <p>Email: ${email}</p>
        <p>Assunto: ${assunto}</p>
        <p>Mensagem: ${mensagem}</p>
        <a href="/">Voltar</a>
    `);
});

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});
