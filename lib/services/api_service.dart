import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:siruangflutter/controller/auth_controller.dart';
import '../models/ruang_model.dart';
import '../models/booking_model.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<Ruangan>> getRuang() async {
    try {
      print(' [GET] Memulai request ke: $baseUrl/ruangan');

      final response = await http.get(
        Uri.parse('$baseUrl/ruangan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(' Response Status: ${response.statusCode}');
      print(' Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(' JSON Response Structure:');
        print('   - success: ${jsonResponse['success']}');
        print('   - data type: ${jsonResponse['data']?.runtimeType}');
        print(
            '   - data length: ${jsonResponse['data'] is List ? jsonResponse['data'].length : 'N/A'}');

        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          List<dynamic> data = jsonResponse['data'];

          // Debug setiap item data
          print(' Debug setiap item data:');
          for (int i = 0; i < data.length; i++) {
            final item = data[i];
            print('''
   📄 Item #${i + 1}:
      - id: ${item['id']}
      - nama: ${item['nama']}
      - kapasitas: ${item['kapasitas']} (type: ${item['kapasitas']?.runtimeType})
      - fasilitas: ${item['fasilitas']} (type: ${item['fasilitas']?.runtimeType})
      - cover: ${item['cover']}''');
          }

          final List<Ruangan> ruanganList =
              data.map((e) => Ruangan.fromJson(e)).toList();
          print(' Berhasil mengkonversi ${ruanganList.length} ruangan');
          return ruanganList;
        } else {
          throw Exception(
              'Format response tidak valid: success=${jsonResponse['success']}, data type=${jsonResponse['data']?.runtimeType}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print(' Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Ruangan> getRuangDetail(int id) async {
    try {
      print(' [GET] Memulai request detail ruangan ID: $id');

      final response = await http.get(
        Uri.parse('$baseUrl/ruangan/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(' Response Status: ${response.statusCode}');
      print(' Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          print(' Detail Ruangan Data:');
          print('   - id: ${jsonResponse['data']['id']}');
          print('   - nama: ${jsonResponse['data']['nama']}');
          print(
              '   - fasilitas: ${jsonResponse['data']['fasilitas']} (type: ${jsonResponse['data']['fasilitas']?.runtimeType})');

          return Ruangan.fromJson(jsonResponse['data']);
        } else {
          throw Exception(
              jsonResponse['message'] ?? 'Gagal memuat detail ruangan');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print(' Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Booking> createBooking(Booking booking) async {
    try {
      final AuthController auth = Get.find<AuthController>();
      final token = auth.token;

      final response = await http.post(
        Uri.parse('$baseUrl/booking'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(booking.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Booking.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Gagal membuat booking');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated. Token tidak dikirim / tidak valid.');
      } else if (response.statusCode == 422) {
        final jsonResponse = json.decode(response.body);
        final errors = jsonResponse['errors'];
        final errorMessage = errors?.values.first?.first ?? 'Data tidak valid';
        throw Exception(errorMessage);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print(' Login API Status: ${response.statusCode}');
      print(' Login API Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Email atau password salah');
      } else if (response.statusCode == 422) {
        // Handle validation errors
        final jsonResponse = json.decode(response.body);
        final errors = jsonResponse['errors'];
        final errorMessage = errors?.values.first?.first ?? 'Data tidak valid';
        throw Exception(errorMessage);
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> logout() async {
    print('Logging out from API');
  }
}
