///     
Class dbo.BBReqProductTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqProductTestSet, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPTSReqProduct created via DDL
ForeignKey FKBBRPTSReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_RPTS_ReqProduct ];

/// Foreign Key FKBBRPTSTestSet created via DDL
ForeignKey FKBBRPTSTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BB_RPTS_TestSet ];

Index IndexMaster On (ReqProductDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBREQPRODUCTTESTSET On RowID [ PrimaryKey, SqlName = PK_BB_REQPRODUCTTESTSET, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBReqProductTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqProductDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqProductTestSetD</DataLocation>
<DefaultData>BBReqProductTestSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqProductTestSetD</IdLocation>
<IndexLocation>^dbo.BBReqProductTestSetI</IndexLocation>
<StreamLocation>^dbo.BBReqProductTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
