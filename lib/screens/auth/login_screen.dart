import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/validators.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(); // serve para ler o texto que é escrito
  final _passCtrl = TextEditingController();
  bool _hidePassword = true; //mostrar ou ocultar a pass

  @override
  void dispose() {
    //quando o ecrã é fechado o controlador é destruido evita fugas
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

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

    final auth = context.read<AuthProvider>(); //tenta fazer login com os dados introduzidos
    final ok = await auth.signIn(_emailCtrl.text.trim(), _passCtrl.text);

    if (!ok && mounted) {
      // se o login falhar mostra um aviso na parte inferior do ecrã snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Não foi possível entrar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthProvider>().isBusy; //verifica se o provider esta a comunicar com a supabase, se tiver ocupado o botão fica desativado
    final theme = Theme.of(context);

    return Scaffold(
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
                    Icon(Icons.sports_tennis,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 8),
                    Text('MarcaJogo',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text('Reserva o teu campo de padel ou ténis',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailCtrl, //liga se ao emailctrl e usa a funcao validator
                      keyboardType: TextInputType.emailAddress,
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
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: busy ? null : _submit,
                      child: busy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Entrar'),
                    ),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Esqueci-me da password'),
                    ),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text('Criar conta'),
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
