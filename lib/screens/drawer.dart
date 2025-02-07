import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
        const SizedBox(
          height: 100, 
          width: double.infinity,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFE31749),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QuizTime',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ),

          _buildDrawerItem(
            icon: LucideIcons.info,
            text: 'Credits',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/credit');
            },
          ),
          _buildDrawerItem(
            icon: LucideIcons.logOut,
            text: 'Log out',
            onTap: () {

              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');

            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  //Metodo que construye un elmento del drawer
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
