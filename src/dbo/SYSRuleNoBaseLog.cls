Class dbo.SYSRuleNoBaseLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_RuleNoBaseLog ]
{

Index IndexMaster On (SYSRuleNoBaseDR, IsUse, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexNo On (SYSRuleNoBaseDR, AddDate, CurNo) [ SqlName = Index_No, Type = index, Unique ];

Index IndexCurNoIsUse On (SYSRuleNoBaseDR, CurNo, IsUse) [ SqlName = Index_CurNoIsUse, Type = index ];

/// Foreign Key FKSYSRuleNoBaseLog created via DDL
ForeignKey FKSYSRuleNoBaseLog(SYSRuleNoBaseDR) References dbo.SYSRuleNoBase(PKSYSRULENOBASE) [ SqlName = FK_SYSRuleNoBaseLog ];

/// DDL Primary Key Specification
Index PKSYSRULENOBASELOG On RowID [ PrimaryKey, SqlName = PK_SYS_RULENOBASELOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SYSRuleNoBaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property CurNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 6 ];

Property IsUse As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSRuleNoBaseLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SYSRuleNoBaseDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>CurNo</Value>
</Value>
<Value name="6">
<Value>IsUse</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSRuleNoBaseLogD</DataLocation>
<DefaultData>SYSRuleNoBaseLogDefaultData</DefaultData>
<IdLocation>^dbo.SYSRuleNoBaseLogD</IdLocation>
<IndexLocation>^dbo.SYSRuleNoBaseLogI</IndexLocation>
<StreamLocation>^dbo.SYSRuleNoBaseLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
