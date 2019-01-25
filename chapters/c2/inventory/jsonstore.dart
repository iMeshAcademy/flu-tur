// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:fluttur/inventory/model.dart';
import "package:flutter/material.dart";
import 'package:fluttur/inventory/storage/filestorage.dart';
import 'package:mutex/mutex.dart';
import 'package:fluttur/inventory/store.dart';
import 'package:fluttur/inventory/modelfactory.dart';

// TODO - At present support only single store for a single model.
// TODO - Need to implement support for different models in the store.

class JsonStore<T extends Model> extends Store<T> {
  List<T> _records = List<T>();

  final Mutex _m = new Mutex();
  final String modelName;

  final FileStorage storage;
  bool _initialized = false;

  JsonStore({@required this.storage, @required this.modelName}) {
    load().then((onValue) {
      debugPrint("Store information loaded.");
    }); // Loading file.
  }

  @override
  Future add(T model) async {
    if (model.modelName != this.modelName) {
      throw new Exception("Model doesn't match whle adding!");
    }
    int count = _records.length;
    _records.add(model);
    // Update the id field.
    model.key = "${model.modelName}__id__$count";
    await super.add(model);
  }

  @override
  Future remove(T model) async {
    if (model.modelName != this.modelName) {
      throw new Exception("Model doesn't match whle adding!");
    }

    _records.remove(model);
    await super.remove(model);
  }

  @override
  Future removeAll() async {
    _records.clear();
    await super.removeAll();
  }

  @override
  Future save() async {
    try {
      await _m.acquire();
      // Convert list to json encoded string.

      String toWrite = JsonEncoder().convert({
        "${this.modelName}":
            this._records.map((record) => record.toJson()).toList()
      });

      await storage.write(toWrite);
    } finally {
      _m.release();
      notifyListeners();
    }
  }

  @override
  Future<List<T>> load() async {
    if (_initialized) return this._records;

    try {
      await _m.acquire();

      final content = await storage.read();
      final jsonData = JsonDecoder().convert(content);
      final List<T> models = (jsonData[this.modelName])
          .map<T>((model) => ModelFactory.createModel(this.modelName, model))
          .toList();
      this._records = models;
    } catch (e) {
      debugPrint(e);
    } finally {
      this._initialized = true;
      _m.release();
    }

    return this._records;
  }

  @override
  Future<int> indexOf(T model) async {
    return this._records.indexWhere((item) {
      return item.key == model.key;
    }, 0);
  }

  @override
  Future update(T model) async {
    this.indexOf(model).then((index) async {
      if (index >= 0) {
        this._records.replaceRange(index, index + 1, [model]);
        await super.update(model);
      }
    });
  }

  @override
  int get count => this._records.length;

  @override
  bool get isLoaded => this._initialized;
}
