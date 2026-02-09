import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:olx/models/usuario.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:olx/views/widgets/input_customizado.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController(text: "");
  TextEditingController controllerSenha = TextEditingController(text: "");

  bool cadastrar = false;
  String mensagemErro = "";
  String textoBotao = "Entrar";

  void cadastrarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha,
      );

      String uid = result.user!.uid;

      await db.collection("usuarios").doc(uid).set({
        "email": usuario.email,
        "idUsuario": uid,
      });

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/");

    } on FirebaseAuthException catch (e) {
      setState(() {
        mensagemErro = e.message ?? "Erro ao cadastrar";
      });
    }
  }

  void logarUsuario(Usuario usuario) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usuario.email, 
        password: usuario.senha
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/");

    } on FirebaseAuthException catch (e) {
      setState(() {
        mensagemErro = "Erro: ${e.message}";
      });
    }
  }

  void validarCampos() {
    String email = controllerEmail.text;
    String senha = controllerSenha.text;

    if (email.isNotEmpty && email.contains("@") && senha.length >= 6) {
      setState(() { mensagemErro = ""; });

      Usuario usuario = Usuario();
      usuario.email = email;
      usuario.senha = senha;

      if (cadastrar) {
        cadastrarUsuario(usuario);
      } else {
        logarUsuario(usuario);
      }
    } else {
      setState(() {
        mensagemErro = "Preencha os campos corretamente!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset("images/logo.png", width: 200, height: 150),
                ),
                InputCustomizado(
                  controller: controllerEmail,
                  hint: "E-mail",
                  type: TextInputType.emailAddress,
                ),
                InputCustomizado(
                  controller: controllerSenha,
                  hint: "Senha",
                  obscure: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Logar"),
                    Switch(
                      value: cadastrar,
                      onChanged: (bool valor) {
                        setState(() {
                          cadastrar = valor;
                          textoBotao = cadastrar ? "Cadastrar" : "Entrar";
                        });
                      },
                    ),
                    const Text("Cadastrar"),
                  ],
                ),
                BotaoCustomizado(
                  texto: textoBotao,
                  onPressed: () => validarCampos(),
                ),
                Text(
                  mensagemErro,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}