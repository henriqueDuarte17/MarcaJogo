import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
//ecrã inicial temporario so para saber se o login e o role funcionam
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox.shrink(); // durante o logout

    return Scaffold(
      appBar: AppBar(
        title: const Text('MarcaJogo'),
        actions: [
          IconButton(
            tooltip: 'Terminar sessão',
            icon: const Icon(Icons.logout),
            onPressed: auth.signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Olá, ${user.name}!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Perfil: ${user.role.label}'),
            const SizedBox(height: 24),
            if (user.role == UserRole.admin)
              FilledButton(
                onPressed: () => context.push('/admin'),
                child: const Text('Painel de administração'),
              ),
            if (user.role == UserRole.manager)
              FilledButton(
                onPressed: () => context.push('/manager'),
                child: const Text('Gerir o meu clube'),
              ),
          ],
        ),
      ),
    );
  }
}

