import 'dart:convert';
import 'dart:io';
import 'package:resepmakanan/services/auth_service.dart';
import 'package:resepmakanan/services/auth_service.dart';
import '../models/receipe_model.dart'; 
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';


class RecipeService {
  final Dio _dio = Dio();

  // Base URL
  static const String _baseUrl = 'https://recipe.incube.id/api/recipes';

  Future<List> getAllRecipe() async {
    final token = await AuthService().getToken();
    try {
      final response = await _dio.get(
        _baseUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data']['data'] ?? [];
      } else {
        print("Error: Invalid response structure");
        return [];
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return [];
    } catch (e) {
      print("Unexpected Error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getRecipeById(String id) async {
    final token = await AuthService().getToken();
    try {
      final response = await _dio.get(
        '$_baseUrl/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data'];
      } else {
        print("Error: Failed to fetch recipe details");
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  Future<bool> addRecipe(String title, String cookingMethod, String description,
      String ingredients, File photo) async {
    final token = await AuthService().getToken();

    try {
      String fileName = photo.path.split('/').last;

      FormData formData = FormData.fromMap({
        "title": title,
        "cooking_method": cookingMethod,
        "ingredients": ingredients,
        "description": description,
        "photo": await MultipartFile.fromFile(photo.path, filename: fileName),
      });

      final response = await _dio.post(
        _baseUrl,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        print("Recipe added successfully");
        return true;
      } else {
        print("Error: ${response.data['message']}");
        return false;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return false;
    } catch (e) {
      print("Unexpected Error: $e");
      return false;
    }
  }

  Future<void> deleteRecipe(int recipeId) async {
    final token = await AuthService().getToken();
    try {
      final response = await _dio.delete(
        '$_baseUrl/$recipeId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print("Recipe deleted successfully");
      } else {
        throw Exception("Failed to delete recipe");
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      print("Unexpected Error: $e");
      throw Exception("Failed to delete recipe");
    }
  }

  Future<bool> updateRecipe(int recipeId, String title, String cookingMethod,
      String description, String ingredients, File? photo) async {
    final token = await AuthService().getToken();

    try {
      FormData formData = FormData.fromMap({
        "title": title,
        "cooking_method": cookingMethod,
        "ingredients": ingredients,
        "description": description,
      });

      if (photo != null) {
        String fileName = photo.path.split('/').last;
        formData.files.add(MapEntry(
          "photo",
          await MultipartFile.fromFile(photo.path, filename: fileName),
        ));
      }

      final response = await _dio.put(
        '$_baseUrl/$recipeId',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print("Recipe updated successfully");
        return true;
      } else {
        print("Error: ${response.data['message']}");
        return false;
      }
    } on DioError catch (e) {
      _handleDioError(e);
      return false;
    } catch (e) {
      print("Unexpected Error: $e");
      return false;
    }
  }

  // Helper untuk menangani error Dio
  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      print("Connection Timeout Error: ${e.message}");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      print("Receive Timeout Error: ${e.message}");
    } else if (e.type == DioExceptionType.badResponse) {
      print("Response Error: ${e.response?.data}");
    } else if (e.type == DioExceptionType.cancel) {
      print("Request Cancelled: ${e.message}");
    } else {
      print("Unexpected Dio Error: ${e.message}");
    }
  }
}