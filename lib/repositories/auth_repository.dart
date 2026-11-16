import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';
// unica classe que fala diretamente com a supabase
//os ecrãs nunca vao chamar a supabase diretamente vao sempre pedir ao repositorio
class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;
  Stream<AuthState> get authChanges => _client.auth.onAuthStateChange;
  //stream vai ouvir as mudanças de autenticação e avisa a aplicação

  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }
  //função que envia o email e a password para a supabase, e se os dados tiverem corretos a supabase autentica o utilizador

  Future<bool> signUp({  //função que cria um novo utilizador na Supabase
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'role': role},
  );
  return response.session != null;
}
  Future<void> resetPassword(String email) async { //pede a supabase para enviar email de recuperacao de palavra passe para email
    await _client.auth.resetPasswordForEmail(email);
  }
  Future<void> signOut() async { //pede a supabase para deslogar o utilizador logout
    await _client.auth.signOut();
  }
  Future<AppUser> fetchProfile(String userId) async {
    final data =
    await _client.from('profiles').select().eq('id', userId).single();
    return AppUser.fromJson(data);
  } //vai a tabela profiles da base de dados procurar a linha do id correspondente e retorna um objeto AppUser com os dados da linha
}
