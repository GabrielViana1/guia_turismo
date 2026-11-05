import 'package:flutter/material.dart';

import 'package:guia/controllers/auth_controller.dart';
import 'package:guia/controllers/camera_controller.dart';
import 'package:guia/controllers/categorias_controller.dart';
import 'package:guia/controllers/localizacao_controller.dart';
import 'package:guia/controllers/lugares_controller.dart';
import 'package:guia/controllers/theme_controller.dart';

import 'package:guia/screens/buscar_local_screen.dart';
import 'package:guia/screens/cadastro_lugar.dart';
import 'package:guia/screens/lugares_screen.dart';
import 'package:guia/screens/mapa_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(Inicializar());
}

class Inicializar extends StatefulWidget {
  const Inicializar({super.key});

  @override
  State<Inicializar> createState() => _InicializarState();
}

class _InicializarState extends State<Inicializar> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LugaresController()),

        ChangeNotifierProvider(create: (_) => CategoriasController()),

        ChangeNotifierProvider(create: (_) => AuthController()),

        ChangeNotifierProvider(create: (_) => ThemeController()),

        ChangeNotifierProvider(create: (_) => CameraController()),

        ChangeNotifierProvider(create: (_) => LocalizacaoController()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        initialRoute: 'cadastro',

        routes: {
          'lugares': (context) => LugaresScreen(),
          'cadastro': (context) => CadastroLugar(),
          'mapa': (context) => MapaScreen(),
          'buscar_local': (context) => BuscarLocalScreen(),
        },
      ),
    );
  }
}
