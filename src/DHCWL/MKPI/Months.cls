/// DHCWL_MKPI.DHCWLKPIMonths  d ##class(DHCWL.MKPI.Months).%BuildIndices()
Class DHCWL.MKPI.Months Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLKPIMonths ]
{

/// 代码
Property KPIMCode As %String [ SqlColumnNumber = 2, SqlFieldName = KPIM_Code ];

/// 名称
Property KPIMName As %String [ SqlColumnNumber = 3, SqlFieldName = KPIM_Name ];

/// 描述
Property KPIMDesc As %String [ SqlColumnNumber = 4, SqlFieldName = KPIM_Desc ];

/// 开始日期
Property KPIMStartDate As %Date [ SqlColumnNumber = 5, SqlFieldName = KPIM_StartDate ];

/// 结束日期
Property KPIMEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = KPIM_EndDate ];

/// 用户
Property KPIMUser As %String [ SqlColumnNumber = 7, SqlFieldName = KPIM_User ];

/// 创建日期
Property KPIMUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = KPIM_UpdateDate ];

/// 备注
Property KPIMRemark As %String [ SqlColumnNumber = 9, SqlFieldName = KPIM_Remark ];

/// 汇总标志
Property KPIMCalFlag As %String [ SqlColumnNumber = 10, SqlFieldName = KPIM_CalFlag ];

/// 区间标志
Property KPIMSectionFlag As DHCWL.MKPI.Section [ SqlColumnNumber = 11, SqlFieldName = KPIM_SectionFlag ];

/// 区间列表
Property KPIMMonthDr As %String(MAXLEN = 255) [ SqlColumnNumber = 12, SqlFieldName = KPIM_Month_Dr ];

Index Code On KPIMCode As AlphaUp;

Index Name On KPIMName;

Index SectionFlag On KPIMSectionFlag;

Index SectionFlagName On (KPIMSectionFlag, KPIMName As Exact);

Storage Default
{
<Data name="MonthsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPIMCode</Value>
</Value>
<Value name="3">
<Value>KPIMDesc</Value>
</Value>
<Value name="4">
<Value>KPIMEndDate</Value>
</Value>
<Value name="5">
<Value>KPIMName</Value>
</Value>
<Value name="6">
<Value>KPIMRemark</Value>
</Value>
<Value name="7">
<Value>KPIMStartDate</Value>
</Value>
<Value name="8">
<Value>KPIMUpdateDate</Value>
</Value>
<Value name="9">
<Value>KPIMUser</Value>
</Value>
<Value name="10">
<Value>KPIMCalFlag</Value>
</Value>
<Value name="11">
<Value>KPIMSectionFlag</Value>
</Value>
<Value name="12">
<Value>KPIMMonthDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MonthsD</DataLocation>
<DefaultData>MonthsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MonthsD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MonthsI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MonthsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
