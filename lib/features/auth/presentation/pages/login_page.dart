import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
// Note: We'll fix the widget imports later when we move the widgets.
// For now, assume they are available from the old path or we move them.
import '../../../../core/widgets/botao_customizado.dart';
import '../../../../core/widgets/input_customizado.dart';
import '../../infrastructure/datasources/auth_remote_datasource.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerSenha = TextEditingController();
  
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    // Dependeny Injection (DIY version)
    final remoteDataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepositoryImpl(remoteDataSource);
    final loginUseCase = LoginUser(repository);
    final registerUseCase = RegisterUser(repository);
    
    _controller = LoginController(
      loginUser: loginUseCase,
      registerUser: registerUseCase
    );
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerSenha.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onPressedButton() async {
    bool sucesso = await _controller.autenticar(
      email: controllerEmail.text.trim(),
      senha: controllerSenha.text.trim(),
    );

    if (sucesso && mounted) {
      Navigator.pushReplacementNamed(context, "/");
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
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
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
                          value: _controller.isCadastrar,
                          onChanged: _controller.toggleCadastrar,
                        ),
                        const Text("Cadastrar"),
                      ],
                    ),
                    if (_controller.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      BotaoCustomizado(
                        texto: _controller.isCadastrar ? "Cadastrar" : "Entrar",
                        onPressed: _onPressedButton,
                      ),
                    if (_controller.mensagemErro.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _controller.mensagemErro,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
