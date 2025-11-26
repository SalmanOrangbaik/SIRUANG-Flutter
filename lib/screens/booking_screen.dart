import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/ruang_controller.dart';
import '../controller/booking_controller.dart';
import '../models/ruang_model.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RuangController ruangC = Get.find<RuangController>();
    final BookingController bookingC = Get.put(BookingController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Booking Ruangan',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Form Booking
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ruangan Dropdown
                    _buildSectionTitle('Pilih Ruangan'),
                    const SizedBox(height: 8),
                    _buildRuangDropdown(ruangC, bookingC),

                    const SizedBox(height: 24),

                    // Tanggal
                    _buildSectionTitle('Tanggal Booking'),
                    const SizedBox(height: 8),
                    Obx(() => _buildDatePicker(bookingC)),

                    const SizedBox(height: 24),

                    // Jam Mulai
                    _buildSectionTitle('Jam Mulai'),
                    const SizedBox(height: 8),
                    Obx(() => _buildTimePicker(
                          bookingC.selectedStartTime.value,
                          (time) => bookingC.setSelectedStartTime(time),
                        )),

                    const SizedBox(height: 24),

                    // Jam Selesai
                    _buildSectionTitle('Jam Selesai'),
                    const SizedBox(height: 8),
                    Obx(() => _buildTimePicker(
                          bookingC.selectedEndTime.value,
                          (time) => bookingC.setSelectedEndTime(time),
                        )),

                    const SizedBox(height: 32),

                    // Error/Success Message
                    Obx(() {
                      if (bookingC.errorMessage.isNotEmpty) {
                        return _buildMessage(bookingC.errorMessage.value, true);
                      }
                      if (bookingC.successMessage.isNotEmpty) {
                        return _buildMessage(
                            bookingC.successMessage.value, false);
                      }
                      return const SizedBox();
                    }),

                    const SizedBox(height: 24),

                    // Tombol Booking
                    _buildBookingButton(bookingC),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildRuangDropdown(
      RuangController ruangC, BookingController bookingC) {
    return Obx(() {
      if (ruangC.isLoading.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text('Loading ruangan...',
                  style: GoogleFonts.poppins(color: Colors.grey[500])),
              const Spacer(),
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
        );
      }

      if (ruangC.ruangList.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text('Tidak ada ruangan tersedia',
                style: GoogleFonts.poppins(color: Colors.grey[500])),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<Ruangan>(
          value: bookingC.isRuangSelected ? bookingC.selectedRuang.value : null,
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text('Pilih Ruangan', style: GoogleFonts.poppins()),
          items: ruangC.ruangList.map((ruang) {
            return DropdownMenuItem<Ruangan>(
              value: ruang,
              child: Text(ruang.nama, style: GoogleFonts.poppins()),
            );
          }).toList(),
          onChanged: (Ruangan? newValue) {
            if (newValue != null) {
              bookingC.setSelectedRuang(newValue);
            }
          },
        ),
      );
    });
  }

  Widget _buildTimePicker(
      TimeOfDay currentTime, Function(TimeOfDay) onTimeSelected) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: Get.context!,
          initialTime: currentTime,
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.blue),
              ),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Icon(Icons.access_time, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BookingController bookingC) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: bookingC.selectedDate.value,
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.blue),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          bookingC.setSelectedDate(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${bookingC.selectedDate.value.day.toString().padLeft(2, '0')}/${bookingC.selectedDate.value.month.toString().padLeft(2, '0')}/${bookingC.selectedDate.value.year}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Icon(Icons.calendar_today, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message, bool isError) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? Colors.red[50] : Colors.green[50],
        border:
            Border.all(color: isError ? Colors.red[200]! : Colors.green[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle,
            color: isError ? Colors.red[800] : Colors.green[800],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: isError ? Colors.red[800] : Colors.green[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton(BookingController bookingC) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: bookingC.isLoading.value
              ? null
              : () {
                  // Langsung panggil submitBooking
                  bookingC.submitBooking();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: bookingC.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Booking Sekarang',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    });
  }
}
