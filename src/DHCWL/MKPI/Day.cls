/// DHCWL_MKPI.DHCWLKPIDay  d ##class(DHCWL.MKPI.Day).%BuildIndices()
Class DHCWL.MKPI.Day Extends %Persistent [ SqlTableName = DHCWLKPIDay ]
{

/// 代码
Property KPIMDCode As %String [ SqlColumnNumber = 2, SqlFieldName = KPIMD_Code ];

/// 名称
Property KPIMDName As %String [ SqlColumnNumber = 3, SqlFieldName = KPIMD_Name ];

/// 描述
Property KPIMDDesc As %String [ SqlColumnNumber = 4, SqlFieldName = KPIMD_Desc ];

/// 开始时间
Property KPIMDStartTime As %String [ SqlColumnNumber = 5, SqlFieldName = KPIMD_StartTime ];

/// 结束时间
Property KPIMDEndTime As %String [ SqlColumnNumber = 6, SqlFieldName = KPIMD_EndTime ];

/// 用户
Property KPIMDUser As %String [ SqlColumnNumber = 7, SqlFieldName = KPIMD_User ];

/// 创建日期
Property KPIMDUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = KPIMD_UpdateDate ];

/// 备注
Property KPIMDRemark As %String [ SqlColumnNumber = 9, SqlFieldName = KPIMD_Remark ];

/// 汇总标志
Property KPIMDCalFlag As %String [ SqlColumnNumber = 10, SqlFieldName = KPIMD_CalFlag ];

/// 区间标志
Property KPIMDDSectionFlag As DHCWL.MKPI.Section [ SqlColumnNumber = 11, SqlFieldName = KPIMD_SectionFlag ];

/// 区间列表
Property KPIMDMonthDr As %String(MAXLEN = 255) [ SqlColumnNumber = 12, SqlFieldName = KPIMD_Month_Dr ];

Index Code On KPIMDCode As AlphaUp;

Index Name On KPIMDName;

Index SectionFlag On KPIMDDSectionFlag;

Storage Default
{
<Data name="DayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPIMDCode</Value>
</Value>
<Value name="3">
<Value>KPIMDName</Value>
</Value>
<Value name="4">
<Value>KPIMDDesc</Value>
</Value>
<Value name="5">
<Value>KPIMDStartTime</Value>
</Value>
<Value name="6">
<Value>KPIMDEndTime</Value>
</Value>
<Value name="7">
<Value>KPIMDUser</Value>
</Value>
<Value name="8">
<Value>KPIMDUpdateDate</Value>
</Value>
<Value name="9">
<Value>KPIMDRemark</Value>
</Value>
<Value name="10">
<Value>KPIMDCalFlag</Value>
</Value>
<Value name="11">
<Value>KPIMDDSectionFlag</Value>
</Value>
<Value name="12">
<Value>KPIMDMonthDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.DayD</DataLocation>
<DefaultData>DayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.DayD</IdLocation>
<IndexLocation>^DHCWL.MKPI.DayI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.DayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
