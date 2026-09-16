import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/usuario_provider.dart';
import 'providers/produto_provider.dart';
import 'pages/login_page.dart';

void main() { runApp(const MeuApp()); }
class MeuApp extends StatelessWidget { const MeuApp({super.key}); @override Widget build(BuildContext context)=>MultiProvider(providers:[ChangeNotifierProvider(create:(_)=>UsuarioProvider()),ChangeNotifierProvider(create:(_)=>ProdutoProvider())],child:MaterialApp(debugShowCheckedModeBanner:false,title:'Controle de Estoque',theme:ThemeData(useMaterial3:true,colorSchemeSeed:Colors.blue),home:const LoginPage())); }
