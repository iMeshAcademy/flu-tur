// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:eventify/eventify.dart';

abstract class Storage<T> extends EventEmitter {
  void save(T);
  Future<T> load();
}
