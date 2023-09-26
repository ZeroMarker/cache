Class User.DHCICUCProperty Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUCP_RowId, SqlTableName = DHC_ICUC_Property, StorageStrategy = CacheStorage ]
{

Property ICUCPCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCP_Code ];

Property ICUCPDesc As %String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = ICUCP_Desc ];

Property ICUCPDefaultValue As %String [ SqlColumnNumber = 4, SqlFieldName = ICUCP_DefaultValue ];

Storage CacheStorage
{
<Data name="DHCICUCPropertyClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DHCICUCPropertyDefaultData">
<Value name="1">
<Value>ICUCPCode</Value>
</Value>
<Value name="2">
<Value>ICUCPDesc</Value>
</Value>
<Value name="3">
<Value>ICUCPDefaultValue</Value>
</Value>
</Data>
<DataLocation>^DHCICUC("Property")</DataLocation>
<DefaultData>DHCICUCPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUC("Property")</IdLocation>
<IndexLocation>^User.DHCICUCPropertyI</IndexLocation>
<SqlRowIdName>ICUCP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUCPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
