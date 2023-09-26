Class dbo.RPVisitNumberChlRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberChlRes ]
{

Index IndexVisitNumber On (VisitNumber, ResultChannel) [ SqlName = Index_VisitNumber, Type = index, Unique ];

Index IndexDate On (MachineParameterDR, AddDate, IsSend, VisitNumber, ResultChannel) [ SqlName = Index_Date, Type = index ];

/// Foreign Key FKVisitNumberChlResMi created via DDL
ForeignKey FKVisitNumberChlResMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_VisitNumberChlResMi ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property ResultChannel As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property IsSend As %Library.Boolean [ SqlColumnNumber = 8 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPVisitNumberChlResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumber</Value>
</Value>
<Value name="3">
<Value>ResultChannel</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>IsSend</Value>
</Value>
<Value name="8">
<Value>MachineParameterDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberChlResD</DataLocation>
<DefaultData>RPVisitNumberChlResDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberChlResD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberChlResI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberChlResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
