import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpet_app/views/booking_page.dart';
import '../providers/product_provider.dart';
import 'booking_page.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Dokter Hewan'),
        backgroundColor: const Color(0xFF4ECDC4), // Warna toska sesuai UI kamu
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          // 1. Loading state
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error state
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text('Error: ${provider.errorMessage}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => provider.fetchDoctors(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // 3. Empty state
          if (provider.doctors.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_hospital_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Belum ada dokter tersedia',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 4. List dokter - Sesuai UI mockup kamu
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.doctors.length,
            itemBuilder: (context, index) {
              final doctor = provider.doctors[index];
              final user = doctor['user'] ?? {};

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Foto + Nama + Spesialisasi
                      Row(
                        children: [
                          // Foto dokter (placeholder)
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: const Color(
                              0xFF4ECDC4,
                            ).withOpacity(0.2),
                            backgroundImage: doctor['doctor_img'] != null
                                ? NetworkImage(doctor['doctor_img'])
                                : null,
                            child: doctor['doctor_img'] == null
                                ? const Icon(
                                    Icons.person,
                                    size: 35,
                                    color: Color(0xFF4ECDC4),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),

                          // Info dokter
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? 'Dr. Unknown',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C5F5D),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  doctor['specialization'] ??
                                      'Dokter Hewan Umum',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Rating & Experience
                                Row(
                                  children: [
                                    // Rating
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${doctor['rating'] ?? 0.0}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),

                                    // Experience
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.work_outline,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${doctor['experience_years'] ?? 0} tahun',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 24),

                      // Tarif & Tombol
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Harga konsultasi
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tarif Konsultasi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Rp${doctor['consultation_fee'] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4ECDC4),
                                ),
                              ),
                            ],
                          ),

                          // Tombol Konsultasi
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingPage(doctor: doctor),
                                ),
                              );
                            },
                            icon: const Icon(Icons.calendar_today, size: 18),
                            label: const Text('Booking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4ECDC4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
