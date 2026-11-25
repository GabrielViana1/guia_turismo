import 'package:flutter/material.dart';

class FotoLugar extends StatelessWidget {
  final String? url;

  final double tamanho;

  const FotoLugar({super.key, required this.url, this.tamanho = 48});

  @override
  Widget build(BuildContext context) {
    final semFoto = Container(
      width: tamanho,
      height: tamanho,
      color: Colors.blueGrey.shade100,
      child: Icon(Icons.image_not_supported, size: tamanho / 2),
    );

    if (url == null) {
      return semFoto;
    }

    return Image.network(
      url!,
      width: tamanho,
      height: tamanho,
      fit: BoxFit.cover,

      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,

      errorBuilder: (context, erro, pilha) => semFoto,
    );
  }
}
