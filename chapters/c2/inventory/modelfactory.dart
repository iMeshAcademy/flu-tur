// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fluttur/inventory/model.dart';
import 'package:fluttur/inventory/inventorymodel.dart';

/// Create model using model information and Json instance provided.

class ModelFactory {
  static Model createModel(String model, Map<String, Object> json) {
    Model m;

    switch (model) {
      case "InventoryModel":
        m = new InventoryModel();
        (m as InventoryModel).parseJson(json);
        break;
    }

    return m;
  }
}
