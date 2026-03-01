import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_storage_repository.dart';
import '../datasources/storage_remote_datasource.dart';

class StorageRepositoryImpl implements IStorageRepository {
  final IStorageRemoteDataSource remoteDataSource;

  StorageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<IFailure, List<String>>> uploadImagens({
    required String idAnuncio,
    required List<File> imagens,
  }) async {
    try {
      final urls = await remoteDataSource.uploadImagens(idAnuncio: idAnuncio, imagens: imagens);
      return Right(urls);
    } on IFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, void>> removerImagens(String idAnuncio) async {
    try {
      await remoteDataSource.removerImagens(idAnuncio);
      return const Right(null);
    } on IFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
