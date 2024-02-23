import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaankari/response_screen.dart';
import 'package:http/http.dart' as http;

class ElectronicsScreen extends StatefulWidget {
  const ElectronicsScreen({super.key});

  @override
  State<ElectronicsScreen> createState() => _ElectronicsScreenState();
}

class _ElectronicsScreenState extends State<ElectronicsScreen> {
  Future<String> fetchResponseFromBackend(String question) async {
    final url = Uri.parse(
        'https://asia-south1-heroic-equinox-413915.cloudfunctions.net/function-1/ask-question/$question');

    // Add headers to the request
    final headers = {
      'Content-Type': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load response');
    }
  }

  Future<void> askOpenAI(String question, String mainText) async {
    try {
      final response = await fetchResponseFromBackend(question);
      final content = extractContentFromResponse(response);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResponseScreen(
            response: content,
            title: mainText,
            imagePath: 'assets/images/electronics.jpg',
          ),
        ),
      );
    } catch (e) {
      print('Error fetching response: $e');
    }
  }

  String extractContentFromResponse(String response) {
    final parsedResponse = jsonDecode(response);
    final content =
        parsedResponse['answer']['choices'][0]['message']['content'];
    return content;
  }

  Widget _buildCategoryButton(
      String mainText, String oneLinerText, String prompt) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: Column(
        children: [
          TextButton(
            onPressed: () => askOpenAI(prompt, mainText),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Colors.transparent;
                },
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mainText,
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF007CC2),
                        ),
                      ),
                      Text(
                        oneLinerText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Divider(
            height: 0, // Remove the height to make the divider invisible
            color: Colors.grey[300],
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "ELECTRONICS",
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color(0xFF007CC2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Column(
            children: [
              _buildCategoryButton(
                "Jan Vishwas",
                "",
                "What are the rules, regualtions, amendments and acts related to Jan Vishwas. List them in separate bullet points",
              ),
              _buildCategoryButton(
                "IT",
                "",
                "What are the rules, regualtions, amendments and acts related to IT. List them in separate bullet points",
              ),
              // Add more buttons as needed
            ],
          ),
        ),
      ),
    );
  }
}
