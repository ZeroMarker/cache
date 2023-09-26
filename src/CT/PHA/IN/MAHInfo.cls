Class CT.PHA.IN.MAHInfo Extends %Persistent [ SqlRowIdName = MAHI_RowId, SqlTableName = MAHInfo, StorageStrategy = Default ]
{

Index INCIFIED On MAHIDesc As Exact;

/// MAHI_Desc ///持有人
Property MAHIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MAHI_Desc ];

/// MAHI_Address ///持有人地址
Property MAHIAddress As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MAHI_Address ];

Storage Default
{
<Data name="MAHInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MAHIDesc</Value>
</Value>
<Value name="3">
<Value>MAHIAddress</Value>
</Value>
</Data>
<DataLocation>^CT.PHA.IN.MAHInfoD</DataLocation>
<DefaultData>MAHInfoDefaultData</DefaultData>
<IdLocation>^CT.PHA.IN.MAHInfoD</IdLocation>
<IndexLocation>^CT.PHA.IN.MAHInfoI</IndexLocation>
<SqlRowIdName>MAHI_RowId</SqlRowIdName>
<StreamLocation>^CT.PHA.IN.MAHInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
