import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../../../core/errors/failures.dart';

abstract class IAuthRemoteDataSource {
  Future<UserModel> logarUsuario(String email, String senha);
  Future<UserModel> cadastrarUsuario(UserModel userModel);
  Future<void> deslogar();
  UserModel? get usuarioAtual;
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<UserModel> logarUsuario(String email, String senha) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: senha);
      
      User? user = userCredential.user;
      if (user == null) throw ServerFailure("Usuário não encontrado.");

      return UserModel(id: user.uid, email: email, senha: "");
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(e.message ?? "Erro ao logar no Firebase");
    } catch (e) {
      throw ServerFailure("Erro inesperado ao logar");
    }
  }

  @override
  Future<UserModel> cadastrarUsuario(UserModel userModel) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userModel.email, password: userModel.senha);
      
      User? user = userCredential.user;
      if (user == null) throw ServerFailure("Erro ao criar usuário.");

      await _db.collection("usuarios").doc(user.uid).set(userModel.toMap());

      return UserModel(id: user.uid, email: userModel.email, senha: "");
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(e.message ?? "Erro ao cadastrar no Firebase");
    } catch (e) {
      throw ServerFailure("Erro inesperado ao cadastrar");
    }
  }

  @override
  Future<void> deslogar() async {
    await _auth.signOut();
  }

  @override
  UserModel? get usuarioAtual {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      return UserModel(
        id: currentUser.uid, 
        email: currentUser.email ?? "", 
        senha: ""
      );
    }
    return null;
  }
}
