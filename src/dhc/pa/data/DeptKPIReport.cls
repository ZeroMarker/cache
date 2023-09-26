Class dhc.pa.data.DeptKPIReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DeptKPIReport_rowid, SqlTableName = DeptKPIReport ]
{

/// DKR_DeptDr
Property DKRDeptDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 2, SqlFieldName = DKR_DeptDr ];

/// DKR_KPIDr
Property DKRKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 3, SqlFieldName = DKR_KPIDr ];

/// DKR_Active
Property DKRActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DKR_Active ];

Storage Default
{
<Data name="DeptKPIReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DKRDeptDr</Value>
</Value>
<Value name="3">
<Value>DKRKPIDr</Value>
</Value>
<Value name="4">
<Value>DKRActive</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.DeptKPIReportD</DataLocation>
<DefaultData>DeptKPIReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.DeptKPIReportD</IdLocation>
<IndexLocation>^dhc.pa.data.DeptKPIReportI</IndexLocation>
<StreamLocation>^dhc.pa.data.DeptKPIReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
