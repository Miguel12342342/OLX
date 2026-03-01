import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class IUseCase<Output, Input> {
  Future<Either<IFailure, Output>> call(Input params);
}

class NoParams {}
