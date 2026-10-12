# RJLF Gestao Local - Instalacao Windows

Este pacote roda em maquina local Windows usando PostgreSQL.

## 1. Copiar o pacote

Extraia esta pasta para:

```cmd
C:\RJLF\rjlf-gestao
```

## 2. Criar o arquivo .env

Na pasta `C:\RJLF\rjlf-gestao`, copie:

```cmd
.env.example
```

e renomeie a copia para:

```cmd
.env
```

Edite o arquivo `.env` e ajuste a senha do PostgreSQL:

```env
DATABASE_URL="postgresql://rjlf_app:SUA_SENHA_DO_POSTGRES@localhost:5432/rjlf_gestao"
CONSULTANT_EMAIL="admin@rjlf.local"
CONSULTANT_PASSWORD="troque-esta-senha"
CONSULTANT_SESSION_TOKEN="troque-por-uma-chave-grande"
NEXT_PUBLIC_APP_NAME="RJLF Consultoria"
```

Exemplo:

```env
DATABASE_URL="postgresql://rjlf_app:Rjlf@2026#Gestao@localhost:5432/rjlf_gestao"
```

Se sua senha tiver caracteres especiais e der erro de conexao, use uma senha mais simples no usuario `rjlf_app` ou codifique os caracteres especiais na URL.

## 3. Instalar dependencias

Abra o PowerShell ou Prompt dentro da pasta:

```cmd
cd C:\RJLF\rjlf-gestao
npm install
```

## 4. Criar as tabelas e carregar os RCFs

Na primeira instalacao, rode:

```cmd
npx prisma generate
npx prisma migrate dev --name init
npm run seed
```

Isso cria as tabelas no banco `rjlf_gestao` e carrega os 17 RCFs.

## 5. Rodar em modo teste

```cmd
npm run dev
```

Acesse:

```text
http://localhost:3000
```

Login padrao sera o que voce colocou no `.env`.

## 6. Rodar em producao

Depois de testar:

```cmd
npm run build
npm run start
```

## 7. Acesso de outras maquinas na rede

Descubra o IP da maquina:

```cmd
ipconfig
```

Em outra maquina, acesse:

```text
http://IP-DA-MAQUINA:3000
```

Se nao abrir, libere a porta no PowerShell como Administrador:

```powershell
New-NetFirewallRule -DisplayName "RJLF Gestao Porta 3000" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow
```

## 8. Rodar como servico do Windows

Recomendado usar NSSM:

```text
https://nssm.cc/download
```

Configuracao:

```text
Path: C:\Program Files\nodejs\npm.cmd
Startup directory: C:\RJLF\rjlf-gestao
Arguments: run start
Display name: RJLF Gestao
Startup type: Automatic
```

Antes de instalar como servico, rode:

```cmd
npm run build
```

## 9. Backup do PostgreSQL

Exemplo PostgreSQL 18:

```cmd
"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe" -U rjlf_app -d rjlf_gestao -f "C:\RJLF\backups\rjlf_gestao_backup.sql"
```

Se sua instalacao estiver em outra versao, ajuste o caminho.

