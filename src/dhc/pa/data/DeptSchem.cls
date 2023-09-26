/// Schem
Class dhc.pa.data.DeptSchem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSC_rowid, SqlTableName = DeptSchem ]
{

/// Schem_code
Property code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSC_code ];

/// Schem_name
Property name As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DSC_name ];

/// Schem_shortcut
Property shortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DSC_shortcut ];

/// Schem_frequency
Property frequency As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DSC_frequency ];

/// Schem_desc
Property desc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DSC_desc ];

/// DSC_isStop  自查项目有效标识 2016-8-3  add cyl
Property isStop As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DSC_isStop ];

Storage Default
{
<Data name="DeptSchemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>code</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
<Value name="4">
<Value>shortcut</Value>
</Value>
<Value name="5">
<Value>frequency</Value>
</Value>
<Value name="6">
<Value>desc</Value>
</Value>
<Value name="7">
<Value>isStop</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPADeptSchemD</DataLocation>
<DefaultData>DeptSchemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPADeptSchemD</IdLocation>
<IndexLocation>^DHCCJXPADeptSchemI</IndexLocation>
<StreamLocation>^DHCCJXPADeptSchemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
