class Validators { //verifica se o campo a preenhcer é vazio se for retorna uma mensagem de erro
  static String? notEmpty(String? value, {String field = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field é obrigatório';
    }
    return null;
  }
  //aproveita a função anterior para garantir que o email nao esta vazio depois usa a expressao Regexp para garantir que tem o formato de um email
  static String? email(String? value) {
    final empty = notEmpty(value, field: 'O email');
    if (empty != null) return empty;

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value!.trim())) return 'Email inválido';
    return null;
  }
  //verifica se a password tem pelo menos 6 caracteres e se esta preenchida
  static String? password(String? value) {
  if (value == null || value.isEmpty) return 'A password é obrigatória';
  if (value.length < 6) return 'A password deve ter pelo menos 6 caracteres';
  return null;
  }
 //compara o que foi inserido na password com a confirmação
  static String? confirmPassword(String? value, String original) {
    if (value != original) return 'As passwords não coincidem';
    return null;
  }
}