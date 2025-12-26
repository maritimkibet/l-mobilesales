/// @widget: Auth Controller
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Authentication state controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
      );
    }
  }

  Future<bool> login(String username, String password, bool rememberMe) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authRepository.login(username, password);
      
      if (user != null) {
        await _authRepository.saveRememberMe(rememberMe);
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: 'Invalid username or password',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'An error occurred. Please try again.',
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = AuthState();
  }
}
