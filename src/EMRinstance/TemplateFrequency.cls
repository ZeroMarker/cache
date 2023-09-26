/// 名称:模板使用频率
/// 描述:模板使用频率
/// 编写者：yejian
/// 编写日期: 2020-3-10
Class EMRinstance.TemplateFrequency Extends %Persistent
{

/// 病历展现业务活动记录ID
Property DocID As %String;

/// 创建者UserID
Property UserID As %String;

/// 使用次数
Property Frequency As %Integer;

Index IdxUserDocID On (UserID, DocID);

Index IdxDocUserFreq On (DocID, UserID, Frequency);

Storage Default
{
<Data name="TemplateFrequencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>Frequency</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.TemplateFrequencyD</DataLocation>
<DefaultData>TemplateFrequencyDefaultData</DefaultData>
<IdLocation>^DHCEMRI.TemplateFrequencyD</IdLocation>
<IndexLocation>^DHCEMRI.TemplateFrequencyI</IndexLocation>
<StreamLocation>^DHCEMRI.TemplateFrequencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
