// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file. 

enum Recurrence { Daily, Weekly, BiWeekly, Monthly, Invalid }

enum Unit { Grams, KiloGram, Liter, Units, Pounds, Invalid }

Recurrence getRecurrenceFromString(String reccurance) {
  for (Recurrence rec in Recurrence.values) {
    if (rec.toString() == reccurance) {
      return rec;
    }
  }
  return Recurrence.Invalid;
}

Unit getUnitFromString(String unit) {
  for (Unit un in Unit.values) {
    if (un.toString() == unit) {
      return un;
    }
  }

  return Unit.Invalid;
}
