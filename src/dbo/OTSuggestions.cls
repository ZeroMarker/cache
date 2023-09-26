Class dbo.OTSuggestions Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_Suggestions ]
{

/// Foreign Key FKTestResultAddUser created via DDL
ForeignKey FKAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AddUser ];

/// Foreign Key FKTestResultAddUser created via DDL
ForeignKey FKOccurWorkGroupDR(OccurWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_OccurWorkGroupDR ];

/// DDL Primary Key Specification
Index PKOTSuggestions On RowID [ PrimaryKey, SqlName = PK_OT_Suggestions, Type = index, Unique ];

Property RowID As %Library.Numeric(MAXVAL = 2147483647, MINVAL = -2147483648, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property OccurUserCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property OccurWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property OccurPage As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 8 ];

Property OccurDesc As %Library.String(COLLATION = "Exact", MAXLEN = 600) [ SqlColumnNumber = 9 ];

Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ReceiveUserName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property ReceiveDesc As %Library.String(COLLATION = "Exact", MAXLEN = 600) [ SqlColumnNumber = 13 ];

Property CompletionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CompletionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property State As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 16 ];

Property Evaluation As %Library.String(COLLATION = "Exact", MAXLEN = 600) [ SqlColumnNumber = 17 ];

Property Img1 As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

Property Img2 As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

Property Img3 As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 20 ];

Property Img4 As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="OTSuggestionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AddDate</Value>
</Value>
<Value name="3">
<Value>AddTime</Value>
</Value>
<Value name="4">
<Value>AddUserDR</Value>
</Value>
<Value name="5">
<Value>OccurUserCode</Value>
</Value>
<Value name="6">
<Value>OccurWorkGroupDR</Value>
</Value>
<Value name="7">
<Value>OccurPage</Value>
</Value>
<Value name="8">
<Value>OccurDesc</Value>
</Value>
<Value name="9">
<Value>ReceiveDate</Value>
</Value>
<Value name="10">
<Value>ReceiveTime</Value>
</Value>
<Value name="11">
<Value>ReceiveUserName</Value>
</Value>
<Value name="12">
<Value>ReceiveDesc</Value>
</Value>
<Value name="13">
<Value>CompletionDate</Value>
</Value>
<Value name="14">
<Value>CompletionTime</Value>
</Value>
<Value name="15">
<Value>State</Value>
</Value>
<Value name="16">
<Value>Evaluation</Value>
</Value>
<Value name="17">
<Value>Img1</Value>
</Value>
<Value name="18">
<Value>Img2</Value>
</Value>
<Value name="19">
<Value>Img3</Value>
</Value>
<Value name="20">
<Value>Img4</Value>
</Value>
</Data>
<DataLocation>^dbo.OTSuggestionsD</DataLocation>
<DefaultData>OTSuggestionsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.OTSuggestionsD</IdLocation>
<IndexLocation>^dbo.OTSuggestionsI</IndexLocation>
<StreamLocation>^dbo.OTSuggestionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
