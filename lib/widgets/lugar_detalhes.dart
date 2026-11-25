import 'package:flutter/material.dart';

import 'package:guia/controllers/favoritos_controller.dart';
import 'package:guia/controllers/gps_controller.dart';

import 'package:guia/models/lugares_model.dart';

import 'package:guia/services/rotas_service.dart';

import 'package:guia/widgets/foto_lugar.dart';

import 'package:provider/provider.dart';

class LugarDetalhes extends StatefulWidget {
  final LugaresModel lugar;

  const LugarDetalhes({super.key, required this.lugar});

  @override
  State<LugarDetalhes> createState() => _LugarDetalhesState();
}

class _LugarDetalhesState extends State<LugarDetalhes> {
  String mensagem = '';

  Future<void> _favoritar() async {
    final resposta = await context
        .read<FavoritosController>()
        .alternarFavorito(widget.lugar.id);

    if (!mounted) return;

    setState(() {
      mensagem = resposta;
    });
  }

  Future<void> _comoChegar() async {
    bool abriu = false;

    try {
      abriu = await RotasService().abrirRota(
        widget.lugar.latitude,
        widget.lugar.longitude,
      );
    } catch (e) {
      abriu = false;
    }

    if (!mounted) return;

    if (!abriu) {
      setState(() {
        mensagem = 'Nao foi possivel abrir o mapa de rotas.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lugar = widget.lugar;

    final distancia = context.watch<GpsController>().distanciaAte(
      lugar.latitude,
      lugar.longitude,
    );

    final favorito = context.watch<FavoritosController>().ehFavorito(lugar.id);

    return Padding(
      padding: EdgeInsets.all(16),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 180,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: FotoLugar(url: lugar.foto, tamanho: 180),
              ),
            ),
          ),

          SizedBox(height: 12),

          Text(lugar.nome, style: TextStyle(fontSize: 22)),

          Text(lugar.categoria ?? 'Sem categoria'),

          if (distancia != null) Text("Distancia: $distancia"),

          SizedBox(height: 8),

          Text(lugar.descricao),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _favoritar,
                  icon: Icon(
                    favorito ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  label: Text(favorito ? "Favorito" : "Favoritar"),
                ),
              ),

              SizedBox(width: 8),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _comoChegar,
                  icon: Icon(Icons.directions),
                  label: Text("Como chegar"),
                ),
              ),
            ],
          ),

          if (mensagem != '')
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(mensagem, textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }
}

void mostrarLugar(BuildContext context, LugaresModel lugar) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => SingleChildScrollView(
      child: LugarDetalhes(lugar: lugar),
    ),
  );
}
