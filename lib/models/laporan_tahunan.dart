class LaporanTahunanResponse {
  final bool status;
  final String periode;
  final String tahun;
  final PenjualanTahunan penjualan;
  final PengeluaranTahunan pengeluaran;
  final RingkasanTahunan ringkasan;
  final List<GrafikTahunan> grafik;

  LaporanTahunanResponse({
    required this.status,
    required this.periode,
    required this.tahun,
    required this.penjualan,
    required this.pengeluaran,
    required this.ringkasan,
    required this.grafik,
  });

  factory LaporanTahunanResponse.fromJson(Map<String, dynamic> json) {
    return LaporanTahunanResponse(
      status: json['status'] ?? false,
      periode: json['periode'] ?? '',
      tahun: json['tahun'] ?? '',
      penjualan: json['penjualan'] != null
          ? PenjualanTahunan.fromJson(json['penjualan'])
          : PenjualanTahunan.empty(),
      pengeluaran: json['pengeluaran'] != null
          ? PengeluaranTahunan.fromJson(json['pengeluaran'])
          : PengeluaranTahunan.empty(),
      ringkasan: json['ringkasan'] != null
          ? RingkasanTahunan.fromJson(json['ringkasan'])
          : RingkasanTahunan.empty(),
      grafik:
          (json['grafik'] as List<dynamic>?)
              ?.map((item) => GrafikTahunan.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class PenjualanTahunan {
  final int totalPenjualan;

  PenjualanTahunan({required this.totalPenjualan});

  factory PenjualanTahunan.fromJson(Map<String, dynamic> json) {
    return PenjualanTahunan(
      totalPenjualan: (json['total_penjualan'] as num?)?.toInt() ?? 0,
    );
  }

  factory PenjualanTahunan.empty() {
    return PenjualanTahunan(totalPenjualan: 0);
  }
}

class PengeluaranTahunan {
  final int totalPengeluaran;

  PengeluaranTahunan({required this.totalPengeluaran});

  factory PengeluaranTahunan.fromJson(Map<String, dynamic> json) {
    return PengeluaranTahunan(
      totalPengeluaran: (json['total_pengeluaran'] as num?)?.toInt() ?? 0,
    );
  }

  factory PengeluaranTahunan.empty() {
    return PengeluaranTahunan(totalPengeluaran: 0);
  }
}

class RingkasanTahunan {
  final int labaBersih;

  RingkasanTahunan({required this.labaBersih});

  factory RingkasanTahunan.fromJson(Map<String, dynamic> json) {
    return RingkasanTahunan(
      labaBersih: (json['laba_bersih'] as num?)?.toInt() ?? 0,
    );
  }

  factory RingkasanTahunan.empty() {
    return RingkasanTahunan(labaBersih: 0);
  }
}

class GrafikTahunan {
  final String bulan;
  final int penjualan;
  final int pengeluaran;

  GrafikTahunan({
    required this.bulan,
    required this.penjualan,
    required this.pengeluaran,
  });

  factory GrafikTahunan.fromJson(Map<String, dynamic> json) {
    return GrafikTahunan(
      bulan: json['bulan'] ?? '',
      penjualan: (json['penjualan'] as num?)?.toInt() ?? 0,
      pengeluaran: (json['pengeluaran'] as num?)?.toInt() ?? 0,
    );
  }

  String get bulanNama {
    switch (bulan) {
      case '01':
        return 'Jan';
      case '02':
        return 'Feb';
      case '03':
        return 'Mar';
      case '04':
        return 'Apr';
      case '05':
        return 'Mei';
      case '06':
        return 'Jun';
      case '07':
        return 'Jul';
      case '08':
        return 'Agu';
      case '09':
        return 'Sep';
      case '10':
        return 'Okt';
      case '11':
        return 'Nov';
      case '12':
        return 'Des';
      default:
        return bulan;
    }
  }
}
