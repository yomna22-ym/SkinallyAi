import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Upload/upload_tab_navigator.dart';
import '../../../../../Core/Base/base_view_model.dart';

class UploadTabViewModel extends BaseViewModel<UploadNavigator>  {

  File? selectedImage;
  bool isLoading = false;
  String? resultMessage;
  String? error;
  String? diagnosisResult;

  static const String API_URL = "https://7efc-35-199-12-34.ngrok-free.app/predict";
  static const int TIMEOUT_SECONDS = 30;

  Future<void> startUpload(File file) async {
    selectedImage = file;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _uploadImageToApi(file);
      resultMessage = response['display_message'];
      diagnosisResult = response['diagnosis'];
    } catch (e) {
      error = _getUserFriendlyErrorMessage(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _getUserFriendlyErrorMessage(String technicalError) {
    final lowerError = technicalError.toLowerCase();

    if (lowerError.contains('connection timeout') ||
        lowerError.contains('timeout')) {
      return "Connection is too slow. Please check your internet and try again.";
    }

    if (lowerError.contains('network error') ||
        lowerError.contains('socket') ||
        lowerError.contains('host lookup failed')) {
      return "No internet connection. Please check your network and try again.";
    }

    if (lowerError.contains('server error') ||
        lowerError.contains('500') ||
        lowerError.contains('502') ||
        lowerError.contains('503')) {
      return "Server is temporarily unavailable. Please try again in a few minutes.";
    }

    if (lowerError.contains('bad request') ||
        lowerError.contains('400')) {
      return "Invalid image format. Please select a different image and try again.";
    }

    if (lowerError.contains('not found') ||
        lowerError.contains('404')) {
      return "Service is currently unavailable. Please try again later.";
    }

    if (lowerError.contains('authentication') ||
        lowerError.contains('authorization') ||
        lowerError.contains('401') ||
        lowerError.contains('403')) {
      return "Access denied. Please try again.";
    }

    if (lowerError.contains('file size') ||
        lowerError.contains('too large')) {
      return "Image is too large. Please choose a smaller image and try again.";
    }

    if (lowerError.contains('invalid file') ||
        lowerError.contains('unsupported format')) {
      return "Unsupported image format. Please use JPG, PNG, or other standard formats.";
    }

    return "Something went wrong. Please try again.";
  }

  Future<Map<String, String>> _uploadImageToApi(File file) async {
    try {
      final dio = Dio();

      dio.options.connectTimeout = Duration(seconds: TIMEOUT_SECONDS);
      dio.options.receiveTimeout = Duration(seconds: TIMEOUT_SECONDS);
      dio.options.sendTimeout = Duration(seconds: TIMEOUT_SECONDS);

      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));

      final String fileExtension = path.extension(file.path).toLowerCase().replaceAll('.', '');
      final String mimeType = _getMimeType(fileExtension);

      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: path.basename(file.path),
          contentType: MediaType(_getMediaMainType(mimeType), _getMediaSubType(mimeType)),
        ),
      });

      final response = await dio.post(
        API_URL,
        data: formData,
        options: Options(
          headers: {
            'ngrok-skip-browser-warning': 'true',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final label = data['predicted_class'] ?? "Unknown";

        return {
          'display_message': "Diagnosis: $label",
          'diagnosis': label,
        };
      } else if (response.statusCode == 400) {
        throw Exception("Invalid image format. Please select a different image.");
      } else if (response.statusCode == 404) {
        throw Exception("Service is currently unavailable. Please try again later.");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception("Access denied. Please try again.");
      } else if (response.statusCode! >= 500) {
        throw Exception("Server is temporarily unavailable. Please try again in a few minutes.");
      } else {
        throw Exception("Something went wrong. Please try again.");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection is too slow. Please check your internet and try again.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Server is taking too long to respond. Please try again.");
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception("Upload is taking too long. Please check your internet or try a smaller image.");
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          throw Exception("Invalid image format. Please select a different image.");
        } else if (statusCode == 404) {
          throw Exception("Service is currently unavailable. Please try again later.");
        } else if (statusCode != null && statusCode >= 500) {
          throw Exception("Server is temporarily unavailable. Please try again in a few minutes.");
        } else {
          throw Exception("Something went wrong. Please try again.");
        }
      } else {
        throw Exception("No internet connection. Please check your network and try again.");
      }
    } catch (e) {
      rethrow;
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }

  String _getMediaMainType(String mimeType) {
    return mimeType.split('/')[0];
  }

  String _getMediaSubType(String mimeType) {
    return mimeType.split('/')[1];
  }

  @override
  void dispose() {
    selectedImage = null;
    isLoading = false;
    resultMessage = null;
    error = null;
    diagnosisResult = null;
    super.dispose();
  }

  void onAiAssistantPressed() {
    if (diagnosisResult != null && diagnosisResult!.isNotEmpty) {
      navigator?.goToAiAssistant(diagnosisResult!);
    } else {
      navigator?.showFailMessage(
        message: "Please wait until the image is processed and diagnosis is ready.",
        posActionTitle: "OK",
      );
    }
  }

  // Add retry functionality
  void retryUpload() {
    if (selectedImage != null) {
      startUpload(selectedImage!);
    }
  }
}