import 'package:flutter/material.dart';

import 'package:guia/controllers/camera_controller.dart';
import 'package:guia/controllers/categorias_controller.dart';
import 'package:guia/controllers/localizacao_controller.dart';
import 'package:guia/controllers/lugares_controller.dart';

import 'package:guia/models/local_model.dart';
import 'package:guia/models/lugares_model.dart';

import 'package:provider/provider.dart';

class CadastroLugar extends StatefulWidget {
  const CadastroLugar({super.key});

  @override
  State<CadastroLugar> createState() => _CadastroLugarState();
}

class _CadastroLugarState extends State<CadastroLugar> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  int? _categoriaId;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final lugaresController = context.read<LugaresController>();

    final dados = LugaresModel(
      nome: _nomeController.text,
      descricao: _descricaoController.text,

      latitude: double.parse(_latitudeController.text),
      longitude: double.parse(_longitudeController.text),

      categoriaId: _categoriaId!,
    );

    final cameraController = context.read<CameraController>();

    final mensagem = await lugaresController.cadastrarLugar(
      dados,
      cameraController.imagemBytes,
      cameraController.nomeImagem,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );

    if (mensagem.contains('sucesso')) {
      _limparFormulario();
      cameraController.limpar();
    }
  }

  void _limparFormulario() {
    _nomeController.clear();
    _descricaoController.clear();
    _latitudeController.clear();
    _longitudeController.clear();

    setState(() {
      _categoriaId = null;
    });
  }

  Future<void> _buscarNoMapa() async {
    context.read<LocalizacaoController>().limpar();

    final local = await Navigator.pushNamed(context, 'buscar_local');

    if (local is LocalModel) {
      _latitudeController.text = local.latitude.toString();
      _longitudeController.text = local.longitude.toString();
    }
  }

  String? _validarObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio!';
    }
    return null;
  }

  String? _validarCoordenada(String? valor, int limite) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio!';
    }

    final numero = double.tryParse(valor);

    if (numero == null) {
      return 'Informe um numero valido!';
    }

    if (numero < -limite || numero > limite) {
      return 'Informe um valor entre -$limite e $limite!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar lugar"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              TextFormField(
                controller: _nomeController,

                decoration: InputDecoration(labelText: 'Nome'),

                validator: _validarObrigatorio,
              ),

              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descricao'),

                maxLines: 3,

                validator: _validarObrigatorio,
              ),

              SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _buscarNoMapa,
                icon: Icon(Icons.map),
                label: Text("Buscar endereco ou CEP no mapa"),
              ),

              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),

                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),

                validator: (valor) => _validarCoordenada(valor, 90),
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (valor) => _validarCoordenada(valor, 180),
              ),

              SizedBox(height: 8),

              Consumer<CategoriasController>(
                builder: (context, categoriasController, child) {
                  if (categoriasController.carregando) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (categoriasController.erro != '') {
                    return Text(categoriasController.erro);
                  }

                  return DropdownButtonFormField<int>(
                    initialValue: _categoriaId,

                    decoration: InputDecoration(labelText: 'Categoria'),

                    items: categoriasController.categorias.map((categoria) {
                      return DropdownMenuItem<int>(
                        value: categoria.id,
                        child: Text(categoria.nome),
                      );
                    }).toList(),

                    onChanged: (valor) {
                      setState(() {
                        _categoriaId = valor;
                      });
                    },

                    validator: (valor) {
                      if (valor == null) {
                        return 'Escolha uma categoria!';
                      }
                      return null;
                    },
                  );
                },
              ),

              SizedBox(height: 16),

              Consumer<CameraController>(
                builder: (context, cameraController, child) {
                  final imagem = cameraController.imagemBytes;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (cameraController.carregando)
                        Center(child: CircularProgressIndicator())

                      else if (imagem != null)
                        Image.memory(
                          imagem,
                          height: 180,
                          fit: BoxFit.cover,
                        ),

                      if (cameraController.erro != '')
                        Text(cameraController.erro),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: cameraController.abrirCamera,
                            icon: Icon(Icons.camera_alt),
                            label: Text("Camera"),
                          ),
                          TextButton.icon(
                            onPressed: cameraController.abrirGaleria,
                            icon: Icon(Icons.photo_library),
                            label: Text("Galeria"),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 24),

              Consumer<LugaresController>(
                builder: (context, lugaresController, child) {
                  if (lugaresController.carregando) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ElevatedButton(
                    onPressed: _salvar,
                    child: Text("Salvar"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
