import 'package:chatott/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase({required this.authRepository});

  Future<void> call() async {
    try {
      await authRepository.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
