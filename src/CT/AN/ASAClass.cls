/// ASA分级
Class CT.AN.ASAClass Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ASAClass ]
{

/// ASA分级代码
Property Code As %String(MAXLEN = 10) [ Required, SqlColumnNumber = 2 ];

/// ASA分级名称
Property Description As %String(MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// ASA分级说明
Property Note As %String(MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 5 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 8 ];

/// Code唯一索引
Index ICode On Code [ Unique ];

Index IExt On ExternalID;

Storage Default
{
<Data name="ASAClassDefaultData">
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
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.ASAClassD</DataLocation>
<DefaultData>ASAClassDefaultData</DefaultData>
<IdLocation>^CT.AN.ASAClassD</IdLocation>
<IndexLocation>^CT.AN.ASAClassI</IndexLocation>
<StreamLocation>^CT.AN.ASAClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
