Class EMRmeta.CDSS.AliHDSDLinkCDSS Extends (%Persistent, %XML.Adaptor)
{

Index IdxHDSDCDSSCode On (HDSDCode, CDSSCode) [ Unique ];

/// 病历术语代码
Property HDSDCode As %String(TRUNCATE = 1);

/// CDSS病历代码
Property CDSSCode As %String(TRUNCATE = 1);

/// 病历名称描述
Property DocumentDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AliHDSDLinkCDSSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HDSDCode</Value>
</Value>
<Value name="3">
<Value>CDSSCode</Value>
</Value>
<Value name="4">
<Value>DocumentDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.AliHDSDLinkCDSSD</DataLocation>
<DefaultData>AliHDSDLinkCDSSDefaultData</DefaultData>
<IdLocation>^DHCEMRM.AliHDSDLinkCDSSD</IdLocation>
<IndexLocation>^DHCEMRM.AliHDSDLinkCDSSI</IndexLocation>
<StreamLocation>^DHCEMRM.AliHDSDLinkCDSSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
