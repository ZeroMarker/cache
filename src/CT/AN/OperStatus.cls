/// 手术状态
Class CT.AN.OperStatus Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperStatus ]
{

/// 手术状态代码
Property Code As %String(MAXLEN = 20) [ Required, SqlColumnNumber = 2 ];

/// 手术状态名称
Property Description As %String(MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 手术状态默认背景颜色
Property BGColor As %String [ SqlColumnNumber = 4 ];

/// 手术状态代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="OperStatusDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>BGColor</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperStatusD</DataLocation>
<DefaultData>OperStatusDefaultData</DefaultData>
<IdLocation>^CT.AN.OperStatusD</IdLocation>
<IndexLocation>^CT.AN.OperStatusI</IndexLocation>
<StreamLocation>^CT.AN.OperStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
