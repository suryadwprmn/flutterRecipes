import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepmakanan/models/receipe_model.dart';
import 'package:resepmakanan/provider/home_notifier.dart';
import 'package:resepmakanan/services/auth_service.dart';
import 'package:resepmakanan/services/receipe_service.dart';
import 'package:resepmakanan/ui/add_recipe_page.dart';
import 'package:resepmakanan/ui/detail.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNotifier(context: context)
        ..fetchRecipes(), // Fetch data saat halaman dibuat
      child: Consumer<HomeNotifier>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Home Page"),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      // Navigasi ke halaman Tambah Resep
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRecipePage(),
                        ),
                      );
                      if (result == true) {
                        // Refresh data jika berhasil menambah resep
                        value.fetchRecipes();
                      }
                    },
                    child: const Text("Tambah Data",
                        style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      // Dialog konfirmasi logout
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi Keluar'),
                            content: const Text(
                                'Apakah Anda yakin ingin keluar dari aplikasi?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog
                                },
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await AuthService().logout(context);
                                },
                                child: const Text('Keluar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: value.isLoading
                ? const Center(
                    child: CircularProgressIndicator(), // Loading indikator
                  )
                : value.recipes.isEmpty
                    ? const Center(
                        child: Text("Belum ada resep. Tambahkan resep baru!"),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Dua kolom untuk menampilkan data
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3 / 4, // Rasio ukuran grid
                        ),
                        itemCount: value.recipes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final recipe = value.recipes[index];
                          return InkWell(
                            onTap: () async {
                              // Navigasi ke DetailPage
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detailscreen(
                                    recipe: recipe,
                                  ),
                                ),
                              );
                              if (result == true) {
                                // Refresh data jika ada perubahan
                                value.fetchRecipes();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.blueAccent,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Gambar Resep
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      recipe['photo_url'] ??
                                          '', // URL gambar, fallback jika null
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.broken_image,
                                        size: 120,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Judul Resep
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      recipe['title'] ?? 'No Title',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Deskripsi Resep
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      recipe['description'] ?? 'No Description',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Informasi Tambahan
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                size: 16, color: Colors.yellow),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${recipe['likes_count'] ?? 0} Likes",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.comment,
                                                size: 16, color: Colors.white),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${recipe['comments_count'] ?? 0} Comments",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
