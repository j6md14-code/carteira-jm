# Carteira João Matheus — como colocar no ar

Seu CRM de leads, imóveis e campanhas. Funciona no celular e no computador, sincronizado, sem custo:

- **GitHub Pages** hospeda a página (grátis).
- **Supabase** guarda os dados, com login só seu (plano gratuito).

Tempo total: uns 20 minutos, uma vez só.

---

## O que tem nesta pasta

| Arquivo | Para que serve |
| --- | --- |
| `index.html` | O CRM |
| `supabase-setup.sql` | Cria o banco de dados e as regras de segurança |
| `manifest.webmanifest`, `sw.js` | Deixam o CRM instalável como app no celular |
| `icon.svg`, `icon-*.png`, `apple-touch-icon.png` | Sua logo como ícone do app |

---

## Passo 1 — Criar o banco no Supabase

1. Entre em **supabase.com** e crie uma conta (pode usar "Continue with GitHub" depois do passo 5, ou e-mail).
2. Clique em **New project**.
   - Nome: `carteira-jm`
   - Database password: crie uma senha forte e **guarde** (não é a senha do CRM).
   - Region: **South America (São Paulo)**.
   - Plano: **Free**.
3. Espere uns 2 minutos até o projeto ficar pronto.

## Passo 2 — Criar a tabela

1. No menu da esquerda, abra **SQL Editor** → **New query**.
2. Abra o arquivo `supabase-setup.sql` desta pasta, copie tudo e cole lá.
3. Clique em **Run**. Deve aparecer "Success. No rows returned".

## Passo 3 — Ligar o CRM ao banco

1. No Supabase, vá em **Project Settings** (engrenagem) → **API Keys** (ou **Data API**).
2. Copie dois valores:
   - **Project URL** — algo como `https://abcdefgh.supabase.co`
   - A **chave pública**: chamada **Publishable key** (`sb_publishable_...`) ou, na aba "Legacy", **anon public**.
3. Abra o `index.html` num editor de texto (Bloco de Notas serve) e procure estas linhas, perto do início do script:

   ```js
   const SUPABASE_URL = "COLE_AQUI_A_PROJECT_URL";
   const SUPABASE_KEY = "COLE_AQUI_A_CHAVE_PUBLICA";
   ```

4. Troque pelos seus valores, mantendo as aspas. Salve.

> **Nunca** use a chave **secret** / **service_role**. Ela dá acesso total ao banco. A chave pública é feita para ficar na página: sem login, ela não lê nada, por causa das regras do passo 2.

## Passo 4 — Criar seu login (e fechar a porta para outros)

1. No Supabase: **Authentication** → **Users** → **Add user** → **Create new user**.
2. Coloque seu e-mail e uma senha. Marque **Auto Confirm User**. Clique em **Create user**.
3. Agora feche o cadastro para mais ninguém criar conta: **Authentication** → **Sign In / Providers** (ou **Providers → Email**) → desligue **Allow new users to sign up** → **Save**.

## Passo 5 — Publicar no GitHub Pages

1. Crie uma conta em **github.com** (grátis).
2. Clique em **+** (canto superior direito) → **New repository**.
   - Nome: `carteira-jm`
   - Deixe **Public** (no plano grátis o GitHub Pages exige isso; seus dados **não** ficam no GitHub, só o código da página).
   - Clique em **Create repository**.
3. Na página do repositório, clique em **uploading an existing file** (ou **Add file → Upload files**).
4. Arraste **todos os arquivos desta pasta** (o `index.html` já com suas chaves). Clique em **Commit changes**.
5. Vá em **Settings** → **Pages**.
   - Source: **Deploy from a branch**
   - Branch: **main** e pasta **/(root)** → **Save**.
6. Espere 1–2 minutos. O endereço do seu CRM aparece no topo dessa página:
   `https://SEU-USUARIO.github.io/carteira-jm/`

## Passo 6 — Ajustar o link de "Esqueci minha senha"

No Supabase: **Authentication** → **URL Configuration**:

- **Site URL**: `https://SEU-USUARIO.github.io/carteira-jm/`
- Em **Redirect URLs**, adicione o mesmo endereço. Salve.

## Passo 7 — Instalar no celular e no computador

- **Android (Chrome):** abra o link, entre com seu e-mail e senha, toque em ⋮ → **Instalar app** (ou **Adicionar à tela inicial**).
- **iPhone (Safari):** abra o link, entre, toque em **Compartilhar** → **Adicionar à Tela de Início**.
- **Computador (Chrome/Edge):** abra o link, entre e clique no ícone de instalar na barra de endereço, ou salve nos favoritos.

O ícone com a sua logo aparece na tela inicial e o CRM abre como um app.

---

## Cuidados importantes

- **Projeto pausado:** no plano gratuito, o Supabase pausa o projeto depois de **7 dias sem nenhum acesso**. Usando o CRM toda semana isso não acontece. Se pausar, entre em supabase.com, abra o projeto e clique em **Restore** — os dados continuam lá.
- **Backup semanal:** em **Ajustes → Baixar backup completo**. Guarde o arquivo `.json` no Google Drive ou no seu e-mail. Com ele você restaura tudo (em **Ajustes → Restaurar backup**), inclusive num projeto Supabase novo.
- **Dados de clientes (LGPD):** só a sua conta lê os leads. Não compartilhe sua senha e não coloque a chave secreta no código.
- **Limites do plano grátis:** 500 MB de banco — dá para centenas de milhares de leads. Não há cobrança automática: se um dia passar do limite, o Supabase avisa antes.

## Como alterar o CRM depois

No GitHub, abra o `index.html` → ícone do lápis (**Edit**) → altere → **Commit changes**. Em 1–2 minutos a nova versão está no ar. No celular, feche e abra o app para carregar.

## Problemas comuns

| O que aparece | O que fazer |
| --- | --- |
| "Falta configurar o banco de dados" | As chaves do passo 3 não foram coladas, ou o `index.html` enviado ao GitHub é o antigo. |
| "E-mail ou senha incorretos" | Confira o usuário no passo 4 (precisa estar com **Auto Confirm**). |
| "Não salvou: permission denied" ou "relation does not exist" | Rode de novo o `supabase-setup.sql` (passo 2). |
| Lançou no celular e não apareceu no computador | Recarregue a página. Se continuar, rode o SQL de novo (ele liga o tempo real). |
| Página 404 no GitHub | Confira se o arquivo se chama exatamente `index.html` e se o Pages está em **main / (root)**. |
