import 'package:go_router/go_router.dart';

import '../models/app_user.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/shared/home_screen.dart';
import '../screens/shared/placeholder_screen.dart';
import '../screens/shared/splash_screen.dart';

//DEFINE AS ROTAS PUBLICAS, FAZ A LISTA DAS ROTAS QUE NÃO PRECISAM DE AUTENTICAÇÃO
const _publicRoutes = ['/login', '/register', '/forgot-password'];

GoRouter createRouter(AuthProvider auth) {
  return GoRouter(
      initialLocation: '/splash',
      refreshListenable: auth,
      redirect: (context, state) {
        final location = state.matchedLocation;
        //verifica se ha sessão guardada
        if (auth.isLoading) return location == '/splash' ? null : '/splash';

        //se não tiver sessão guardada e tetar aceder aos ecrãs privados o router manda o para o ecrã de login
        if (!auth.isLoggedIn) {
          return _publicRoutes.contains(location) ? null : '/login';
        }
        //se um utilizador fizer login o router redireciona-o para a home page
        if (_publicRoutes.contains(location) || location == '/splash') {
          return '/home';
        }
        //Segurança: garante que se um utilizador tentar aceder a zonas de admin ou manager é redirecionado para a home page
        final role = auth.user!.role;
        if (location.startsWith('/admin') && role != UserRole.admin) {
          return '/home';
        }
        if (location.startsWith('/manager') && role != UserRole.manager) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/admin',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Painel de administração'),
      ),
      GoRoute(
        path: '/manager',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Gerir o meu clube'),
      ), //diz ao router que URL corresponde a cada ecrã visual
    ],
  );
}





