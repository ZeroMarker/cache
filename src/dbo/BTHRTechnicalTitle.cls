Class dbo.BTHRTechnicalTitle Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTHR_TechnicalTitle, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTHRTECHNICALTITLE On RowID [ PrimaryKey, SqlName = PK_BTHR_TECHNICALTITLE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTHRTECHNICALTITLEDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTHRTechnicalTitleD</DataLocation>
<DefaultData>BTHRTechnicalTitleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTHRTechnicalTitleD</IdLocation>
<IndexLocation>^dbo.BTHRTechnicalTitleI</IndexLocation>
<StreamLocation>^dbo.BTHRTechnicalTitleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
