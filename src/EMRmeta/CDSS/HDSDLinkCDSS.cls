/// Desc:      术语集关联临床决策支持系统
/// Creator:   Candy
/// CreateDate:2018-10-18
Class EMRmeta.CDSS.HDSDLinkCDSS Extends (%Persistent, %XML.Adaptor)
{

Index IdxHDSDCDSSMul On (CDSSTool, EMRDocID, TitleCode);

Index IdxHDSDCDSSSin On (CDSSTool, EMRDocID);

/// CDSS厂商标识
Property CDSSTool As %String;

/// CDSS病历代码
Property CDSSCode As %String(TRUNCATE = 1);

/// 病历名称描述
Property DocumentDesc As %String(TRUNCATE = 1);

/// titleCode
Property TitleCode As %String(TRUNCATE = 1);

Property EMRDocID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="HDSDLinkCDSSDefaultData">
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
<Value name="5">
<Value>TitleCode</Value>
</Value>
<Value name="6">
<Value>EMRDocID</Value>
</Value>
<Value name="7">
<Value>CDSSTool</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CDSS.HDSDLinkCDSSD</DataLocation>
<DefaultData>HDSDLinkCDSSDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CDSS.HDSDLinkCDSSD</IdLocation>
<IndexLocation>^DHCEMRM.CDSS.HDSDLinkCDSSI</IndexLocation>
<StreamLocation>^DHCEMRM.CDSS.HDSDLinkCDSSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
