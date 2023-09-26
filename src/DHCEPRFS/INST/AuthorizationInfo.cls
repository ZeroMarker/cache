Class DHCEPRFS.INST.AuthorizationInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 归档就诊号
Property MREpisodeID As %String(TRUNCATE = 1);

/// 批准日期
Property AppointDate As %Date;

/// 批准时间
Property AppointTime As %Time;

/// 批准人
Property AppointUserID As %String(TRUNCATE = 1);

/// 申请人
Property RequestUserID As %String(TRUNCATE = 1);

/// 申请科室
Property RequestDept As %String(TRUNCATE = 1);

/// 申请日期
Property RequestDate As %Date;

/// 申请时间
Property RequestTime As %Time;

/// 申请信息
Property RequestComment As %String(TRUNCATE = 1);

/// 申请操作(SCAN:扫描; REVOKE:撤销提交)
Property RequestAct As %String(TRUNCATE = 1);

/// 申请类型(DOCTOR:医生; NURSE:护士)
Property RequestType As %String(TRUNCATE = 1);

/// 授权类型(N:申请未授权; R:拒绝; F:完成授权)
Property AppointStatus As %String(TRUNCATE = 1);

/// 批准内容
Property AppointComment As %String(TRUNCATE = 1);

Index IdxMREpisodeID On MREpisodeID;

Index IdxAppointStatus On AppointStatus;

Index IdxEpisodeID On EpisodeID;

Index IdxStatusRequestDt On (AppointStatus, RequestDate, RequestTime);

Index IdxRequestActStatus On (RequestAct, AppointStatus, RequestDate, RequestTime);

Storage Default
{
<Data name="AuthorizationInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>MREpisodeID</Value>
</Value>
<Value name="4">
<Value>AppointDate</Value>
</Value>
<Value name="5">
<Value>AppointTime</Value>
</Value>
<Value name="6">
<Value>AppointUserID</Value>
</Value>
<Value name="7">
<Value>RequestUserID</Value>
</Value>
<Value name="8">
<Value>RequestDept</Value>
</Value>
<Value name="9">
<Value>RequestDate</Value>
</Value>
<Value name="10">
<Value>RequestTime</Value>
</Value>
<Value name="11">
<Value>RequestComment</Value>
</Value>
<Value name="12">
<Value>RequestAct</Value>
</Value>
<Value name="13">
<Value>RequestType</Value>
</Value>
<Value name="14">
<Value>AppointStatus</Value>
</Value>
<Value name="15">
<Value>AppointComment</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AuthorizationD</DataLocation>
<DefaultData>AuthorizationInfoDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.AuthorizationD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AuthorizationI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AuthorizationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
