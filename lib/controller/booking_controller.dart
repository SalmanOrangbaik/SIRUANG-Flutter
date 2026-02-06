import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siruangflutter/controller/auth_controller.dart';
import '../services/api_service.dart';
import '../models/booking_model.dart';
import '../models/ruang_model.dart';

class BookingController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var selectedStartTime = TimeOfDay.fromDateTime(DateTime.now()).obs;
  var selectedEndTime =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1))).obs;

  var selectedRuang = Ruangan(
    id: 0,
    cover: '',
    nama: '',
    kapasitas: 0,
    fasilitas: [],
  ).obs;

  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  bool get isRuangSelected => selectedRuang.value.id > 0;

  bool validateBooking() {
    final AuthController authController = Get.find<AuthController>();

    if (!authController.isLoggedIn.value) {
      errorMessage.value = 'Silakan login terlebih dahulu';
      return false;
    }

    if (!isRuangSelected) {
      errorMessage.value = 'Pilih ruangan terlebih dahulu';
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  Future<void> createBooking() async {
    try {
      print('Mulai proses booking...');

      final AuthController authController = Get.find<AuthController>();
      final userId = authController.user.value!.id;

      // Format data
      final formattedDate =
          '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';
      final formattedStartTime =
          '${selectedStartTime.value.hour.toString().padLeft(2, '0')}:${selectedStartTime.value.minute.toString().padLeft(2, '0')}';
      final formattedEndTime =
          '${selectedEndTime.value.hour.toString().padLeft(2, '0')}:${selectedEndTime.value.minute.toString().padLeft(2, '0')}';

      print(' Data booking:');
      print('   - User ID: $userId');
      print(
          '   - Ruang: ${selectedRuang.value.nama} (ID: ${selectedRuang.value.id})');
      print('   - Tanggal: $formattedDate');
      print('   - Waktu: $formattedStartTime - $formattedEndTime');

      final booking = Booking(
        userId: userId,
        ruangId: selectedRuang.value.id,
        tanggal: formattedDate,
        jamMulai: formattedStartTime,
        jamSelesai: formattedEndTime,
        status: 'pending',
      );

      isLoading(true);
      errorMessage.value = '';
      successMessage.value = '';
      update();

      // Kirim ke API
      await _apiService.createBooking(booking);

      isLoading(false);
      successMessage.value = 'Booking berhasil dibuat!';
      update();

      print(' Booking sukses!');
    } catch (e) {
      isLoading(false);
      final errorMsg = e.toString().replaceAll("Exception: ", "");
      errorMessage.value = errorMsg;
      update();

      print(' Booking gagal: $errorMsg');
    }
  }

  void submitBooking() {
    print('Tombol booking ditekan');

    // Validasi sederhana
    if (validateBooking()) {
      createBooking();
    }
  }

  void setSelectedRuang(Ruangan ruang) {
    selectedRuang.value = ruang;
    errorMessage.value = '';
    print(' Ruang dipilih: ${ruang.nama}');
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    errorMessage.value = '';
  }

  void setSelectedStartTime(TimeOfDay time) {
    selectedStartTime.value = time;
    errorMessage.value = '';
  }

  void setSelectedEndTime(TimeOfDay time) {
    selectedEndTime.value = time;
    errorMessage.value = '';
  }
}
