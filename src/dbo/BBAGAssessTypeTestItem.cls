///     
Class dbo.BBAGAssessTypeTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AGAssessTypeTestItem, StorageStrategy = Default ]
{

/// Foreign Key AGAssessTypeTestItem created via DDL
ForeignKey AGAssessTypeTestItem(AGAssessTypeDR) References dbo.BBAGAssessType(PKBBAGASSESSTYPE) [ SqlName = AGAssessTypeTestItem ];

/// Foreign Key FKAGAssessTypeTestItem2 created via DDL
ForeignKey FKAGAssessTypeTestItem2(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_AGAssessTypeTestItem2 ];

Index IndexMaster On (AGAssessTypeDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (AGAssessTypeDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBAGASSESSTYPETESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_AGASSESSTYPETESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGAssessTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ValueLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property ValueHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBAGAssessTypeTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGAssessTypeDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>ValueLow</Value>
</Value>
<Value name="5">
<Value>ValueHigh</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAGAssessTypeTestItemD</DataLocation>
<DefaultData>BBAGAssessTypeTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BBAGAssessTypeTestItemD</IdLocation>
<IndexLocation>^dbo.BBAGAssessTypeTestItemI</IndexLocation>
<StreamLocation>^dbo.BBAGAssessTypeTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
