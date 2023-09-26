///     
Class dbo.BDAgreeFormTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AgreeFormTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKBDAFTestItemAgreeForm created via DDL
ForeignKey FKBDAFTestItemAgreeForm(AgreeFormDR) References dbo.BDAgreeForm(PKBDAGREEFORM) [ SqlName = FK_BD_AFTestItem_AgreeForm ];

/// Foreign Key FKBDAFTestItemTestItem created via DDL
ForeignKey FKBDAFTestItemTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BD_AFTestItem_TestItem ];

Index IndexMaster On (AgreeFormDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDAGREEFORMTESTITEM On RowID [ PrimaryKey, SqlName = PK_BD_AGREEFORMTESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AgreeFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDAgreeFormTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AgreeFormDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAgreeFormTestItemD</DataLocation>
<DefaultData>BDAgreeFormTestItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDAgreeFormTestItemD</IdLocation>
<IndexLocation>^dbo.BDAgreeFormTestItemI</IndexLocation>
<StreamLocation>^dbo.BDAgreeFormTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
