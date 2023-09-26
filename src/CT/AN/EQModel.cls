/// 设备型号
Class CT.AN.EQModel Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EQModel ]
{

/// 型号代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 型号名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 制造商
Property Manufacturer As CT.AN.EQManufacturer [ Required, SqlColumnNumber = 4 ];

/// 说明文档路径
Property DocUrl As %String [ SqlColumnNumber = 5 ];

/// 类型
Property EQType As CT.AN.EQType [ SqlColumnNumber = 6 ];

/// 制造商索引
Index IMFR On Manufacturer;

/// 型号代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="EQModelDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Manufacturer</Value>
</Value>
<Value name="4">
<Value>DocUrl</Value>
</Value>
<Value name="5">
<Value>EQType</Value>
</Value>
</Data>
<DataLocation>^CT.AN.EQModelD</DataLocation>
<DefaultData>EQModelDefaultData</DefaultData>
<IdLocation>^CT.AN.EQModelD</IdLocation>
<IndexLocation>^CT.AN.EQModelI</IndexLocation>
<StreamLocation>^CT.AN.EQModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
