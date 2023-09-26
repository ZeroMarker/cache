/// 名称:	EMR.DB1.EMRDept
/// 描述:	当前门诊病历所处科室
/// 编写者：yejian
/// 编写日期: 2022-6-8
/// 产品组：电子病历产品组
Class EMR.DB1.EMRDept Extends %Persistent
{

Index EpisodeIDIdx On EpisodeID [ Unique ];

Index EpisodeAndActIdx On (EpisodeID, IsActivity);

/// 病人就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 指定到科室
Property EMRDept As %String(TRUNCATE = 1);

/// 起始日期（指定日期）
Property StartDate As %Date;

/// 起始时间（指定时间）
Property StartTime As %Time;

/// 截止日期
Property EndDate As %Date;

/// 截止时间
Property EndTime As %Time;

/// 是否处于有效状态（Y--是 N--否）
Property IsActivity As %String(TRUNCATE = 1);

/// 指定病历科室的医生ID
Property AppointUserID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EMRDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EMRDept</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>EndTime</Value>
</Value>
<Value name="8">
<Value>IsActivity</Value>
</Value>
<Value name="9">
<Value>AppointUserID</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.EMRDeptD</DataLocation>
<DefaultData>EMRDeptDefaultData</DefaultData>
<IdLocation>^EMR.DB1.EMRDeptD</IdLocation>
<IndexLocation>^EMR.DB1.EMRDeptI</IndexLocation>
<StreamLocation>^EMR.DB1.EMRDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
