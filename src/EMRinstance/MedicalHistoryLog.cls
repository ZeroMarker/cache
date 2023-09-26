/// Desc：患者病史信息日志(历史数据)
/// Creator:Donglulu
/// CreateDate:20210122
Class EMRinstance.MedicalHistoryLog Extends %Persistent
{

/// 患者ID
Property PatientID As %String(TRUNCATE = 1);

/// 关联EMRmeta.QuestionData
Property QuestionDataID As %Integer;

/// 问题代码
Property QuestionCode As %String(MAXLEN = 99);

/// 问题名称
Property QuestionName As %String(MAXLEN = 99999999);

/// 问题类型
Property QuestionType As %String(TRUNCATE = 1);

/// 问题答案
Property Value As %String(MAXLEN = 99999999);

/// 最后修改日期
Property ModifyDate As %Date;

/// 最后修改时间
Property ModifyTime As %Time;

/// 最后修改人
Property ModifyUser As %String(TRUNCATE = 1);

Index IdxPatidDateTimeQuestID On (PatientID, ModifyDate, ModifyTime, QuestionDataID) [ Unique ];

Storage Default
{
<Data name="MedicalHistoryLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>QuestionDataID</Value>
</Value>
<Value name="4">
<Value>QuestionCode</Value>
</Value>
<Value name="5">
<Value>QuestionName</Value>
</Value>
<Value name="6">
<Value>QuestionType</Value>
</Value>
<Value name="7">
<Value>Value</Value>
</Value>
<Value name="8">
<Value>ModifyDate</Value>
</Value>
<Value name="9">
<Value>ModifyTime</Value>
</Value>
<Value name="10">
<Value>ModifyUser</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalHistoryLogD</DataLocation>
<DefaultData>MedicalHistoryLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MedicalHistoryLogD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalHistoryLogI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalHistoryLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
