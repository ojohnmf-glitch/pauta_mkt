# Painel Semanal de Pautas

Painel de acompanhamento das pautas de marketing, organizado por frente
(Alimentos Preparados MI, Alimentos Preparados ME, In Natura ME e Inovação),
com horizontes Agora / Próximo / Depois, saúde em semáforo, prazos,
próximo passo com checklist e resumo formatado para e-mail.

Arquivo único, sem dependências: `index.html`.

## Hospedar no GitHub Pages

1. No repositório, abra **Settings → Pages**.
2. Em **Build and deployment**, escolha **Deploy from a branch**, branch `main`, pasta `/ (root)`.
3. Salve. Em alguns minutos o painel fica em `https://<usuario>.github.io/pauta_mkt/`.

## Onde os dados ficam

O painel escolhe o armazenamento ao abrir:

| Onde a página é aberta | Armazenamento | Compartilhado com o time? |
|---|---|---|
| Artifact no claude.ai | Banco do artifact (tempo real) | Sim, para quem tem acesso de Contribuidor |
| GitHub Pages ou qualquer outro host | `localStorage` do navegador | Não. Cada pessoa vê só o que digitou no próprio navegador |

Ou seja: hospedado fora do claude.ai, o painel funciona como ferramenta
individual. Para uso compartilhado fora do claude.ai é preciso ligar um banco
externo. Os pontos de integração estão isolados no final do `<script>`:
a função `localDB()` implementa a interface mínima usada pelo painel
(`collection().onSnapshot(cb)`, `doc(path).set(body)`, `doc(path).delete()`).
Um adaptador equivalente para Firebase Firestore ou Supabase substitui essa
função sem mexer no restante do código.

## Modelo de dados

Cada pauta é um documento em `projetos/<id>` com os campos:

`titulo`, `frente` (`alpmi` | `alpme` | `innme` | `inov`), `tags[]`,
`etapa` (`nao_iniciado` | `em_andamento` | `em_revisao` | `pausado` | `concluido`),
`horizonte` (`agora` | `proximo` | `depois`), `saude` (`ok` | `atencao` | `critico`),
`responsavel`, `proximoPasso` (texto livre; linhas com `- ` viram tópicos e
`[ ]` / `[x]` viram checklist), `prazo` (`AAAA-MM-DD`), `notas`, `ordem`
(número usado para ordenar), `atualizadoEm` e `concluidoEm` (ISO 8601).

## Uso

- **Semana**: indicadores, prioridades do "Agora", pontos de atenção, fila e concluídos.
- **Por frente**: um cartão por frente; arraste pautas entre Agora, Próximo e Depois.
- **Prazos**: vencidos, por mês e sem prazo.
- **Concluídos**: histórico.
- **Copiar resumo**: coloca na área de transferência um resumo formatado (HTML e texto) para colar no Outlook.
- Arraste pela alça de seis pontos para reordenar. Alt + seta para cima ou para baixo faz o mesmo pelo teclado.
