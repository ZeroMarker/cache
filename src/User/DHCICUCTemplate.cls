Class User.DHCICUCTemplate Extends %Persistent [ Language = java, Owner = {_SYSTEM}, SqlRowIdName = ICUCT_RowId, SqlTableName = DHC_ICUC_Template, StorageStrategy = CacheStorage ]
{

Index Code On ICUCTCode As Exact [ Data = ICUCTCode ];

Property ICUCTCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCT_Code ];

Property ICUCTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCT_Desc ];

Property ICUCTActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ICUCT_Active ];

Property ICUCTICUCTCDr As User.DHCICUCTemplateCat [ SqlColumnNumber = 5, SqlFieldName = ICUCT_ICUCTC_Dr ];

Property ICUCTData As %String(MAXLEN = 2000) [ SqlColumnNumber = 6, SqlFieldName = ICUCT_Data ];

Storage CacheStorage
{
<Data name="DataMaster">
<Value name="1">
<Value>ICUCTCode</Value>
</Value>
<Value name="2">
<Value>ICUCTDesc</Value>
</Value>
<Value name="3">
<Value>ICUCTActive</Value>
</Value>
<Value name="4">
<Value>ICUCTICUCTCDr</Value>
</Value>
<Value name="5">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="6">
<Value>ICUCTData</Value>
</Value>
</Data>
<DataLocation>^DHCICUC("Template")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUC("Template")</IdLocation>
<IndexLocation>^DHCICUC("Template",0)</IndexLocation>
<SqlRowIdName>ICUCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUCTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
