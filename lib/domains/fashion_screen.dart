import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaankari/response_screen.dart';
import 'package:http/http.dart' as http;

class FashionScreen extends StatefulWidget {
  const FashionScreen({super.key});

  @override
  State<FashionScreen> createState() => _FashionScreenState();
}

class _FashionScreenState extends State<FashionScreen> {
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
            imagePath: 'assets/images/textile_image.jpg',
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
          "FASHION",
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
                "Cotton",
                "Organic certification, fair labor practices, traceability.",
                "What do you mean by cotton in Organic certification, fair labor practices, traceability in the product and market ",
              ),
              _buildCategoryButton(
                "Handloom",
                "Authenticity certification, weaver protection, fair trade.",
                "What do you mean by handloom in Authenticity certification, weaver protection, fair trade in the product and market",
              ),
              _buildCategoryButton(
                "Jute",
                "Sustainability certifications, fair trade practices, quality control.",
                "What do you mean by Jute in Sustainability certifications, fair trade practices, quality control. in the product and market",
              ),
              _buildCategoryButton(
                "Silk",
                "Quality standards, origin labeling, ethical sourcing.",
                "What do you mean by Silk in Quality standards, origin labeling, ethical sourcing. in the product and market",
              ),

              // Add more buttons as needed
            ],
          ),
        ),
      ),
    );
  }
}
