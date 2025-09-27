// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../history/history_screen.dart';
import 'camera_screen.dart';
import 'file_upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  late AnimationController _notificationController;
  late AnimationController _cardAnimationController;
  late List<Animation<Offset>> _cardSlideAnimations;
  late List<Animation<double>> _cardFadeAnimations;
  bool _hasNotifications = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _notificationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create staggered animations for cards
    _cardSlideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _cardAnimationController,
          curve: Interval(
            index * 0.1,
            0.6 + index * 0.1,
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });

    _cardFadeAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardAnimationController,
          curve: Interval(
            index * 0.1,
            0.8 + index * 0.1,
            curve: Curves.easeOut,
          ),
        ),
      );
    });
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _cardAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _notificationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive breakpoints
    final isSmallScreen = width < 360;
    final isMediumScreen = width >= 360 && width < 400;
    final isLargeScreen = width >= 400;

    // Adaptive dimensions
    final horizontalPadding = isSmallScreen
        ? 16.0
        : (isMediumScreen ? 18.0 : 20.0);
    final cardSpacing = height * 0.025; // 2.5% of screen height
    final headerHeight = height * 0.06; // 6% of screen height

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: height * 0.02, // 2% of screen height
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with animation
              SlideTransition(
                position: _cardSlideAnimations[0],
                child: FadeTransition(
                  opacity: _cardFadeAnimations[0],
                  child: _buildHeader(width, headerHeight),
                ),
              ),

              SizedBox(height: cardSpacing),

              // Greeting card with animation
              SlideTransition(
                position: _cardSlideAnimations[1],
                child: FadeTransition(
                  opacity: _cardFadeAnimations[1],
                  child: _buildGreetingCard(width, height),
                ),
              ),

              SizedBox(height: cardSpacing),

              // Process flow with animation
              SlideTransition(
                position: _cardSlideAnimations[2],
                child: FadeTransition(
                  opacity: _cardFadeAnimations[2],
                  child: _buildProcessFlow(width, height),
                ),
              ),

              SizedBox(height: cardSpacing),

              // Quick Stats Card
              SlideTransition(
                position: _cardSlideAnimations[3],
                child: FadeTransition(
                  opacity: _cardFadeAnimations[3],
                  child: _buildQuickStatsCard(width, height),
                ),
              ),

              SizedBox(height: cardSpacing),

              // Action buttons
              _buildActionButtons(context, width, height),

              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double width, double height) {
    final fontSize = width < 360 ? 18.0 : (width < 400 ? 19.0 : 20.0);
    final iconSize = width < 360 ? 20.0 : 24.0;
    final horizontalPadding = width * 0.05; // 5% of screen width
    final verticalPadding = height * 0.2; // 20% of header height

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.lightGreen],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.elasticOut,
            builder: (context, rotation, child) {
              return Transform.rotate(
                angle: rotation * 0.5,
                child: Icon(Icons.eco, color: Colors.white, size: iconSize),
              );
            },
          ),
          SizedBox(width: width * 0.03), // 3% of screen width
          Text(
            AppStrings.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCard(double width, double height) {
    final titleFontSize = width < 360 ? 18.0 : (width < 400 ? 19.0 : 20.0);
    final subtitleFontSize = width < 360 ? 13.0 : (width < 400 ? 14.0 : 15.0);
    final circleSize = width < 360 ? 60.0 : (width < 400 ? 70.0 : 80.0);
    final iconSize = circleSize * 0.5;
    final cardPadding = width * 0.06; // 6% of screen width

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        AppStrings.helloUser,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    AnimatedBuilder(
                      animation: _notificationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _hasNotifications
                              ? 1.0 + (_notificationController.value * 0.2)
                              : 1.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _hasNotifications = !_hasNotifications;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _hasNotifications
                                        ? 'Notifications enabled'
                                        : 'Notifications disabled',
                                  ),
                                  backgroundColor: AppColors.primaryGreen,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _hasNotifications
                                    ? Icons.notifications_active
                                    : Icons.notifications_off,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Text(
                  AppStrings.readyToCheck,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 2000),
              curve: Curves.elasticOut,
              builder: (context, rotation, child) {
                return Transform.rotate(
                  angle: rotation * 0.1,
                  child: Icon(Icons.eco, color: Colors.white, size: iconSize),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessFlow(double width, double height) {
    final titleFontSize = width < 360 ? 16.0 : (width < 400 ? 17.0 : 18.0);
    final labelFontSize = width < 360 ? 10.0 : 11.0;
    final iconSize = width < 360 ? 20.0 : 24.0;
    final stepWidth = width < 360 ? 50.0 : 60.0;
    final cardPadding = width * 0.06;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withOpacity(0.9),
            AppColors.lightGreen,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'How It Works',
            style: TextStyle(
              color: Colors.white,
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProcessStep(
                Icons.camera_alt,
                AppStrings.takeAPicture,
                0,
                stepWidth,
                iconSize,
                labelFontSize,
              ),
              _buildArrow(),
              _buildProcessStep(
                Icons.analytics,
                AppStrings.seeDiagnosis,
                1,
                stepWidth,
                iconSize,
                labelFontSize,
              ),
              _buildArrow(),
              _buildProcessStep(
                Icons.medication,
                AppStrings.getMedicine,
                2,
                stepWidth,
                iconSize,
                labelFontSize,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(
    IconData icon,
    String label,
    int index,
    double stepWidth,
    double iconSize,
    double fontSize,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (index * 200)),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryGreen,
                  size: iconSize,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: stepWidth,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArrow() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
        );
      },
    );
  }

  Widget _buildQuickStatsCard(double width, double height) {
    final titleFontSize = width < 360 ? 16.0 : (width < 400 ? 17.0 : 18.0);
    final valueFontSize = width < 360 ? 18.0 : (width < 400 ? 19.0 : 20.0);
    final labelFontSize = width < 360 ? 11.0 : 12.0;
    final iconSize = width < 360 ? 18.0 : 20.0;
    final cardPadding = width * 0.05;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppColors.primaryGreen, size: 24),
              SizedBox(width: width * 0.03),
              Text(
                'Quick Stats',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Scans Today',
                '0',
                Icons.today,
                iconSize,
                valueFontSize,
                labelFontSize,
              ),
              _buildStatItem(
                'Total Plants',
                '0',
                Icons.eco,
                iconSize,
                valueFontSize,
                labelFontSize,
              ),
              _buildStatItem(
                'Health Score',
                '0%',
                Icons.favorite,
                iconSize,
                valueFontSize,
                labelFontSize,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    double iconSize,
    double valueFontSize,
    double labelFontSize,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: iconSize),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    double width,
    double height,
  ) {
    final buttonHeight = height < 600 ? 100.0 : (height < 700 ? 110.0 : 120.0);
    final iconSize = width < 360 ? 28.0 : 32.0;
    final fontSize = width < 360 ? 12.0 : 14.0;
    final buttonSpacing = height * 0.02;

    return Column(
      children: [
        // Main action buttons row
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                AppStrings.scanHere,
                Icons.qr_code_scanner,
                AppColors.primaryGreen,
                () => _navigateWithAnimation(context, const CameraScreen()),
                height: buttonHeight,
                iconSize: iconSize,
                fontSize: fontSize,
                gradient: LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.lightGreen],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActionButton(
                context,
                AppStrings.uploadFromFile,
                Icons.upload_file,
                AppColors.lightGreen,
                () => _navigateWithAnimation(context, const FileUploadScreen()),
                height: buttonHeight,
                iconSize: iconSize,
                fontSize: fontSize,
                gradient: LinearGradient(
                  colors: [AppColors.lightGreen, AppColors.primaryGreen],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: buttonSpacing),

        // History button
        _buildActionButton(
          context,
          AppStrings.history,
          Icons.history,
          AppColors.darkGreen,
          () => _navigateWithAnimation(context, const HistoryScreen()),
          width: double.infinity,
          height: buttonHeight,
          iconSize: iconSize,
          fontSize: fontSize,
          gradient: LinearGradient(
            colors: [AppColors.darkGreen, AppColors.primaryGreen],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    double? width,
    required double height,
    required double iconSize,
    required double fontSize,
    Gradient? gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(height * 0.15), // 15% of button height
        decoration: BoxDecoration(
          gradient:
              gradient ??
              LinearGradient(colors: [color, color.withOpacity(0.8)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(iconSize * 0.375), // 37.5% of icon size
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: iconSize),
            ),
            SizedBox(height: height * 0.1), // 10% of button height
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateWithAnimation(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.refresh, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Data refreshed successfully!'),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
