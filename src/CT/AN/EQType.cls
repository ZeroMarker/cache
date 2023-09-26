/// 设备类型
Class CT.AN.EQType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EQType ]
{

/// 设备类型代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 设备类型名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 设备类型
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="EQTypeDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CT.AN.EQTypeD</DataLocation>
<DefaultData>EQTypeDefaultData</DefaultData>
<IdLocation>^CT.AN.EQTypeD</IdLocation>
<IndexLocation>^CT.AN.EQTypeI</IndexLocation>
<StreamLocation>^CT.AN.EQTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
