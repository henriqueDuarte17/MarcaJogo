import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

//changeNotifier serve para que sempre que algo mude a aplicação seja avisada
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repo) {
    _init();
  }
  final AuthRepository _repo;
  StreamSubscription<AuthState>? _sub;

  AppUser? user; // null = sem sessão
  bool isLoading = true; // a verificar a sessão guardada ao arrancar
  bool isBusy = false; // login/registo/etc. em curso
  String? error; //msg de erro
  bool awaitingConfirmation = false;

  bool get isLoggedIn => user != null;

  Future<void> _init() async {
    await _loadUser();    //chama loaduser para verificar se existe uma sessão guardada
    isLoading = false;
    notifyListeners();

    _sub = _repo.authChanges.listen((state) {
      if (state.event == AuthChangeEvent.signedOut && user != null) {
        user = null;
        notifyListeners();
      }
    });
  }
  Future<void> _loadUser() async {  //se houver vai buscar os dados do utilizador à base de dados
    final session = _repo.currentSession;
    if (session == null) {
      user = null;
      return;
  }
  try {
    final profile = await _repo.fetchProfile(session.user.id);
    if (profile.isBlocked) {
      await _repo.signOut();
      user = null;
      error = 'Esta conta está bloqueada. Contacta o administrador.';
    } else {
      user = profile;
    }
    } catch (_) {
      user = null;
    }
  }
  Future<bool> signIn(String email, String password) { //login e carrega o perfil do utilizador
    return _run(() async {
      await _repo.signIn(email, password);
      await _loadUser();
    });
  }

  Future<bool> signUp({ // cria a conta enviando os dados para a supabase
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    return _run(() async {
      awaitingConfirmation = false;
      final hasSession = await _repo.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      if (hasSession) {
        await _loadUser();
      } else {
        awaitingConfirmation = true;
      }
    });
  }

  Future<bool> resetPassword(String email) {
    return _run(() => _repo.resetPassword(email));
  }

  Future<void> signOut() async { //desloga o utilizador e avisa a aplicação
    await _repo.signOut();
    user = null;
    notifyListeners();
  }

  /// Corre uma ação com estado "ocupado" e tratamento de erros
  Future<bool> _run(Future<void> Function() action) async {
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return error == null;
    } on AuthException catch (e) {
      error = _translate(e.message);
      return false;
    } catch (_) {
      error = 'Erro de ligação. Verifica a internet e tenta de novo.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  String _translate(String message) {
    final m = message.toLowerCase();
    if (m.contains('invalid login credentials')) {
      return 'Email ou password incorretos.';
    }
    if (m.contains('already registered')) {
      return 'Já existe uma conta com este email.';
    }
    if (m.contains('email not confirmed')) {
      return 'Confirma o teu email antes de entrar.';
    }
    return message;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
