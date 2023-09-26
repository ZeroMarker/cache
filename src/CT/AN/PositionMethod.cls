/// 定位方法
Class CT.AN.PositionMethod Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PositionMethod ]
{

/// 定位方法代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 定位方法名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 定位方法代码唯一索引
Index ICode On Code;

Storage Default
{
<Data name="PositionMethodDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CT.AN.PositionMethodD</DataLocation>
<DefaultData>PositionMethodDefaultData</DefaultData>
<IdLocation>^CT.AN.PositionMethodD</IdLocation>
<IndexLocation>^CT.AN.PositionMethodI</IndexLocation>
<StreamLocation>^CT.AN.PositionMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
