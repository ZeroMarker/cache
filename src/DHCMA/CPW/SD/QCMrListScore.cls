/// 名称: DHCMA.CPW.SD.QCMrListScore
/// 描述: 质控表单项目评分记录表
/// 编写者：zgz
/// 编写日期: 20120-04-28
Class DHCMA.CPW.SD.QCMrListScore Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病种入组MrListID
Property MrListID As %String;

/// 评分表项（工具项，非表单项）
Property ScoreItem As DHCMA.CPW.SD.QCEntityItem;

/// 评估记录
Property ScoreRecords As %String;

/// 评定日期
Property ScoreDate As %Date;

/// 评定时间
Property ScoreTime As %Time;

Index IndexMrItem On (MrListID, ScoreItem) [ Unique ];

Storage Default
{
<Data name="QCMrListScoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MrListID</Value>
</Value>
<Value name="3">
<Value>ScoreItemID</Value>
</Value>
<Value name="4">
<Value>ScoreRecords</Value>
</Value>
<Value name="5">
<Value>ScoreDate</Value>
</Value>
<Value name="6">
<Value>ScoreTime</Value>
</Value>
<Value name="7">
<Value>ScoreItem</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCMrListScoreD</DataLocation>
<DefaultData>QCMrListScoreDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCMrListScoreD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCMrListScoreI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCMrListScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
