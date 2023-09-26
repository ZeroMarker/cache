Class dbo.BTMarkContent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_MarkContent ]
{

/// Foreign Key FKBTMarkContentPublishMessageTypeDR created via DDL
ForeignKey FKBTMarkContentPublishMessageTypeDR(PublishMessageTypeDR) References dbo.BTPublishMessageType(PKBTPUBLISHMESSAGETYPE) [ SqlName = FK_BTMarkContentPublishMessageTypeDR ];

/// Foreign Key FKBTMarkContentTestCodeDR created via DDL
ForeignKey FKBTMarkContentTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTMarkContentTestCodeDR ];

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

Index IndexType On (PublishMessageTypeDR, Code) [ SqlName = Index_Type, Type = index ];

/// DDL Primary Key PKRPDrugCombination
Index PKBTMarkContent On RowID [ PrimaryKey, SqlName = PK_BT_MarkContent, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 标记类型
Property PublishMessageTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 是否打印
Property IsPrint As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

/// 关联项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 显示序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTMarkContentDefaultData">
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
<Value>PublishMessageTypeDR</Value>
</Value>
<Value name="5">
<Value>IsPrint</Value>
</Value>
<Value name="6">
<Value>TestCodeDR</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMarkContentD</DataLocation>
<DefaultData>BTMarkContentDefaultData</DefaultData>
<IdLocation>^dbo.BTMarkContentD</IdLocation>
<IndexLocation>^dbo.BTMarkContentI</IndexLocation>
<StreamLocation>^dbo.BTMarkContentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
