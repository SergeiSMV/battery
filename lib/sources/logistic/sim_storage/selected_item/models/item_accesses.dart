import 'package:flutter/cupertino.dart';

import '../../models/sim_elements.dart';



class ItemButtonAccess{
  final SimElements simElements;
  
  const ItemButtonAccess({
    required this.simElements
  });

  replaceAccess(Widget button) => simElements.ssiMove() ? button : const SizedBox.shrink();
  sendQrAccess(Widget button) => simElements.ssiQr() ? button : const SizedBox.shrink();
  historyAccess(Widget button) => simElements.ssiMove() ? button : const SizedBox.shrink();
  photoAccess(Widget button) => simElements.ssiAphoto() ? button : const SizedBox.shrink();
  statusAccess(Widget button) => simElements.ssiStatus() ? button : const SizedBox.shrink();
  editAccess(Widget button) => simElements.ssiEdit() ? button : const SizedBox.shrink();
  deleteAccess(Widget button) => simElements.ssiDelete() ? button : const SizedBox.shrink();
  delPhotoAccess(Widget button) => simElements.ssiDphoto() ? button : const SizedBox.shrink();



}


