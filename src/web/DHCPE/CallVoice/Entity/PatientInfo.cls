Class web.DHCPE.CallVoice.Entity.PatientInfo Extends (%Persistent, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 窗口诊室名称
Property WindowName As %String(TRUNCATE = 1);

/// 计算机名称
Property WindowIP As %String(TRUNCATE = 1);

/// 技师
Property WindowDoctor As %String(TRUNCATE = 1);

/// 主任医师
Property WindowDocPro As %String(TRUNCATE = 1);

/// 外科
Property WindowDept As %String(TRUNCATE = 1);

/// 说明
Property WindowNote As %String(TRUNCATE = 1);

/// <State>Reg/Cancel</State >
Property State As %String(TRUNCATE = 1);

/// IP
Property IP As %String(TRUNCATE = 1);

/// 急诊/VIP/普通
Property Priority As %String(TRUNCATE = 1);

/// 排队号
Property QueueNo As %String(TRUNCATE = 1);

/// 姓名
Property PatientName As %String(TRUNCATE = 1);

/// 性别
Property PatientSex As %String(TRUNCATE = 1);

/// 检查号
Property RegisterNo As %String(TRUNCATE = 1);

/// 就诊科室
Property Department As %String(TRUNCATE = 1);

/// 队列类别
Property CheckCat As %String(TRUNCATE = 1);

/// 预约日期
Property ScheduleDate As %String(TRUNCATE = 1);

/// 检查分组
Property StudyGroup As %String(TRUNCATE = 1);

/// 检查技师
Property Doctor As %String(TRUNCATE = 1);

/// 当前呼叫患者信息2513052724
Property VisitingPatients As list Of VisitingPatient;

/// 等候患者信息
Property WaitingPatients As list Of WaitingPatient;

/// 过号患者信息
Property SkipPatients As list Of SkipPatient;

Storage Default
{
<Data name="PatientInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SkipPatients</Value>
</Value>
<Value name="3">
<Value>VisitingPatients</Value>
</Value>
<Value name="4">
<Value>WaitingPatients</Value>
</Value>
<Value name="5">
<Value>WindowDept</Value>
</Value>
<Value name="6">
<Value>WindowDocPro</Value>
</Value>
<Value name="7">
<Value>WindowDoctor</Value>
</Value>
<Value name="8">
<Value>WindowIP</Value>
</Value>
<Value name="9">
<Value>WindowName</Value>
</Value>
<Value name="10">
<Value>WindowNote</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>IP</Value>
</Value>
<Value name="13">
<Value>Priority</Value>
</Value>
<Value name="14">
<Value>QueueNo</Value>
</Value>
<Value name="15">
<Value>PatientName</Value>
</Value>
<Value name="16">
<Value>RegisterNo</Value>
</Value>
<Value name="17">
<Value>Department</Value>
</Value>
<Value name="18">
<Value>CheckCat</Value>
</Value>
<Value name="19">
<Value>ScheduleDate</Value>
</Value>
<Value name="20">
<Value>StudyGroup</Value>
</Value>
<Value name="21">
<Value>Doctor</Value>
</Value>
<Value name="22">
<Value>PatientSex</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CallV91B.PatientInfoD</DataLocation>
<DefaultData>PatientInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CallV91B.PatientInfoD</IdLocation>
<IndexLocation>^web.DHCPE.CallV91B.PatientInfoI</IndexLocation>
<StreamLocation>^web.DHCPE.CallV91B.PatientInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
