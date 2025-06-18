import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../Core/Base/base_view_model.dart';
import '../../../Core/Base/base_navigator.dart';

class Message {
  final String sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}

class ChatViewModel extends BaseViewModel<BaseNavigator> {
  final List<Message> _messages = [];
  bool _isTyping = false;
  final TextEditingController messageController = TextEditingController();

  List<Message> get messages => _messages;

  bool get isTyping => _isTyping;

  final String userName;
  final String userAge;
  final String gender;
  final String skinType;
  final String bodyArea;
  final String? diagnosis;

  static const String LLM_API_URL =
      "https://319b-35-231-60-151.ngrok-free.app/medical-assistant";
  static const int TIMEOUT_SECONDS = 30;

  ChatViewModel({
    required this.userName,
    required this.userAge,
    required this.gender,
    required this.skinType,
    required this.bodyArea,
    this.diagnosis,
  }) {
    _fetchInitialBotMessage();
  }

  String _getUserFriendlyErrorMessage(dynamic error, {int? statusCode}) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return "The connection is taking too long. Please check your internet connection and try again.";

        case DioExceptionType.connectionError:
          return "Unable to connect to the server. Please check your internet connection and try again.";

        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 422) {
            return "Some required information is missing. Please go back and fill in all the required fields.";
          } else if (error.response?.statusCode == 500) {
            return "The server is currently experiencing issues. Please try again in a few minutes.";
          } else if (error.response?.statusCode == 404) {
            return "The medical assistant service is temporarily unavailable. Please try again later.";
          }
          return "We're having trouble processing your request. Please try again later.";

        case DioExceptionType.cancel:
          return "Request was cancelled. Please try again.";

        case DioExceptionType.unknown:
        default:
          return "Something went wrong. Please check your internet connection and try again.";
      }
    }

    // Handle other types of errors
    String errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') || errorString.contains('network')) {
      return "Network connection problem. Please check your internet and try again.";
    } else if (errorString.contains('timeout')) {
      return "The request timed out. Please try again.";
    } else
    if (errorString.contains('certificate') || errorString.contains('ssl')) {
      return "Security connection error. Please try again later.";
    }

    return "We encountered an unexpected error. Please try again.";
  }

  void _fetchInitialBotMessage() async {
    _isTyping = true;
    notifyListeners();

    try {

      final dio = Dio();
      dio.options.connectTimeout = Duration(seconds: TIMEOUT_SECONDS);
      dio.options.receiveTimeout = Duration(seconds: TIMEOUT_SECONDS);
      dio.options.sendTimeout = Duration(seconds: TIMEOUT_SECONDS);

      final requestData = {
        "name": userName.trim(),
        "age": userAge.trim(),
        "gender": gender.trim(),
        "diagnosis": (diagnosis ?? "Unknown").trim(),
        "affected_area": bodyArea.trim(),
        "skin_type": skinType.trim(),
      };

      final formData = FormData.fromMap(requestData);

      final response = await dio.post(
        LLM_API_URL,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          validateStatus: (status) => true,
        ),
      );

      _isTyping = false;



      if (response.statusCode == 200) {
        final data = response.data;
        final message = data is Map
            ? data['response'] ?? data['message'] ?? data['answer'] ??
            data.toString()
            : data.toString();

        addMessage(sender: 'bot', content: message);
      } else {
        String errorMessage;

        if (response.statusCode == 422) {
          errorMessage =
          "Some required information is missing. Please go back and fill in all the required fields.";
        } else if (response.statusCode == 500) {
          errorMessage =
          "The medical assistant is temporarily unavailable. Please try again in a few minutes.";
        } else if (response.statusCode == 404) {
          errorMessage =
          "The medical assistant service is currently unavailable. Please try again later.";
        } else if (response.statusCode == 403) {
          errorMessage =
          "Access denied. Please contact support for assistance.";
        } else if (response.statusCode! >= 500) {
          errorMessage =
          "The server is experiencing issues. Please try again later.";
        } else {
          errorMessage =
          "We're having trouble processing your request. Please try again.";
        }

        addMessage(sender: 'bot', content: errorMessage);
      }
    } catch (e) {
      _isTyping = false;
      String userFriendlyError = _getUserFriendlyErrorMessage(e);
      addMessage(sender: 'bot', content: userFriendlyError);


    }

    notifyListeners();
  }

  void addMessage({required String sender, required String content}) {
    _messages.add(
      Message(sender: sender, content: content, timestamp: DateTime.now()),
    );
    notifyListeners();
  }

  void sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    addMessage(sender: 'user', content: message);
    messageController.clear();

    _isTyping = true;
    notifyListeners();

    try {
      final botResponse = await _getAIResponse(message);
      _isTyping = false;
      addMessage(sender: 'bot', content: botResponse);
    } catch (e) {
      _isTyping = false;
      String userFriendlyError = _getUserFriendlyErrorMessage(e);
      addMessage(sender: 'bot', content: userFriendlyError);
    }
  }

  Future<String> _getAIResponse(String userMessage) async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = Duration(seconds: TIMEOUT_SECONDS);
      dio.options.receiveTimeout = Duration(seconds: TIMEOUT_SECONDS);
      dio.options.sendTimeout = Duration(seconds: TIMEOUT_SECONDS);

      final requestData = {
        "name": userName.trim(),
        "age": userAge.trim(),
        "gender": gender.trim(),
        "diagnosis": (diagnosis ?? "Unknown").trim(),
        "affected_area": bodyArea.trim(),
        "skin_type": skinType.trim(),
        "user_message": userMessage.trim(),
      };

      final formData = FormData.fromMap(requestData);
      final response = await dio.post(
        LLM_API_URL,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          responseType: ResponseType.json,
          validateStatus: (status) => true,
        ),
      );


      if (response.statusCode == 200) {
        final data = response.data;
        return data is Map
            ? data['response'] ?? data['message'] ?? data['answer'] ??
            data.toString()
            : data.toString();
      } else {
        if (response.statusCode == 422) {
          return "I need some additional information to help you better. Please try rephrasing your question.";
        } else if (response.statusCode == 500) {
          return "I'm temporarily unavailable. Please try again in a few minutes.";
        } else if (response.statusCode == 404) {
          return "The medical assistant service is currently unavailable. Please try again later.";
        } else if (response.statusCode! >= 500) {
          return "I'm experiencing technical difficulties. Please try again later.";
        } else {
          return "I'm having trouble processing your message. Please try again.";
        }
      }
    } catch (e) {
      print("🔴 Follow-up error: $e");
      throw e;
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}



