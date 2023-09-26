Class dbo.BTHRStation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTHR_Station, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexDepartment On DepartmentDR [ SqlName = Index_Department, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index PKBTHRSTATION On RowID [ PrimaryKey, SqlName = PK_BTHR_STATION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property StationDescribe As %Library.String(COLLATION = "Exact", MAXLEN = 3000) [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTHRSTATIONDefaultData">
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
<Value>DepartmentDR</Value>
</Value>
<Value name="5">
<Value>StationDescribe</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTHRStationD</DataLocation>
<DefaultData>BTHRStationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTHRStationD</IdLocation>
<IndexLocation>^dbo.BTHRStationI</IndexLocation>
<StreamLocation>^dbo.BTHRStationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
