import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: thirdColor, width: 2)),
          ),
          child: Theme(
            data: ThemeData(splashColor: Colors.transparent),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });

                widget.onItemTapped(index);
              },
              elevation: 0,
              selectedLabelStyle: semiBoldTextStyle.copyWith(fontSize: 10),
              unselectedLabelStyle: mediumTextStyle.copyWith(fontSize: 10),
              unselectedIconTheme: IconThemeData(color: grayColor),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: whiteColor,
              unselectedItemColor: grayColor,
              backgroundColor: secondaryColor,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Icon(Icons.home_filled, size: 20),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Icon(Icons.stadium_rounded, size: 20),
                  ),
                  label: 'Stadium',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Icon(Icons.settings, size: 20),
                  ),
                  label: 'Setting',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
