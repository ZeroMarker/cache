///     
Class dbo.BTScreenPrompt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ScreenPrompt ]
{

/// Foreign Key FKBTScreenPromptWorkGroupDR created via DDL
ForeignKey FKBTScreenPromptWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTScreenPromptWorkGroupDR ];

/// DDL Primary Key Specification
Index PKBTSCREENPROMPT On RowID [ PrimaryKey, SqlName = PK_BT_SCREENPROMPT, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property NoAcceptMinite As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property TATFinshMinite As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property NoDealMachPanicMinite As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property DocNoDealPanicMinite As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTScreenPromptDefaultData">
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
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>NoAcceptMinite</Value>
</Value>
<Value name="6">
<Value>TATFinshMinite</Value>
</Value>
<Value name="7">
<Value>NoDealMachPanicMinite</Value>
</Value>
<Value name="8">
<Value>DocNoDealPanicMinite</Value>
</Value>
</Data>
<DataLocation>^dbo.BTScreenPromptD</DataLocation>
<DefaultData>BTScreenPromptDefaultData</DefaultData>
<IdLocation>^dbo.BTScreenPromptD</IdLocation>
<IndexLocation>^dbo.BTScreenPromptI</IndexLocation>
<StreamLocation>^dbo.BTScreenPromptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
