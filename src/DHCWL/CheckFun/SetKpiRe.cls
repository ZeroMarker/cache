/// 考核方案与考核指标关系表 
/// DHCWL_CheckFun.DHCWLSetKpiRe d ##class(DHCWL.CheckFun.SetKpiRe).%BuildIndices()
Class DHCWL.CheckFun.SetKpiRe Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLSetKpiRe ]
{

/// 考核方案id SetKpiRe_Set_Dr
Property SetKpiReSetDr As DHCWL.CheckFun.CheckSet [ SqlColumnNumber = 2, SqlFieldName = SetKpiRe_Set_Dr ];

/// 考核指标id SetKpiRe_Kpi_Dr
Property SetKpiReKpiDr As DHCWL.CheckFun.CheckKPI [ SqlColumnNumber = 3, SqlFieldName = SetKpiRe_Kpi_Dr ];

/// 更新日期 SetKpiRe_UpdateDate
Property SetKpiReUpdateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SetKpiRe_UpdateDate ];

/// 更新用户 SetKpiRe_UpdateUser	
Property SetKpiReUpdateUser As %String [ SqlColumnNumber = 5, SqlFieldName = SetKpiRe_UpdateUser ];

Index Set On SetKpiReSetDr;

Index Kpi On SetKpiReKpiDr;

Index SetKpi On (SetKpiReSetDr, SetKpiReKpiDr);

Storage Default
{
<Data name="SetKpiReDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SetKpiReSetDr</Value>
</Value>
<Value name="3">
<Value>SetKpiReKpiDr</Value>
</Value>
<Value name="4">
<Value>SetKpiReUpdateDate</Value>
</Value>
<Value name="5">
<Value>SetKpiReUpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CheckFun.SetKpiReD</DataLocation>
<DefaultData>SetKpiReDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CheckFun.SetKpiReD</IdLocation>
<IndexLocation>^DHCWL.CheckFun.SetKpiReI</IndexLocation>
<StreamLocation>^DHCWL.CheckFun.SetKpiReS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
