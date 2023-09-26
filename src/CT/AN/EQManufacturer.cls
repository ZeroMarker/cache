/// 设备制造商
Class CT.AN.EQManufacturer Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EQManufacturer ]
{

/// 制造商代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 制造商名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 制造商说明
Property Note As %String [ SqlColumnNumber = 4 ];

/// 制造商代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="EQManufacturerDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^CT.AN.EQManufacturerD</DataLocation>
<DefaultData>EQManufacturerDefaultData</DefaultData>
<IdLocation>^CT.AN.EQManufacturerD</IdLocation>
<IndexLocation>^CT.AN.EQManufacturerI</IndexLocation>
<StreamLocation>^CT.AN.EQManufacturerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
