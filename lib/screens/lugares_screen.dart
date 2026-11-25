import 'package:flutter/material.dart';

import 'package:guia/controllers/favoritos_controller.dart';
import 'package:guia/controllers/gps_controller.dart';
import 'package:guia/controllers/lugares_controller.dart';

import 'package:guia/widgets/foto_lugar.dart';
import 'package:guia/widgets/lugar_detalhes.dart';

import 'package:provider/provider.dart';

class LugaresScreen extends StatefulWidget {
  const LugaresScreen({super.key});

  @override
  State<LugaresScreen> createState() => _LugaresScreenState();
}

class _LugaresScreenState extends State<LugaresScreen> {
  Future<void> _favoritar(int lugarId) async {
    final mensagem = await context
        .read<FavoritosController>()
        .alternarFavorito(lugarId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lugares para visitar"),
      ),

      body: Consumer3<LugaresController, FavoritosController, GpsController>(
        builder: (context, lugaresController, favoritosController,
            gpsController, child) {
          if (lugaresController.carregando) {
            return Center(child: CircularProgressIndicator());
          }

          if (lugaresController.erro != '') {
            return Center(child: Text(lugaresController.erro));
          }

          if (lugaresController.lugares.isEmpty) {
            return Center(child: Text("Nenhum lugar encontrado!"));
          }

          return ListView.builder(
            itemCount: lugaresController.lugares.length,

            itemBuilder: (context, index) {
              final lugar = lugaresController.lugares[index];

              final distancia = gpsController.distanciaAte(
                lugar.latitude,
                lugar.longitude,
              );

              final favorito = favoritosController.ehFavorito(lugar.id);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,

                child: ListTile(
                  onTap: () => mostrarLugar(context, lugar),

                  title: Text(lugar.nome),

                  subtitle: Text(
                    distancia == null
                        ? lugar.categoria ?? ''
                        : '${lugar.categoria ?? ''} - $distancia',
                  ),

                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FotoLugar(url: lugar.foto),
                  ),

                  trailing: IconButton(
                    onPressed: () => _favoritar(lugar.id),
                    icon: Icon(
                      favorito ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
