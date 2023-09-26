Class dhc.pa.data.schemMDept Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCM_RowID, SqlTableName = schem_MDept ]
{

//考核方案ID

Property SCMSchemDR As dhc.pa.data.Schem [ SqlColumnNumber = 2, SqlFieldName = SCM_SchemDR ];

//归口科室

Property SCMDeptDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = SCM_DeptDr ];

//负责人

Property SCMUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = SCM_UserDR ];

Index SCMschemDrJXUnitUser On (SCMSchemDR, SCMDeptDr, SCMUserDR);

Storage Default
{
<Data name="schemMDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCMSchemDR</Value>
</Value>
<Value name="3">
<Value>SCMDeptDr</Value>
</Value>
<Value name="4">
<Value>SCMUserDR</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAschemMDeptD</DataLocation>
<DefaultData>schemMDeptDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAschemMDepttD</IdLocation>
<IndexLocation>^DHCCJXPAschemMDeptI</IndexLocation>
<StreamLocation>^dhc.pa.data.schemMDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
