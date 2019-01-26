// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

abstract class AbstractFileStorage {
  const AbstractFileStorage();

  Future<String> read();
  Future write(String content);
}
