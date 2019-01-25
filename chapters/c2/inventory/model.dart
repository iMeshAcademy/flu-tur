// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:fluttur/inventory/storefactory.dart';

abstract class Model {
  @protected
  final String model;
  @protected
  String id = '';

  @protected
  bool get isModified;

  Model({@required this.model});

  String get modelName => model;

  // Abstract function to convert the string to json.
  Map<String, Object> toJson();

  String get key => this.id;

  set key(String value) => this.id = value;

  Future save() async {
    if (isModified) {
      var store = StoreFactory().get(modelName);
      if (key.length > 0) {
        await store.update(this);
      } else {
        await store.add(this);
      }
    }
  }
}
