// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/reset_password_usecase.dart'
    as _i474;
import '../../features/auth/domain/usecases/send_otp_usecase.dart' as _i663;
import '../../features/auth/domain/usecases/send_reset_code_usecase.dart'
    as _i1069;
import '../../features/auth/domain/usecases/signup_usecase.dart' as _i57;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/calls/data/datasources/calls_remote_datasource.dart'
    as _i903;
import '../../features/calls/data/repositories/calls_repository_impl.dart'
    as _i722;
import '../../features/calls/domain/repositories/calls_repository.dart'
    as _i1032;
import '../../features/calls/domain/usecases/get_outbound_phone_numbers_usecase.dart'
    as _i398;
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart'
    as _i817;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/get_dashboard_metrics_usecase.dart'
    as _i512;
import '../../features/dashboard/domain/usecases/get_recent_activity_usecase.dart'
    as _i461;
import '../config/app_config.dart' as _i650;
import '../database/sync_engine.dart' as _i809;
import '../network/auth_event_bus.dart' as _i702;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/interceptors/logging_interceptor.dart' as _i344;
import '../network/interceptors/refresh_token_interceptor.dart' as _i322;
import '../network/network_info.dart' as _i932;
import '../storage/preferences_service.dart' as _i636;
import '../storage/secure_storage_service.dart' as _i666;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i650.AppConfig>(() => _i650.AppConfig());
    gh.lazySingleton<_i702.AuthEventBus>(() => _i702.AuthEventBus());
    gh.lazySingleton<_i344.LoggingInterceptor>(
      () => _i344.LoggingInterceptor(),
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageService(),
    );
    gh.lazySingleton<_i636.PreferencesService>(
      () => _i636.PreferencesService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl());
    gh.lazySingleton<_i322.RefreshTokenInterceptor>(
      () => _i322.RefreshTokenInterceptor(
        gh<_i666.SecureStorageService>(),
        gh<_i702.AuthEventBus>(),
      ),
    );
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(gh<_i666.SecureStorageService>()),
    );
    gh.lazySingleton<_i745.AuthInterceptor>(
      () => _i745.AuthInterceptor(gh<_i666.SecureStorageService>()),
    );
    gh.lazySingleton<_i809.SyncEngine>(
      () => _i809.SyncEngine(gh<_i932.NetworkInfo>()),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i932.NetworkInfo>(),
        gh<_i650.AppConfig>(),
        gh<_i745.AuthInterceptor>(),
        gh<_i322.RefreshTokenInterceptor>(),
        gh<_i344.LoggingInterceptor>(),
      ),
    );
    gh.lazySingleton<_i817.DashboardRemoteDataSource>(
      () => _i817.DashboardRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i665.DashboardRepository>(
      () =>
          _i509.DashboardRepositoryImpl(gh<_i817.DashboardRemoteDataSource>()),
    );
    gh.lazySingleton<_i903.CallsRemoteDataSource>(
      () => _i903.CallsRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i512.GetDashboardMetricsUseCase>(
      () => _i512.GetDashboardMetricsUseCase(gh<_i665.DashboardRepository>()),
    );
    gh.lazySingleton<_i461.GetRecentActivityUseCase>(
      () => _i461.GetRecentActivityUseCase(gh<_i665.DashboardRepository>()),
    );
    gh.lazySingleton<_i1032.CallsRepository>(
      () => _i722.CallsRepositoryImpl(gh<_i903.CallsRemoteDataSource>()),
    );
    gh.lazySingleton<_i398.GetOutboundPhoneNumbersUseCase>(
      () => _i398.GetOutboundPhoneNumbersUseCase(gh<_i1032.CallsRepository>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i17.GetCurrentUserUseCase>(
      () => _i17.GetCurrentUserUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i474.ResetPasswordUseCase>(
      () => _i474.ResetPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i663.SendOtpUseCase>(
      () => _i663.SendOtpUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1069.SendResetCodeUseCase>(
      () => _i1069.SendResetCodeUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i57.SignupUseCase>(
      () => _i57.SignupUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i503.VerifyOtpUseCase>(
      () => _i503.VerifyOtpUseCase(gh<_i787.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
