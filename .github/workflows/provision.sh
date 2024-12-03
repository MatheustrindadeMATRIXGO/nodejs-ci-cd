# Executa menu interativo
./script.sh

# Limpeza direta
./script.sh cleanup

# Deploy para ambiente específico
./script.sh deploy production

# Backup do projeto
./script.sh backup


#!/bin/bash

# Script de Limpeza de Projeto
cleanup_project() {
    echo "🧹 Iniciando limpeza do projeto..."
    
    # Remove node_modules e pacotes
    rm -rf node_modules
    rm -rf package-lock.json
    rm -rf yarn.lock
    
    # Remove arquivos de build
    rm -rf dist
    rm -rf build
    
    # Remove arquivos de cache
    find . -type d -name ".cache" -exec rm -rf {} +
    find . -type d -name "__pycache__" -exec rm -rf {} +
    
    # Limpa logs
    find . -type f -name "*.log" -delete
    
    echo "✅ Limpeza concluída!"
}

# Script de Backup de Projeto
backup_project() {
    local project_name=$(basename "$PWD")
    local backup_dir="$HOME/backups/$project_name"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    
    mkdir -p "$backup_dir"
    
    echo "📦 Criando backup do projeto $project_name..."
    
    tar -czvf "$backup_dir/$project_name-$timestamp.tar.gz" \
        --exclude=node_modules \
        --exclude=.git \
        --exclude=*.log \
        .
    
    echo "✅ Backup salvo em: $backup_dir/$project_name-$timestamp.tar.gz"
}

# Script de Verificação de Dependências
check_dependencies() {
    echo "🕵️ Verificando dependências..."
    
    # Node.js
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js não instalado"
        return 1
    fi
    
    # NPM
    if ! command -v npm &> /dev/null; then
        echo "❌ NPM não instalado"
        return 1
    fi
    
    # Versões
    echo "Node.js version: $(node -v)"
    echo "NPM version: $(npm -v)"
    
    # Vulnerabilidades
    npm audit
}

# Script de Deploy Automatizado
auto_deploy() {
    local environment=$1
    
    echo "🚀 Iniciando deploy para $environment"
    
    # Testes antes do deploy
    npm run test
    
    if [ $? -ne 0 ]; then
        echo "❌ Testes falharam. Deploy cancelado."
        exit 1
    fi
    
    # Build
    npm run build
    
    # Deploy baseado no ambiente
    case "$environment" in
        "production")
            git push heroku main
            ;;
        "staging")
            git push staging develop
            ;;
        "development")
            echo "Deploy local"
            npm start
            ;;
        *)
            echo "Ambiente inválido"
            exit 1
            ;;
    esac
    
    echo "✅ Deploy concluído para $environment"
}

# Menu de Seleção
menu() {
    echo "🛠️ Menu de Automação"
    echo "1. Limpar Projeto"
    echo "2. Backup do Projeto"
    echo "3. Verificar Dependências"
    echo "4. Deploy"
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1) cleanup_project ;;
        2) backup_project ;;
        3) check_dependencies ;;
        4) 
            read -p "Ambiente (production/staging/development): " env
            auto_deploy "$env"
            ;;
        *) echo "Opção inválida" ;;
    esac
}

# Execução do script
main() {
    if [ "$1" ]; then
        case "$1" in
            "cleanup") cleanup_project ;;
            "backup") backup_project ;;
            "deps") check_dependencies ;;
            "deploy") auto_deploy "${2:-development}" ;;
            *) menu ;;
        esac
    else
        menu
    fi
}

main "$@"
