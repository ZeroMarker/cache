/// 切口类型
Class CT.AN.BladeType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BladeType ]
{

/// 切口类型代码
Property Code As %String(MAXLEN = 10) [ Required, SqlColumnNumber = 2 ];

/// 切口类型名称
Property Description As %String(MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 切口类型说明
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
<Data name="BladeTypeDefaultData">
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
<DataLocation>^CT.AN.BladeTypeD</DataLocation>
<DefaultData>BladeTypeDefaultData</DefaultData>
<IdLocation>^CT.AN.BladeTypeD</IdLocation>
<IndexLocation>^CT.AN.BladeTypeI</IndexLocation>
<StreamLocation>^CT.AN.BladeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
