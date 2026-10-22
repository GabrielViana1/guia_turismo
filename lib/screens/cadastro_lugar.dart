import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:guia/controllers/camera_controller.dart';
import 'package:guia/controllers/categorias_controller.dart';
import 'package:guia/controllers/lugares_controller.dart';

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

    final mensagem = await lugaresController.cadastrarLugar(dados);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );

    if (mensagem.contains('sucesso')) {
      _limparFormulario();
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

  String? _validarObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio!';
    }
    return null;
  }

  String? _validarNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio!';
    }

    if (double.tryParse(valor) == null) {
      return 'Informe um numero valido!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar lugar"),

        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, 'lugares'),
            icon: Icon(Icons.list),
            tooltip: 'Ver lugares',
          ),
        ],
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

              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),

                keyboardType: TextInputType.numberWithOptions(decimal: true),

                validator: _validarNumero,
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: _validarNumero,
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
                  final imagem = cameraController.imagemSelecionada;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (cameraController.carregando)
                        Center(child: CircularProgressIndicator())

                      else if (imagem != null)
                        kIsWeb
                            ? Image.network(
                                imagem.path,
                                height: 180,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                imagem,
                                height: 180,
                                fit: BoxFit.cover,
                              ),

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
