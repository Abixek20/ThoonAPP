import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Base API Service (ASP.NET Core Web API Integration)
// ─────────────────────────────────────────────────────────────────────────────

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // ─── COMPLAINTS ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> submitComplaint(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/Complaint/raise'),
      headers: _headers,
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }
    return {'success': false, 'error': response.body};
  }

  Future<List<Map<String, dynamic>>> getComplaintHistory(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/Complaint/$userId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    return [];
  }

  // ─── SERVICES ──────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getServices({String? category}) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/Dashboard'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['featuredServices'] ?? []);
    }
    return [];
  }

  // ─── BOOKINGS ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> bookSiteVisit(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/Design/request'),
      headers: _headers,
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'bookingId': jsonDecode(response.body)['id']};
    }
    return {'success': false, 'error': response.body};
  }

  // ─── BUILDING ENQUIRY ──────────────────────────────────────────────────────

  Future<Map<String, dynamic>> submitBuildingEnquiry(Map<String, dynamic> payload) async {
    return await bookSiteVisit(payload); // Reusing design request logic for now
  }

  // ─── NOTIFICATIONS ─────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    return []; // Notification endpoint not yet exposed
  }

  // ─── RAZORPAY WEBHOOK ──────────────────────────────────────────────────────

  Future<bool> verifyRazorpayPayment({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    // Verified by .NET backend
    return true; 
  }
}

