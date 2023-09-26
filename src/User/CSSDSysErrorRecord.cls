Class User.CSSDSysErrorRecord Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDSYSER_RowId, SqlTableName = CSSD_SysErrorRecord ]
{

Parameter EXTENTSIZE = 250;

Property CSSDSYSERDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = CSSDSYSER_Date ];

Property CSSDSYSERTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = CSSDSYSER_Time ];

Property CSSDSYSERApp As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDSYSER_App ];

Property CSSDSYSERErrInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 5, SqlFieldName = CSSDSYSER_ErrInfo ];

Property CSSDSYSERKeyValue As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 6, SqlFieldName = CSSDSYSER_KeyValue ];

Property CSSDSYSERErrorTrigger As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7, SqlFieldName = CSSDSYSER_ErrorTrigger ];

Property CSSDSYSERIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CSSDSYSER_IP ];

Property CSSDSYSERSSUSRDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CSSDSYSER_SSUSR_DR ];

Property CSSDSYSERBrowserInfo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10, SqlFieldName = CSSDSYSER_BrowserInfo ];

Property CSSDSYSERType As %String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = CSSDSYSER_Type ];

Storage Default
{
<Data name="CSSDSysErrorRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSYSERDate</Value>
</Value>
<Value name="3">
<Value>CSSDSYSERTime</Value>
</Value>
<Value name="4">
<Value>CSSDSYSERApp</Value>
</Value>
<Value name="5">
<Value>CSSDSYSERErrInfo</Value>
</Value>
<Value name="6">
<Value>CSSDSYSERKeyValue</Value>
</Value>
<Value name="7">
<Value>CSSDSYSERErrorTrigger</Value>
</Value>
<Value name="8">
<Value>CSSDSYSERIP</Value>
</Value>
<Value name="9">
<Value>CSSDSYSERSSUSRDR</Value>
</Value>
<Value name="10">
<Value>CSSDSYSERBrowserInfo</Value>
</Value>
<Value name="11">
<Value>CSSDSYSERType</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSysErrorRecordD</DataLocation>
<DefaultData>CSSDSysErrorRecordDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.CSSDSysErrorRecordD</IdLocation>
<IndexLocation>^User.CSSDSysErrorRecordI</IndexLocation>
<SqlRowIdName>CSSDSYSER_RowId</SqlRowIdName>
<StreamLocation>^User.CSSDSysErrorRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
