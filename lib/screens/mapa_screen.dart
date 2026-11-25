import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:guia/controllers/auth_controller.dart';
import 'package:guia/controllers/gps_controller.dart';
import 'package:guia/controllers/lugares_controller.dart';

import 'package:guia/widgets/foto_lugar.dart';
import 'package:guia/widgets/lugar_detalhes.dart';

import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _irParaMinhaPosicao() async {
    final gpsController = context.read<GpsController>();

    await gpsController.buscarPosicao();

    if (!mounted) return;

    final posicao = gpsController.posicao;

    if (posicao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(gpsController.erro)),
      );
      return;
    }

    try {
      _mapController.move(LatLng(posicao.latitude, posicao.longitude), 15);
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthController>().usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text("Ola, ${usuario?.nome ?? ''}"),

        actions: [
          CircleAvatar(
            backgroundImage: usuario?.foto != null
                ? NetworkImage(usuario!.foto!)
                : null,
            child: usuario?.foto == null ? Icon(Icons.person) : null,
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, 'lugares'),
            icon: Icon(Icons.list),
            tooltip: 'Ver lugares',
          ),
          IconButton(
            onPressed: () => context.read<AuthController>().sair(),
            icon: Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          FloatingActionButton.small(
            heroTag: 'gps',
            onPressed: _irParaMinhaPosicao,
            tooltip: 'Minha localizacao',
            child: Icon(Icons.my_location),
          ),

          SizedBox(height: 12),

          FloatingActionButton(
            heroTag: 'cadastro',
            onPressed: () => Navigator.pushNamed(context, 'cadastro'),
            tooltip: 'Cadastrar lugar',
            child: Icon(Icons.add),
          ),
        ],
      ),

      body: Consumer2<LugaresController, GpsController>(
        builder: (context, lugaresController, gpsController, child) {
          if (lugaresController.carregando) {
            return Center(child: CircularProgressIndicator());
          }

          if (lugaresController.erro != '') {
            return Center(child: Text(lugaresController.erro));
          }

          final lugares = lugaresController.lugares
              .where((lugar) => lugar.coordenadasValidas)
              .toList();

          final posicao = gpsController.posicao;

          return FlutterMap(
            mapController: _mapController,

            options: MapOptions(
              initialCenter: LatLng(-14.235, -51.925),
              initialZoom: 4,

              initialCameraFit: lugares.isEmpty
                  ? null
                  : CameraFit.coordinates(
                      coordinates: lugares.map((lugar) {
                        return LatLng(lugar.latitude, lugar.longitude);
                      }).toList(),
                      padding: EdgeInsets.all(48),
                      maxZoom: 16,
                    ),
            ),

            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.guia',
              ),

              MarkerLayer(
                markers: lugares.map((lugar) {
                  return Marker(
                    point: LatLng(lugar.latitude, lugar.longitude),
                    width: 48,
                    height: 48,
                    child: GestureDetector(
                      onTap: () => mostrarLugar(context, lugar),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 3),
                        ),
                        child: ClipOval(
                          child: FotoLugar(url: lugar.foto, tamanho: 42),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              if (posicao != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(posicao.latitude, posicao.longitude),
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),

              SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          );
        },
      ),
    );
  }
}
