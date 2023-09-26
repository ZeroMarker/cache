Class EMRmeta.CDSS.AliHDSDSection Extends %Persistent
{

Index IdxHDSD On HDSDCode;

/// 病历术语代码
Property HDSDCode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 病历章节术语代码
Property HDSDSectionCode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 病历章节描述
Property SectionDesc As %String(TRUNCATE = 1);

/// 章节对应ali关键字
Property SectionKeyDesc As %String(TRUNCATE = 1);

/// 特殊配置 
Property ConfigSpecial As %String;

Storage Default
{
<Data name="AliHDSDSectionDefaultData">
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
<Value name="6">
<Value>HDSDSectionCode</Value>
</Value>
<Value name="7">
<Value>SectionDesc</Value>
</Value>
<Value name="8">
<Value>SectionKeyDesc</Value>
</Value>
<Value name="9">
<Value>DiagnosisType</Value>
</Value>
<Value name="10">
<Value>ConfigSpecial</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.AliHDSDSectionD</DataLocation>
<DefaultData>AliHDSDSectionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.AliHDSDSectionD</IdLocation>
<IndexLocation>^DHCEMRM.AliHDSDSectionI</IndexLocation>
<StreamLocation>^DHCEMRM.AliHDSDSectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
