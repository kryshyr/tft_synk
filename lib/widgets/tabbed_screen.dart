import 'package:flutter/material.dart';
import '../app_constants.dart';
import 'diamond_indicator.dart';
import '../units.dart';
import '../traits.dart';
import '../items.dart';

class TabbedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 2,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'UNITS'),
              Tab(text: 'TRAITS'),
              Tab(text: 'ITEMS'),
            ],
            dividerColor: AppColors.secondary,
            indicator: DiamondIndicator(),
            indicatorColor: AppColors.secondary,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.secondary.withOpacity(0.6),
            labelStyle: AppTextStyles.headline2BeaufortforLOL,
          ),
          backgroundColor: AppColors.primary,
        ),
        body: TabBarView(
          children: [
            UnitTab(),
            TraitsTab(),
            ItemsTab(),
          ],
        ),
      ),
    );
  }
}
