# LAUDO TÉCNICO — Central de Achados e Perdidos

## Missão 1 — Configuração inicial

O projeto não compilava porque `lib/firebase_options.dart` não vem no repositório (o README avisa isso). Para rodar, gere o arquivo com `flutterfire configure` no projeto Firebase da escola. Esse arquivo não foi alterado nem inventado.

Também removi `test/widget_test.dart`, que era o teste padrão do Flutter (contador, classe `MyApp` e pacote `bugsresolver`, que não existem neste projeto) e quebrava o analisador.

---

## Bug 1
- **Arquivo:** `lib/pages/central_page.dart`
- **Sintoma:** o app não compilava na tela de lista.
- **Causa:** a string do `subtitle` tinha uma quebra de linha real dentro de aspas simples, o que é erro de sintaxe no Dart.
- **Correção:** a quebra de linha real foi trocada por `\n`.
- **Teste:** `flutter analyze` sem erros de sintaxe e a lista exibe duas linhas por item.

## Bug 2
- **Arquivo:** `lib/pages/central_page.dart`
- **Sintoma:** ao tocar em uma ocorrência o app não compilava (e não abria o detalhe).
- **Causa:** `DetalhePage()` era chamada sem o parâmetro obrigatório `ocorrencia`.
- **Correção:** `DetalhePage(ocorrencia: o)`.
- **Teste:** ao tocar em um item, a tela de detalhes abre com os dados dele.

## Bug 3
- **Arquivo:** `lib/pages/central_page.dart`
- **Sintoma:** era possível registrar objeto com título ou local vazio.
- **Causa:** a validação usava `&&`; só bloqueava se os dois campos estivessem vazios.
- **Correção:** trocado por `||`.
- **Teste:** com só o título preenchido (ou só o local) aparece "Informe título e local." e nada é salvo.

## Bug 4
- **Arquivo:** `lib/pages/central_page.dart`
- **Sintoma:** o interruptor "Somente não resolvidos" ficava ligado quando estava desligado, e vice-versa.
- **Causa:** `onChanged` gravava `!value` (valor invertido).
- **Correção:** `somenteAbertos = value`.
- **Teste:** ao ligar o interruptor, ele fica ligado e o filtro é aplicado.

## Bug 5
- **Arquivo:** `lib/pages/central_page.dart`
- **Sintoma:** com o filtro ligado, apareciam só os itens resolvidos.
- **Causa:** o filtro usava `where((o) => o.resolvido)`.
- **Correção:** `where((o) => !o.resolvido)`.
- **Teste:** com um item resolvido e um aberto, o filtro mostra apenas o aberto.

## Bug 6
- **Arquivo:** `lib/models/ocorrencia.dart`
- **Sintoma:** itens novos (`resolvido: false`) apareciam como "Resolvido" e os resolvidos como "Em aberto".
- **Causa:** o `fromDoc` lia `!(d['resolvido'] ...)`, invertendo o valor.
- **Correção:** `resolvido: d['resolvido'] as bool? ?? false`.
- **Teste:** um item novo aparece "Em aberto"; depois de marcado, aparece "Resolvido".

## Bug 7
- **Arquivo:** `lib/models/ocorrencia.dart`
- **Sintoma:** o botão de alterar status não aparecia para o dono, ou o dono era tratado como outra pessoa.
- **Causa:** `autorId` era lido do campo `autorNome`.
- **Correção:** `autorId: d['autorId']`.
- **Teste:** na conta que criou a ocorrência, o botão "Marcar como resolvido" aparece; na outra conta, não.

## Bug 8
- **Arquivo:** `lib/services/central_service.dart` (método `registrar`)
- **Sintoma:** o dono nunca era reconhecido na verificação de autorização.
- **Causa:** `autorId` era salvo com o e-mail, mas a verificação compara com o `uid`.
- **Correção:** `'autorId': u.uid`.
- **Teste:** no Firestore, o campo `autorId` do novo documento contém o uid do usuário.
- **Observação:** documentos criados antes da correção ainda têm e-mail no `autorId`. Basta registrar novas ocorrências para testar.

## Bug 9
- **Arquivo:** `lib/services/central_service.dart` (método `alterarStatus`)
- **Sintoma:** ao marcar como encontrado, nada mudava (o valor gravado era o mesmo que já estava).
- **Causa:** `update({'resolvido': item.resolvido})` gravava o valor atual.
- **Correção:** `update({'resolvido': !item.resolvido})`.
- **Teste:** o dono marca como resolvido, o status muda na lista e, com "Reabrir", volta a aberto.

## Bug 10
- **Arquivo:** `lib/services/central_service.dart` (método `enviarPista`)
- **Sintoma:** as pistas não apareciam na ocorrência certa (todas iam para o mesmo lugar).
- **Causa:** o caminho usava `.doc('pistas')` fixo em vez do id da ocorrência.
- **Correção:** `.doc(ocorrenciaId).collection('pistas')`.
- **Teste:** pista enviada em uma ocorrência aparece só nela, e não aparece em outra.

## Bug 11
- **Arquivo:** `lib/pages/detalhe_page.dart` (método `enviar`)
- **Sintoma:** enviar uma pista não fazia nada com texto preenchido, e com o campo vazio enviava uma pista em branco.
- **Causa:** a condição estava invertida (`isNotEmpty` saía da função) e a mensagem enviada era `''` em vez do texto digitado.
- **Correção:** `if (pista.text.trim().isEmpty) return;` e `enviarPista(widget.ocorrencia.id, pista.text)`.
- **Teste:** digitar e enviar mostra a pista com o texto e o nome do autor; campo vazio não envia.

## Bug 12
- **Arquivo:** `lib/services/central_service.dart` (método `acompanhar`)
- **Sintoma:** as ocorrências mais antigas apareciam no topo e as novas ficavam no final da lista.
- **Causa:** `orderBy('criadoEm', descending: false)`.
- **Correção:** `descending: true`.
- **Teste:** ao registrar dois objetos em sequência, o mais recente aparece primeiro.

---

## Teste com duas contas (Missão 3)
1. Conta A registra uma ocorrência.
2. Conta B (outro navegador/perfil) vê a ocorrência aparecer sozinha, sem recarregar.
3. Conta B envia uma pista, que aparece na ocorrência correta nas duas contas.
4. Conta B abre a ocorrência da conta A e não vê o botão de alterar status. Conta A vê o botão e consegue alterar.

A captura de tela das duas contas deve ser anexada na entrega.

## Regras respeitadas
Nenhuma funcionalidade foi removida, a autenticação foi mantida e nenhuma regra de segurança foi desativada.
