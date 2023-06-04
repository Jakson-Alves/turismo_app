import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../model/ponto_turistico.dart';

class ConteudoFormDialog extends StatefulWidget{
  final PontoTuristico? turismoAtual;
  ConteudoFormDialog({Key? key, this.turismoAtual}) : super (key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  Position? _localizacaoAtual;
  final _controller = TextEditingController();

  String get _textoLocalizacao => _localizacaoAtual == null ? '' :
  'Latitude: ${_localizacaoAtual!.latitude}  |  Longetude: ${_localizacaoAtual!.longitude}';

  String get _latitude => _localizacaoAtual?.latitude.toString() ?? '';
  String get _longitude => _localizacaoAtual?.longitude.toString() ?? '';

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaooController = TextEditingController();
  final _diferenciaisController = TextEditingController();
  final _dataController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();

  //Inicia todas os campos
  @override
  void iniState(){
    super.initState();
    if (widget.turismoAtual != null){
      _nomeController.text = widget.turismoAtual!.nome;
      _diferenciaisController.text = widget.turismoAtual!.diferenciais;
      _descricaooController.text = widget.turismoAtual!.descricao;
      _dataController.text = widget.turismoAtual!.dataCadastroFormatado;
      _longitudeController.text = widget.turismoAtual!.longitude;
      _latitudeController.text = widget.turismoAtual!.latitude;
    };
  }

  Widget build(BuildContext context){
    return Form(
        key: _formKey,
        child: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today),
                Text("Data: ${_dataController.text.isEmpty ? _dateFormat.format(DateTime.now()) : _dataController.text}")
              ],
            ),
            Divider(color: Colors.white,),
            //Campo para receber o nome do ponto turistico
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe o nome:';
                }
                return null;
              },
            ),
            //Campo para receber a descrição do ponto turistico
            TextFormField(
              controller: _descricaooController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe a descrição:';
                }
                return null;
              },
            ),
            //Campo para receber o diferencial do ponto turistico
            TextFormField(
              controller: _diferenciaisController,
              decoration: InputDecoration(labelText: 'Diferenciais'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe os diferenciais:';
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    labelText: 'Local do Ponto Turistico',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.map),
                      tooltip: 'Abrir no mapa',
                      onPressed: _abrirNoMapaExterno,
                    )
                ),
              ),
            ),
            Divider(color: Colors.white,),
            ElevatedButton(
              child: Text('Obter Localização Atual'),
              onPressed: _obterLocalizacaoAtual,
            ),
            if(_localizacaoAtual != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [Expanded(child: Text(_textoLocalizacao),),ElevatedButton(onPressed: _abrirCoordenadasNoMapaExterno,child: Icon(Icons.map)),],
                ),
              ),
            ],
        ),
        )
        );
  }
  bool dadosValidos() => _formKey.currentState?.validate() == true;

  PontoTuristico get novoTurismo => PontoTuristico(
      id: widget.turismoAtual?.id ?? 0,
      nome: _nomeController.text,
      descricao: _descricaooController.text,
      diferenciais: _diferenciaisController.text,
      latitude: _latitude,
      longitude: _longitude,
      dataCadastro: DateTime.now()
  );

  //Obtém a localização atual
  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if(!permissoesPermitidas){
      return;
    }
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {

    });
  }
  void _abrirNoMapaExterno(){
    if(_controller.text.trim().isEmpty){
      return;
    }
    MapsLauncher.launchQuery(_controller.text);
  }
  void _abrirCoordenadasNoMapaExterno() {
    if(_localizacaoAtual == null){
      return;
    }
    MapsLauncher.launchCoordinates(_localizacaoAtual!.latitude, _localizacaoAtual!.longitude);
  }

  //Permissões permitidas
  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if(permissao == LocationPermission.denied){
      permissao = await Geolocator.requestPermission();
      if(permissao == LocationPermission.denied){
        _mostrarMensagem('Não será possível utilizar o recusro por falta de permissão');
        return false;
      }
    }
    if(permissao == LocationPermission.deniedForever){
      await _mostrarMensagemDialog(
          'Para utilizar esse recurso, você deverá acessar as configurações '
              'do app permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilotado = await Geolocator.isLocationServiceEnabled();
    if(!servicoHabilotado){
      await _mostrarMensagemDialog('Para utilizar esse recurso, você deverá habilitar o serviço de localização '
          'no dispositivo');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarMensagemDialog(String mensagem) async{
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

}