import 'package:flutter/material.dart';

import '../../../static/ui/no_accesse.dart';
import '../ui/departments_views.dart';
import 'deaprtments_routers.dart';

class SortDeaprtments{
  final BuildContext context;
  final List accesses;
  const SortDeaprtments({required this.context, required this.accesses});


  sortDepartments(){
    List departments = [];

    for(var m in accesses){
      m is Map ? 
        m['department'] == 'main' ? departments.add(m) : null
        : 
        null;
    }

    if(departments.isEmpty){
      return noAccesse();
    }

    else if (departments.length == 1){
      departmentsRouters(true, departments);
      WidgetsBinding.instance.addPostFrameCallback((_) { 
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => departments[0]['route']));
      });
      return const SizedBox();
    }
    
    else if (departments.length > 1){
      departmentsRouters(false, departments);
      return departmentsViews(departments);
    }
  }



}