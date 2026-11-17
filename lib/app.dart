import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'providers/auth_provider.dart';

class MarcaJogoApp extends StatefulWidget {
  const MarcaJogoApp({super.key});

  @override
  State<MarcaJogoApp> createState() => _MarcaJogoAppState();
}

class _MarcaJogoAppState extends State<MarcaJogoApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(context.read<AuthProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MarcaJogo',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: _router,
    );
  }
}
