// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'model.dart';
import 'dart:async';

abstract class Store<T extends Model> extends Listenable {
  int _storeSyncVersion = 0;
  int _microTastSyncVersion = 0;
  int _suspendEventCount = 0;
  int _transactionCount = 0;

  List<VoidCallback> _listeners = List<VoidCallback>();

  void addListener(VoidCallback listener) {
    if (null != listener && this._listeners.contains(listener) == false) {
      this._listeners.add(listener);
      _notifyListeners();
    }
  }

  void removeListener(VoidCallback listener) {
    if (null != listener) {
      this._listeners.remove(listener);
    }
  }

  void beginTransaction() {
    ++_transactionCount;
  }

  void endTransaction() {
    --_transactionCount;
    if (_transactionCount < 0) {
      _transactionCount = 0;
    }
  }

  Future commit() async {
    if (_transactionCount > 0) {
      return;
    }
    _performSave();
  }

  void suspendEvents() {
    ++this._suspendEventCount;
  }

  void resumeEvents() {
    --this._suspendEventCount;
    if (this._suspendEventCount > 0) {
      _notifyListeners();
    }
  }

  Future _performSave() async {
    if (this._transactionCount == 0) {
      await save();
      return 1;
    } else {
      return 0;
    }
  }

  @mustCallSuper
  Future<int> add(T record) async {
    return await _performSave();
  }

  @mustCallSuper
  Future<int> remove(T record) async {
    return await _performSave();
  }

  @mustCallSuper
  Future removeAll() async {
    await _performSave();
  }

  Future<List<T>> load();

  @mustCallSuper
  Future<int> update(T record) async {
    return await _performSave();
  }

  Future<int> indexOf(T model);

  @protected
  @mustCallSuper
  Future save() {
    _notifyListeners();
    return null;
  }

  void _notifyListeners() {
    if (_storeSyncVersion == _microTastSyncVersion) {
      _storeSyncVersion++;
      scheduleMicrotask(() {
        this._listeners.forEach((listener) => listener());
        _microTastSyncVersion++;
      });
    }
  }

  int get count;
  bool get isLoaded;
}
