/// DHCWL_ComplexRpt.MKpi
/// 配置报表生成的指标池
/// d ##class(DHCWL.ComplexRpt.MKpi).%BuildIndices()
Class DHCWL.ComplexRpt.MKpi Extends %Persistent [ ClassType = persistent, SqlTableName = MKpi ]
{

/// 指标
Property KpiDr As DHCWL.MKPI.MKPI [ SqlColumnNumber = 2, SqlFieldName = MKpi_KpiDr ];

/// 统计模式
Property MKpiMode As %String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = MKpi_Mode ];

/// 统计内容
Property MKpiContent As %String(COLLATION = "Exact", MAXLEN = 250) [ SqlColumnNumber = 4, SqlFieldName = MKpi_Content ];

/// 指标维度串
Property MKpiDimStr As %String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = MKpi_DimStr ];

/// 更新时间
Property MKpiUpdateDate As %String [ SqlColumnNumber = 6, SqlFieldName = MKpi_UpdateDate ];

/// 备注
Property MKpiRemark As %String [ SqlColumnNumber = 7, SqlFieldName = MKpi_Remark ];

Index KpiDr On KpiDr;

Index ConKpiDr On (MKpiContent, KpiDr);

Index ModeKpiDr On (MKpiMode, KpiDr);

Index ModeConKpi On (MKpiMode, MKpiContent);

Storage Default
{
<Data name="MKpiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KpiDr</Value>
</Value>
<Value name="3">
<Value>MKpiMode</Value>
</Value>
<Value name="4">
<Value>MKpiContent</Value>
</Value>
<Value name="5">
<Value>MKpiDimStr</Value>
</Value>
<Value name="6">
<Value>MKpiUpdateDate</Value>
</Value>
<Value name="7">
<Value>MKpiRemark</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.MKpiD</DataLocation>
<DefaultData>MKpiDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.MKpiD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.MKpiI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.MKpiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
