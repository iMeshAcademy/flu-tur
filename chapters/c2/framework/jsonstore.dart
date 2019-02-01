// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'store.dart';
import 'model.dart';
import 'package:mutex/mutex.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'modelfactory.dart';
import 'storage.dart';

class JsonStore<T extends Model> extends Store<T> {
  List<T> _records = List<T>();
  final Mutex _m = new Mutex();
  bool _isInitialized = false;

  final String modelName;
  final Storage storage;

  JsonStore({this.modelName, this.storage}) {
    this.load().then((onValue) {
      debugPrint("Store loaded!");
    });
  }

  @override
  int add(T record) {
    if (record.modelName != modelName) {
      throw new Exception("Model doesn't match whle adding!");
    }
    int count = _records.length;
    _records.add(record);
    // Update the id field.
    record.key = "${record.modelName}__id__$count";
    return super.add(record);
  }

  @override
  Future<List<T>> load() async {
    if (this.isLoaded) {
      return Future.value(this._records);
    }
    try {
      await _m.acquire();
      if (this.isLoaded) {
        return Future.value(this._records);
      }

      final content = await storage.load();

      final jsonData = JsonDecoder().convert(content);
      final List<T> models = (jsonData[this.modelName])
          .map<T>((model) =>
              ModelFactory.instance.createModel(this.modelName, model))
          .toList();
      this._records = models;
    } catch (e) {
      debugPrint("Exception while loading store ${e.toString()}");
    } finally {
      this._isInitialized = true;
      _m.release();
    }

    emit("onload", this, this._records);
    return Future.value(this._records);
  }

  @override
  int remove(T model) {
    if (model.modelName != this.modelName) {
      throw new Exception("Model doesn't match whle adding!");
    }

    _records.remove(model);
    return super.remove(model);
  }

  @override
  void save() async {
    try {
      await _m.acquire();
      // Convert list to json encoded string.

      String toWrite = JsonEncoder().convert({
        "${this.modelName}":
            this._records.map((record) => record.toJson()).toList()
      });

      storage.save(toWrite);
    } finally {
      _m.release();
    }
    super.save();
  }

  @override
  int indexOf(T model) {
    return this._records.indexWhere((item) {
      return item.key == model.key;
    }, 0);
  }

  @override
  int update(T record) {
    int index = this.indexOf(record);
    if (index >= 0) {
      this._records.replaceRange(index, index + 1, [record]);
      return super.update(record);
    }
    return 0;
  }

  @override
  int removeAll() {
    _records.clear();
    return super.removeAll();
  }

  @override
  int get count => this._records.length;

  @override
  bool get isLoaded => this._isInitialized;
}
