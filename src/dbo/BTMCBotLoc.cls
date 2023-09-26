///     
Class dbo.BTMCBotLoc Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_BotLoc ]
{

/// Foreign Key FKBTMCBotLocHospitalDR created via DDL
ForeignKey FKBTMCBotLocHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTMCBotLocHospitalDR ];

/// DDL Primary Key Specification
Index PKBTMCBOTLOC On RowID [ PrimaryKey, SqlName = PK_BTMC_BOTLOC, Type = index, Unique ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTMCBotLocDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCBotLocD</DataLocation>
<DefaultData>BTMCBotLocDefaultData</DefaultData>
<IdLocation>^dbo.BTMCBotLocD</IdLocation>
<IndexLocation>^dbo.BTMCBotLocI</IndexLocation>
<StreamLocation>^dbo.BTMCBotLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
