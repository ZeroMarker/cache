Class CHSSWeb.Barcode.PersonBarcodeObj Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 姓名
Property PersonName As %String(TRUNCATE = 1);

/// 性别
Property SexName As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 名称
Property BarcodeTypeName As %String(TRUNCATE = 1);

/// 条形码
Property Barcode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PersonBarcodeObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Age</Value>
</Value>
<Value name="3">
<Value>Barcode</Value>
</Value>
<Value name="4">
<Value>BarcodeTypeName</Value>
</Value>
<Value name="5">
<Value>PersonName</Value>
</Value>
<Value name="6">
<Value>PersonRowId</Value>
</Value>
<Value name="7">
<Value>SexName</Value>
</Value>
<Value name="8">
<Value>PersonBarcode46List</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Bar52D.PersonBarcod642D</DataLocation>
<DefaultData>PersonBarcodeObjDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.Bar52D.PersonBarcod642D</IdLocation>
<IndexLocation>^CHSSWeb.Bar52D.PersonBarcod642I</IndexLocation>
<StreamLocation>^CHSSWeb.Bar52D.PersonBarcod642S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
