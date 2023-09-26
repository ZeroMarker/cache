Class EMRmeta.CDSS.AliHDSDLinkEMRDoc Extends (%Persistent, %XML.Adaptor)
{

Index IdxHDSDEMRDoc On (HDSDCode, EMRDocID);

Index IdxEMRDocHDSD On (EMRDocID, HDSDCode);

Index IdxEMRDocCode On (EMRDocID, TitleCode, HDSDCode);

/// 病历术语代码
Property HDSDCode As %String(TRUNCATE = 1);

/// 病历显示结构的目录节点ID
Property EMRDocID As %String(TRUNCATE = 1);

/// 病程标题
Property TitleCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AliHDSDLinkEMRDocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HDSDCode</Value>
</Value>
<Value name="3">
<Value>EMRDocID</Value>
</Value>
<Value name="4">
<Value>TitleCode</Value>
</Value>
<Value name="5">
<Value>CDSSCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.AliHDSDLinkEMRDocD</DataLocation>
<DefaultData>AliHDSDLinkEMRDocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.AliHDSDLinkEMRDocD</IdLocation>
<IndexLocation>^DHCEMRM.AliHDSDLinkEMRDocI</IndexLocation>
<StreamLocation>^DHCEMRM.AliHDSDLinkEMRDocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
