Class dhc.pa.inter.PALogger Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PL_RowID, SqlTableName = PALogger ]
{

Property PLCode As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PL_Code ];

Property PLPar As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PL_Par ];

Property PLResult As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PL_Result ];

Property PLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PL_Desc ];

Storage Default
{
<Data name="PALoggerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PLCode</Value>
</Value>
<Value name="3">
<Value>PLPar</Value>
</Value>
<Value name="4">
<Value>PLResult</Value>
</Value>
<Value name="5">
<Value>PLDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPALoggerD</DataLocation>
<DefaultData>PALoggerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPALoggerD</IdLocation>
<IndexLocation>^DHCCJXPALoggerI</IndexLocation>
<StreamLocation>^dhc.pa.inter.PALoggerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
