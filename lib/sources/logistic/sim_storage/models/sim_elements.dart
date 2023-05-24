// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';



class SimElements{
  final List blocState;
  SimElements({required this.blocState});

  // ss - sim storage

  // СКЛАД СИМ
  bool ssAdd() => _accessList().contains('ss_add') ? true : false;  // доступ на прием сырья и материалов СиМ
  bool ssPanel() => _accessList().contains('ss_panel') ? true : false;  // доступ к панели управления складом СиМ 
  bool sspNmncl() => _accessList().contains('ssp_nmncl') ? true : false;  // доступ на создание и редактирование номенклатуры СиМ
  bool sspColor() => _accessList().contains('ssp_color') ? true : false;  // доступ на создание и редактирование цветовой схемы ТМЦ СиМ
  bool sspPrdcr() => _accessList().contains('ssp_prdcr') ? true : false;  // доступ на создание и редактирование поставщиков ТМЦ СиМ
  bool ssaDate() => _accessList().contains('ssa_date') ? true : false;  // доступ на редактирование даты при поступлении ТМЦ
  bool ssaPlace() => _accessList().contains('ssa_place') ? true : false;  // доступ на прямое поступление ТМЦ на склад в обход склада ВК
  
  // ЗАЯВКИ СИМ
  bool soAdd() => _accessList().contains('so_add') ? true : false;  // доступ на создание заявок для СиМ
  bool soOut() => _accessList().contains('so_out') ? true : false;  // доступ на выдачу ТМЦ по заявке со склада СиМ

  // ИНФОРМАЦИЯ О ТМЦ СИМ
  bool ssItem() => _accessList().contains('ss_item') ? true : false;  // доступ панели управления ТМЦ СиМ
  bool ssiMove() => _accessList().contains('ssi_move') ? true : false;  // доступ к перемещению ТМЦ между зонами СиМ
  bool ssiQr() => _accessList().contains('ssi_qr') ? true : false;  // доступ к отправке QR кода ТМЦ СиМ
  bool ssiHistory() => _accessList().contains('ssi_history') ? true : false;  // доступ истории движения ТМЦ СиМ
  bool ssiAphoto() => _accessList().contains('ssi_aphoto') ? true : false;  // доступ на добавление фото ТМЦ СиМ
  bool ssiDphoto() => _accessList().contains('ssi_dphoto') ? true : false;  // доступ на удаление фото ТМЦ СиМ
  bool ssiStatus() => _accessList().contains('ssi_status') ? true : false;  // доступ на изменение статуса ТМЦ СиМ
  bool ssiEdit() => _accessList().contains('ssi_edit') ? true : false;  // доступ на редактирование ТМЦ СиМ
  bool ssiDelete() => _accessList().contains('ssi_delete') ? true : false;  // доступ на удаление ТМЦ СиМ

  bool statusGod(){
    return _accessList().contains('god') ? true : false;
  }


  List _accessList(){
    List accessList = [];
    Function eq = const ListEquality().equals;
    List<dynamic> compare = ['search'];
    bool result = eq(blocState, compare);
    result ? null : {for(var a in blocState){ accessList.add(a['chapter']) }};
    return accessList;
  }

}