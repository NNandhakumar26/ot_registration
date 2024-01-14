import 'package:get_it/get_it.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

final getIt = GetIt.instance;

// Register dependencies
Future<void> intializeSingletons() async {
  await getIt.registerSingleton<UserRepo>(UserRepo());
}
