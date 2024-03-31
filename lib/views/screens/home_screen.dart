import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import '../../utils/constants.dart';
import 'profile_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.deepPurpleAccent.shade100,
          bottomNavigationBar: WaterDropNavBar(
            bottomPadding: 5,
            inactiveIconColor: Colors.amber.shade400,
            waterDropColor: Colors.deepPurpleAccent.shade100,
            barItems: <BarItem>[
              BarItem(
                filledIcon: Icons.home,
                outlinedIcon: Icons.home_outlined,
              ),
              BarItem(
                filledIcon: Icons.search_rounded,
                outlinedIcon: Icons.search_outlined,
              ),
              BarItem(
                  filledIcon: Icons.add_circle_rounded,
                  outlinedIcon: Icons.add_circle_outline_rounded),
              BarItem(
                filledIcon: Icons.person_rounded,
                outlinedIcon: Icons.person_outline_rounded,
              ),
            ],
            selectedIndex: selectedIndex,
            onItemSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
              pageController.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad);
            },
          ),
          /* bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: CustomAddIcon(),
                label: "Add",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: "Message",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ), */
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: <Widget>[
              /* VideoScreen(),
              SearchScreen(),
              const AddVideoScreen(), */
              ProfileScreen(uid: authController.user!.uid)
            ],
          ),
        ),
      ),
    );
  }
}
