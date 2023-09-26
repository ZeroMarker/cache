/// 名称: 当前病历所处科室(新框架)
/// 描述: 指定病历所在的科室。用于转科后，原转出科室补写病历，加载原科室模板的问题
/// 编写者：guozongtao
/// 编写日期: 2014-01-07
Class EMRinstance.EMRDept Extends %Persistent
{

Index EpisodeIDIdx On EpisodeID [ Unique ];

Index EpisodeAndActIdx On (EpisodeID, IsActivity);

//病人就诊号

Property EpisodeID As %String(TRUNCATE = 1);

//指定到科室

Property EMRDept As %String(TRUNCATE = 1);

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
<DataLocation>^DHCEMRI.EMRDeptD</DataLocation>
<DefaultData>EMRDeptDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.EMRDeptD</IdLocation>
<IndexLocation>^DHCEMRI.EMRDeptI</IndexLocation>
<StreamLocation>^DHCEMRI.EMRDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
