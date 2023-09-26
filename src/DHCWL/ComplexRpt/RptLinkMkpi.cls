/// DHCWL_ComplexRpt.RptLinkMkpi
/// 报表与指标的关联表
Class DHCWL.ComplexRpt.RptLinkMkpi Extends %Persistent [ ClassType = persistent, SqlTableName = RptLinkMkpi ]
{

/// 指标池ID
Property RMKpi As DHCWL.ComplexRpt.MKpi [ SqlColumnNumber = 2, SqlFieldName = RptLink_Kpi ];

/// 报表
Property RMRpt As DHCWL.ComplexRpt.RptCfg [ SqlColumnNumber = 3, SqlFieldName = RptLink_Rpt ];

/// 备注
Property RMRemark As %String [ SqlColumnNumber = 4, SqlFieldName = RptLink_Remark ];

Index LinkKpi On RMKpi;

Index LinkRpt On RMRpt;

Index LinkRptKpi On (RMRpt, RMKpi);

Storage Default
{
<Data name="RptLinkMkpiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RMKpi</Value>
</Value>
<Value name="3">
<Value>RMRpt</Value>
</Value>
<Value name="4">
<Value>RMRemark</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.RptLinkMkpiD</DataLocation>
<DefaultData>RptLinkMkpiDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.RptLinkMkpiD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.RptLinkMkpiI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.RptLinkMkpiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
