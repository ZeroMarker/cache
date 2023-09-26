Class dhc.sync.data.System Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_System ]
{

Property Code As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Code ];

Property Name As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Name ];

Property Active As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Active ];

Property PublicKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PublicKey ];

Property PrivateKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PrivateKey ];

/// 加密传输与否
Property Enc As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = Enc ];

/// 走集成平台与否
Property Ensemble As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = Ensemble ];

Property WSDLUrl As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = WSDLUrl ];

Property ClsName As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ClsName ];

Property MthName As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MthName ];

Index syncSysCode On Code;

Storage Default
{
<Data name="SystemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>PrivateKey</Value>
</Value>
<Value name="6">
<Value>PublicKey</Value>
</Value>
<Value name="7">
<Value>Enc</Value>
</Value>
<Value name="8">
<Value>Ensemble</Value>
</Value>
<Value name="9">
<Value>WSDLUrl</Value>
</Value>
<Value name="10">
<Value>ClsName</Value>
</Value>
<Value name="11">
<Value>MthName</Value>
</Value>
</Data>
<DataLocation>^dhcsyncSystemD</DataLocation>
<DefaultData>SystemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncSystemD</IdLocation>
<IndexLocation>^dhcsyncSystemI</IndexLocation>
<StreamLocation>^dhc.sync.data.SystemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
