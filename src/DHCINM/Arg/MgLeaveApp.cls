/// Creater:wangpf
/// Descriptions:护士护士长请假表
/// Date:2020-06-24
Class DHCINM.Arg.MgLeaveApp Extends %Persistent
{

/// 请假来源 N：护士 H：护士长
Property LeaveSource As %String(DISPLAYLIST = ",Nurse,NurseHead", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,H") [ SqlColumnNumber = 2, SqlFieldName = Leave_Source ];

/// 请假病区
Property LeaveWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Leave_Ward ];

/// 请假类型
Property LeaveType As CF.DHCINM.DB.MgArgWardPost [ SqlColumnNumber = 4, SqlFieldName = Leave_Type ];

/// 请假开始日期
Property LeaveStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Leave_StDate ];

/// 请假开始时间
Property LeaveStTime As %Time [ SqlColumnNumber = 6, SqlFieldName = Leave_StTime ];

/// 请假结束日期
Property LeaveEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Leave_EndDate ];

/// 请假结束时间
Property LeaveEndTime As %Time [ SqlColumnNumber = 8, SqlFieldName = Leave_EndTime ];

/// 请假事由
Property LeaveReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Leave_Reason ];

/// 请假期间所在地
Property LeavePosition As %String [ SqlColumnNumber = 10, SqlFieldName = Leave_Position ];

/// 临时负责人
Property LeaveCharger As %String [ SqlColumnNumber = 11, SqlFieldName = Leave_Charger ];

/// 临时负责人联系方式
Property LeaveChargerTel As %String [ SqlColumnNumber = 12, SqlFieldName = Leave_ChargerTel ];

/// 状态 B：驳回 Y：提交 NA：护士长审核 ZA：科护士长审核 HA：护理部审核
Property LeaveStatus As %String(DISPLAYLIST = ",驳回,提交,护士长审核,科护士长审核,护理部审核", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",B,Y,NA,ZA,HA") [ SqlColumnNumber = 13, SqlFieldName = Leave_Status ];

/// 创建人
Property Creator As CF.DHCINM.HR.Persons [ SqlColumnNumber = 14, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 15, SqlFieldName = CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 16, SqlFieldName = CreateTime ];

/// 护士长审核人
Property Auditor As %String [ SqlColumnNumber = 17, SqlFieldName = Auditor ];

/// 护士长审核日期
Property AuditDate As %Date [ SqlColumnNumber = 18, SqlFieldName = AuditDate ];

/// 护士长审核时间
Property AuditTime As %Time [ SqlColumnNumber = 19, SqlFieldName = AuditTime ];

/// 科护士长审核人
Property ZAuditor As %String [ SqlColumnNumber = 20, SqlFieldName = ZAuditor ];

/// 科护士长审核日期
Property ZAuditDate As %Date [ SqlColumnNumber = 21, SqlFieldName = ZAuditDate ];

/// 科护士长审核时间
Property ZAuditTime As %Time [ SqlColumnNumber = 22, SqlFieldName = ZAuditTime ];

/// 护理部审核人
Property HAuditor As %String [ SqlColumnNumber = 23, SqlFieldName = HAuditor ];

/// 护理部审核日期
Property HAuditDate As %Date [ SqlColumnNumber = 24, SqlFieldName = HAuditDate ];

/// 护理部审核时间
Property HAuditTime As %Time [ SqlColumnNumber = 25, SqlFieldName = HAuditTime ];

/// 护士长审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 26, SqlFieldName = AuditOpinion ];

/// 科护士长审核意见
Property ZAuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 27, SqlFieldName = ZAuditOpinion ];

/// 护理部审核意见
Property HAuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 28, SqlFieldName = HAuditOpinion ];

/// 实际工作日期
Property WorkDate As list Of %Date [ SqlColumnNumber = 29, SqlFieldName = WorkDate ];

Index Source On LeaveSource;

Index Nurse On Creator;

Index WardPer On (LeaveWard, Creator, LeaveStatus);

Index LeaveType On LeaveType;

Storage Default
{
<Data name="MgLeaveAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LeaveSource</Value>
</Value>
<Value name="3">
<Value>LeaveWard</Value>
</Value>
<Value name="4">
<Value>LeaveType</Value>
</Value>
<Value name="5">
<Value>LeaveStDate</Value>
</Value>
<Value name="6">
<Value>LeaveStTime</Value>
</Value>
<Value name="7">
<Value>LeaveEndDate</Value>
</Value>
<Value name="8">
<Value>LeaveEndTime</Value>
</Value>
<Value name="9">
<Value>LeaveReason</Value>
</Value>
<Value name="10">
<Value>LeavePosition</Value>
</Value>
<Value name="11">
<Value>LeaveCharger</Value>
</Value>
<Value name="12">
<Value>LeaveChargerTel</Value>
</Value>
<Value name="13">
<Value>LeaveStatus</Value>
</Value>
<Value name="14">
<Value>Creator</Value>
</Value>
<Value name="15">
<Value>CreateDate</Value>
</Value>
<Value name="16">
<Value>CreateTime</Value>
</Value>
<Value name="17">
<Value>Auditor</Value>
</Value>
<Value name="18">
<Value>AuditDate</Value>
</Value>
<Value name="19">
<Value>AuditTime</Value>
</Value>
<Value name="20">
<Value>ZAuditor</Value>
</Value>
<Value name="21">
<Value>ZAuditDate</Value>
</Value>
<Value name="22">
<Value>ZAuditTime</Value>
</Value>
<Value name="23">
<Value>HAuditor</Value>
</Value>
<Value name="24">
<Value>HAuditDate</Value>
</Value>
<Value name="25">
<Value>HAuditTime</Value>
</Value>
<Value name="26">
<Value>AuditOpinion</Value>
</Value>
<Value name="27">
<Value>ZAuditOpinion</Value>
</Value>
<Value name="28">
<Value>HAuditOpinion</Value>
</Value>
<Value name="29">
<Value>WorkDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgLeaveAppD</DataLocation>
<DefaultData>MgLeaveAppDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgLeaveAppD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgLeaveAppI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgLeaveAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
