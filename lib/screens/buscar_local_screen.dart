import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:guia/controllers/localizacao_controller.dart';

import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

class BuscarLocalScreen extends StatefulWidget {
  const BuscarLocalScreen({super.key});

  @override
  State<BuscarLocalScreen> createState() => _BuscarLocalScreenState();
}

class _BuscarLocalScreenState extends State<BuscarLocalScreen> {
  final _enderecoController = TextEditingController();
  final _mapController = MapController();

  @override
  void dispose() {
    _enderecoController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    final endereco = _enderecoController.text.trim();

    if (endereco.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    final localizacaoController = context.read<LocalizacaoController>();

    await localizacaoController.buscarEndereco(endereco);

    if (!mounted) return;

    final local = localizacaoController.local;

    if (localizacaoController.erro == '' && local != null) {
      _mapController.move(LatLng(local.latitude, local.longitude), 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar local"),
      ),

      body: Consumer<LocalizacaoController>(
        builder: (context, localizacaoController, child) {
          final local = localizacaoController.local;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Padding(
                padding: EdgeInsets.all(16),

                child: TextField(
                  controller: _enderecoController,

                  decoration: InputDecoration(
                    labelText: 'Endereco ou CEP',

                    suffixIcon: localizacaoController.carregando
                        ? Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : IconButton(
                            onPressed: _buscar,
                            icon: Icon(Icons.search),
                            tooltip: 'Buscar',
                          ),
                  ),

                  onSubmitted: (_) => _buscar(),
                ),
              ),

              if (localizacaoController.erro != '')
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(localizacaoController.erro),
                ),

              Expanded(
                child: FlutterMap(
                  mapController: _mapController,

                  options: MapOptions(
                    initialCenter: LatLng(-14.235, -51.925),
                    initialZoom: 4,

                    onTap: (tapPosition, ponto) {
                      localizacaoController.escolherPonto(
                        ponto.latitude,
                        ponto.longitude,
                      );
                    },
                  ),

                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.guia',
                    ),

                    if (local != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(local.latitude, local.longitude),
                            width: 40,
                            height: 40,
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.place,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),

                    SimpleAttributionWidget(
                      source: Text('OpenStreetMap contributors'),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    Text(
                      local == null
                          ? 'Busque um endereco ou toque no mapa'
                          : local.endereco,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: local == null
                          ? null
                          : () => Navigator.pop(context, local),
                      child: Text("Usar este local"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
