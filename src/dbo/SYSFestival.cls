Class dbo.SYSFestival Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Festival ]
{

Index IndexFestivalDate On FestivalDate [ SqlName = Index_FestivalDate, Type = index ];

Index PKSYSFestival On RowID [ PrimaryKey, SqlName = PK_SYS_Festival, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property FestivalDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="SYSFestivalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>FestivalDate</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSFestivalD</DataLocation>
<DefaultData>SYSFestivalDefaultData</DefaultData>
<IdLocation>^dbo.SYSFestivalD</IdLocation>
<IndexLocation>^dbo.SYSFestivalI</IndexLocation>
<StreamLocation>^dbo.SYSFestivalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
