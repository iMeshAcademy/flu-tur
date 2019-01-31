// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'core/event_emitter.dart';
import 'model.dart';

abstract class Store<T extends Model> extends EventEmitter {
  int _suspendEventCount = 0;
  int _transactionCount = 0;

  void beginTransaction() {
    ++_transactionCount;
  }

  void endTransaction() {
    --_transactionCount;
    if (_transactionCount < 0) {
      _transactionCount = 0;
    }
  }

  void commit() async {
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
    if (this._suspendEventCount <= 0) {
      notifyEvents("refresh");
      this._suspendEventCount = 0;
    }
  }

  void _performSave() {
    if (this._transactionCount == 0) {
      save();
    }
  }

  @mustCallSuper
  int add(T record) {
    _performSave();
    return 1;
  }

  @mustCallSuper
  int remove(T record) {
    _performSave();
    return 1;
  }

  @mustCallSuper
  int removeAll() {
    _performSave();
    return 1;
  }

  Future<List<T>> load();

  @mustCallSuper
  int update(T record) {
    _performSave();
    return 1;
  }

  int indexOf(T model);

  @protected
  @mustCallSuper
  void save() {
    notifyEvents("onsave");
  }

  int get count;
  bool get isLoaded;
}
