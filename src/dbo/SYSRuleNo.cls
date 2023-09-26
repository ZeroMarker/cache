Class dbo.SYSRuleNo Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_RuleNo ]
{

/// DDL Primary Key Specification
Index PKSYSRuleNo On RowID [ PrimaryKey, SqlName = PK_SYS_RuleNo, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property SignStr As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 4 ];

Property RuleStr As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Property CurNoStr As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 6 ];

Property OutFormatStr As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSRuleNoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SignStr</Value>
</Value>
<Value name="3">
<Value>RuleStr</Value>
</Value>
<Value name="4">
<Value>CurNoStr</Value>
</Value>
<Value name="5">
<Value>OutFormatStr</Value>
</Value>
<Value name="6">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSRuleNoD</DataLocation>
<DefaultData>SYSRuleNoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSRuleNoD</IdLocation>
<IndexLocation>^dbo.SYSRuleNoI</IndexLocation>
<StreamLocation>^dbo.SYSRuleNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
