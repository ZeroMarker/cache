Class dhc.qm.data.PatShow Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PatShow_rowid, SqlTableName = PatShow ]
{

/// PatShow_code
Property PatShowCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PatShow_code ];

/// PatShow_name
Property PatShowName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PatShow_name ];

/// PatShow_desc
Property PatShowDesc As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PatShow_desc ];

/// PatShow_active
Property PatShowActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PatShow_active ];

Index PatShowCode On PatShowCode;

Storage Default
{
<Data name="PatShowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatShowCode</Value>
</Value>
<Value name="3">
<Value>PatShowName</Value>
</Value>
<Value name="4">
<Value>PatShowDesc</Value>
</Value>
<Value name="5">
<Value>PatShowActive</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMPatShowD</DataLocation>
<DefaultData>PatShowDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMPatShowD</IdLocation>
<IndexLocation>^DHCCJXQMPatShowI</IndexLocation>
<StreamLocation>^DHCCJXQMPatShowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
