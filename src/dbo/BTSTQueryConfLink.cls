Class dbo.BTSTQueryConfLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTST_QueryConfLink, StorageStrategy = Default ]
{

/// Foreign Key FKTATTestSetGroupLinkTestSet created via DDL
ForeignKey FKBTSTQueryConfLink(QueryConfDR) References dbo.BTSTQueryConf(PKBTSTQueryConf) [ SqlName = FK_BTSTQueryConfLink ];

Index IndexSequence On (QueryConfDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexMaster On (QueryConfDR, LinkType, LinkDataID) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSTQueryConfLink On RowID [ PrimaryKey, SqlName = PK_BTST_QueryConfLink, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 统计配置表DR
Property QueryConfDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 关联类型 1组合套 2检测项目 3工作小组
Property LinkType As %TinyInt [ Required, SqlColumnNumber = 4 ];

/// 关联类型数据主键
Property LinkDataID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTSTQueryConfLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryConfDR</Value>
</Value>
<Value name="3">
<Value>LinkType</Value>
</Value>
<Value name="4">
<Value>LinkDataID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSTQueryConfLinkD</DataLocation>
<DefaultData>BTSTQueryConfLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTSTQueryConfLinkD</IdLocation>
<IndexLocation>^dbo.BTSTQueryConfLinkI</IndexLocation>
<StreamLocation>^dbo.BTSTQueryConfLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
