/// 手术体位
Class CT.AN.OperPosition Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperPosition ]
{

/// 手术体位代码
Property Code As %String(MAXLEN = 10) [ Required, SqlColumnNumber = 2 ];

/// 手术体位名称
Property Description As %String(MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 手术体位说明
Property Note As %String(MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 5 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6 ];

/// 排序号
Property SeqNo As %Integer [ SqlColumnNumber = 7 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 9 ];

/// Code唯一索引
Index ICode On Code [ Unique ];

Index IExt On ExternalID;

Storage Default
{
<Data name="OperPositionDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Note</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>SeqNo</Value>
</Value>
<Value name="7">
<Value>ActiveDate</Value>
</Value>
<Value name="8">
<Value>ExpireDate</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperPositionD</DataLocation>
<DefaultData>OperPositionDefaultData</DefaultData>
<IdLocation>^CT.AN.OperPositionD</IdLocation>
<IndexLocation>^CT.AN.OperPositionI</IndexLocation>
<StreamLocation>^CT.AN.OperPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
