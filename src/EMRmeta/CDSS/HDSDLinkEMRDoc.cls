/// Desc:      病历术语集关联临床数据配置
/// Creator:   Candy
/// CreateDate:2018-10-18
Class EMRmeta.CDSS.HDSDLinkEMRDoc Extends (%Persistent, %XML.Adaptor)
{

Index IdxEMRDocHDSD On (CDSSTool, EMRDocID, HDSDCode);

Index IdxEMRDocCode On (CDSSTool, EMRDocID, TitleCode, HDSDCode);

/// CDSS厂商标识
Property CDSSTool As %String;

/// 病历术语代码
Property HDSDCode As %String(TRUNCATE = 1);

/// 病历显示结构的目录节点ID
Property EMRDocID As %String(TRUNCATE = 1);

/// 病程标题
Property TitleCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="HDSDLinkEMRDocDefaultData">
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
<Value>CDSSTool</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CDSS.HDSDLinkEMRDocD</DataLocation>
<DefaultData>HDSDLinkEMRDocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CDSS.HDSDLinkEMRDocD</IdLocation>
<IndexLocation>^DHCEMRM.CDSS.HDSDLinkEMRDocI</IndexLocation>
<StreamLocation>^DHCEMRM.CDSS.HDSDLinkEMRDocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
