import 'package:siruangflutter/models/ruang_model.dart';

class Booking {
  final int? id;
  final int? userId;
  final int ruangId;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String status;
  final Ruangan? ruang;

  Booking({
    this.id,
    this.userId,
    required this.ruangId,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    this.status = 'pending',
    this.ruang,
  }) {
    // Validasi data
    _validateData();
  }

  void _validateData() {
    if (ruangId <= 0) {
      throw Exception('ruang_id harus lebih dari 0');
    }

    // Validasi format tanggal (YYYY-MM-DD)
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(tanggal)) {
      throw Exception('Format tanggal harus YYYY-MM-DD');
    }

    // Validasi format jam (HH:MM)
    final timeRegex = RegExp(r'^\d{2}:\d{2}$');
    if (!timeRegex.hasMatch(jamMulai)) {
      throw Exception('Format jam_mulai harus HH:MM');
    }
    if (!timeRegex.hasMatch(jamSelesai)) {
      throw Exception('Format jam_selesai harus HH:MM');
    }

    // Validasi jam_selesai harus setelah jam_mulai
    final start = _timeToMinutes(jamMulai);
    final end = _timeToMinutes(jamSelesai);
    if (end <= start) {
      throw Exception('jam_selesai harus setelah jam_mulai');
    }
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour * 60 + minute;
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      ruangId: json['ruang_id'],
      tanggal: _normalizeDate(json['tanggal']),
      jamMulai: _normalizeTime(json['jam_mulai']),
      jamSelesai: _normalizeTime(json['jam_selesai']),
      status: json['status'] ?? 'pending',
      ruang: json['ruang'] != null ? Ruangan.fromJson(json['ruang']) : null,
    );
  }

  static String _normalizeDate(dynamic value) {
    final raw = (value ?? '').toString().trim();
    if (raw.isEmpty) {
      return raw;
    }

    if (raw.contains('T')) {
      return raw.split('T').first;
    }

    if (raw.contains(' ')) {
      return raw.split(' ').first;
    }

    return raw;
  }

  static String _normalizeTime(dynamic value) {
    final raw = (value ?? '').toString().trim();
    if (raw.isEmpty) {
      return raw;
    }

    final parts = raw.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }

    return raw;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'ruang_id': ruangId,
      'tanggal': tanggal,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'status': status,
    };
  }
}
