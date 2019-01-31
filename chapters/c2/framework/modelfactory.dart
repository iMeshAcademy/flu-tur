// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'model.dart';

/// Create model using model information and Json instance provided.

typedef Model CreateModelFunction(
  Map<String, Object> param,
);

class ModelFactory {
  static ModelFactory _factory = new ModelFactory._();

  Map<String, CreateModelFunction> _modelGenerator =
      new Map<String, CreateModelFunction>();

  ModelFactory._();
  static ModelFactory get instance => _factory;

  void attach(String modelName, CreateModelFunction function) {
    this._modelGenerator[modelName] = function;
  }

  void detach(String modelName) {
    this._modelGenerator.remove(modelName);
  }

  Model createModel(String modelName, Map<String, Object> configs) {
    return this._modelGenerator[modelName](configs) ?? null;
  }
}
