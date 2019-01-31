// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'storage.dart';

class FileStorage extends Storage<String> {
  final String fileName;
  final Future<Directory> Function() getDocumentDirectory;

  FileStorage(this.fileName, this.getDocumentDirectory);

  Future<File> _getFile() async {
    final Directory directory = await getDocumentDirectory();
    File file = new File('${directory.path}/$fileName');
    return file;
  }

  @override
  Future<String> load() async {
    File file = await _getFile();
    return await file.readAsString();
  }

  @override
  void save(dynamic data) async {
    File f = await _getFile();
    await f.writeAsString(data);
    notifyEvents("onsave");
  }

  void remove() async {
    File f = await _getFile();
    f.delete();
  }
}
