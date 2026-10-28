# Painel Semanal de Pautas

Painel de acompanhamento das pautas de marketing, organizado por frente
(Alimentos Preparados MI, Alimentos Preparados ME, In Natura ME e Inovação),
com horizontes Agora / Próximo / Depois, saúde em semáforo, prazos,
próximo passo com checklist e resumo formatado para e-mail.

Arquivos: `index.html` (o painel), `config.js` (chaves do banco compartilhado) e `supabase/` (SQL de estrutura e carga inicial).

## Hospedar no GitHub Pages

1. No repositório, abra **Settings → Pages**.
2. Em **Build and deployment**, escolha **Deploy from a branch**, branch `main`, pasta `/ (root)`.
3. Salve. Em alguns minutos o painel fica em `https://<usuario>.github.io/pauta_mkt/`.

## Onde os dados ficam

O painel escolhe o armazenamento ao abrir, nesta ordem:

| Situação | Armazenamento | Compartilhado com o time? |
|---|---|---|
| Aberto como artifact no claude.ai | Banco do artifact (tempo real) | Sim, para quem tem acesso de Contribuidor |
| Hospedado, com `config.js` preenchido | Supabase (tempo real) | Sim, para quem tiver o link |
| Hospedado, com `config.js` vazio | `localStorage` do navegador | Não. Cada pessoa vê só o que digitou no próprio navegador |

## Ligar o Supabase (uso compartilhado no site hospedado)

Leva uns 10 minutos. Tudo é feito no painel do Supabase e neste repositório.

1. **Criar o projeto.** Em [supabase.com/dashboard](https://supabase.com/dashboard), *New project*. Escolha um nome (ex.: `pauta-mkt`), uma senha de banco (guarde, mas o site não usa) e a região *South America (São Paulo)*. Aguarde o projeto ficar pronto.
2. **Criar a tabela e as permissões.** No menu lateral, *SQL Editor* → *New query*. Cole o conteúdo de [`supabase/schema.sql`](supabase/schema.sql) e clique em *Run*. Deve terminar com *Success. No rows returned*.
3. **Carregar as pautas atuais** (opcional, mas recomendado). Nova query, cole [`supabase/seed.sql`](supabase/seed.sql), *Run*. São as pautas exportadas do artifact em 27/10/2026. Pode rodar de novo depois: registros existentes são atualizados, não duplicados.
4. **Copiar as chaves.** *Project Settings* (ícone de engrenagem) → *API*. Copie **Project URL** e a chave **anon public**.
5. **Preencher `config.js`** neste repositório com os dois valores, entre aspas:

   ```js
   window.PAUTAS_CONFIG = {
     supabaseUrl: "https://SEU-PROJETO.supabase.co",
     supabaseAnonKey: "eyJ..."
   };
   ```

   Faça o commit. O GitHub Pages republica em 1 a 2 minutos.
6. **Conferir.** Abra o site. O aviso amarelo de "Modo local" não deve aparecer, e as pautas da carga inicial devem estar na tela. Abra em dois navegadores e edite num deles: o outro atualiza sozinho.

### Sobre segurança

A chave *anon* é feita para ficar no site; ela é pública por desenho. Quem decide o que pode ser lido ou alterado são as políticas de segurança por linha (RLS) criadas pelo `schema.sql`. A versão entregue **libera leitura e escrita para qualquer pessoa que tenha o link do painel**, o que equivale ao Trello com quadro aberto por link. Se isso não for aceitável, o próximo passo é o login por e-mail do Supabase (magic link) restrito aos endereços do time, com as políticas apontando para `auth.email()`. É uma mudança pequena no site e nas políticas.

Para desligar o Supabase basta esvaziar os dois campos de `config.js`.

## Modelo de dados

Cada pauta é um documento em `projetos/<id>` com os campos:

`titulo`, `frente` (`alpmi` | `alpme` | `innme` | `inov`), `tags[]`,
`etapa` (`nao_iniciado` | `em_andamento` | `em_revisao` | `pausado` | `concluido`),
`horizonte` (`agora` | `proximo` | `depois`), `saude` (`ok` | `atencao` | `critico`),
`responsavel`, `proximoPasso` (texto livre; linhas com `- ` viram tópicos e
`[ ]` / `[x]` viram checklist), `prazo` (`AAAA-MM-DD`), `notas`, `ordem`
(número usado para ordenar), `atualizadoEm` e `concluidoEm` (ISO 8601).

## Uso

- **Semana**: indicadores, avisos importantes e férias do time na lateral; prioridades do "Agora", pontos de atenção, fila e concluídos.
- **Por frente**: um cartão por frente; arraste pautas entre Agora, Próximo e Depois.
- **Responsáveis**: um cartão por pessoa, com as pautas ativas por horizonte e a sigla da frente.
- **Prazos**: vencidos, por mês e sem prazo.
- **Concluídos**: histórico.
- **Copiar resumo**: coloca na área de transferência um resumo formatado (HTML e texto) para colar no Outlook.
- Clique na faixa de um cartão para recolher ou expandir; "Recolher tudo" na linha de busca vale para a aba aberta.
- Arraste pela alça de seis pontos para reordenar. Alt + seta para cima ou para baixo faz o mesmo pelo teclado.

Além das pautas, a mesma coleção guarda dois documentos especiais: `projetos/_avisos` (`{ texto }`) e `projetos/_ferias` (`{ itens: [{ id, nome, inicio, fim }] }`), usados pelos blocos de avisos e férias da aba Semana.
