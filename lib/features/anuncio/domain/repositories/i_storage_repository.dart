import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class IStorageRepository {
  Future<Either<IFailure, List<String>>> uploadImagens({
    required String idAnuncio,
    required List<File> imagens,
  });
  Future<Either<IFailure, void>> removerImagens(String idAnuncio);
}
