// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'storefactory.dart';

abstract class Model {
  final String modelName;

  String _id = '';

  @protected
  bool get isModified;

  Model({@required this.modelName});
  void save() async {
    if (isModified) {
      var store = StoreFactory().get(modelName);
      if (key.length > 0) {
        store.update(this);
      } else {
        store.add(this);
      }
    }
  }

  String get key => this._id;
  set key(String value) {
    if (this._id.trim().length > 0) {
      return;
    }

    this._id = value;
  }

  Map<String, Object> toJson();
}
