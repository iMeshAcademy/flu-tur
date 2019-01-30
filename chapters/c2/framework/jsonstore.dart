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
  Future<int> add(T record) async {
    if (record.modelName != modelName) {
      throw new Exception("Model doesn't match whle adding!");
    }
    int count = _records.length;
    _records.add(record);
    // Update the id field.
    record.key = "${record.modelName}__id__$count";
    await super.add(record);

    return 1;
  }

  @override
  Future<List<T>> load() async {
    if (this.isLoaded) {
      return this._records;
    }
    try {
      await _m.acquire();

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

    return this._records;
  }

  @override
  Future<int> remove(T model) async {
    if (model.modelName != this.modelName) {
      throw new Exception("Model doesn't match whle adding!");
    }

    int removed = _records.remove(model) ? 1 : 0;
    await super.remove(model);
    return removed;
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

      await storage.save(toWrite);
    } finally {
      _m.release();
    }
    await super.save();
  }

  @override
  Future<int> indexOf(T model) async {
    return this._records.indexWhere((item) {
      return item.key == model.key;
    }, 0);
  }

  @override
  Future<int> update(T record) {
    return this.indexOf(record).then((index) async {
      if (index >= 0) {
        this._records.replaceRange(index, index + 1, [record]);
        await super.update(record);
        return 1;
      }
    });
  }

  @override
  Future removeAll() async {
    _records.clear();
    await super.removeAll();
  }

  @override
  int get count => this._records.length;

  @override
  bool get isLoaded => this._isInitialized;
}
