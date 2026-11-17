import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'repositories/auth_repository.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://ayzblvretzqsjggsfeua.supabase.co');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'sb_publishable_RnjFC6ypAPROTuMSif667g_4bBUm8x6');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(AuthRepository()),
      child: const MarcaJogoApp(),
    ),
  );
}
