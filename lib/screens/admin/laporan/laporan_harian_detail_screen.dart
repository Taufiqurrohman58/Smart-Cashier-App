import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/laporan_harian.dart';

class LaporanHarianDetailScreen extends StatelessWidget {
  final LaporanHarianResponse laporan;
  final DateTime selectedDate;

  const LaporanHarianDetailScreen({
    super.key,
    required this.laporan,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1F),
        title: Text(
          "Detail Laporan ${dateFormat.format(selectedDate)}",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummaryCard(),
            const SizedBox(height: 20),

            // Penjualan Section
            _buildSectionTitle("Penjualan"),
            _buildPenjualanList(),
            const SizedBox(height: 20),

            // Pengeluaran Section
            _buildSectionTitle("Pengeluaran"),
            _buildPengeluaranList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 25.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Penjualan:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp${laporan.ringkasan.totalPenjualan.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pengeluaran:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp${laporan.ringkasan.totalPengeluaran.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Laba Bersih:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp${laporan.ringkasan.labaBersih.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: laporan.ringkasan.labaBersih >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1D1D1F),
      ),
    );
  }

  Widget _buildPenjualanList() {
    if (laporan.penjualan.detail.isEmpty) {
      return const Center(child: Text('Tidak ada data penjualan'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: laporan.penjualan.detail.length,
      itemBuilder: (context, index) {
        final detail = laporan.penjualan.detail[index];
        return _penjualanCard(detail);
      },
    );
  }

  Widget _penjualanCard(DetailPenjualan detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 25.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                detail.invoice,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Rp${detail.total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Kasir: ${detail.kasir}",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            "Items:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          ...detail.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${item.produk} (x${item.qty})"),
                  Text(
                    "Rp${item.subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengeluaranList() {
    if (laporan.pengeluaran.detail.isEmpty) {
      return const Center(child: Text('Tidak ada data pengeluaran'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: laporan.pengeluaran.detail.length,
      itemBuilder: (context, index) {
        final detail = laporan.pengeluaran.detail[index];
        return _pengeluaranCard(detail);
      },
    );
  }

  Widget _pengeluaranCard(DetailPengeluaran detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 25.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                detail.deskripsi,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Rp${detail.jumlah.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Kasir: ${detail.kasir}",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
