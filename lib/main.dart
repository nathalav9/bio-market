import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:residents_app/screen/home.dart';
import 'package:residents_app/screen/login.dart';
import 'package:residents_app/screen/sign_up.dart';
import 'package:residents_app/views/promotions.dart';
import 'package:residents_app/views/create_view.dart';
import 'package:residents_app/views/create_promotion_view.dart';
import 'package:residents_app/views/favorites_view.dart';
import 'package:residents_app/views/promotions_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:residents_app/screen/camera_screen.dart'; // Importamos la pantalla de la cámara
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase inicializado correctamente");
  } catch (e) {
    print("Error al inicializar Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/login', 
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(childView: child);
        },
        routes: [
          GoRoute(
            path: '/favorites',
            builder: (context, state) => FavoritesView(),
          ),
          GoRoute(
            path: '/create-proposal',
            builder: (context, state) => const CreateProposalView(),
          ),
          GoRoute(
            path: '/proposals',
            builder: (context, state) => ProposalsView(),
          ),
          GoRoute(
            path: '/announcement',
            builder: (context, state) => AnnouncementView(),
          ),
          GoRoute(
            path: '/create-announcement',
            builder: (context, state) => CreateAnnouncementView(),
          ),
          GoRoute(
            path: '/camera',  // Nueva ruta para la cámara
            builder: (context, state) => CameraScreen(),
          ),
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

