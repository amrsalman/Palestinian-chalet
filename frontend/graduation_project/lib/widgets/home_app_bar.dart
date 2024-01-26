import 'package:flutter/material.dart';
import 'package:graduation_project/pages/search.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onFavoritePressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onFilterPressed;
  final bool showRemoveFilterButton;
  final VoidCallback onRemoveFilterPressed;

  HomeAppBar({
    required this.onFavoritePressed,
    required this.onSearchPressed,
    required this.onFilterPressed,
    this.showRemoveFilterButton = false,
    required this.onRemoveFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _buildRoundedButton(
        icon: Icons.favorite_border_outlined,
        onPressed: onFavoritePressed,
        color: Colors.red,
      ),
      title: Expanded(
        child: _buildLocationTitle(),
      ),
      actions: [
        _buildRoundedButton(
          icon: Icons.search,
          onPressed: onSearchPressed,
          color: Colors.red,
        ),
        _buildRoundedButton(
          icon: Icons.filter_list,
          onPressed: onFilterPressed,
          color: Colors.red,
        ),
         if (showRemoveFilterButton)  // Conditionally show the "Remove Filter" button
          TextButton(
            onPressed: onRemoveFilterPressed,
            child: Text('Remove Filter', style: TextStyle(color: Colors.red)),
          ),
      ],
      backgroundColor: Colors.transparent, // Set the AppBar background color to white
      elevation: 0, // Remove AppBar shadow if you want a flat design
    );
  }

  Widget _buildRoundedButton({required IconData icon, required VoidCallback onPressed, required Color color}) {
    return Container(
      margin: EdgeInsets.all(5), // Add margin if needed
      decoration: BoxDecoration(
        color: Colors.white, // Button background color
        borderRadius: BorderRadius.circular(10), // Adjust radius to get the desired corner roundness
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
        iconSize: 24, // Adjust the icon size to fit the design
        padding: EdgeInsets.all(8), // Adjust padding to fit the design
        constraints: BoxConstraints(), // Apply constraints to minimize button size
      ),
    );
  }

  Widget _buildLocationTitle() {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.location_on, size: 24, color: Colors.red),
          ),
         
          TextSpan(
            text: 'Palestine',
            style: TextStyle(
              color: Colors.black, // Change to your preferred color
              fontWeight: FontWeight.normal,
              fontSize: 20, // Change to your preferred size
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
