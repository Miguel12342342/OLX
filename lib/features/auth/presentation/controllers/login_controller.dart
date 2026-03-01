import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

class LoginController extends ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  LoginController({
    required this.loginUser,
    required this.registerUser,
  });

  bool isCadastrar = false;
  bool isLoading = false;
  String mensagemErro = "";

  void toggleCadastrar(bool value) {
    isCadastrar = value;
    mensagemErro = "";
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setErro(String mensagem) {
    mensagemErro = mensagem;
    notifyListeners();
  }

  Future<bool> autenticar({required String email, required String senha}) async {
    _setLoading(true);
    _setErro("");

    if (isCadastrar) {
      final userModel = UserEntity(email: email, senha: senha);
      final result = await registerUser(userModel);
      
      _setLoading(false);
      
      return result.fold(
        (failure) {
          _setErro(failure.message);
          return false;
        },
        (user) => true,
      );
    } else {
      final params = LoginUserParams(email: email, senha: senha);
      final result = await loginUser(params);
      
      _setLoading(false);

      return result.fold(
        (failure) {
          _setErro(failure.message);
          return false;
        },
        (user) => true,
      );
    }
  }
}
