class Pengeluaran {
  final int id;
  final String deskripsi;
  final int jumlah;
  final String tanggal;
  final String kasir;

  Pengeluaran({
    required this.id,
    required this.deskripsi,
    required this.jumlah,
    required this.tanggal,
    required this.kasir,
  });

  factory Pengeluaran.fromJson(Map<String, dynamic> json) {
    return Pengeluaran(
      id: json['id'],
      deskripsi: json['deskripsi'],
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
      kasir: json['kasir'],
    );
  }
}
