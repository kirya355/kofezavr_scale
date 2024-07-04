import 'dart:async';

import 'package:kofezavr_scale/src/feature/scale/model/scale_data.dart';

abstract interface class ScaleRepository {
  Future<void> scan();
  Future<void> connect();

  Future<void> dose();
  Future<void> tare();
  Future<void> startListening();
  Future<void> endListening();

  Stream<ScaleData> scaleDataStream();
}

final class ScaleRepositoryImpl implements ScaleRepository {
  final StreamController<ScaleData> _scaleDataStreamController = StreamController.broadcast();

  @override
  Stream<ScaleData> scaleDataStream() => _scaleDataStreamController.stream;

  @override
  Future<void> scan() {
    // TODO: implement scan
    throw UnimplementedError();
  }

  @override
  Future<void> connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> dose() {
    // TODO: implement dose
    throw UnimplementedError();
  }

  @override
  Future<void> tare() {
    // TODO: implement tare
    throw UnimplementedError();
  }

  @override
  Future<void> startListening() {
    // TODO: implement startListening
    throw UnimplementedError();
  }

  @override
  Future<void> endListening() {
    // TODO: implement endListening
    throw UnimplementedError();
  }
}
