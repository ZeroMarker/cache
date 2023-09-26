Class dbo.SYSForm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Form ]
{

/// Foreign Key FKSYSFormSystemSub created via DDL
ForeignKey FKSYSFormSystemSub(SystemSubDR) References dbo.SYSSystemSub(PKSYSSYSTEMSUB) [ SqlName = FK_SYSForm_SystemSub ];

/// DDL Primary Key Specification
Index PKSYSForm On RowID [ PrimaryKey, SqlName = PK_SYS_Form, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexSystemSub On SystemSubDR [ SqlName = Index_SystemSub, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

Property SysCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Property Url As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property Path As %Library.String(COLLATION = "Exact", MAXLEN = 450) [ Required, SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 10 ];

Property FormHelp As %Library.String(COLLATION = "Exact", MAXLEN = 5000) [ SqlColumnNumber = 11 ];

Property HelpWidth As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property HelpHeight As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property HelpDoc As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

Property SystemSubDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="SYSFormDefaultData">
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
<Value>SysCode</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>Url</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Path</Value>
</Value>
<Value name="10">
<Value>FormHelp</Value>
</Value>
<Value name="11">
<Value>HelpWidth</Value>
</Value>
<Value name="12">
<Value>HelpHeight</Value>
</Value>
<Value name="13">
<Value>HelpDoc</Value>
</Value>
<Value name="14">
<Value>SystemSubDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSFormD</DataLocation>
<DefaultData>SYSFormDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSFormD</IdLocation>
<IndexLocation>^dbo.SYSFormI</IndexLocation>
<StreamLocation>^dbo.SYSFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
