/// Desc:       临床决策病历章节代码表
/// Creator:    Candy
/// CreateDate: 2018-10-18
Class EMRmeta.CDSS.HDSDSection Extends (%Persistent, %XML.Adaptor)
{

Index IdxHDSD On (CDSSTool, HDSDCode);

/// CDSS厂商标识
Property CDSSTool As %String;

/// 病历术语代码
Property HDSDCode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 病历章节术语代码
Property HDSDSectionCode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 病历章节描述
Property SectionDesc As %String(TRUNCATE = 1);

/// 门诊章节关联惠每传参关键字
Property SectionKeyDesc As %String(TRUNCATE = 1);

/// 诊断类型 
Property DiagnosisType As %String(TRUNCATE = 1);

/// 特殊配置  （多个章节拼到一个关键字里面）
Property ConfigSpecial As %String;

Storage Default
{
<Data name="HDSDSectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HDSDCode</Value>
</Value>
<Value name="3">
<Value>HDSDSectionCode</Value>
</Value>
<Value name="4">
<Value>SectionDesc</Value>
</Value>
<Value name="5">
<Value>SectionKeyDesc</Value>
</Value>
<Value name="6">
<Value>DiagnosisType</Value>
</Value>
<Value name="7">
<Value>ConfigSpecial</Value>
</Value>
<Value name="8">
<Value>CDSSTool</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CDSS.HDSDSectionD</DataLocation>
<DefaultData>HDSDSectionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CDSS.HDSDSectionD</IdLocation>
<IndexLocation>^DHCEMRM.CDSS.HDSDSectionI</IndexLocation>
<StreamLocation>^DHCEMRM.CDSS.HDSDSectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
