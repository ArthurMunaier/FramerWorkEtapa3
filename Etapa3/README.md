# Central de Missões

Projeto Flutter + Firebase Cloud Firestore feito em nível simples de aluno.

## Estrutura

lib/
- main.dart
- firebase_options.dart
- models/missao.dart
- providers/missao_provider.dart
- services/missao_service.dart
- pages/home_page.dart

## Firebase

O arquivo `firebase_options.dart` é gerado automaticamente pelo FlutterFire e não pode ser preenchido corretamente sem o projeto Firebase do aluno.

Depois de baixar o projeto:

1. Instale o FlutterFire CLI:
   `dart pub global activate flutterfire_cli`

2. Entre na pasta do projeto.

3. Execute:
   `flutter pub get`

4. Faça login no Firebase:
   `firebase login`

5. Configure o projeto:
   `flutterfire configure`

6. Escolha seu projeto Firebase e a plataforma que vai usar.

7. Crie o Cloud Firestore no console do Firebase.

8. Execute:
   `flutter run`

A coleção usada pelo aplicativo será:

`missoes`

Os documentos terão:
- titulo
- dificuldade
- pontos
- concluida

## Observação

Não é necessário criar a coleção manualmente. Quando você cadastrar a primeira missão pelo aplicativo, o Firestore criará a coleção `missoes` automaticamente.
