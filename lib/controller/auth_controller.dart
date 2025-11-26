import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final box = GetStorage();

  var user = Rxn<UserModel>();
  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    try {
      final token = box.read('token');
      final userData = box.read('user');

      print('Checking login status - Token: $token, User: $userData');

      if (token != null && userData != null) {
        user.value = UserModel.fromJson(userData);
        isLoggedIn.value = true;
        print('User already logged in: ${user.value?.name}');
      } else {
        isLoggedIn.value = false;
        user.value = null;
        print('No user logged in');
      }
    } catch (e) {
      print('Error checking login status: $e');
      logout();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      update();

      print('Starting login process for: $email');
      final response = await _apiService.login(email, password);
      print('Login API Response: $response');

      if (response['token'] != null) {
        final String token = response['token'];
        await box.write('token', token);

        if (response['user'] != null) {
          final userData = response['user'];
          await box.write('user', userData);
          user.value = UserModel.fromJson(userData);
        }

        isLoggedIn.value = true;
        isLoading.value = false;
        update();

        print('Login successful! User: ${user.value?.name}');

        Get.snackbar(
          'Success',
          'Login berhasil!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        throw Exception(response['message'] ?? 'Login gagal');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      update();

      print('Login failed: $e');

      String errorMsg = e.toString().replaceAll('Exception: ', '');

      Get.snackbar(
        'Login Failed',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      return false;
    }
  }

  Future<void> logout() async {
    try {
      await box.remove('token');
      await box.remove('user');

      user.value = null;
      isLoggedIn.value = false;
      errorMessage.value = '';

      print('Logout successful');

      Get.offAllNamed('/login');

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  bool get isAuthenticated => isLoggedIn.value && user.value != null;
  String? get token => box.read('token');
  UserModel? get currentUser => user.value;
}
