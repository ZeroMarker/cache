Class dbo.BTMixCollType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMix_CollType, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index PKBTMIXCOllTYPE On RowID [ PrimaryKey, SqlName = PK_BTMIX_COllTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTMixCollTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMixCollTypeD</DataLocation>
<DefaultData>BTMixCollTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTMixCollTypeD</IdLocation>
<IndexLocation>^dbo.BTMixCollTypeI</IndexLocation>
<StreamLocation>^dbo.BTMixCollTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
