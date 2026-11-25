import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:guia/firebase_options.dart';

import 'package:guia/models/usuario_model.dart';

class AuthService {
  Future<void> iniciar() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb) {
      await GoogleSignIn.instance.initialize();
    }
  }

  Future<UsuarioModel?> usuarioLogado() async {
    final usuario = await FirebaseAuth.instance.authStateChanges().first;

    if (usuario == null) {
      return null;
    }

    return _converter(usuario);
  }

  Future<UsuarioModel?> entrar() async {
    UserCredential resultado;

    if (kIsWeb) {
      resultado = await FirebaseAuth.instance.signInWithPopup(
        GoogleAuthProvider(),
      );
    } else {
      final conta = await GoogleSignIn.instance.authenticate();

      final credencial = GoogleAuthProvider.credential(
        idToken: conta.authentication.idToken,
      );

      resultado = await FirebaseAuth.instance.signInWithCredential(credencial);
    }

    final usuario = resultado.user;

    if (usuario == null) {
      return null;
    }

    return _converter(usuario);
  }

  Future<void> sair() async {
    await FirebaseAuth.instance.signOut();

    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
  }

  UsuarioModel _converter(User usuario) {
    return UsuarioModel(
      nome: usuario.displayName ?? usuario.email ?? 'Usuario',
      email: usuario.email ?? '',
      foto: usuario.photoURL,
    );
  }
}
