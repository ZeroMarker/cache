/// 名称:	EMRinstance.PrintTips
/// 描述:	打印提示(标注医生点击首次点击打印提示“请确认已打印心电图、CT报告单、会诊记录单”(辽宁沈阳胸科医院)
/// 编写者：yejian
/// 编写日期: 2021-12-31
Class EMRinstance.PrintTips Extends %Persistent
{

Index IdxTipsData On (UserID, EpisodeID, TipsDate);

/// 就诊号
Property EpisodeID As %String;

/// 用户ID
Property UserID As %String;

/// 已经提示日期
Property TipsDate As %Date;

Storage Default
{
<Data name="PrintTipsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>TipsDate</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PrintTipsD</DataLocation>
<DefaultData>PrintTipsDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PrintTipsD</IdLocation>
<IndexLocation>^DHCEMRI.PrintTipsI</IndexLocation>
<StreamLocation>^DHCEMRI.PrintTipsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
