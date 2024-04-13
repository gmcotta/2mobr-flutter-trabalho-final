import 'package:flutter/material.dart';

import 'package:trabalho_final_2mobr/tabs/budget_tab.dart';
import 'package:trabalho_final_2mobr/tabs/summary_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Planejador financeiro'),
      ),
      body: [budgetTab,summaryTab][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.account_balance), label: 'Orçamento'),
          NavigationDestination(
            icon: Icon(
              Icons.summarize,
            ),
            label: 'Resumo',
          ),
        ],
      ),
    );
  }
}
