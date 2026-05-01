import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/language_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/exploitant_provider.dart';
import 'providers/exploitation_provider.dart';
import 'providers/questionnaire_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/exploitant_management_screen.dart';
import 'screens/questionnaire_screen.dart';
import 'screens/rga_stepper_screen.dart';
import 'screens/sections/exploitation_form.dart';
import 'screens/sections/01_exploitant_section.dart';
import 'screens/investor_dashboard_screen.dart';
import 'screens/add_exploitation_screen.dart';
import 'screens/add_exploitant_screen.dart';
import 'screens/campaigns_screen.dart';
import 'screens/completed_census_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // سطر جديد مضاف
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ExploitantsProvider()),
        ChangeNotifierProvider(create: (_) => ExploitationProvider()),
        ChangeNotifierProvider(create: (_) => QuestionnaireProvider()),
      ],
      child: const RgaApp(),
    ),
  );
}

class RgaApp extends StatelessWidget {
  const RgaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGA App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/investor_dashboard': (context) => InvestorDashboardScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/exploitant_management': (context) => ExploitantManagementScreen(),
        '/exploitant_form': (context) => ExploitantFormScreen(),
        '/add_exploitant': (context) => const AddExploitantScreen(),
        '/add_exploitation': (context) => const AddExploitationScreen(),
        '/exploitation_form': (context) => ExploitationFormScreen(),
        '/questionnaire': (context) => RgaStepperScreen(),
        '/campaigns': (context) => const CampaignsScreen(),
        '/completed_census': (context) => const CompletedSurveysScreen(),
      },
    );
  }
}
