///     
Class dbo.BTTestMethodFee Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestMethodFee, StorageStrategy = Default ]
{

/// Foreign Key FKBTTMFeeCostItem created via DDL
ForeignKey FKBTTMFeeCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BT_TMFee_CostItem ];

/// Foreign Key FKBTTMFeeTestCode created via DDL
ForeignKey FKBTTMFeeTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BT_TMFee_TestCode ];

/// Foreign Key FKBTTMFeeTestMethod created via DDL
ForeignKey FKBTTMFeeTestMethod(TestMethodDR) References dbo.BTTestMethod(PKBTTESTMETHOD) [ SqlName = FK_BT_TMFee_TestMethod ];

Index IndexMaster On (TestCodeDR, TestMethodDR, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTESTMETHODFEE On RowID [ PrimaryKey, SqlName = PK_BT_TESTMETHODFEE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ItemNum As %Library.Float [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTTestMethodFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>TestMethodDR</Value>
</Value>
<Value name="4">
<Value>CostItemDR</Value>
</Value>
<Value name="5">
<Value>ItemNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestMethodFeeD</DataLocation>
<DefaultData>BTTestMethodFeeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestMethodFeeD</IdLocation>
<IndexLocation>^dbo.BTTestMethodFeeI</IndexLocation>
<StreamLocation>^dbo.BTTestMethodFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
