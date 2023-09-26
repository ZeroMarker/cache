/// 手术麻醉原因
Class CT.AN.Reason Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Reason ]
{

/// 手术麻醉原因代码
Property Code As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 2 ];

/// 手术麻醉原因描述
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 原因类型
Property ReasonType As %String(DISPLAYLIST = ",手术取消,手术拒绝,麻醉用药", VALUELIST = ",C,D,A") [ SqlColumnNumber = 4 ];

/// 原因代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="ReasonDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ReasonType</Value>
</Value>
</Data>
<DataLocation>^CT.AN.ReasonD</DataLocation>
<DefaultData>ReasonDefaultData</DefaultData>
<IdLocation>^CT.AN.ReasonD</IdLocation>
<IndexLocation>^CT.AN.ReasonI</IndexLocation>
<StreamLocation>^CT.AN.ReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
