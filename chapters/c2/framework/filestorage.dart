// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'storage.dart';

import 'package:mvc/framework/core/profiler.dart';
import 'package:mvc/framework/core/profiler_data.dart';

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
    //Profiler.instance
    //     .add(new ProfilerData("FileStorage", "Before Save", DateTime.now()));
    File f = await _getFile();
    await f.writeAsString(data);
    // Profiler.instance
    //     .add(new ProfilerData("FileStorage", "After Save", DateTime.now()));

    notifyEvents("onsave");
  }

  void remove() async {
    File f = await _getFile();
    f.delete();
  }
}
