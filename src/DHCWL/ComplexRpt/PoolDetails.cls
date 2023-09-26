/// DHCWL_ComplexRpt.MKpiPoolDetails
/// 配置报表生成的指标池明细
/// d ##class(DHCWL.ComplexRpt.PoolDetails).%BuildIndices()
Class DHCWL.ComplexRpt.PoolDetails Extends %Persistent [ ClassType = persistent, SqlTableName = MKpiPoolDetails ]
{

/// 指标池ID
Property KpiPool As DHCWL.ComplexRpt.MKpi [ SqlColumnNumber = 2, SqlFieldName = kpiPD_pool ];

/// 维度Code
Property DimCode As %String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = kpiPD_DimCode ];

/// 更新时间
Property UpdateDate As %String [ SqlColumnNumber = 4, SqlFieldName = kpiPD_UpdateDate ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 5, SqlFieldName = kpiPD_Remark ];

Index PoolDimCode On (DimCode, KpiPool);

Storage Default
{
<Data name="PoolDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KpiPool</Value>
</Value>
<Value name="3">
<Value>DimCode</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.PoolDetailsD</DataLocation>
<DefaultData>PoolDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.PoolDetailsD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.PoolDetailsI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.PoolDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
