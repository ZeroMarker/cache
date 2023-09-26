Class dhc.pa.data.PAUpLoadInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PAULI_Rowid, SqlTableName = PAUpLoadInfo ]
{

Property UDRDDr As dhc.pa.data.UnitDeptResult [ SqlColumnNumber = 3, SqlFieldName = PAULI_UDRDDr ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PAULI_FileName ];

Property UploadUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PAULI_UploadUser ];

Property UploadDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PAULI_UploadDate ];

Property FileURL As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PAULI_FileURL ];

Storage Default
{
<Data name="PAUpLoadInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UDRDDr</Value>
</Value>
<Value name="3">
<Value>FileName</Value>
</Value>
<Value name="4">
<Value>SubUser</Value>
</Value>
<Value name="5">
<Value>SubDate</Value>
</Value>
<Value name="6">
<Value>FileURL</Value>
</Value>
<Value name="7">
<Value>UploadUser</Value>
</Value>
<Value name="8">
<Value>UploadDate</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAUpLoadInfoD</DataLocation>
<DefaultData>PAUpLoadInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAUpLoadInfoD</IdLocation>
<IndexLocation>^DHCCJXPAUpLoadInfoI</IndexLocation>
<StreamLocation>^DHCCJXPAUpLoadInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
