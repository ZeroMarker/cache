Class dbo.BTRUTestCodeCatalogLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_TestCodeCatalogLink ]
{

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKRUTestCodeCatalogLink(TestCodeCatalogDR) References dbo.BTRUTestCodeCatalog(PKBTRUTestCodeCatalog) [ SqlName = FK_RUTestCodeCatalogLink ];

/// DDL Primary Key Specification
Index PKBTRUTestCodeCatalogLink On RowID [ PrimaryKey, SqlName = PK_BT_RUTestCodeCatalogLink, Type = index, Unique ];

Index IndexMaster On (RUTestCodeDR, TestCodeCatalogDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TestCodeCatalogDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTRUTestCodeCatalogLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUTestCodeDR</Value>
</Value>
<Value name="3">
<Value>ResultType</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>TestCodeCatalogDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRUTestCodeCatalogLinkD</DataLocation>
<DefaultData>BTRUTestCodeCatalogLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRUTestCodeCatalogLinkD</IdLocation>
<IndexLocation>^dbo.BTRUTestCodeCatalogLinkI</IndexLocation>
<StreamLocation>^dbo.BTRUTestCodeCatalogLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
