///     
Class dbo.BBReqProductTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqProductTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPTIReqProduct created via DDL
ForeignKey FKBBRPTIReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_RPTI_ReqProduct ];

/// Foreign Key FKBBRPTITestItem created via DDL
ForeignKey FKBBRPTITestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BB_RPTI_TestItem ];

Index IndexMaster On (ReqProductDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBREQPRODUCTTESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_REQPRODUCTTESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 5 ];

Property IsPrompt As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBReqProductTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqProductDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>IsMandatory</Value>
</Value>
<Value name="5">
<Value>IsPrompt</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqProductTestItemD</DataLocation>
<DefaultData>BBReqProductTestItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqProductTestItemD</IdLocation>
<IndexLocation>^dbo.BBReqProductTestItemI</IndexLocation>
<StreamLocation>^dbo.BBReqProductTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
