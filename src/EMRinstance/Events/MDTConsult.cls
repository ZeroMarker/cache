/// 名称:EMRinstance.Events.MDTConsult
/// 描述:实例数据-医疗活动事件-会诊
/// 编写者：Donglulu
/// 编写日期: 2021-07-21
Class EMRinstance.Events.MDTConsult Extends (%Persistent, %XML.Adaptor)
{

Index IdxEpisodeIsActive On (EpisodeID, IsActive, ApplyDate, ApplyTime);

Index IdxFromCode On ConsultID [ Unique ];

Property PatientID As %String;

Property EpisodeID As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 不否活动
Property IsActive As %String;

/// 会诊ID
Property ConsultID As %String;

/// 会诊申请日期
Property ApplyDate As %Date;

/// 会诊申请时间
Property ApplyTime As %Time;

/// 会诊申请医生名称
Property ApplyDoctor As %String;

/// 会诊完成日期
Property FinishDate As %Date;

/// 会诊完成时间
Property FinishTime As %Time;

/// 会诊医生名称（多个以逗号为分隔）
Property ConsultDoctor As %String(MAXLEN = 100);

/// 疑难病种描述
Property ConsultType As %String;

/// 会诊科室描述（多个以逗号为分隔）
Property ConsultLoc As %String;

/// 会诊申请科室描述
Property ApplyLoc As %String(MAXLEN = 100);

/// 会诊目的
Property ConDestination As %String(MAXLEN = 9900);

/// 会诊意见
Property Attitude As %String(MAXLEN = 9900);

/// 会诊状态(完成/取消完成)
Property ConsultStatus As %String;

Storage Default
{
<Data name="MDTConsultDefaultData">
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
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>ConsultID</Value>
</Value>
<Value name="8">
<Value>ApplyDate</Value>
</Value>
<Value name="9">
<Value>ApplyTime</Value>
</Value>
<Value name="10">
<Value>ApplyDoctor</Value>
</Value>
<Value name="11">
<Value>FinishDate</Value>
</Value>
<Value name="12">
<Value>FinishTime</Value>
</Value>
<Value name="13">
<Value>ConsultDoctor</Value>
</Value>
<Value name="14">
<Value>ConsultType</Value>
</Value>
<Value name="15">
<Value>ConsultLoc</Value>
</Value>
<Value name="16">
<Value>ApplyLoc</Value>
</Value>
<Value name="17">
<Value>ConDestination</Value>
</Value>
<Value name="18">
<Value>Attitude</Value>
</Value>
<Value name="19">
<Value>ConsultStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.MDTD</DataLocation>
<DefaultData>MDTConsultDefaultData</DefaultData>
<IdLocation>^DHCEMRI.Events.MDTD</IdLocation>
<IndexLocation>^DHCEMRI.Events.MDTI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.MDTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
