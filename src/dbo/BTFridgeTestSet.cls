///     
Class dbo.BTFridgeTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_FridgeTestSet ]
{

Index IndexMaster On (WorkGroupDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTFridgeTestSetTestSetDR created via DDL
ForeignKey FKBTFridgeTestSetTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTFridgeTestSetTestSetDR ];

/// Foreign Key FKBTFridgeTestSetWorkGroupDR created via DDL
ForeignKey FKBTFridgeTestSetWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTFridgeTestSetWorkGroupDR ];

/// DDL Primary Key Specification
Index PKBTFRIDGETESTSET On RowID [ PrimaryKey, SqlName = PK_BT_FRIDGETESTSET, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTFridgeTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFridgeTestSetD</DataLocation>
<DefaultData>BTFridgeTestSetDefaultData</DefaultData>
<IdLocation>^dbo.BTFridgeTestSetD</IdLocation>
<IndexLocation>^dbo.BTFridgeTestSetI</IndexLocation>
<StreamLocation>^dbo.BTFridgeTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
