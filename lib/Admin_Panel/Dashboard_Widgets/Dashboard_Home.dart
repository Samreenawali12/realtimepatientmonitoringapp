// ignore: file_names
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dashboard_header.dart';
import 'dashboard_list.dart';

// ignore: camel_case_types
class A_DashboardHome extends StatelessWidget {
  const A_DashboardHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
            bottom: false,
            child: Container(
              padding: Vx.mOnly(right: 25.0, left: 20.0, top: 0.0),
                child: Column(
                  crossAxisAlignment:
                   CrossAxisAlignment.start, // isey text syart s ae ga
                  children: const [
                    aDashboardHeader(),
                    ADashboardList(),
                    //tabbar(),
                  ],
                ),
              ),
            ),
        );
  }
}