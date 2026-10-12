# Publicacao Online - Vercel + Supabase

Este guia publica o sistema RJLF Gestao na internet usando Vercel e Supabase.

## 1. Preparar Supabase

1. Acesse o projeto no Supabase.
2. Va em `SQL Editor`.
3. Abra o arquivo:

```text
database/supabase_setup.sql
```

4. Copie todo o conteudo.
5. Cole no SQL Editor.
6. Clique em `Run`.

Esse SQL cria as tabelas e carrega os 17 RCFs iniciais.

## 2. Pegar a string de conexao do Supabase

No Supabase:

```text
Project Settings > Database > Connection string
```

Use preferencialmente `Transaction pooler`, porta `6543`, para a variavel `DATABASE_URL`.

Formato:

```env
DATABASE_URL="postgresql://postgres.PROJECT_REF:SENHA@aws-0-sa-east-1.pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1"
```

Se aparecer regiao diferente de `sa-east-1`, use exatamente a que o Supabase mostrar.

## 3. Subir para GitHub

Envie a pasta do projeto para um repositorio GitHub.

Se o repositorio ja existir:

```cmd
git add .
git commit -m "Sistema RJLF Gestao online"
git push
```

## 4. Criar projeto na Vercel

1. Acesse Vercel.
2. Clique em `Add New > Project`.
3. Importe o repositorio GitHub.
4. Framework: `Next.js`.
5. Root Directory: deixe vazio se o projeto estiver na raiz. Se estiver dentro de uma pasta, selecione a pasta correta.

## 5. Variaveis de ambiente na Vercel

Em:

```text
Project > Settings > Environment Variables
```

Cadastre:

```env
DATABASE_URL
CONSULTANT_EMAIL
CONSULTANT_PASSWORD
CONSULTANT_SESSION_TOKEN
NEXT_PUBLIC_APP_NAME
```

Exemplo:

```env
CONSULTANT_EMAIL=admin@rjlf.local
CONSULTANT_PASSWORD=SenhaForteAqui
CONSULTANT_SESSION_TOKEN=UmaChaveGrandeAleatoriaAqui
NEXT_PUBLIC_APP_NAME=RJLF Consultoria
```

Para gerar uma chave grande no PowerShell:

```powershell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
```

## 6. Deploy

Clique em:

```text
Deploy
```

Depois acesse a URL gerada pela Vercel.

## 7. Login

Use:

```text
CONSULTANT_EMAIL
CONSULTANT_PASSWORD
```

configurados na Vercel.

## Observacao importante

O sistema atual usa login simples do consultor por variaveis de ambiente. Para liberar acesso individual para gestores/clientes, a proxima evolucao recomendada e usar Supabase Auth com usuarios por empresa.
