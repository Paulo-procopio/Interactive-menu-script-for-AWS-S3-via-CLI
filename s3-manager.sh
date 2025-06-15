#!/bin/bash

# ================================
# 🚀 Gerenciador de Bucket S3 via AWS CLI
# ================================

# 👉 Configurações Iniciais
read -p "Informe o nome do bucket (deve ser único globalmente): " BUCKET_NAME
read -p "Informe a região (ex.: us-east-1, us-east-2, sa-east-1): " REGION

# ================================
# 📦 Funções
# ================================

criar_bucket() {
    echo "✅ Criando bucket: $BUCKET_NAME na região $REGION"

    if [ "$REGION" == "us-east-1" ]; then
        aws s3api create-bucket \
            --bucket $BUCKET_NAME \
            --region $REGION
    else
        aws s3api create-bucket \
            --bucket $BUCKET_NAME \
            --region $REGION \
            --create-bucket-configuration LocationConstraint=$REGION
    fi

    if [ $? -eq 0 ]; then
        echo "🎉 Bucket criado com sucesso!"
    else
        echo "❌ Falha ao criar o bucket."
    fi
}

enviar_arquivo() {
    read -p "Digite o nome do arquivo que deseja enviar: " arquivo
    if [[ -f "$arquivo" ]]; then
        aws s3 cp "$arquivo" s3://$BUCKET_NAME/
        echo "📤 Arquivo enviado com sucesso!"
    else
        echo "❌ Arquivo não encontrado!"
    fi
}

listar_arquivos() {
    echo "📄 Listando arquivos no bucket:"
    aws s3 ls s3://$BUCKET_NAME/
}

baixar_arquivo() {
    read -p "Digite o nome do arquivo que deseja baixar: " arquivo
    aws s3 cp s3://$BUCKET_NAME/$arquivo $arquivo
    echo "⬇️ Arquivo baixado como $arquivo"
}

deletar_arquivo() {
    read -p "Digite o nome do arquivo que deseja deletar: " arquivo
    aws s3 rm s3://$BUCKET_NAME/$arquivo
    echo "🗑️ Arquivo deletado do bucket!"
}

deletar_bucket() {
    echo "⚠️ Atenção! Isso irá remover o bucket e todos os arquivos dentro dele."
    read -p "Tem certeza? (s/n): " conf
    if [[ "$conf" == "s" ]]; then
        aws s3 rb s3://$BUCKET_NAME --force
        echo "🗑️ Bucket removido!"
    else
        echo "❌ Ação cancelada."
    fi
}

# ================================
# 📜 Menu
# ================================

while true; do
    echo "=============================================="
    echo "🚀 Gerenciador AWS S3 CLI"
    echo "Bucket: $BUCKET_NAME | Região: $REGION"
    echo "=============================================="
    echo "1️⃣ Criar Bucket"
    echo "2️⃣ Enviar Arquivo"
    echo "3️⃣ Listar Arquivos"
    echo "4️⃣ Baixar Arquivo"
    echo "5️⃣ Deletar Arquivo"
    echo "6️⃣ Deletar Bucket"
    echo "0️⃣ Sair"
    echo "=============================================="
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1) criar_bucket ;;
        2) enviar_arquivo ;;
        3) listar_arquivos ;;
        4) baixar_arquivo ;;
        5) deletar_arquivo ;;
        6) deletar_bucket ;;
        0) echo "👋 Saindo..."; break ;;
        *) echo "❌ Opção inválida. Tente novamente." ;;
    esac

    echo "" # Linha em branco para separar
done
