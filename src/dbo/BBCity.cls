/// 城市/地区
Class dbo.BBCity Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_City ]
{

/// Foreign Key FKBBCityCityDR created via DDL
ForeignKey FKBBCityCityDR(CityDR) References dbo.BBCity(PKBBCITY) [ SqlName = FK_BBCityCityDR ];

/// Foreign Key FKBBCityProvinceDR created via DDL
ForeignKey FKBBCityProvinceDR(ProvinceDR) References dbo.BBProvince(PKBBPROVINCE) [ SqlName = FK_BBCityProvinceDR ];

/// DDL Primary Key Specification
Index PKBBCITY On RowID [ PrimaryKey, SqlName = PK_BB_CITY, Type = index, Unique ];

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexCity On CityDR [ SqlName = Index_City, Type = index ];

Index IndexProvince On ProvinceDR [ SqlName = Index_Province, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property CityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property ProvinceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBCityDefaultData">
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
<Value>CityDR</Value>
</Value>
<Value name="5">
<Value>ProvinceDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBCityD</DataLocation>
<DefaultData>BBCityDefaultData</DefaultData>
<IdLocation>^dbo.BBCityD</IdLocation>
<IndexLocation>^dbo.BBCityI</IndexLocation>
<StreamLocation>^dbo.BBCityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
