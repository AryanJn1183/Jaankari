import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaankari/response_screen.dart';
import 'package:http/http.dart' as http;

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class ApiService {
  static Future<String> fetchData(String prompt) async {
    // Simulating an API call, replace this with your actual API call
    await Future.delayed(Duration(seconds: 2));
    return "Response for prompt: $prompt";
  }
}

class _GroceryScreenState extends State<GroceryScreen> {
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
            imagePath: 'assets/images/grocery_image.jpg',
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
    return Column(
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
          child: ScreenUtilInit(
            designSize: Size(390, 844),
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
            "GROCERY | F&B",
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
                  "Licensing & Registration",
                  "Hygiene, capacity, license types.",
                  "What do you mean by Licensing and Registration in Hygiene, capacity, license types in India",
                ),
                _buildCategoryButton(
                  "Food Standards & Additives",
                  "Ingredients, limits, labeling.",
                  "What do you mean by Food Standards & Additives in Ingredients, limits, labeling in India",
                ),
                _buildCategoryButton(
                  "Prohibited & Restricted Sales",
                  "Banned substances, specific limits.",
                  "What do you mean by Prohibited & Restricted Sales in Banned substances, specific limits in India",
                ),
                _buildCategoryButton(
                  "Contaminants & Residues",
                  "Maximum limits, testing protocols.",
                  "What do you mean by Contaminants & Residues in Maximum limits, testing protocols in India",
                ),
                _buildCategoryButton(
                  "Speciality Foods",
                  "Specific definitions, labeling, claims.",
                  "What do you mean by Speciality Foods in Specific definitions, labeling, claims in India",
                ),
                _buildCategoryButton(
                  "Food Recall Procedure",
                  "Timely action, consumer notification.",
                  "What do you mean by  Food Recall Procedure. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Import",
                  "Hygiene certificates, labeling requirements.",
                  "What do you mean by  Import. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Non-Specific Food Approval",
                  "Predefined criteria, simplified approval.",
                  "What do you mean by  Non-Specific Food Approval. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Organic Food",
                  "Certification standards, traceability.",
                  "What do you mean by  Organic Food. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Alcoholic Beverages",
                  "Regulates production, sale & consumption of alcohol. Licensing, labeling, age restrictions",
                  "What do you mean by  Alcoholic Beverages. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Food Fortification",
                  "Enriches staple foods with essential nutrients.    Specific nutrients, levels, monitoring.",
                  "What do you mean by  Food Fortification. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Food Safety Auditing",
                  "Independent assessment of food safety practices.   HACCP compliance, corrective actions.",
                  "What do you mean by  Food Safety Auditing. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Advertising & Claims",
                  "Truthful, substantiated claims, no health exploitation.",
                  "What do you mean by  Advertising & Claims. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Packaging",
                  "Protects food, provides information & prevents tampering.  Labeling requirements, material safety..",
                  "What do you mean by  Packaging. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Surplus Food Management",
                  "Hygiene standards, donation criteria, traceability.",
                  "What are the rules, regulations, Surplus Food Management to Packaging. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Children's School Food",
                  "Nutritional guidelines, hygiene standards, age-appropriate portions.",
                  "What do you mean by  Children's School Food. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Infant Nutrition",
                  "Sets strict standards for infant formula & food.   Specific nutrient composition, safety testing, labeling.",
                  "What do you mean by  Infant Nutrition. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Ayurveda Aahara",
                  "Regulates claims & safety of Ayurveda-based food products. Science-based claims, no harmful ingredients.",
                  "What do you mean by  Ayurveda Aahara. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Vegan Foods",
                  "Defines & protects integrity of vegan food labels. No animal-derived ingredients, clear labeling.",
                  "What do you mean by  Vegan Foods. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Meeting Procedures",
                  "Ensures transparency & efficiency in conducting business.  Defined roles, quorum requirements, voting procedures.",
                  "What do you mean by  Meeting Procedures. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Central Advisory Committee",
                  "Expertise, stakeholder representation, meeting protocols.",
                  "What do you mean by  Central Advisory Committee. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Employee Compensation",
                  "Defines fair & transparent compensation structure. Competitive salaries, performance-based incentives.",
                  "What do you mean by  Employee Compensation. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Scientific Committee & Panel",
                  "Expert composition, meeting procedures, conflict of interest rules.",
                  "What do you mean by  Scientific Committee & Panel. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Recruitment & Appointment",
                  "Merit-based selection, documented procedures.",
                  "What do you mean by  Recruitment & Appointment. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Financial",
                  "Governs financial management & accountability. Budgetary control, audit mechanisms, transparency.",
                  "What do you mean by  Financial. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Labelling & Display",
                  "Informs consumers about food contents & safety.    Clear, accurate, mandatory information.",
                  "What do you mean by  Labelling & Display. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Lab Recognition & Notification",
                  "Ensures labs meet quality & competency standards.  Accreditation, specific tests, government approval.",
                  "What do you mean by  Lab Recognition & Notification. List them in separate bullet points",
                ),
                _buildCategoryButton(
                  "Laboratory & Sampling Analysis",
                  "Tests food for safety, quality & compliance with regulations.  Standardized methods, qualified personnel, data integrity.",
                  "What do you mean by  Laboratory & Sampling Analysis. List them in separate bullet points",
                ),

                // Add more buttons as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
