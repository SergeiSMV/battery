
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/sim_uniq_items_bloc.dart';

class SearchUniqItems extends StatefulWidget {
  const SearchUniqItems({Key? key}) : super(key: key);

  @override
  State<SearchUniqItems> createState() => _SearchUniqItemsState();
}

class _SearchUniqItemsState extends State<SearchUniqItems> {
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
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0),)),
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
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
                  fillColor: Colors.green.shade50,
                  hintText: 'поиск',
                  contentPadding: const EdgeInsets.only(bottom: 15.0),
                  isDense: true,
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF095D82)),
                  suffixIcon: controller.text.isEmpty ? 
                  const SizedBox.shrink()
                  : 
                  IconButton(splashRadius: 20, onPressed: (){ 
                    context.read<SimUniqBloc>().add(SimUniqClearSearchEvent());
                    controller.clear(); 
                    setState(() {});
                  }, icon: const Icon(Icons.clear, color: Color(0xFF095D82)))
                ),
                onChanged: (text) {
                  setState(() {});
                  text = text.toLowerCase();
                  context.read<SimUniqBloc>().add(SimUniqSearchEvent(text: text));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}