import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaankari/domains/agriculture_screen.dart';
import 'package:jaankari/domains/electronics_screen.dart';
import 'package:jaankari/domains/fashion_screen.dart';
import 'package:jaankari/domains/grocery_screen.dart';
import 'package:jaankari/response_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _imagePaths = [
    'assets/images/homescreen.png',
    'assets/images/homescreen1.png',
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    // Start timer to switch images every 5 seconds
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < _imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _buildCategoryButton(String imagePath, String text, Widget screen) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            height: 30,
            width: 50,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Colors.blue.shade50;
                },
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF007CC2),
              ),
            ),
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
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF007CC2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0.r),
            ),
          ),
          flexibleSpace: Center(
            child: Image.asset(
              'assets/images/jaankari_logo.png',
              width: 150.w, // Adjust the width as needed
              height: 250.h, // Adjust the height as needed
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_home.png'),
              opacity: 0.35,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: SizedBox(
                  height: 250.h,
                  width: 380.w,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _imagePaths.length,
                    itemBuilder: (context, index) {
                      return AspectRatio(
                        aspectRatio: 1.0, // Set the aspect ratio
                        child: Image.asset(
                          _imagePaths[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < _imagePaths.length; i++)
                    Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _currentPage ? Colors.blue : Colors.grey,
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResponseScreen(
                          title: "Generalised Rules",
                          response:
                              "In India, the realm of metrology is intricately woven with laws and regulations aimed at ensuring fairness and accuracy in measurements, crucial for trade, commerce, and everyday life. Here's a deeper dive into the regulatory framework: \n Legal Metrology Act, 2009: This cornerstone legislation establishes standards for weights and measures, regulating their use in trade and commerce. It also addresses the mandatory requirements for packaging and labeling of commodities.\n Packaged Commodities Rules, 2011: These rules mandate the labeling requirements for packaged goods, ensuring consumers have access to essential information like the net quantity, MRP, manufacturing details, and more. \n National Standards Rules, 2011: To maintain uniformity and precision, these rules outline procedures for maintaining and disseminating national standards of weights and measures, crucial for calibration and verification processes.\n General Metrology Rules, 2011: Covering a wide array of metrological aspects, these rules deal with verification and stamping of weights, measures, and instruments, along with the appointment and duties of inspectors.\n Standards of Weights and Measures (Enforcement) Act, 1985: Although not specific to metrology, this act empowers the enforcement of standards, ensuring compliance and fair practices in transactions.\n Standards of Weights and Measures (General) Rules, 1987: These rules specify the standards to be used in various trades and transactions, ensuring uniformity and accuracy across different sectors.",
                          imagePath: "assets/images/metrology_image.jpg"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor: Color(0xFF007CC2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 65.w, vertical: 10.h),
                ),
                child: Text(
                  "Generalised Rules",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategoryButton(
                      'assets/icons/agri_logo.png',
                      "Agriculture",
                      AgricultureScreen(),
                    ),
                    _buildCategoryButton(
                      'assets/icons/elec_logo.png',
                      "Electronics",
                      ElectronicsScreen(),
                    ),
                    _buildCategoryButton(
                      'assets/icons/fashion_logo.png',
                      "Textile",
                      FashionScreen(),
                    ),
                    _buildCategoryButton(
                      'assets/icons/fastfood_logo.png',
                      "Food & Beverages",
                      GroceryScreen(),
                    ),
                    _buildCategoryButton(
                      'assets/icons/grocery_logo.png',
                      "Grocery",
                      GroceryScreen(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
