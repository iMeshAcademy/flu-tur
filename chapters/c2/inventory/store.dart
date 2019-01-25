// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';

/**
 * Flutter - C2-P1 : Home inventory application ( Scaffold, Navigator, Routes, Tab bar, Pages, Forms, Drawer, Floating Action Button  )
 * 
 *  Base Store for the inventory application.
 *  This shall implement basic CRUD operations and notify user when there is a change in the store.
 *  Store also support saving to the local file system or saving to webclient, if supported.
 *  Store is an abstract class.
 */

import "model.dart";

abstract class Store<T extends Model> extends Listenable {
  // Set of listeners for store changes.
  final Set<VoidCallback> _listeners = Set<VoidCallback>();

  int _storeSyncVersion = 0;
  int _microTastSyncVersion = 0;
  int _suspendEventCount = 0;
  int _transactionCount = 0;
  bool _isDirty = false;

  void beginTransaction() {
    ++_transactionCount;
  }

  void endTransaction() {
    --_transactionCount;
    if(_transactionCount < 0){
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
    ++ this._suspendEventCount;
  }

  void resumeEvents() {
    --this._suspendEventCount;
    if(this._suspendEventCount > 0 ){
    notifyListeners();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (false == this._listeners.contains(listener)) {
      this._listeners.add(listener);
      notifyListeners();
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (this._listeners.contains(listener)) {
      this._listeners.remove(listener);
    }
  }

  Future _performSave() async {
    if (this._transactionCount == 0 && isDirty) {
      await save();
      _isDirty = false;
    }
  }

  @mustCallSuper
  Future add(T model) async {
    _isDirty = true;
    await _performSave();
  }

  @mustCallSuper
  Future remove(T model) async {
    _isDirty = true;
    await _performSave();
  }

  @mustCallSuper
  Future removeAll() async {
    _isDirty = true;
    await _performSave();
  }

  @mustCallSuper
  Future update(T model) async {
    _isDirty = true;
    await _performSave();
  }

  Future<int> indexOf(T model);

  @protected
  void notifyListeners() {
    if (this._suspendEventCount > 0 ) {
      return;
    }
// Fire this callback only after some time.

    // Need to have some versionig for this as there is a chance that
    // application could trigger another sync while the UI is still building
    // which could cause performance issues.
    if (_storeSyncVersion == _microTastSyncVersion) {
      _storeSyncVersion++;
      scheduleMicrotask(() {
        this._listeners.forEach(
            (VoidCallback listener) => listener()); // Invoke each listeners.

        _microTastSyncVersion++;
      });
    }
  }

  Future<List<T>> load();

  @protected
  Future save();

  @protected
  bool get isDirty => this._isDirty;

  bool get isLoaded;


  int get count;
}
