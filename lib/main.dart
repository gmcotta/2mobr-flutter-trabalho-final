import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:trabalho_final_2mobr/entities/budget_period.dart';
import 'package:trabalho_final_2mobr/screens/add_register_screen.dart';
import 'package:trabalho_final_2mobr/screens/home_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => BudgetPeriodModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planejador financeiro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add': (context) => const AddRegisterScreen()
      },
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('en'), Locale('pt')],
    );
  }
}
