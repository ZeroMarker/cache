Class dbo.BTSmartEpisTestSetRep Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisTestSetRep ]
{

/// Foreign Key FKBTSmartEpisTestSetBTSmartEpis created via DDL
ForeignKey FKBTSmartEpisTestSetBTTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTSmartEpisTestSetBTTestSet ];

Index IndexMaster On TestSetDR [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSmartEpisTestSetRep On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisTestSetRep, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Storage Default
{
<Data name="BTSmartEpisTestSetRepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisTestSetRepD</DataLocation>
<DefaultData>BTSmartEpisTestSetRepDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisTestSetRepD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisTestSetRepI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisTestSetRepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
