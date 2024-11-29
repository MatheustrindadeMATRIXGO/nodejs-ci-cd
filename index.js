const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

// Middleware para processar dados do formulário
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Servir arquivos estáticos
app.use(express.static('public'));

// Rota principal para servir o formulário
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
