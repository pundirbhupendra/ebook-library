import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../core/error/error_mapper.dart';
import '../core/network/dio_client.dart';
import '../core/services/file_service.dart';
import '../features/ebook/data/datasources/ebook_remote_datasource.dart';
import '../features/ebook/data/repositories/ebook_repository_impl.dart';
import '../features/ebook/domain/repositories/ebook_repository.dart';
import '../features/ebook/domain/usecases/delete_ebook.dart';
import '../features/ebook/domain/usecases/get_download_url.dart';
import '../features/ebook/domain/usecases/get_ebooks.dart';
import '../features/ebook/domain/usecases/search_ebooks.dart';
import '../features/ebook/domain/usecases/upload_ebook.dart';
import '../features/ebook/presentation/bloc/ebook_bloc.dart';
import '../flavor/app_flavor.dart';
import '../router/app_router.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<AppRouter>()) return;

  sl
    ..registerLazySingleton<AppFlavor>(() => AppFlavor.current)
    ..registerLazySingleton<Logger>(() => Logger())
    ..registerLazySingleton<ErrorMapper>(ErrorMapper.new)
    ..registerLazySingleton<DioClient>(() => DioClient(flavor: sl(), logger: sl()))
    ..registerLazySingleton<Dio>(() => sl<DioClient>().dio)
    ..registerLazySingleton<AppRouter>(AppRouter.new)
    ..registerLazySingleton<FileService>(FileService.new)
    ..registerLazySingleton<EbookRemoteDataSource>(() => EbookRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<EbookRepository>(() => EbookRepositoryImpl(remoteDataSource: sl(), errorMapper: sl()))
    ..registerLazySingleton<GetEbooks>(() => GetEbooks(sl()))
    ..registerLazySingleton<SearchEbooks>(() => SearchEbooks(sl()))
    ..registerLazySingleton<UploadEbook>(() => UploadEbook(sl()))
    ..registerLazySingleton<DeleteEbook>(() => DeleteEbook(sl()))
    ..registerLazySingleton<GetDownloadUrl>(() => GetDownloadUrl(sl()))
    ..registerLazySingleton<EbookBloc>(() => EbookBloc(getEbooks: sl(), searchEbooks: sl(), uploadEbook: sl(), deleteEbook: sl(), repository: sl()));
}
