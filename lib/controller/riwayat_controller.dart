import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class RiwayatController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = true.obs;
  var riwayatList = <Booking>[].obs;

  @override
  void onInit() {
    fetchRiwayat();
    super.onInit();
  }

  void fetchRiwayat() async {
    try {
      isLoading(true);
      final data = await apiService.getRiwayat();
      riwayatList.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
