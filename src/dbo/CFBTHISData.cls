Class dbo.CFBTHISData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CFBT_HISData, StorageStrategy = Default ]
{

Index IndexMaster On (DataType, DataCode, SYSCode, HospitalCode, HISDataCode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexHISDataCode On (HospitalCode, SYSCode, DataType, HISDataCode) [ SqlName = Index_HISDataCode, Type = index ];

Index IndexHISDataID On (HospitalCode, SYSCode, DataType, HISDataID) [ SqlName = Index_HISDataID, Type = index ];

/// DDL Primary Key Specification
Index PKCFBTHISDATAROWID On RowID [ PrimaryKey, SqlName = PK_CFBT_HISDATAROWID, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 3 ];

Property DataCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

Property SYSCode As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 5 ];

Property HospitalCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

Property HISDataCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 7 ];

Property HISDataID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property HISDataName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="CFBTHISDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataType</Value>
</Value>
<Value name="3">
<Value>DataCode</Value>
</Value>
<Value name="4">
<Value>SYSCode</Value>
</Value>
<Value name="5">
<Value>HospitalCode</Value>
</Value>
<Value name="6">
<Value>HISDataCode</Value>
</Value>
<Value name="7">
<Value>HISDataID</Value>
</Value>
<Value name="8">
<Value>HISDataName</Value>
</Value>
</Data>
<DataLocation>^dbo.CFBTHISDataD</DataLocation>
<DefaultData>CFBTHISDataDefaultData</DefaultData>
<IdLocation>^dbo.CFBTHISDataD</IdLocation>
<IndexLocation>^dbo.CFBTHISDataI</IndexLocation>
<StreamLocation>^dbo.CFBTHISDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
