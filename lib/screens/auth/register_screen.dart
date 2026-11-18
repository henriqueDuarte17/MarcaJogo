import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/validators.dart';
import '../../models/app_user.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  UserRole _role = UserRole.player;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return; //valida o formulario com o que definimos no validator

    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await auth.signUp(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      role: _role.name, // 'player' ou 'manager'
    ); //pede ao authprovider para executar o registo na supabase com os dados introduzidos

    if (!mounted) return; //vai garantir que o ecrã ainda esta aberto

    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Não foi possível criar a conta.')),
      );
      return;
    }
// Se o Supabase exige confirmação de email, não há sessão ainda.
    if (auth.awaitingConfirmation) {
      context.pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Conta criada! Confirma o email e depois entra.'),
        ),
      );
    }
  // Se já há sessão, o router leva-nos para /home automaticamente.
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthProvider>().isBusy;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => Validators.notEmpty(v, field: 'O nome'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress, // abre o texlado em modo email
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                        ),
                      ),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _hidePassword,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) =>
                          Validators.confirmPassword(v, _passCtrl.text),
                    ),
                    const SizedBox(height: 24),
                    Text('Como vais usar a app?',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SegmentedButton<UserRole>(
                      segments: const [
                        ButtonSegment(
                          value: UserRole.player,
                          label: Text('Jogador'),
                          icon: Icon(Icons.sports_tennis),
                        ),
                        ButtonSegment(
                          value: UserRole.manager,
                          label: Text('Gestor'),
                          icon: Icon(Icons.storefront),
                        ),
                      ],
                      selected: {_role},
                      onSelectionChanged: (selection) =>
                          setState(() => _role = selection.first),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: busy ? null : _submit,
                      child: busy
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



