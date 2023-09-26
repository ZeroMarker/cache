Class User.DHCICUCTemplateCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUCTC_RowId, SqlTableName = DHC_ICUC_TemplateCat, StorageStrategy = CacheStorage ]
{

Index Code On ICUCTCCode As Exact;

Property ICUCTCCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCTC_Code ];

Property ICUCTCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCTC_Desc ];

Property ICUCTCActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ICUCTC_Active ];

Property ICUCTCICUCTSCDr As User.DHCICUCTemplateSuperCat [ SqlColumnNumber = 5, SqlFieldName = ICUCTC_ICUCTSC_Dr ];

Storage CacheStorage
{
<Data name="DHCICUCTemplateCatDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>ICUCTCCode</Value>
</Value>
<Value name="2">
<Value>ICUCTCDesc</Value>
</Value>
<Value name="3">
<Value>ICUCTCActive</Value>
</Value>
<Value name="4">
<Value>ICUCTCICUCTSCDr</Value>
</Value>
</Data>
<DataLocation>^DHCICUC("TCat")</DataLocation>
<DefaultData>DHCICUCTemplateCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUC("TCat")</IdLocation>
<IndexLocation>^DHCICUC("TCat",0)</IndexLocation>
<SqlRowIdName>ICUCTC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUCTemplateCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
