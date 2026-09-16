import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/library_mark.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _continueToApp();
  }

  Future<void> _continueToApp() async {
    final results = await Future.wait([
      ref.read(authProvider.future),
      ref.read(secureStorageServiceProvider).hasCompletedOnboarding(),
    ]);

    if (!mounted) {
      return;
    }

    _navigationTimer = Timer(const Duration(milliseconds: 1100), () {
      if (!mounted) {
        return;
      }

      final authState = results[0] as AuthState;
      final hasCompletedOnboarding = results[1] as bool;

      if (authState.isLoggedIn) {
        context.go(
          authState.role == UserRole.member ? '/home' : '/unsupported',
        );
        return;
      }

      context.go(hasCompletedOnboarding ? '/login' : '/onboarding');
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LibraryMark(size: 92, inverted: true),
              SizedBox(height: 24),
              Text(
                'BlueShelf',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your library, always within reach',
                style: TextStyle(color: Color(0xFFDCEAFF), fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
