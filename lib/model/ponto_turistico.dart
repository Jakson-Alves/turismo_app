
import 'package:intl/intl.dart';

class PontoTuristico{

  static const nomeTabela = 'ponto_turistico';
  static const campoId = 'id';
  static const campoNome = 'nome';
  static const campoDescricao = 'descricao';
  static const campoData = 'data';
  static const campoDiferenciais = 'diferenciais';
  static const campoLongitude = 'longitude';
  static const campoLatitude = 'latitude';
  static const campoLocalizacao = 'localizacao';
  static const campoCEP = 'cep';
  static const campoFinalizada = 'finalizada';

  int? id;
  String nome;
  String descricao;
  String diferenciais;
  DateTime? dataCadastro = DateTime.now();
  String longitude;
  String latitude;
  String localizacao;
  String cep;
  bool finalizada;

  PontoTuristico({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.diferenciais,
    required this.longitude,
    required this.latitude,
    required this.localizacao,
    required this.cep,
    this.finalizada = false,
    this.dataCadastro
  });

  String get dataCadastroFormatado{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  Map<String, dynamic> toMap() => {
    campoId: id == 0 ? null: id,
    campoNome: nome,
    campoDescricao: descricao,
    campoDiferenciais: diferenciais,
    campoData:
    dataCadastro == null ? null : DateFormat("yyyy-MM-dd").format(dataCadastro!),
    campoLongitude:longitude,
    campoLatitude:latitude,
    campoLocalizacao:localizacao,
    campoCEP:cep,
    campoFinalizada: finalizada ? 1 : 0
  };

  factory PontoTuristico.fromMap(Map<String, dynamic> map) => PontoTuristico(
    id: map[campoId] is int ? map[campoId] : null,
    nome: map[campoNome] is String ? map[campoNome] : '',
    descricao: map[campoDescricao] is String ? map[campoDescricao] : '',
    diferenciais: map[campoDiferenciais] is String ? map[campoDiferenciais] : '',
    dataCadastro: map[campoData] is String
        ? DateFormat("yyyy-MM-dd").parse(map[campoData])
        : null,
    latitude: map[campoLatitude] is String ? map[campoLatitude] : '',
    longitude: map[campoLongitude] is String ? map[campoLongitude] : '',
    localizacao: map[campoLocalizacao] is String ? map[campoLocalizacao] : '',
    cep: map[campoCEP] is String ? map[campoCEP] : '',
    finalizada: map[campoFinalizada] == 1,
  );
}




















