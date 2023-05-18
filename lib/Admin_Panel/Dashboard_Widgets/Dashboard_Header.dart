import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: camel_case_types
class aDashboardHeader extends StatelessWidget {
  const aDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // isey text syart s ae ga
      children: [
        "ADMIN DASHBOARD ".text.xl4.bold.color(context.accentColor).make(),
        "Dashboard".text.xl2.make(),
      ],
    );
  }
}
