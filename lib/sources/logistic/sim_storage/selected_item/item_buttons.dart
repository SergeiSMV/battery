import 'package:battery/static/ui/system_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../../static/ui/colors.dart';
import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';
import '../bloc/isexpanded_bloc.dart';
import 'bloc/itemhistory_bloc.dart';
import 'bloc/itemmenu_index_bloc.dart';
import 'bloc/itemphoto_bloc.dart';
import 'models/item_addimage.dart';
import 'models/item_deleteimage.dart';



// кнопки на пвнели управления ТМЦ склада сырья и материалов
class ItemButtons{
  final BuildContext selectedItemContext;
  final Map itemData;
  
  const ItemButtons({
    required this.selectedItemContext,
    required this.itemData,
  });

  bool get isExpanded => selectedItemContext.read<IsExpandedBloc>().state;

  replaceButton(){
    return IconButton(
      onPressed: () {
        selectedItemContext.read<ItemMenuIndexBloc>().add(const ItemMenuIndexChange(data: 0)); 
        isExpanded ? null : selectedItemContext.read<IsExpandedBloc>().add(IsExpandedChange()); 
      },
      icon: Icon(MdiIcons.arrowRightCircle, color: firmColor,));
  }


  sendQrButton(){
    return IconButton(
      onPressed: () {
        Connection(data: {'data': itemData}, route: sendQr).connect();
        Navigator.pop(selectedItemContext);
        systemMessage(selectedItemContext, 'QR код отправлен на почту');
      },
      icon: Icon(MdiIcons.printer, color: firmColor,),
    );
  }

  historyButton(){
    return IconButton(
      onPressed: () {
        Connection(data: {'itemId': itemData['itemId']}, route: simGetHistory).connect().then((value) => 
          value is List ? selectedItemContext.read<ItemHistoryBloc>().add(ItemHistoryChange(data: value)) : null,
        );
        selectedItemContext.read<ItemMenuIndexBloc>().add(const ItemMenuIndexChange(data: 1));
        isExpanded ? null : selectedItemContext.read<IsExpandedBloc>().add(IsExpandedChange()); 
      },
      icon: Icon(MdiIcons.clipboardTextClock, color: firmColor,),
    );
  }

  photoAddButtons(){
    List currentPhotoList = selectedItemContext.watch<ItemPhotoBloc>().state;
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        IconButton(
          onPressed: () { 
            itemAddImage(itemData, ImageSource.gallery).then((value){
              currentPhotoList.add(value);
              selectedItemContext.read<ItemPhotoBloc>().add(ItemPhotoChange(data: currentPhotoList.toList()));
            }); 

          },
          icon: Icon(MdiIcons.imagePlus, color: firmColor,),
        ),

        IconButton(
          onPressed: () { 
            itemAddImage(itemData, ImageSource.camera).then((value){
              currentPhotoList.add(value);
              selectedItemContext.read<ItemPhotoBloc>().add(ItemPhotoChange(data: currentPhotoList.toList()));
            }); 
          },
          icon: Icon(MdiIcons.cameraPlus, color: firmColor,),
        )
      ],
    );
  }

  photoDelButtons(List imageLinks, int index){
    return Padding(
      padding: const EdgeInsets.only(left: 260, top: 145),
      child: CircleAvatar(
        backgroundColor: Colors.red, 
        radius: 20, 
        child: IconButton(
          onPressed: () async {
            String delLink = imageLinks[index];
            imageLinks.removeAt(index);
            await itemDeleteImage(itemData, delLink).then((value){ selectedItemContext.read<ItemPhotoBloc>().add(ItemPhotoChange(data: imageLinks.toList())); });
          }, 
          icon: Icon(MdiIcons.delete, color: Colors.white, size: 25,),
        )
      ),
    );
  }

  statusButton(){
    return IconButton(
      onPressed: () { 
        selectedItemContext.read<ItemMenuIndexBloc>().add(const ItemMenuIndexChange(data: 2));
        isExpanded ? null : selectedItemContext.read<IsExpandedBloc>().add(IsExpandedChange());
      },
      icon: Icon(MdiIcons.pauseOctagon, color: firmColor,),
    );
  }

  editButton(){
    return IconButton(
      onPressed: () { 
        selectedItemContext.read<ItemMenuIndexBloc>().add(const ItemMenuIndexChange(data: 3)); 
        isExpanded ? null : selectedItemContext.read<IsExpandedBloc>().add(IsExpandedChange());
      },
      icon: Icon(MdiIcons.fileEdit, color: firmColor,),
    );
  }

  deleteButton(){
    return IconButton(
      onPressed: () { 
        selectedItemContext.read<ItemMenuIndexBloc>().add(const ItemMenuIndexChange(data: 4)); 
        isExpanded ? null : selectedItemContext.read<IsExpandedBloc>().add(IsExpandedChange());
      },
      icon: Icon(MdiIcons.deleteForever, color: firmColor,),
    );
  }


}