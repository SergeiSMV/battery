import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/allitems_bloc.dart';



class StorageSearchBar extends StatefulWidget {
  const StorageSearchBar({Key? key,}) : super(key: key);

  @override
  State<StorageSearchBar> createState() => _StorageSearchBarState();
}

class _StorageSearchBarState extends State<StorageSearchBar> {
  final TextEditingController controller = TextEditingController();
  

  @override
  void dispose(){
    controller.clear();
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.indigoAccent.shade100),
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                
                autofocus: false,
                controller: controller,
                style: const TextStyle(fontSize: 15, color: Color(0xFF095D82), overflow: TextOverflow.ellipsis),
                
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'поиск',
                  contentPadding: const EdgeInsets.only(bottom: 15.0, left: 25),
                  isDense: true,
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1)),
                  suffixIcon: controller.text.isEmpty ? const SizedBox.shrink() :
                    IconButton(splashRadius: 20, onPressed: (){ 
                      context.read<AllItemsBloc>().add(SimStorageClearSearchEvent());
                      controller.clear(); 
                      setState(() {});
                    }, icon: const Icon(Icons.clear, color: Color(0xFF095D82)))
                ),
                
                onChanged: (text) {
                  setState(() {});
                  text = text.toLowerCase();
                  context.read<AllItemsBloc>().add(SimStorageSearchEvent(text: text));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}