// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:fluttur/inventory/inventorymodel.dart';
import 'package:fluttur/inventory/units.dart';

class AddEditInventory extends StatefulWidget {
  final InventoryModel model;

  AddEditInventory(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AddInventoryState(model);
  }
}

class _AddInventoryState extends State<AddEditInventory> {
  String _inventoryName = '';
  String _currentQuantity = '';
  String _requiredQuantity = '';
  String _unitValue = '';
  String _recurrenceValue = '';
  String _itemCostPerUnit = '';

  final InventoryModel model;
  final bool bIsEditing;

  double _borderWidth = 0.2;

  _AddInventoryState(this.model) : bIsEditing = model != null {
    if (this.model != null) {
      _inventoryName = this.model.itemName;
      _currentQuantity = this.model.currentQuantity.toString();
      _requiredQuantity = this.model.requiredQuantity.toString();
      _unitValue = this.model.unit.toString();
      _recurrenceValue = this.model.recurrence.toString();
      _itemCostPerUnit = this.model.costPerUnit.toString();
    } else {
      _inventoryName = '';
      _currentQuantity = '0.0';
      _requiredQuantity = '0.0';
      _unitValue = Unit.Grams.toString();
      _recurrenceValue = Recurrence.Daily.toString();
      _itemCostPerUnit = '0.0';
    }
  }

  static final _key = GlobalKey<FormState>();

  String _numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null || n <= 0.0) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  Widget _createFormTextField(
      String key,
      String intialValue,
      String title,
      String hintText,
      bool autoFocus,
      bool autoValidate,
      TextStyle style,
      TextInputType inputType,
      FormFieldValidator<String> validator,
      FormFieldSetter<String> setter) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey[300],
              style: BorderStyle.solid,
              width: _borderWidth),
        ),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        key: Key("column_$key"),
        children: <Widget>[
          Text(title),
          TextFormField(
            initialValue: intialValue,
            key: Key(key),
            autofocus: autoFocus,
            style: style,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            validator: validator,
            autovalidate: autoValidate,
            onSaved: setter,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  String _inventoryNameValidator(String name) {
    return name.trim().isEmpty ? "Please enter a valid item name" : null;
  }

  DropdownMenuItem<String> _createDropDownMenuItem(
      String key, String value, String text) {
    return DropdownMenuItem<String>(
        key: Key(key), value: value, child: Text(text));
  }

  Widget _constructDropdownButtonFormField(
      String key,
      String title,
      String value,
      List<DropdownMenuItem<String>> children,
      ValueChanged<String> onValueChanged,
      FormFieldValidator<String> validator,
      FormFieldSetter<String> onSaved) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey[300],
              style: BorderStyle.solid,
              width: _borderWidth),
        ),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Text(title),
          DropdownButtonFormField(
            key: Key(key),
            items: children,
            value: value,
            onChanged: onValueChanged,
            validator: validator,
            onSaved: onSaved,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget _createUnitDropdownButtonFormField() {
    List<DropdownMenuItem<String>> children = List<DropdownMenuItem<String>>();

    Unit.values.forEach((val) {
      switch (val) {
        case Unit.Grams:
          children
              .add(_createDropDownMenuItem("grams", val.toString(), "Grams"));
          break;
        case Unit.KiloGram:
          children.add(
              _createDropDownMenuItem("kilogram", val.toString(), "Kilogram"));
          break;
        case Unit.Liter:
          children
              .add(_createDropDownMenuItem("liter", val.toString(), "Liter"));
          break;
        case Unit.Pounds:
          children
              .add(_createDropDownMenuItem("pounds", val.toString(), "Pound"));
          break;
        case Unit.Units:
          children
              .add(_createDropDownMenuItem("units", val.toString(), "Unit"));
          break;
        case Unit.Invalid:
          break;
      }
    });

    _unitValue = _unitValue.trim().isEmpty == false ? _unitValue : "Unit.Grams";

    String onValueChanged(String value) {
      setState(() {
        this._unitValue = value;
      });

      return value;
    }

    String onValidateChange(String value) {
      return null;
    }

    void onValueSaved(String value) {}

    return _constructDropdownButtonFormField("unit", "Quantity in : ",
        _unitValue, children, onValueChanged, onValidateChange, onValueSaved);
  }

  Widget _createRecurrenceDropdownButtonFormField() {
    List<DropdownMenuItem<String>> children = List<DropdownMenuItem<String>>();

    Recurrence.values.forEach((val) {
      switch (val) {
        case Recurrence.Daily:
          children
              .add(_createDropDownMenuItem("daily", val.toString(), "Daily"));
          break;
        case Recurrence.Weekly:
          children
              .add(_createDropDownMenuItem("weekly", val.toString(), "Weekly"));
          break;
        case Recurrence.BiWeekly:
          children.add(
              _createDropDownMenuItem("biweekly", val.toString(), "Biweekly"));
          break;
        case Recurrence.Monthly:
          children.add(
              _createDropDownMenuItem("monthly", val.toString(), "Monthly"));
          break;
        case Recurrence.Invalid:
          break;
      }
    });

    String onValueChanged(String value) {
      setState(() {
        this._recurrenceValue = value;
      });

      return value;
    }

    String onValidateChange(String value) {
      return null;
    }

    void onValueSaved(String value) {}

    _recurrenceValue = _recurrenceValue.trim().isEmpty == false
        ? _recurrenceValue
        : "Recurrence.Daily";

    return _constructDropdownButtonFormField(
        "Recurrence",
        "How often you want to stock this item?",
        _recurrenceValue,
        children,
        onValueChanged,
        onValidateChange,
        onValueSaved);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            this.bIsEditing
                ? "Edit Inventory"
                : "Add to Inventory", // TODO - Include localization.
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
              key: _key,
              autovalidate: false,
              onWillPop: () {
                return Future(() => true);
              },
              child: ListView(
                children: [
                  _createFormTextField(
                      "inventoryItemName",
                      this._inventoryName,
                      '',
                      false == this.bIsEditing
                          ? "New Inventory Item"
                          : "Provide a new name for this item",
                      true,
                      false,
                      textTheme.headline,
                      TextInputType.text,
                      _inventoryNameValidator,
                      (name) => _inventoryName = name),
                  SizedBox(
                    child: Container(),
                    height: 16.0,
                  ),
                  _createFormTextField(
                      "requiredQuantity",
                      null != widget.model ? _requiredQuantity : '0.0',
                      "How much quantity you need?",
                      "Enter total stock needed",
                      false,
                      false,
                      textTheme.subhead,
                      TextInputType.number,
                      _numberValidator,
                      (val) => _requiredQuantity = val),
                  SizedBox(
                    child: Container(),
                    height: 16.0,
                  ),
                  _createFormTextField(
                      "currentQuantity",
                      _currentQuantity,
                      "How much is left?",
                      "Enter current stock.",
                      false,
                      false,
                      textTheme.subhead,
                      TextInputType.number,
                      _numberValidator,
                      (val) => _currentQuantity = val),
                  SizedBox(
                    child: Container(),
                    height: 16.0,
                  ),
                  _createUnitDropdownButtonFormField(),
                  SizedBox(
                    child: Container(),
                    height: 16.0,
                  ),
                  _createRecurrenceDropdownButtonFormField(),
                  SizedBox(
                    child: Container(),
                    height: 16.0,
                  ),
                  _createFormTextField(
                      "itemCostPerUnit",
                      _itemCostPerUnit,
                      "How much does it cost?",
                      "Enter the stock price per unit.",
                      false,
                      false,
                      textTheme.subhead,
                      TextInputType.number,
                      _numberValidator,
                      (val) => _itemCostPerUnit = val),
                ],
              )),
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              key: Key(this.bIsEditing ? "SaveInventory" : "SaveNewInventory"),
              child: Icon(this.bIsEditing ? Icons.check : Icons.add),
              onPressed: () async {
                final form = _key.currentState;
                if (form.validate()) {
                  form.save();

                  // Validate all entries and make sure that we can save it now.
                  InventoryModel im =
                      null == model ? new InventoryModel() : model;

                  im.itemName = _inventoryName;
                  im.recurrence = Recurrence.values.firstWhere(
                      (item) => _recurrenceValue.toString() == item.toString());
                  im.unit = Unit.values.firstWhere(
                      (item) => _unitValue.toString() == item.toString());
                  im.requiredQuantity = double.parse(_requiredQuantity);
                  im.currentQuantity = double.parse(_currentQuantity);
                  im.costPerUnit = double.parse(_itemCostPerUnit);
                  await im.save();
                  Navigator.pop(context);
                }
              },
            );
          },
        ));
  }
}
