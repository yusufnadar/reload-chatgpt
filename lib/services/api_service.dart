import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_consts.dart';
import '../models/chat_model.dart';
import '../models/models_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/models"),
        headers: {'Authorization': 'Bearer ${ApiConstants.apiKey}'},
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessageGPT(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/chat/completions"),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.apiKey}',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );
      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage({
    required String message,
    required String modelId,
  }) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/completions"),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.apiKey}',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      rethrow;
    }
  }

}
