///     
Class dbo.BTDVManufacturer Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTDV_Manufacturer, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTDVMANUFACTURER On RowID [ PrimaryKey, SqlName = PK_BTDV_MANUFACTURER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property Alias As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTDVManufacturerDefaultData">
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
<Value>EName</Value>
</Value>
<Value name="6">
<Value>Alias</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDVManufacturerD</DataLocation>
<DefaultData>BTDVManufacturerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTDVManufacturerD</IdLocation>
<IndexLocation>^dbo.BTDVManufacturerI</IndexLocation>
<StreamLocation>^dbo.BTDVManufacturerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
