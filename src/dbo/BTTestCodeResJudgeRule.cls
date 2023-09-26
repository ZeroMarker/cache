Class dbo.BTTestCodeResJudgeRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeResJudgeRule ]
{

Index IndexTestCodeDR On (TestCodeDR, Sequence) [ SqlName = Index_WorkGroupMachineDR, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTestCodeResJudgeRule On RowID [ PrimaryKey, SqlName = PK_BT_TestCodeResJudgeRule, Type = index, Unique ];

/// Foreign Key FKTestCodeJudgeRanges created via DDL
ForeignKey FKTestCodeResJudgeRuleTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeJudgeRanges ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property CalculateFormula As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 6 ];

Property Conclusion As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTTestCodeResJudgeRuleDefaultData">
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
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>CalculateFormula</Value>
</Value>
<Value name="6">
<Value>Conclusion</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeResJudgeRuleD</DataLocation>
<DefaultData>BTTestCodeResJudgeRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeResJudgeRuleD</IdLocation>
<IndexLocation>^dbo.BTTestCodeResJudgeRuleI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeResJudgeRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
