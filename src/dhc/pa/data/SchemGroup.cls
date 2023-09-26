Class dhc.pa.data.SchemGroup Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCG_RowID, SqlTableName = schem_Group ]
{

//考核方案ID

Property SCMSchemDR As dhc.pa.data.Schem [ SqlColumnNumber = 2, SqlFieldName = SCM_SchemDR ];

//科室分组

Property SCMDeptDr As dhc.pa.data.JXGroup [ SqlColumnNumber = 3, SqlFieldName = SCM_DeptDr ];

Storage Default
{
<Data name="SchemGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCMSchemDR</Value>
</Value>
<Value name="3">
<Value>SCMDeptDr</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPASchemGroupD</DataLocation>
<DefaultData>SchemGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPASchemGroupD</IdLocation>
<IndexLocation>^DHCCJXPASchemGroupI</IndexLocation>
<StreamLocation>^dhc.pa.data.SchemGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
