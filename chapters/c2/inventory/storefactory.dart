// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fluttur/inventory/store.dart';

class StoreFactory {
  static final StoreFactory _instance = new StoreFactory._internal();

  // Stores are created for individual models.
  // These store names are pulled from config.
  // First item in the store entry is the model name,
  // for which store needed to be created.
  Map<String, Store> _stores = Map<String, Store>();

  factory StoreFactory() {
    return _instance;
  }

  StoreFactory._internal();

  void attach(String modelName, Store store) {
    if (_stores.containsKey(modelName)) {
      throw new Exception("A store is already associated with $modelName");
    }
    _stores[modelName] = store;
  }

  void detach(String modelName) {
    this._stores.remove(modelName);
  }

  void clear() {
    this._stores.clear();
  }

  // Get the store using the model name.
  // This is very easy to support multiple models.
  Store get(String modelName) =>
      this._stores.containsKey(modelName) ? this._stores[modelName] : null;
}
