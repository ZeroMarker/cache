Class EMRinstance.EMRActionAppoint Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 批准日期
Property AppointDate As %Date;

/// 批准时间
Property AppointTime As %Time;

/// 截止日期
Property AppointEndDate As %Date;

/// 截止时间
Property AppointEndTime As %Time;

/// 申请的打印ID 集合
Property RequestCateCharpter As %String(MAXLEN = 8192, TRUNCATE = 1);

/// 批准的打印ID 集合
Property AppointCateCharpter As %String(MAXLEN = 8192, TRUNCATE = 1);

/// 批准人
Property AppointUserID As %String(TRUNCATE = 1);

/// 申请人
Property RequestUserID As %String(TRUNCATE = 1);

/// 申请科室
Property RequestDept As %String(TRUNCATE = 1);

/// 发出申请的日期
Property RequestDate As %Date;

/// 发出申请的时间
Property RequestTime As %Time;

/// 操作类型
/// 界面模板浏览-view 保存-save 打印-print 提交-commit 切换模板-switch 更新模板-switchtemplate
/// 主任医师签名-chiefcheck 主治医生签名-attendingcheck 病历浏览-browse
Property EPRAction As %String(TRUNCATE = 1);

/// 授权类型,0-授权给个人,1-授权给科室
Property AppointType As %String(TRUNCATE = 1);

/// 授权类型(N:正常; R:拒绝; I:过期失效; F:完成)
Property AppointStatus As %String(TRUNCATE = 1);

/// 申请原因
Property RequestReason As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 申请前内容
Property BeforeRequestContent As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 申请后欲修改的内容
Property AfterRequestContent As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 申请号码
Property RequestNumber As %String;

/// 授权级别
Property AuthLevel As %String(TRUNCATE = 1);

///  拒绝原因
Property RefuseReason As %String(MAXLEN = 1024, TRUNCATE = 1);

Index IdxAstatus On AppointStatus;

Index IdxRequestDt On (AppointStatus, RequestDate);

Index IdxAppointDt On (AppointStatus, AppointDate);

Index IdxEpisode On EpisodeID;

Index IdxStatusEpisode On (AppointStatus, EpisodeID);

Storage Default
{
<Data name="EMRActionAppointDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>AppointDate</Value>
</Value>
<Value name="4">
<Value>AppointTime</Value>
</Value>
<Value name="5">
<Value>AppointEndDate</Value>
</Value>
<Value name="6">
<Value>AppointEndTime</Value>
</Value>
<Value name="7">
<Value>RequestCateCharpter</Value>
</Value>
<Value name="8">
<Value>AppointCateCharpter</Value>
</Value>
<Value name="9">
<Value>AppointUserID</Value>
</Value>
<Value name="10">
<Value>RequestUserID</Value>
</Value>
<Value name="11">
<Value>RequestDept</Value>
</Value>
<Value name="12">
<Value>RequestDate</Value>
</Value>
<Value name="13">
<Value>RequestTime</Value>
</Value>
<Value name="14">
<Value>EPRAction</Value>
</Value>
<Value name="15">
<Value>AppointType</Value>
</Value>
<Value name="16">
<Value>AppointStatus</Value>
</Value>
<Value name="17">
<Value>RequestReason</Value>
</Value>
<Value name="18">
<Value>BeforeRequestContent</Value>
</Value>
<Value name="19">
<Value>AfterRequestContent</Value>
</Value>
<Value name="20">
<Value>AuthLevel</Value>
</Value>
<Value name="21">
<Value>RefuseReason</Value>
</Value>
<Value name="22">
<Value>RequestNumber</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.EMRActionAppointD</DataLocation>
<DefaultData>EMRActionAppointDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.EMRActionAppointD</IdLocation>
<IndexLocation>^DHCEMRI.EMRActionAppointI</IndexLocation>
<StreamLocation>^DHCEMRI.EMRActionAppointS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
