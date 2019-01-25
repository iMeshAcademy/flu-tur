// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

/**
 *  FileStorage will act as a utility class to perform file operations on device.
 * Following file operations are supported now.
 * Read - Read content from file.
 * Write - Write content to file.
 * Create - Create file
 * remove - Remove file from the directory path associated.
 * 
 * Directory path for iOS and Andoid are different. 
 * So, we need to provide correct directory path in order to load or save files to the private path in application.
 * 
 * 
*/

class FileStorage {
  final String fileName;
  final Future<Directory> Function() getDocumentDirectory;

  const FileStorage(this.fileName, this.getDocumentDirectory);

  // Open file using the file path and file name provided.
  Future<File> _getFile() async {
    final Directory directory = await getDocumentDirectory();
    File file = new File('${directory.path}/$fileName');
    return file;
  }

  ///
  ///Read file content.
  Future<String> read() async {
    // Get the file from location.
    File f = await this._getFile();

    // We might need to check the sync/async performance. For better UX, an async load is recommended.
    String content = await f.readAsString();
    return content;
  }

  Future write(String content) async {
    File f = await this._getFile();
    await f.writeAsString(content);
  }

  Future<FileSystemEntity> remove() async {
    File f = await this._getFile();
    return f.delete();
  }
}
