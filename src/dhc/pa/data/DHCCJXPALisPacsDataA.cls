Class dhc.pa.data.DHCCJXPALisPacsDataA Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

//医嘱号

Property DoctorAdviceNo As %String [ SqlColumnNumber = 7 ];

//医嘱ID

Property DoctorAdviceID As %String [ SqlColumnNumber = 6 ];

//科室ID

Property DeptID As %String [ SqlColumnNumber = 4 ];

//接受科室

Property DeptName As %String [ SqlColumnNumber = 5 ];

//报告人

Property Reportor As %String [ SqlColumnNumber = 11 ];

//患者类型

Property PatientType As %String [ SqlColumnNumber = 9 ];

//申请时间

Property ApplyTime As %String [ SqlColumnNumber = 2 ];

//lis集中接收时间/pacs检查登记时间

Property LisReceiveOrPacsCheckRegTime As %String [ SqlColumnNumber = 8 ];

//接收

Property ReceiveTime As %String [ SqlColumnNumber = 10 ];

//审核

Property AuditTime As %String [ SqlColumnNumber = 3 ];

//预约等待时间

Property DateWaitTime As %String [ SqlColumnNumber = 12 ];

//出报告时间

Property ReportTime As %String [ SqlColumnNumber = 13 ];

//病人登记号

Property PatNo As %String [ SqlColumnNumber = 14 ];

//病人登记号

Property PatName As %String [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="DHCCJXPALisPacsDataADefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DoctorAdviceNo</Value>
</Value>
<Value name="3">
<Value>DoctorAdviceID</Value>
</Value>
<Value name="4">
<Value>DeptID</Value>
</Value>
<Value name="5">
<Value>DeptName</Value>
</Value>
<Value name="6">
<Value>Reportor</Value>
</Value>
<Value name="7">
<Value>PatientType</Value>
</Value>
<Value name="8">
<Value>ApplyTime</Value>
</Value>
<Value name="9">
<Value>LisReceiveOrPacsCheckRegTime</Value>
</Value>
<Value name="10">
<Value>ReceiveTime</Value>
</Value>
<Value name="11">
<Value>AuditTime</Value>
</Value>
<Value name="12">
<Value>DateWaitTime</Value>
</Value>
<Value name="13">
<Value>ReportTime</Value>
</Value>
<Value name="14">
<Value>PatNo</Value>
</Value>
<Value name="15">
<Value>PatName</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.DHCCJXPALis1079D</DataLocation>
<DefaultData>DHCCJXPALisPacsDataADefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.DHCCJXPALis1079D</IdLocation>
<IndexLocation>^dhc.pa.data.DHCCJXPALis1079I</IndexLocation>
<StreamLocation>^dhc.pa.data.DHCCJXPALis1079S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
