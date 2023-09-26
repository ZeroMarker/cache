/// Desc：患者病史信息
/// Creator:Candy
/// CreateDate:20201218
Class EMRinstance.MedicalHistory Extends %Persistent
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

Index IdxPatientIDQuestID On (PatientID, QuestionDataID) [ Unique ];

Index IdxPatQuestCode On (PatientID, QuestionCode);

Index IdxQuestionDataID On QuestionDataID;

Storage Default
{
<Data name="MedicalHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>QuestionDataID</Value>
</Value>
<Value name="4">
<Value>QuestionName</Value>
</Value>
<Value name="5">
<Value>Value</Value>
</Value>
<Value name="6">
<Value>QuestionType</Value>
</Value>
<Value name="7">
<Value>PatientID</Value>
</Value>
<Value name="8">
<Value>QuestionCode</Value>
</Value>
<Value name="9">
<Value>ModifyDate</Value>
</Value>
<Value name="10">
<Value>ModifyTime</Value>
</Value>
<Value name="11">
<Value>ModifyUser</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalHistoryD</DataLocation>
<DefaultData>MedicalHistoryDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MedicalHistoryD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalHistoryI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
