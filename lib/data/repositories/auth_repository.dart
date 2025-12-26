/// @widget: Auth Repository
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Authentication repository

import '../models/user_model.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final DataService _dataService = DataService();
  final StorageService _storageService = StorageService();

  Future<UserModel?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    final users = await _dataService.loadUsers();
    
    for (var userData in users) {
      if (userData['username'] == username && userData['password'] == password) {
        final user = UserModel.fromJson(userData);
        await _storageService.saveToken('mock_token_${user.id}');
        await _storageService.saveString('user_id', user.id);
        await _storageService.saveString('user_name', user.fullName);
        return user;
      }
    }
    
    return null;
  }

  Future<void> logout() async {
    await _storageService.clear();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null;
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = _storageService.getString('user_id');
    if (userId == null) return null;

    final users = await _dataService.loadUsers();
    for (var userData in users) {
      if (userData['id'] == userId) {
        return UserModel.fromJson(userData);
      }
    }
    return null;
  }

  Future<void> saveRememberMe(bool remember) async {
    await _storageService.saveBool('remember_me', remember);
  }

  bool getRememberMe() {
    return _storageService.getBool('remember_me') ?? false;
  }
}
