import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:guia/controllers/lugares_controller.dart';

import 'package:guia/models/lugares_model.dart';

import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  void _mostrarLugar(LugaresModel lugar) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${lugar.nome} - ${lugar.categoria}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa dos lugares"),
      ),

      body: Consumer<LugaresController>(
        builder: (context, lugaresController, child) {
          if (lugaresController.carregando) {
            return Center(child: CircularProgressIndicator());
          }

          if (lugaresController.erro != '') {
            return Center(child: Text(lugaresController.erro));
          }

          final lugares = lugaresController.lugares
              .where((lugar) => lugar.coordenadasValidas)
              .toList();

          return FlutterMap(
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
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => _mostrarLugar(lugar),
                      child: Icon(
                        Icons.place,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                }).toList(),
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
