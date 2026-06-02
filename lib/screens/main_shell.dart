import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),
      body: navigationShell,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final tabs = [
      (icon: Icons.home_outlined, label: '时光',selectedIcon: Icons.home),
      (icon: Icons.calendar_today_outlined, label: '印记',selectedIcon: Icons.calendar_today),
      (icon: Icons.person_outlined, label: '我的',selectedIcon: Icons.person),
    ];

    return Container(
      height: 80,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F0),
        border: Border(top: BorderSide(color: Color(0xFFE8E4DC), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isActive = navigationShell.currentIndex == index;
          return _BottomNavItem(
            icon: isActive ? tabs[index].selectedIcon : tabs[index].icon,
            label: tabs[index].label,
            isActive: isActive,
            onTap: () {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          );
        }),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFF2EDDF) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isActive ? const Color(0xFFD4A853) : const Color(0xFFAEA89C),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? const Color(0xFFD4A853) : const Color(0xFFAEA89C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
