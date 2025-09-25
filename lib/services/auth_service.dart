import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _superAdminEmail = 'emaleo0522@gmail.com';
  static const String _superAdminPassword = 'SofiLuci07';

  bool _isLoggedIn = false;
  String _currentUserEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get currentUserEmail => _currentUserEmail;

  Future<bool> login(String email, String password, {bool rememberMe = false, bool keepLoggedIn = false}) async {
    // Verificar credenciales del super admin
    if (email == _superAdminEmail && password == _superAdminPassword) {
      _isLoggedIn = true;
      _currentUserEmail = email;

      // Guardar preferencias
      final prefs = await SharedPreferences.getInstance();

      if (rememberMe) {
        await prefs.setString('remembered_email', email);
      } else {
        await prefs.remove('remembered_email');
      }

      if (keepLoggedIn) {
        await prefs.setBool('keep_logged_in', true);
        await prefs.setString('logged_in_user', email);
      } else {
        await prefs.setBool('keep_logged_in', false);
        await prefs.remove('logged_in_user');
      }

      return true;
    }

    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUserEmail = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keep_logged_in', false);
    await prefs.remove('logged_in_user');
  }

  Future<String?> getRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('remembered_email');
  }

  Future<bool> checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final keepLoggedIn = prefs.getBool('keep_logged_in') ?? false;
    final loggedInUser = prefs.getString('logged_in_user');

    if (keepLoggedIn && loggedInUser != null) {
      _isLoggedIn = true;
      _currentUserEmail = loggedInUser;
      return true;
    }

    return false;
  }
}