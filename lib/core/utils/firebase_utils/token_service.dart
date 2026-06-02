import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'firebase_id_token';
  static const String _refreshTokenKey = 'firebase_refresh_token';

  static String? _cachedToken;
  static DateTime? _tokenExpiry;

  /// Get the current Firebase ID token
  static Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('No user is currently signed in');
      return null;
    }

    try {
      // Check if we have a cached token that's still valid (tokens expire in 1 hour)
      if (!forceRefresh && _cachedToken != null && _tokenExpiry != null) {
        if (DateTime.now().isBefore(_tokenExpiry!)) {
          return _cachedToken;
        }
      }

      // Get fresh token from Firebase
      final idTokenResult = await user.getIdTokenResult(forceRefresh);
      final token = idTokenResult.token;
      
      if (token == null) {
        debugPrint('Firebase ID token is null');
        return null;
      }

      _cachedToken = token;
      // Cache for 50 minutes (tokens expire in 1 hour)
      _tokenExpiry = DateTime.now().add(const Duration(minutes: 50));
      
      // Persist token locally
      await _persistToken(token);
      
      debugPrint('Firebase ID token retrieved successfully');
      return token;
    } catch (e) {
      debugPrint('Error getting ID token: $e');
      // Try to get cached token from local storage
      return await _getPersistedToken();
    }
  }

  /// Persist token to local storage
  static Future<void> _persistToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_refreshTokenKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error persisting token: $e');
    }
  }

  /// Get persisted token from local storage
  static Future<String?> _getPersistedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final tokenTimeStr = prefs.getString(_refreshTokenKey);
      
      if (token != null && tokenTimeStr != null) {
        final tokenTime = DateTime.parse(tokenTimeStr);
        // Check if token is less than 1 hour old
        if (DateTime.now().difference(tokenTime) < const Duration(hours: 1)) {
          _cachedToken = token;
          _tokenExpiry = tokenTime.add(const Duration(hours: 1));
          return token;
        }
      }
    } catch (e) {
      debugPrint('Error getting persisted token: $e');
    }
    return null;
  }

  /// Clear persisted token (called on sign out)
  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
      _cachedToken = null;
      _tokenExpiry = null;
      debugPrint('Token cleared successfully');
    } catch (e) {
      debugPrint('Error clearing token: $e');
    }
  }

  /// Check if user is authenticated with valid token
  static Future<bool> isAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final token = await getIdToken();
    return token != null;
  }

  /// Get current user token or throw error if not authenticated
  static Future<String> getCurrentToken() async {
    final token = await getIdToken();
    if (token == null) {
      throw StateError('User is not authenticated or token is unavailable');
    }
    return token;
  }
}
