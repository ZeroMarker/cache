Class DHCWL.MKPI.ModeMagRptCfg Extends %Persistent [ ClassType = persistent, SqlRowIdName = RptCfg_RowID, SqlTableName = ModeMagRptCfg ]
{

Parameter EXTENTSIZE = 250;

/// RptCfg_Code
Property RptCfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RptCfg_Code ];

/// RptCfg_Desc
Property RptCfgDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RptCfg_Desc ];

/// RtpCfg_URL
Property RptCfgURL As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RptCfg_URL ];

/// RptCfg_ParentCode
Property RptCfgPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RptCfg_PCode ];

Index RptCfgCodeUnqIdx1 On RptCfgCode [ Unique ];

Index RptCfgModeRptIndex On (RptCfgPCode, RptCfgCode);

//add by lhh@20131101

Storage Default
{
<Data name="ModeMagRptCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptCfgCode</Value>
</Value>
<Value name="3">
<Value>RptCfgDesc</Value>
</Value>
<Value name="4">
<Value>RptCfgPCode</Value>
</Value>
<Value name="5">
<Value>RptCfgURL</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.ModeMagRptCfgD</DataLocation>
<DefaultData>ModeMagRptCfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.MKPI.ModeMagRptCfgD</IdLocation>
<IndexLocation>^DHCWL.MKPI.ModeMagRptCfgI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.ModeMagRptCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
