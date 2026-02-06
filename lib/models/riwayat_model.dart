class Riwayat {
  final int id;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String status;
  final String namaRuang;

  Riwayat({
    required this.id,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.status,
    required this.namaRuang,
  });

  factory Riwayat.fromJson(Map<String, dynamic> json) {
    return Riwayat(
      id: json['id'],
      tanggal: json['tanggal'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      status: json['status'],
      namaRuang: json['ruang']['nama_ruang'],
    );
  }
}
