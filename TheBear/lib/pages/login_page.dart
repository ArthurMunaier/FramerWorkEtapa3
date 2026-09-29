import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'cadastro_page.dart';
import 'pedidos_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bear - Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),
            const SizedBox(height: 20),
            Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return ElevatedButton(
                  onPressed: () async {
                    bool entrou = await viewModel.login(
                      emailController.text,
                      senhaController.text,
                    );

                    if (entrou) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PedidosPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(viewModel.mensagem),
                        ),
                      );
                    }
                  },
                  child: const Text('Entrar'),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroPage(),
                  ),
                );
              },
              child: const Text('Não tenho cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
