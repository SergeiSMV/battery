import 'package:flutter/material.dart';

import '../../../static/ui/colors.dart';

Widget departmentsViews(List departments){
  return Column(
    children: [
      const SizedBox(height: 100),
      Padding(
        padding: const EdgeInsets.only(left: 13),
        child: SizedBox(
          child: Align(
            alignment: Alignment.topLeft, 
            child: Text('Выбирете департамент', 
              style: TextStyle(fontSize: 21, fontFamily: 'Montserrat-Regular', color: firmColor),
            )
          )
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: departments.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue.shade50.withOpacity(0.5), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  title: Text('${departments[index]['description']}', style:  TextStyle(fontSize: 14, color: firmColor)),
                  onTap: (){ 
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => departments[index]['route']));
                  },
                ),
              ),
            );
          },
        ),
      ),
    ],
  ); 
}