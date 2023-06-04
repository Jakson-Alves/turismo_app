import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../model/ponto_turistico.dart';
import 'mapa_interno.dart';

class DetalhesTurismoPage extends StatefulWidget {
  final PontoTuristico pontoturistico;

  const DetalhesTurismoPage({Key? key, required this.pontoturistico}) : super(key: key);

  @override
  _DetalhesTurismoPageState createState() => _DetalhesTurismoPageState();
}

class _DetalhesTurismoPageState extends State<DetalhesTurismoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Turismo'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Campo(descricao: 'Código: '),
            Valor(valor: '${widget.pontoturistico.id}'),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Nome: '),
            Valor(valor: widget.pontoturistico.nome),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Descrição: '),
            Valor(valor: widget.pontoturistico.descricao),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Data: '),
            Valor(valor: widget.pontoturistico.dataCadastroFormatado),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Diferenciais: '),
            Valor(valor: widget.pontoturistico.diferenciais),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Localização: '),
            Valor(
              valor: 'Latitude: ${widget.pontoturistico.latitude}\nLongetude: ${widget.pontoturistico.longitude}',
            ),
            ElevatedButton(
                onPressed: _abrirCoordenadasNoMapaExterno,
                child: Icon(Icons.map)
            ),
            ElevatedButton(
                onPressed: _abrirCoordenadasNoMapaInterno,
                child: Icon(Icons.map)
            ),
          ],
        ),

        Row(
          children: [
            Campo(descricao: 'finalizada: '),
            Valor(valor: widget.pontoturistico.finalizada ? 'Sim' : 'Não'),
          ],
        ),
      ],
    ),
  );

  void _abrirCoordenadasNoMapaExterno() {
    if (widget.pontoturistico.latitude.isEmpty || widget.pontoturistico.longitude.isEmpty ) {
      return;
    }
    MapsLauncher.launchCoordinates(double.parse(widget.pontoturistico.latitude), double.parse(widget.pontoturistico.longitude));
  }

  void _abrirCoordenadasNoMapaInterno(){
    if (widget.pontoturistico.latitude.isEmpty || widget.pontoturistico.longitude.isEmpty ){
      return;
    }
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) => MapaPage(
          latitude: double.parse(widget.pontoturistico.latitude), longitude: double.parse(widget.pontoturistico.longitude)
      ),
      ),
    );
  }
}

class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        descricao,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}