// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:meta/meta.dart';

typedef EventCallback(String event, Object context, Object data);

class IEvent {
  final String eventName;
  final Object context;
  final EventCallback callback;

  IEvent(this.eventName, this.context, this.callback);
}

class EventEmitter {
  int _storageSyncVersion = 0;
  int _microTastSyncVersion = 0;

  final List<String> _broadCastEvents = const ["update", "refresh"];

  Map<String, List<IEvent>> _listeners = Map<String, List<IEvent>>();

  void _broadCastAllEvents(String event, String data) {
    if (_storageSyncVersion == _microTastSyncVersion) {
      _storageSyncVersion++;
      scheduleMicrotask(() {
        this._listeners.forEach((str, val) {
          val.forEach((ev) {
            ev.callback(event?.trim()?.length == 0 ? "refresh" : event,
                ev.context, data);
          });
        });
        _microTastSyncVersion++;
      });
    }
  }

  bool contains(String event, EventCallback callback) {
    bool bContains = false;
    if (this._listeners.containsKey(event)) {
      this._listeners[event].forEach((ev) {
        if (ev.callback == callback) {
          bContains = true;
          return;
        }
      });
    }

    return bContains;
  }

  void addListener(String event, Object context, EventCallback listener) {
    if (null == listener) return;

    if (null == event || event.trim().length == 0) {
      event = _broadCastEvents[0];
    }

    if (this._listeners.containsKey(event)) {
      if (false == contains(event, listener)) {
        IEvent ev = new IEvent(event, context, listener);
        this._listeners[event].add(ev);
      }
    } else {
      IEvent ev = new IEvent(event, context, listener);
      // New listener
      this._listeners[event] = [ev];
    }
  }

  IEvent getEvent(String event, EventCallback callback) {
    IEvent iev;
    if (this._listeners.containsKey(event)) {
      this._listeners[event].forEach((ev) {
        if (ev.callback == callback) {
          iev = ev;
          return;
        }
      });
    }

    return iev;
  }

  void removeListener(String event, EventCallback listener) {
    if (null != listener) {
      if (null == event || event.trim().length == 0) {
        detachAllListeners(listener);
      } else {
        IEvent ev = getEvent(event, listener);
        if (null != ev) {
          this._listeners[event].remove(ev);
        }

        if (this._listeners[event].length == 0) {
          // Remove if no listeners in the list.
          this._listeners.remove(event);
        }
      }
    }
  }

  void detachAllListeners(EventCallback listener) {
    this._listeners.keys.forEach((str) {
      IEvent event = getEvent(str, listener);
      if (null != event) {
        this._listeners[str].remove(event);
      }
    });
  }

  @protected
  void notifyEvents([String event, Object data]) {
    if (event == null ||
        event.trim().length == 0 ||
        _broadCastEvents.contains(event)) {
      _broadCastAllEvents(event, data);
    } else {
      scheduleMicrotask(() {
        if (this._listeners.containsKey(event)) {
          this._listeners[event].forEach((ev) {
            ev.callback(event, ev.context, data);
          });
        }
      });
    }
  }

  void fireEvents(String event, Object data) {
    notifyEvents(event, data);
  }
}
