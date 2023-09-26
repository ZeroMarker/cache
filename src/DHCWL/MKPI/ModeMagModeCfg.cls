/// DHCWL.MKPI.ModeMagModeCfg
Class DHCWL.MKPI.ModeMagModeCfg Extends %Library.Persistent [ ClassType = persistent, SqlRowIdName = ModeCfg_RowID, SqlTableName = ModeMagModeCfg ]
{

Parameter EXTENTSIZE = 250;

/// ModeCfg_Code
Property ModeCfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ModeCfg_Code ];

/// ModeCfg_Desc
Property ModeCfgDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ModeCfg_Desc ];

/// ModeCfg_ParentCode
Property ModeCfgPCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ModeCfg_PCode ];

Index ModeCfgCodeUnqIdx1 On ModeCfgCode [ Unique ];

Storage Default
{
<Data name="ModeMagModeCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModeCfgCode</Value>
</Value>
<Value name="3">
<Value>ModeCfgDesc</Value>
</Value>
<Value name="4">
<Value>ModeCfgPCode</Value>
</Value>
<Value name="5">
<Value>ModeCfgParendDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.ModeMagModeCfgD</DataLocation>
<DefaultData>ModeMagModeCfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.MKPI.ModeMagModeCfgD</IdLocation>
<IndexLocation>^DHCWL.MKPI.ModeMagModeCfgI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.ModeMagModeCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
