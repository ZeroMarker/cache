/// 名称:EMRinstance.Events.ModDiagnosis
/// 描述:实例数据-医疗活动事件-修改诊断事件
/// 编写者：yejian
/// 编写日期: 2018-8-29
Class EMRinstance.Events.ModDiagnosis Extends %Persistent
{

Index IdxEpisodeIsActive On (EpisodeID, IsActive, DiagnosisDate, DiagnosisTime);

Property PatientID As %String;

Property EpisodeID As %String;

/// 用户ID
Property UserID As %String;

/// 诊断描述
Property DiagnosisDesc As %String;

/// 诊断日期
Property DiagnosisDate As %Date;

Property DiagnosisTime As %Time;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 不否活动
Property IsActive As %String;

Storage Default
{
<Data name="ModDiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>DiagnosisID</Value>
</Value>
<Value name="5">
<Value>DiagnosisDesc</Value>
</Value>
<Value name="6">
<Value>DiagnosisDate</Value>
</Value>
<Value name="7">
<Value>DiagnosisTime</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>IsActive</Value>
</Value>
<Value name="11">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.ModDiagnosisD</DataLocation>
<DefaultData>ModDiagnosisDefaultData</DefaultData>
<IdLocation>^DHCEMRI.Events.ModDiagnosisD</IdLocation>
<IndexLocation>^DHCEMRI.Events.ModDiagnosisI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.ModDiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
