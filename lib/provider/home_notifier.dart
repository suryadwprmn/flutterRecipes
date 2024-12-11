import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:resepmakanan/services/receipe_service.dart';

class HomeNotifier extends ChangeNotifier {
  final BuildContext context;

  HomeNotifier({required this.context}) {
    fetchRecipes();
  }

  File? _imageRecipe;
  String? _imageRecipeDefault;

  File? get imageRecipe => _imageRecipe;
  String? get imageRecipeDefault => _imageRecipeDefault;

  final GlobalKey<FormState> keyfrom = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController cookingMethodController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController photoController = TextEditingController();

  bool _isLoading = false;
  bool _isDeleting = false;
  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;
  bool get isUpdating => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setDeleting(bool value) {
    _isDeleting = value;
    notifyListeners();
  }

  void setUpdating(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final RecipeService _recipeServices = RecipeService();
  List recipes = [];
  Map<String, dynamic>? recipeById;

  void fetchRecipes() async {
    recipes = await _recipeServices.getAllRecipe();
    notifyListeners();
  }

  Future<void> fetchRecipeById(String id) async {
    recipeById = await _recipeServices.getRecipeById(id);
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageRecipe = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Fungsi untuk menghapus resep
  Future<void> deleteRecipe(int recipeId) async {
    setDeleting(true);

    try {
      await _recipeServices.deleteRecipe(recipeId);
      // Jika berhasil dihapus, navigasi kembali ke halaman sebelumnya
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipe deleted successfully")),
      );
    } catch (e) {
      setDeleting(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete recipe")),
      );
    }
  }

  Future<void> updateRecipe(int recipeId, String title, String cookingMethod,
      String description, String ingredients, File? photo) async {
    setUpdating(true);

    try {
      bool success = await _recipeServices.updateRecipe(
          recipeId, title, cookingMethod, description, ingredients, photo);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Recipe updated successfully")),
        );
        Navigator.pop(
            context, true); // Kembali ke halaman sebelumnya dengan callback
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update recipe")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating recipe: $e")),
      );
    } finally {
      setUpdating(false);
    }
  }
}