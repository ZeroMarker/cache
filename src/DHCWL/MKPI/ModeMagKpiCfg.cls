/// DHCWL_MKPI.ModeMagKpiCfg
Class DHCWL.MKPI.ModeMagKpiCfg Extends %Persistent [ ClassType = persistent, SqlRowIdName = KpiCfg_RowID, SqlTableName = ModeMagKpiCfg ]
{

Parameter EXTENTSIZE = 250;

/// KpiCfg_Code
Property KpiCfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = KpiCfg_Code ];

/// KpiCfg_DimCfgRule
Property KpiCfgDimCfgRule As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = KpiCfg_DimCfgRule ];

/// KpiCfg_KpiFilterRule
Property KpiCfgKpiFilterRule As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = KpiCfg_KpiFilterRule ];

/// KpiCfg_PCode
Property KpiCfgPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = KpiCfg_PCode ];

/// KpiCfg_OrderNum
Property KpiCfgOrderNum As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = KpiCfg_OrderNum ];

Index RptKpiIndex On KpiCfgPCode;

//add by lhh@20131101

Storage Default
{
<Data name="ModeMagKpiCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KpiCfgCode</Value>
</Value>
<Value name="3">
<Value>KpiCfgDimCfgRule</Value>
</Value>
<Value name="4">
<Value>KpiCfgKpiFilterRule</Value>
</Value>
<Value name="5">
<Value>KpiCfgOrderNum</Value>
</Value>
<Value name="6">
<Value>KpiCfgPCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.ModeMagKpiCfgD</DataLocation>
<DefaultData>ModeMagKpiCfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.MKPI.ModeMagKpiCfgD</IdLocation>
<IndexLocation>^DHCWL.MKPI.ModeMagKpiCfgI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.ModeMagKpiCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
