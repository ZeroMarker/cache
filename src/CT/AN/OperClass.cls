/// 手术分级
Class CT.AN.OperClass Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperClass ]
{

/// 手术分级代码
Property Code As %String(MAXLEN = 10) [ Required, SqlColumnNumber = 2 ];

/// 手术分级名称
Property Description As %String(MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 手术分级说明
Property Note As %String(MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 5 ];

/// 激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 6 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 手术分级对应的数值
Property ClassNum As %String [ SqlColumnNumber = 8 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9 ];

/// Code唯一索引
Index ICode On Code [ Unique ];

/// 外部系统ID索引
Index IExt On ExternalID;

/// 激活标志索引
Index IActive On Active;

Storage Default
{
<Data name="OperClassDefaultData">
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
<Value>ActiveDate</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>ClassNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperClassD</DataLocation>
<DefaultData>OperClassDefaultData</DefaultData>
<IdLocation>^CT.AN.OperClassD</IdLocation>
<IndexLocation>^CT.AN.OperClassI</IndexLocation>
<StreamLocation>^CT.AN.OperClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
