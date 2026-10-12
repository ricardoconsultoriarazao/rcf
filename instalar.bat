@echo off
echo Instalando dependencias RJLF Gestao...
npm install
echo.
echo Gerando Prisma Client...
npx prisma generate
echo.
echo Criando tabelas no PostgreSQL...
npx prisma migrate dev --name init
echo.
echo Carregando RCFs iniciais...
npm run seed
echo.
echo Instalacao concluida.
pause
