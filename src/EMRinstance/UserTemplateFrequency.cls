/// 名称: 科室模板使用频率表
/// 描述: 科室模板使用频率表
/// 编写者：董璐璐
/// 编写日期: 2019-5-17
Class EMRinstance.UserTemplateFrequency Extends (%Persistent, %XML.Adaptor)
{

/// 模板ID
Property TemplateID As %String;

/// 科室模板ID
Property UserTemplateID As %String;

/// 创建者UserID
Property UserID As %String;

/// 使用次数
Property Frequency As %Integer;

Index IdxUserIDUserTemplateID On (UserID, UserTemplateID);

Index IdxTemUserTemUserFreq On (TemplateID, UserTemplateID, UserID, Frequency);

Storage Default
{
<Data name="UserTemplateFrequencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>UserTemplateID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>Frequency</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.UserTemplateFreqD</DataLocation>
<DefaultData>UserTemplateFrequencyDefaultData</DefaultData>
<IdLocation>^DHCEMRI.UserTemplateFreqD</IdLocation>
<IndexLocation>^DHCEMRI.UserTemplateFreqI</IndexLocation>
<StreamLocation>^DHCEMRI.UserTemplateFreqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
