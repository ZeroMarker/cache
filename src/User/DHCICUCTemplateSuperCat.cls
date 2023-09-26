Class User.DHCICUCTemplateSuperCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUCTSC_RowId, SqlTableName = DHC_ICUC_TemplateSuperCat, StorageStrategy = CacheStorage ]
{

Index Code On ICUCTSCCode As Exact [ Data = ICUCTSCCode ];

Property ICUCTSCCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCTSC_Code ];

Property ICUCTSCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCTSC_Desc ];

Property ICUCTSCActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ICUCTSC_Active ];

Property ICUCTSCCtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = ICUCTSC_Ctloc_Dr ];

Storage CacheStorage
{
<Data name="DHCICUCTemplateSuperCatDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>ICUCTSCCode</Value>
</Value>
<Value name="2">
<Value>ICUCTSCDesc</Value>
</Value>
<Value name="3">
<Value>ICUCTSCActive</Value>
</Value>
<Value name="4">
<Value>ICUCTSCCtlocDr</Value>
</Value>
</Data>
<DataLocation>^DHCICUC("TSCat")</DataLocation>
<DefaultData>DHCICUCTemplateSuperCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUC("TSCat")</IdLocation>
<IndexLocation>^DHCICUC("TSCat",0)</IndexLocation>
<SqlRowIdName>ICUCTSC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUCTemplateSuperCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
