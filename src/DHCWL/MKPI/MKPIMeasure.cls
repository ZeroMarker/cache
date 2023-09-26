/// table: DHCWL_MKPI.DHCWLMKPIMeasure
Class DHCWL.MKPI.MKPIMeasure Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLMKPIMeasure ]
{

/// 关联度量
Property MKPIMeaDr As DHCWL.MeasureDimrole.Measure [ SqlColumnNumber = 2, SqlFieldName = MKPI_MeaDr ];

/// 关联指标
Property MKPIKpiDr As DHCWL.MKPI.MKPI [ SqlColumnNumber = 3, SqlFieldName = MKPI_KpiDr ];

/// 创建/修改时间
Property MeaCreateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Mea_CreateDate ];

Index MKPIMeaI On (MKPIKpiDr, MKPIMeaDr);

Storage Default
{
<Data name="MKPIMeasureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKPIMeaDr</Value>
</Value>
<Value name="3">
<Value>MKPIKpiDr</Value>
</Value>
<Value name="4">
<Value>MeaCreateDate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPIMeasureD</DataLocation>
<DefaultData>MKPIMeasureDefaultData</DefaultData>
<IdLocation>^DHCWL.MKPI.MKPIMeasureD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPIMeasureI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPIMeasureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
