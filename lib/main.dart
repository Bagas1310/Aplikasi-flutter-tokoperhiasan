import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const BarelyShopApp());
}

class BarelyShopApp extends StatefulWidget {
  const BarelyShopApp({super.key});

  @override
  State<BarelyShopApp> createState() => _BarelyShopAppState();
}

class _BarelyShopAppState extends State<BarelyShopApp> {
  final AuthProvider _authProvider = AuthProvider();
  final CartProvider _cartProvider = CartProvider();

  @override
  void initState() {
    super.initState();
    _authProvider.addListener(_onAuthChanged);
    _authProvider.tryAutoLogin();
  }

  void _onAuthChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _authProvider.dispose();
    _cartProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthProviderScope(
      provider: _authProvider,
      child: CartProviderScope(
        provider: _cartProvider,
        child: MaterialApp(
          title: 'barely_shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryBlue,
              primary: AppColors.primaryBlue,
              secondary: AppColors.accentPink,
              surface: AppColors.background,
            ),
            scaffoldBackgroundColor: AppColors.background,
            textTheme: GoogleFonts.poppinsTextTheme(),
            useMaterial3: true,
            cardTheme: CardThemeData(
              elevation: 2,
              shadowColor: AppColors.primaryBlue.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
          home: _authProvider.isLoggedIn
              ? const MainShell()
              : const LoginScreen(),
        ),
      ),
    );
  }
}
