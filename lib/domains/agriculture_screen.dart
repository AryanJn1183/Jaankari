import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaankari/response_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgricultureScreen extends StatefulWidget {
  const AgricultureScreen({Key? key}) : super(key: key);

  @override
  State<AgricultureScreen> createState() => _AgricultureScreenState();
}

class _AgricultureScreenState extends State<AgricultureScreen> {
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
            imagePath: 'assets/images/agri_image.jpg',
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
      String mainText, String oneLinerText, String question) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: Column(
        children: [
          TextButton(
            onPressed: () => askOpenAI(question, mainText),
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
            height: 0,
            color: Colors.grey[300],
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: Scaffold(
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
            "AGRICULTURE",
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Color(0xFF007CC2),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: [
                _buildCategoryButton(
                  "Agricultural Marketing",
                  "Transparency, competition, consumer protection.",
                  "What is Agricultural Marketing",
                ),
                _buildCategoryButton(
                  "Agricultural Nutrient Management",
                  "Balanced use of fertilizers, soil testing, organic matter management.",
                  "What is Agricultural Nutrient Management",
                ),
                _buildCategoryButton(
                  "Mechanization and Technology",
                  "Safety standards, emission regulations, responsible technology adoption.",
                  "What is Mechanization and Technology",
                ),
                _buildCategoryButton(
                  "Cooperation",
                  "Cooperative societies, fair trade practices, democratic decision-making.",
                  "What is Cooperation",
                ),
                _buildCategoryButton(
                  "Natural Resource Management",
                  "Soil conservation measures, water management practices, biodiversity protection.",
                  "What is Natural Resource Management",
                ),
                _buildCategoryButton(
                    "Crops & NFSM",
                    "Crop-specific regulations, minimum support prices, quality standards.",
                    "What is Crops & NFSM"),
                _buildCategoryButton(
                    "Oilseeds Divisions",
                    "Import-export regulations, quality control standards, oilseed development schemes.",
                    "What is Oilseeds Divisions"),
                _buildCategoryButton(
                  "Drought Management",
                  "Water conservation measures, drought-resistant crop varieties, emergency action plans.",
                  "What is Drought Management",
                ),
                _buildCategoryButton(
                  "Economic Administration",
                  "Market regulations, fair trade practices, financial assistance programs.",
                  "What is Economic Administration",
                ),
                _buildCategoryButton(
                  "Plant Protection",
                  "Pesticide regulations, integrated pest management (IPM) practices, quarantine measures.",
                  "What is Plant Protection",
                ),
                _buildCategoryButton(
                  "Extension",
                  "Extension services, training programs, information dissemination strategies.",
                  "What is Extension",
                ),
                _buildCategoryButton(
                  "Policy",
                  "Land use policies, agricultural subsidies, trade agreements.",
                  "What is Policy",
                ),
                _buildCategoryButton(
                  "Farmer Welfare",
                  "Minimum wages, social security schemes, farmer education programs.",
                  "What is Farmer Welfare",
                ),
                _buildCategoryButton(
                  "General Administration",
                  "Regulatory framework, budget allocation, monitoring & evaluation mechanisms.",
                  "What is General Administration",
                ),
                _buildCategoryButton(
                  "Seeds",
                  "Seed certification standards, variety registration, quality control checks.",
                  "What is Seeds",
                ),
                _buildCategoryButton(
                  "Horticulture",
                  "Good agricultural practices (GAP) guidelines, post-harvest management protocols, market standards.",
                  "What is Horticulture",
                ),
                _buildCategoryButton(
                  "Digital Agriculture",
                  "Cybersecurity measures, data privacy regulations, responsible technology use.",
                  "What is Digital Agriculture",
                )
                // Add more buttons as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
