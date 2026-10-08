import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Undergraduate Profile',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE2E8F0),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          surface: Colors.white,
          outline: Colors.black12,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF818CF8),
          surface: Color(0xFF1E293B),
          outline: Colors.white12,
        ),
        useMaterial3: true,
      ),
      home: ProfileScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User profile state
  String _name = 'Shamal';
  String _email = 'sharana@nsbm.com';
  int _points = 0;
  bool _hasClaimedPoint = false;
  IconData _selectedAvatar = Icons.code_rounded;

  final List<IconData> _avatarOptions = [
    Icons.code_rounded,
    Icons.terminal_rounded,
    Icons.laptop_mac_rounded,
    Icons.person_rounded,
    Icons.face_rounded,
  ];

  // Logic to handle one-time point claim
  void _claimPoint() {
    if (!_hasClaimedPoint) {
      setState(() {
        _points += 1;
        _hasClaimedPoint = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(
            child: Text('🎉 1 Reward Point Claimed!'),
          ),
          backgroundColor: const Color(0xFF6366F1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  // Logic to reset claimed point
  void _resetPoint() {
    if (_hasClaimedPoint) {
      setState(() {
        _points = 0;
        _hasClaimedPoint = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(
            child: Text('Point reward reset to 0.'),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  // Edit Profile Glassmorphic Sheet
  void _showEditProfileSheet() {
    final TextEditingController nameController = TextEditingController(text: _name);
    final TextEditingController emailController = TextEditingController(text: _email);
    IconData tempAvatar = _selectedAvatar;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return GlassmorphicContainer(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Edit Student Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Profile Icon',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _avatarOptions.map((icon) {
                      final isSelected = tempAvatar == icon;
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            tempAvatar = icon;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF6366F1)
                                : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black54),
                            size: 24,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Student Email',
                      prefixIcon: const Icon(Icons.school_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _name = nameController.text.trim();
                          _email = emailController.text.trim();
                          _selectedAvatar = tempAvatar;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Undergraduate Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, size: 28),
            onPressed: _showEditProfileSheet,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Aesthetic Decorative Blobs for Glassmorphism
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x666366F1),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x4410B981),
              ),
            ),
          ),

          // Main Scrollable Body Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // 1. CENTERED PROFILE HEADER GLASS CARD
                    GlassmorphicContainer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF6366F1), Color(0xFF10B981)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                                  child: Icon(
                                    _selectedAvatar,
                                    size: 58,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF10B981), width: 2),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF10B981),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Software Engineering Undergraduate',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF818CF8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2. CENTERED USER DETAILS GLASS CARD
                    GlassmorphicContainer(
                      title: 'STUDENT DETAILS',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildCenteredInfoTile(
                            icon: Icons.person_outline_rounded,
                            label: 'Full Name',
                            value: _name,
                            isDark: isDark,
                          ),
                          const Divider(height: 24),
                          _buildCenteredInfoTile(
                            icon: Icons.alternate_email_rounded,
                            label: 'Student Email',
                            value: _email,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. REWARD POINTS GLASS CARD (WITH RESET BUTTON)
                    GlassmorphicContainer(
                      title: 'REWARDS & POINTS',
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _claimPoint,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _hasClaimedPoint ? Icons.star_rounded : Icons.star_border_rounded,
                                    color: _hasClaimedPoint ? Colors.amber : (isDark ? Colors.white70 : Colors.black54),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '$_points Point',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _hasClaimedPoint ? Colors.amber : (isDark ? Colors.white : Colors.black),
                                    ),
                                  ),
                                  if (!_hasClaimedPoint) ...[
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Tap to Pick',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF10B981),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          // Reset Button after picking point
                          if (_hasClaimedPoint) ...[
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _resetPoint,
                              icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.redAccent),
                              label: const Text(
                                'Remove / Reset Point',
                                style: TextStyle(color: Colors.redAccent, fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 4. SETTINGS GLASS CARD (PUSH NOTIFICATIONS REMOVED)
                    GlassmorphicContainer(
                      title: 'PREFERENCES',
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                    color: const Color(0xFF6366F1),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Dark Theme',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: isDark,
                                activeColor: const Color(0xFF6366F1),
                                onChanged: widget.onThemeChanged,
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Privacy & Security settings open.')),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Color(0xFF6366F1),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Privacy & Security',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showEditProfileSheet,
        backgroundColor: const Color(0xFF6366F1),
        elevation: 6,
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Centered detail item builder
  Widget _buildCenteredInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF6366F1), size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

// Reusable Glassmorphism Container Widget with Blurred Backdrop
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.title,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.65),
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.8),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 14),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}