///     
Class dbo.BDAdvReactTestItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AdvReactTestItemResult, StorageStrategy = Default ]
{

Index IXBDAdvReactTestItemResult On (AdverseReactionDR, AdvReactTestItemDR) [ SqlName = IX_BD_AdvReactTestItemResult, Type = index ];

Index IndexMaster On (AdverseReactionDR, RowID) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBBAdvReactTestItemResult On RowID [ PrimaryKey, SqlName = PK_BB_AdvReactTestItemResult, Type = index, Unique ];

/// Foreign Key FKBDAdvReactTestItemResultBBAdvReactTestItem created via DDL
ForeignKey FKBDAdvReactTestItemResultBBAdvReactTestItem(AdvReactTestItemDR) References dbo.BBAdvReactTestItem(PKBBAdvReactTestItem1) [ SqlName = FK_BD_AdvReactTestItemResult_BB_AdvReactTestItem ];

/// Foreign Key FKBDAdvReactTestItemResultBDAdverseReaction created via DDL
ForeignKey FKBDAdvReactTestItemResultBDAdverseReaction(AdverseReactionDR) References dbo.BDAdverseReaction(PKBDADVERSEREACTION) [ SqlName = FK_BD_AdvReactTestItemResult_BD_AdverseReaction ];

/// Foreign Key FKBDAdvReactTestItemResultSYSUser created via DDL
ForeignKey FKBDAdvReactTestItemResultSYSUser(ResultUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AdvReactTestItemResult_SYS_User ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AdverseReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AdvReactTestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 6 ];

Property Type As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property ResultUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BDAdvReactTestItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>AdverseReactionDR</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
<Value name="5">
<Value>AdvReactTestItemDR</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Units</Value>
</Value>
<Value name="9">
<Value>RefRanges</Value>
</Value>
<Value name="10">
<Value>ResultDate</Value>
</Value>
<Value name="11">
<Value>ResultTime</Value>
</Value>
<Value name="12">
<Value>ResultUserDR</Value>
</Value>
<Value name="13">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAdvReactTestItemResultD</DataLocation>
<DefaultData>BDAdvReactTestItemResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDAdvReactTestItemResultD</IdLocation>
<IndexLocation>^dbo.BDAdvReactTestItemResultI</IndexLocation>
<StreamLocation>^dbo.BDAdvReactTestItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
