import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepmakanan/provider/home_notifier.dart';

class EditRecipePage extends StatelessWidget {
  final Map<String, dynamic> recipe;
  const EditRecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNotifier(context: context),
      child: Consumer<HomeNotifier>(
        builder: (context, value, child) {
          value.titleController.text = recipe['title'] ?? '';
          value.cookingMethodController.text = recipe['cooking_method'] ?? '';
          value.ingredientsController.text = recipe['ingredients'] ?? '';
          value.descriptionController.text = recipe['description'] ?? '';
          value.photoController.text = recipe['photo_url'] ?? '';
          return Scaffold(
            appBar: AppBar(
              title: Text(recipe['title'] ?? 'Edit Recipe'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Resep
                    recipe['photo_url'] != null
                        ? Image.network(
                            recipe['photo_url'],
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.broken_image,
                              size: 120,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.broken_image,
                            size: 120,
                            color: Colors.grey,
                          ),
                    const SizedBox(height: 16),
                    // Form untuk memperbarui resep
                    TextFormField(
                      controller: value.titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: value.cookingMethodController,
                      decoration:
                          const InputDecoration(labelText: 'Cooking Method'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: value.ingredientsController,
                      decoration:
                          const InputDecoration(labelText: 'Ingredients'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: value.descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 16),
                    // Upload Foto Resep
                    GestureDetector(
                      onTap: () => value.pickImage(context),
                      child: value.imageRecipe == null
                          ? Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 48,
                                color: Colors.grey,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                value.imageRecipe!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    // Tombol Update Resep
                    ElevatedButton(
                      onPressed: value.isUpdating
                          ? null
                          : () {
                              value.updateRecipe(
                                recipe['id'],
                                value.titleController.text,
                                value.cookingMethodController.text,
                                value.descriptionController.text,
                                value.ingredientsController.text,
                                value.imageRecipe,
                              );
                            },
                      child: value.isUpdating
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Update Recipe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}