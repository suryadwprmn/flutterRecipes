import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:resepmakanan/provider/home_notifier.dart';
import 'package:resepmakanan/services/receipe_service.dart';

class AddRecipePage extends StatelessWidget {
  const AddRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNotifier(context: context),
      child: Consumer<HomeNotifier>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Add Recipe"),
          ),  
          body: Form(
            key: value.keyfrom,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: value.titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Title Tidak Boleh Kosong";
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: value.cookingMethodController,
                            decoration: InputDecoration(
                              labelText: 'Cooking Method',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Cooking Method Tidak Boleh Kosong";
                              }
                              return null;
                            },
                          )
                        ],
                      ),

                      const SizedBox(height: 16),
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: value.ingredientsController,
                            decoration: InputDecoration(
                              labelText: 'Ingredients',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Ingredients Tidak Boleh Kosong";
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: value.descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Description Tidak Boleh Kosong";
                              }
                              return null;
                            },
                          )
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Image picker
                      GestureDetector(
                        onTap: () => value.pickImage(context),
                        child: value.imageRecipe == null
                            ? Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey[300],
                                ),
                                child: Icon(Icons.add_a_photo,
                                    color: Colors.grey[500]),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  value.imageRecipe!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),

                      const SizedBox(height: 16),

                      // Section: Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (value.keyfrom.currentState!.validate()) {
                              value.setLoading(true);
                              bool success = await RecipeService().addRecipe(
                                value.titleController.text,
                                value.cookingMethodController.text,
                                value.descriptionController.text, 
                                value.ingredientsController.text,
                                value.imageRecipe!, // Mengirim file foto
                              );
                              value.setLoading(false);

                              if (success) {
                                Navigator.pop(context,
                                    true); // Kembali ke halaman sebelumnya dengan callback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Recipe added successfully"),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to add recipe"),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: value.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Tambah Resep',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}