import 'package:flutter/material.dart';

import 'package:guia/controllers/auth_controller.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),

          child: Consumer<AuthController>(
            builder: (context, authController, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(Icons.travel_explore, size: 80),

                  SizedBox(height: 16),

                  Text(
                    "Guia de Turismo",
                    style: TextStyle(fontSize: 28),
                  ),

                  SizedBox(height: 8),

                  Text("Entre para ver e cadastrar lugares"),

                  SizedBox(height: 32),

                  if (authController.entrando)
                    CircularProgressIndicator()
                  else
                    ElevatedButton.icon(
                      onPressed: authController.firebasePronto
                          ? authController.entrarComGoogle
                          : null,
                      icon: Icon(Icons.login),
                      label: Text("Entrar com o Google"),
                    ),

                  if (authController.erro != '')
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        authController.erro,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
