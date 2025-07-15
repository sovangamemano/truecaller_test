import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'inventory_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
   int selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    InventoryScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.inventory, 'label': 'Inventory'},
    {'icon': Icons.notifications, 'label': 'Orders'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(color: Color(0xFFFEFEFE)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  border: isSelected
                      ? const Border(
                          top: BorderSide(color: Color(0xFF454093), width: 1),
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _navItems[index]['icon'],
                      size: 24,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _navItems[index]['label'],
                      style: TextStyle(
                        fontSize: isSelected ? 12 : 10,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF454093)
                            : const Color(0xFF909090),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}