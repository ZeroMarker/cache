///     
Class dbo.SYSRecordNumber Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_RecordNumber, StorageStrategy = Default ]
{

/// Foreign Key FKSYSRuleNoBase created via DDL
ForeignKey FKSYSRuleNoBase(SYSRuleNoBaseDR) References dbo.SYSRuleNoBase(PKSYSRULENOBASE) [ SqlName = FK_SYSRuleNoBase ];

Index IndexMaster On (NumType, NumNode) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKSYSRECORDNUMBER On RowID [ PrimaryKey, SqlName = PK_SYS_RECORDNUMBER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property NumType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ Required, SqlColumnNumber = 3 ];

Property NumNode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property LastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property MaxNum As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ SqlColumnNumber = 7 ];

Property Prefix As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 8 ];

Property Suffix As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 9 ];

Property Length As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property SYSRuleNoBaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="SYSRecordNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NumType</Value>
</Value>
<Value name="3">
<Value>NumNode</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>LastDate</Value>
</Value>
<Value name="6">
<Value>MaxNum</Value>
</Value>
<Value name="7">
<Value>Prefix</Value>
</Value>
<Value name="8">
<Value>Suffix</Value>
</Value>
<Value name="9">
<Value>Length</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>SYSRuleNoBaseDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSRecordNumberD</DataLocation>
<DefaultData>SYSRecordNumberDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSRecordNumberD</IdLocation>
<IndexLocation>^dbo.SYSRecordNumberI</IndexLocation>
<StreamLocation>^dbo.SYSRecordNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
