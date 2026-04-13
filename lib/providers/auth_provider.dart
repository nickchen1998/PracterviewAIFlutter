import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthState {
  final bool isLoggedIn;
  final bool hasCompletedOnboarding;

  const AuthState({
    this.isLoggedIn = false,
    this.hasCompletedOnboarding = false,
  });

  AuthState copyWith({bool? isLoggedIn, bool? hasCompletedOnboarding}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void login() {
    state = state.copyWith(isLoggedIn: true, hasCompletedOnboarding: true);
  }

  void loginNewUser() {
    state = state.copyWith(isLoggedIn: true, hasCompletedOnboarding: false);
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  void logout() {
    state = const AuthState();
  }
}
