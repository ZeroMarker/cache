Class EMRinstance.AuthAppoint Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 申请记录ID (-1:直接授权)
Property RequestID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 申请人
Property RequestUserID As %String(TRUNCATE = 1);

/// 申请科室
Property RequestDept As %String(TRUNCATE = 1);

/// 申请日期
Property RequestDate As %Date;

/// 申请时间
Property RequestTime As %Time;

/// 申请的打印ID 集合
Property RequestCateCharpter As %String(MAXLEN = 8192, TRUNCATE = 1);

/// 操作类型
/// 保存-save 打印-print 删除-delete 浏览-view 创建-creat
Property RequestAction As %String(TRUNCATE = 1);

/// 授权人
Property AppointUserID As %String(TRUNCATE = 1);

/// 授权科室
Property AppointDept As %String(TRUNCATE = 1);

/// 授权日期
Property AppointDate As %Date;

/// 授权时间
Property AppointTime As %Time;

/// 授权截止日期
Property AppointEndDate As %Date;

/// 授权截止时间
Property AppointEndTime As %Time;

/// 授权类型,0-授权给个人,1-授权给科室
Property AppointType As %String(TRUNCATE = 1);

/// 状态(N:未授权; R:已拒绝; I:过期失效; F:已授权)
Property AppointStatus As %String(TRUNCATE = 1);

/// 授权级别
Property AuthLevel As %String(TRUNCATE = 1);

/// 拒绝原因
Property RefuseReason As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 授权说明
Property AppointDesc As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 授权人
Property AppointUserID2 As %String(TRUNCATE = 1);

/// 授权科室
Property AppointDept2 As %String(TRUNCATE = 1);

/// 授权人
Property AppointUserID3 As %String(TRUNCATE = 1);

/// 授权科室
Property AppointDept3 As %String(TRUNCATE = 1);

/// 状态(N:未授权; R:已拒绝; I:过期失效; F:已授权)
Property AppointStatus1 As %String(TRUNCATE = 1);

/// 状态(N:未授权; R:已拒绝; I:过期失效; F:已授权)
Property AppointStatus2 As %String(TRUNCATE = 1);

/// 状态(N:未授权; R:已拒绝; I:过期失效; F:已授权)
Property AppointStatus3 As %String(TRUNCATE = 1);

/// 授权日期
Property OperDate1 As %Date;

/// 授权时间
Property OperTime1 As %Time;

/// 授权日期
Property OperDate2 As %Date;

/// 授权时间
Property OperTime2 As %Time;

/// 授权日期
Property OperDate3 As %Date;

/// 授权时间
Property OperTime3 As %Time;

/// 关联授权
Property RelatedAppoint As %String;

Index IdxEpisode On EpisodeID;

Index IdxRequest On RequestID;

Index IdxAstatus On AppointStatus;

Index IdxRequestDt On (AppointStatus, RequestDate);

Index IdxAppointDt On (AppointStatus, AppointDate);

Index IdxStatusEpisode On (AppointStatus, EpisodeID);

Index IdxRequestDt1 On (AppointStatus1, RequestDate);

Index IdxAppointDt1 On (AppointStatus1, AppointDate);

Index IdxStatusEpisode1 On (AppointStatus1, EpisodeID);

Index IdxRequestDt2 On (AppointStatus2, RequestDate);

Index IdxAppointDt2 On (AppointStatus2, AppointDate);

Index IdxStatusEpisode2 On (AppointStatus2, EpisodeID);

Index IdxRequestDt3 On (AppointStatus3, RequestDate);

Index IdxAppointDt3 On (AppointStatus3, AppointDate);

Index IdxStatusEpisode3 On (AppointStatus3, EpisodeID);

Index IdxRelatedAppoint On RelatedAppoint;

Storage Default
{
<Data name="AuthAppointDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>RequestUserID</Value>
</Value>
<Value name="5">
<Value>RequestDept</Value>
</Value>
<Value name="6">
<Value>RequestDate</Value>
</Value>
<Value name="7">
<Value>RequestTime</Value>
</Value>
<Value name="8">
<Value>AppointUserID</Value>
</Value>
<Value name="9">
<Value>AppointDate</Value>
</Value>
<Value name="10">
<Value>AppointTime</Value>
</Value>
<Value name="11">
<Value>AppointEndDate</Value>
</Value>
<Value name="12">
<Value>AppointEndTime</Value>
</Value>
<Value name="13">
<Value>AppointType</Value>
</Value>
<Value name="14">
<Value>AppointStatus</Value>
</Value>
<Value name="15">
<Value>AuthLevel</Value>
</Value>
<Value name="16">
<Value>RefuseReason</Value>
</Value>
<Value name="17">
<Value>RequestCateCharpter</Value>
</Value>
<Value name="18">
<Value>RequestAction</Value>
</Value>
<Value name="19">
<Value>AppointUserID2</Value>
</Value>
<Value name="20">
<Value>AppointDesc</Value>
</Value>
<Value name="21">
<Value>AppointUserID3</Value>
</Value>
<Value name="22">
<Value>AppointStatus2</Value>
</Value>
<Value name="23">
<Value>AppointStatus3</Value>
</Value>
<Value name="24">
<Value>OperDate1</Value>
</Value>
<Value name="25">
<Value>OperTime1</Value>
</Value>
<Value name="26">
<Value>OperDate2</Value>
</Value>
<Value name="27">
<Value>OperTime2</Value>
</Value>
<Value name="28">
<Value>OperDate3</Value>
</Value>
<Value name="29">
<Value>OperTime3</Value>
</Value>
<Value name="30">
<Value>AppointStatus1</Value>
</Value>
<Value name="31">
<Value>RelatedAppoint</Value>
</Value>
<Value name="32">
<Value>AppointDept</Value>
</Value>
<Value name="33">
<Value>AppointDept2</Value>
</Value>
<Value name="34">
<Value>AppointDept3</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AuthAppointD</DataLocation>
<DefaultData>AuthAppointDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AuthAppointD</IdLocation>
<IndexLocation>^DHCEMRI.AuthAppointI</IndexLocation>
<StreamLocation>^DHCEMRI.AuthAppointS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
