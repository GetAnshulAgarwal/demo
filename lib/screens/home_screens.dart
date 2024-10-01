import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import 'like_post_screen.dart';
import 'saved_post_screen.dart';
import 'community_screen.dart';
import '../widgets/post_card.dart';

class NotificationBadge extends StatelessWidget {
  final int count;

  NotificationBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(Icons.notifications),
        if (count > 0) // Only show badge if count is greater than 0
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: BoxConstraints(
                minWidth: 15,
                minHeight: 5,
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10, // Reduced font size
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    final likedPosts =
        postProvider.posts.where((post) => post.isLiked).toList();
    final savedPosts =
        postProvider.posts.where((post) => post.isSaved).toList();

    final List<Widget> _screens = [
      Consumer<PostProvider>(builder: (context, postProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            print("Refreshing posts...");
            await postProvider.fetchPosts();
          },
          child: ListView.builder(
            itemCount: postProvider.posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: postProvider.posts[index],
                onDelete: () =>
                    postProvider.deletePost(postProvider.posts[index]),
              );
            },
          ),
        );
      }),
      LikedPostsScreen(likedPosts: likedPosts),
      CommunityScreen(),
      SavedPostsScreen(savedPosts: savedPosts),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Demo App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: NotificationBadge(count: 5),
            onPressed: () {
              // Handle notifications if needed
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Demo App Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Liked Posts'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Community'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Saved Posts'),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Add action for settings or navigate to settings screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Add logout functionality
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _screens[_currentIndex], // Main content

          // Floating Bottom Navigation Bar
          Positioned(
            bottom: 30, // Position it above the bottom of the screen
            left: 30, // Padding from the left
            right: 30, // Padding from the right
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black, // Background color for the navigation bar
                borderRadius: BorderRadius.circular(30), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset:
                        Offset(0, 5), // Shadow effect to create floating feel
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor:
                    Colors.transparent, // Make the background transparent
                elevation: 0, // Remove the default elevation
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Feed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Liked',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    label: 'Community',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark),
                    label: 'Saved',
                  ),
                ],
                currentIndex: _currentIndex,
                selectedItemColor: Colors.blue, // Selected item color
                unselectedItemColor: Colors.grey, // Unselected item color
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
