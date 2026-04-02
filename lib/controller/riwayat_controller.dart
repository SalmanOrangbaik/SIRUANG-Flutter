import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class RiwayatController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = true.obs;
  var riwayatList = <Booking>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchRiwayat();
    super.onInit();
  }

  Future<void> fetchRiwayat() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await apiService.getRiwayat();
      riwayatList.assignAll(data);
    } catch (e) {
      riwayatList.clear();
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateBooking(Booking booking) async {
    try {
      isLoading(true);
      await apiService.updateBooking(booking.id!, booking);
      Get.snackbar(
        'Berhasil',
        'Booking berhasil diubah',
        snackPosition: SnackPosition.BOTTOM,
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));
      fetchRiwayat();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      isLoading(true);
      await apiService.cancelBooking(bookingId);
      Get.snackbar(
        'Berhasil',
        'Booking berhasil dibatalkan',
        snackPosition: SnackPosition.BOTTOM,
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));
      fetchRiwayat();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
