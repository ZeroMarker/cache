///     
Class dbo.OTSQL Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_SQL, StorageStrategy = Default ]
{

Index IndexDate On (DBType, AddDate) [ SqlName = Index_Date, Type = index ];

Index IndexMaster On (DBType, Code) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKOTSQL On RowID [ PrimaryKey, SqlName = PK_OT_SQL, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property DBType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property SQLStr As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

Property SQLType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Property AddUser As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="OTSQLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DBType</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>SQLStr</Value>
</Value>
<Value name="5">
<Value>SQLType</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>AddUser</Value>
</Value>
<Value name="8">
<Value>AddDate</Value>
</Value>
<Value name="9">
<Value>AddTime</Value>
</Value>
<Value name="10">
<Value>AddTime1</Value>
</Value>
</Data>
<DataLocation>^dbo.OTSQLD</DataLocation>
<DefaultData>OTSQLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.OTSQLD</IdLocation>
<IndexLocation>^dbo.OTSQLI</IndexLocation>
<StreamLocation>^dbo.OTSQLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
