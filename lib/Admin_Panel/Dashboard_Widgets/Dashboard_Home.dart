import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Dashboard_Header.dart';
import 'Dashboard_List.dart';

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
                  children: [
                    A_DashboardHeader(),
                    A_DashboardList(),
                    //tabbar(),
                  ],
                ),
              ),
            ),
        );
  }
}