/// 医生指标、系统指标、过滤规则关联表
/// DHCWL_DocQuery.DHCWLDocKpiRelKpi   d ##class(DHCWL.DocQuery.DocKpiCFG).%BuildIndices()
Class DHCWL.DocQuery.DocKpiRelKpi Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLDocKpiRelKpi ]
{

/// 医生指标 
Property MDocKPIDr As DHCWL.DocQuery.DocKpiDef [ SqlColumnNumber = 2, SqlFieldName = MDocKPI_Dr ];

//Property MKPIdr As DHCWL.MKPI.MKPI [ SqlColumnNumber = 3, SqlFieldName = MKPI_dr ];

/// 指标 
/// 指标维度(用户过滤表达式)MKPIDocDimDr  DHCWL.MKPI.MKPIDimensions
Property MKPIDim As %String [ SqlColumnNumber = 3, SqlFieldName = MKPI_Dim ];

/// 维度属性(用户过滤表达式)MDimDocPropDr  DHCWL.MKPI.DimProperty
Property MDimProp As %String [ SqlColumnNumber = 4, SqlFieldName = MDim_Prop ];

/// 其他滤表达式 
Property OtherFilterRule As %Text(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = OtherFilter_Rule ];

/// 指标代码
Property MKPICode As %String [ SqlColumnNumber = 6, SqlFieldName = MKPI_Code ];

Index MDocKPIDr On MDocKPIDr;

Index MDocRel On (MDocKPIDr, MKPICode);

Storage Default
{
<Data name="DocKpiRelKpiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MDocKPIDr</Value>
</Value>
<Value name="3">
<Value>MKPIdr</Value>
</Value>
<Value name="4">
<Value>DocFilterRule</Value>
</Value>
<Value name="5">
<Value>OtherFilterRule</Value>
</Value>
<Value name="6">
<Value>MKPIDocDimDr</Value>
</Value>
<Value name="7">
<Value>MDimDocPropDr</Value>
</Value>
<Value name="8">
<Value>NewProperty1</Value>
</Value>
<Value name="9">
<Value>MKPIDocDim</Value>
</Value>
<Value name="10">
<Value>MDimDocProp</Value>
</Value>
<Value name="11">
<Value>MKPIDim</Value>
</Value>
<Value name="12">
<Value>MDimProp</Value>
</Value>
<Value name="13">
<Value>MKPICode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DocQuery.DocKpiRelKpiD</DataLocation>
<DefaultData>DocKpiRelKpiDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.DocQuery.DocKpiRelKpiD</IdLocation>
<IndexLocation>^DHCWL.DocQuery.DocKpiRelKpiI</IndexLocation>
<StreamLocation>^DHCWL.DocQuery.DocKpiRelKpiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
