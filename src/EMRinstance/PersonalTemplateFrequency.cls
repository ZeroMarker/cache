/// 名称: 用户模板使用频率表
/// 描述: 用户模板使用频率表
/// 编写者：董璐璐
/// 编写日期: 2019-5-28
Class EMRinstance.PersonalTemplateFrequency Extends (%Persistent, %XML.Adaptor)
{

/// 模板ID
Property TemplateID As %String;

/// 用户模板ID
Property PersonalTemplateID As %String;

/// 创建者UserID
Property UserID As %String;

/// 使用次数
Property Frequency As %Integer;

Index IdxUserIDPersonalTemplateID On (UserID, PersonalTemplateID);

Index IdxTemPerTemUserFreq On (TemplateID, PersonalTemplateID, UserID, Frequency);

Storage Default
{
<Data name="PersonalTemplateFrequencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>PersonalTemplateID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>Frequency</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PersonalTemplateFreqD</DataLocation>
<DefaultData>PersonalTemplateFrequencyDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PersonalTemplateFreqD</IdLocation>
<IndexLocation>^DHCEMRI.PersonalTemplateFreqI</IndexLocation>
<StreamLocation>^DHCEMRI.PersonalTemplateFreqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
