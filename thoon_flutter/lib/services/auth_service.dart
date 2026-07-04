import 'dart:convert';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// THOON – ASP.NET Core JWT Auth Service
// ─────────────────────────────────────────────────────────────────────────────

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _currentUserId;
  String? _currentPhone;
  String? _jwtToken;

  String? get currentUserId => _currentUserId;
  bool get isLoggedIn => _currentUserId != null && _jwtToken != null;
  String? get jwtToken => _jwtToken;

  // ─── PHONE AUTH ────────────────────────────────────────────────────────────

  Future<bool> sendOtp(String phoneNumber) async {
    // For Phase 1 with JWT Auth, we can skip actual OTP sending and just return true.
    // The user will enter a password or generic code in the verify step.
    _currentPhone = phoneNumber;
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    if (_currentPhone == null) return false;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': _currentPhone, 'password': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jwtToken = data['token'];
        _currentUserId = data['userId'].toString();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String fullName, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/Auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'phone': phone,
          'password': password,
          'email': '',
          'role': 'Customer'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jwtToken = data['token'];
        _currentUserId = data['userId'].toString();
        _currentPhone = phone;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ─── GOOGLE SIGN-IN ────────────────────────────────────────────────────────

  Future<bool> signInWithGoogle() async {
    return false; // Not supported by ASP.NET backend currently
  }

  // ─── SIGN OUT ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    _currentUserId = null;
    _currentPhone = null;
    _jwtToken = null;
  }

  // ─── ID TOKEN ──────────────────────────────────────────────────────────────

  Future<String?> getIdToken() async {
    return _jwtToken;
  }
}

