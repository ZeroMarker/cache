///     
Class dbo.BTDVServiceCompany Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTDV_ServiceCompany, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTDVSERVICECOMPANY On RowID [ PrimaryKey, SqlName = PK_BTDV_SERVICECOMPANY, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property Alias As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property Linkman As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

Property OfficeTe As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property Mobile As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

Property FaxNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

Property PostNo As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 12 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 13 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTDVServiceCompanyDefaultData">
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
<Value>LName</Value>
</Value>
<Value name="5">
<Value>Alias</Value>
</Value>
<Value name="6">
<Value>Linkman</Value>
</Value>
<Value name="7">
<Value>OfficeTe</Value>
</Value>
<Value name="8">
<Value>Mobile</Value>
</Value>
<Value name="9">
<Value>FaxNo</Value>
</Value>
<Value name="10">
<Value>Address</Value>
</Value>
<Value name="11">
<Value>PostNo</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
<Value name="14">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDVServiceCompanyD</DataLocation>
<DefaultData>BTDVServiceCompanyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTDVServiceCompanyD</IdLocation>
<IndexLocation>^dbo.BTDVServiceCompanyI</IndexLocation>
<StreamLocation>^dbo.BTDVServiceCompanyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
