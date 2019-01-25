// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fluttur/inventory/model.dart';
import 'package:fluttur/inventory/units.dart';

class InventoryModel extends Model {
  /// Fields in InventoryModel class.
  String _inventoryItem = "";
  Recurrence _recurrence = Recurrence.Daily;
  Unit _unit = Unit.Units;
  double _costPerUnit = 0.0;
  double _currentQuantity = 0.0;
  double _requiredQuantity = 0.0;
  bool _isModified = false;

  InventoryModel() : super(model: "InventoryModel");

  void parseJson(Map<String, Object> json) {
    // Following parameters are supposed to be there in the json.
    /// Name  - inventory name;
    /// Recurrence - The recurrance of the item.
    /// Unit - What is the unit of the item, kg, gram, unit or liter.
    /// Cost - Cost per unit.
    /// RequiredQuantity - Required quantity
    /// CurrentQuantity - Current quantity.
    ///
    ///
    if (null != json) {
      this.key = json.containsKey("__id__") ? json["__id__"] : "";
      this._inventoryItem = json["Name"];
      this._recurrence = getRecurrenceFromString(json["Recurrence"]);
      this._unit = getUnitFromString(json["Unit"]);
      this._costPerUnit = json["Cost"] as double;
      this._requiredQuantity = json["RequiredQuantity"] as double;
      this._currentQuantity = json["CurrentQuantity"] as double;
    }
  }

  @override
  Map<String, Object> toJson() {
    Map<String, Object> _json = {
      "__id__": key,
      "Name": this._inventoryItem,
      "Recurrence": this._recurrence.toString(),
      "Unit": this._unit.toString(),
      "Cost": this._costPerUnit,
      "RequiredQuantity": this._requiredQuantity,
      "CurrentQuantity": this._currentQuantity
    };
    return _json;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  int get hashCode =>
      super.hashCode ^
      _inventoryItem.hashCode ^
      _recurrence.hashCode ^
      _unit.hashCode ^
      _costPerUnit.hashCode ^
      _currentQuantity.hashCode ^
      _requiredQuantity.hashCode;

  @override
  operator ==(Object item) {
    return identical(this, item) ||
        (item is InventoryModel &&
            runtimeType == item.runtimeType &&
            _inventoryItem == item._inventoryItem &&
            _recurrence == item._recurrence &&
            _unit == item._unit &&
            _costPerUnit == item._costPerUnit &&
            _currentQuantity == item._currentQuantity &&
            _requiredQuantity == item._requiredQuantity);
  }

  String get itemName => this._inventoryItem;
  set itemName(String name) {
    this._inventoryItem = name;
    this._isModified = true;
  }

  Recurrence get recurrence => this._recurrence;
  set recurrence(Recurrence val) {
    if (this._recurrence != val) {
      this._recurrence = val;
      this._isModified = true;
    }
  }

  Unit get unit => this._unit;
  set unit(Unit val) {
    if (val != this._unit) {
      this._unit = val;
      this._isModified = true;
    }
  }

  double get costPerUnit => this._costPerUnit;
  set costPerUnit(double val) {
    if (val < 0.0) {
      throw new Exception("Cost per unit value can't be less than 0.0");
    }

    this._costPerUnit = val;
    this._isModified = true;
  }

  double get currentQuantity => this._currentQuantity;
  set currentQuantity(double val) {
    if (val < 0.0) {
      throw new Exception("Current quantity can't be less than 0.0");
    }

    this._currentQuantity = val;
    this._isModified = true;
  }

  double get requiredQuantity => this._requiredQuantity;
  set requiredQuantity(double val) {
    if (val < 0.0) {
      throw new Exception("Required quantity can't be less than 0.0");
    }

    this._requiredQuantity = val;
    this._isModified = true;
  }

  void updateQuantity(int quantity) {
    double qtp = 0.0; // Quantity to update.

    // Adjust quantity based on the current model data.
    // If unit is in grams, change in 100 grams interval.
    // if unit is in kg - change by 500 gram steps.
    // if unit is in liter - change by 500 ml steps.
    // if unit is in unit, change by 1 unit steps.

    switch (unit) {
      case Unit.Grams:
        qtp = 100.0 * quantity;
        break;
      case Unit.KiloGram:
      case Unit.Pounds:
      case Unit.Liter:
        qtp = .500 * quantity;
        break;

      case Unit.Units:
        qtp = 1.0 * quantity;
        break;
      case Unit.Invalid:
        break;
    }

    if (this.currentQuantity + qtp >= 0.0) {
      this.currentQuantity = this.currentQuantity + qtp;
    }
  }

  @override
  bool get isModified => this._isModified || key.length == 0;
}
