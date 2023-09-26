/// 名称: 当前病历所处科室(新框架)
/// 描述: 指定病历所在的科室。用于转科后，原转出科室补写病历，加载原科室模板的问题
/// 编写者：chenwenjun
/// 编写日期: 09/08/10
Class EPRinstance.EPRDept Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//病人就诊号

Property EpisodeID As %String(TRUNCATE = 1);

//指定到科室

Property EPRDept As %String(TRUNCATE = 1);

//起始日期（指定日期）

Property StartDate As %Date;

//起始时间（指定时间）

Property StartTime As %Time;

//截止日期

Property EndDate As %Date;

//截止时间

Property EndTime As %Time;

//是否处于有效状态（Y--是 N--否）

Property IsActivity As %String(TRUNCATE = 1);

//指定病历科室的医生ID

Property AppointUserID As %String(TRUNCATE = 1);

Index EpisodeIDIdx On EpisodeID [ Unique ];

Index EpisodeAndActIdx On (EpisodeID, IsActivity);

Storage Default
{
<Data name="EPRDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppointUserID</Value>
</Value>
<Value name="3">
<Value>EPRDept</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>EndTime</Value>
</Value>
<Value name="6">
<Value>EpisodeID</Value>
</Value>
<Value name="7">
<Value>IsActivity</Value>
</Value>
<Value name="8">
<Value>StartDate</Value>
</Value>
<Value name="9">
<Value>StartTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.EPRDeptD</DataLocation>
<DefaultData>EPRDeptDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.EPRDeptD</IdLocation>
<IndexLocation>^DHCEPRI.EPRDeptI</IndexLocation>
<StreamLocation>^DHCEPRI.EPRDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
