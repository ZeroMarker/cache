Class EMRinstance.AuthRequest Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 申请人
Property RequestUserID As %String(TRUNCATE = 1);

/// 申请科室
Property RequestDept As %String(TRUNCATE = 1);

/// 申请号码
Property RequestNumber As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 发出申请的日期
Property RequestDate As %Date;

/// 发出申请的时间
Property RequestTime As %Time;

/// 申请原因
Property RequestReason As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 申请前内容
Property BeforeRequestContent As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 申请后欲修改的内容
Property AfterRequestContent As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 申请的打印ID 集合
Property RequestCateCharpter As %String(MAXLEN = 8192, TRUNCATE = 1);

/// 操作类型
/// 保存-save 打印-print 删除-delete 浏览-view 创建-creat
Property RequestAction As %String(TRUNCATE = 1);

Index IdxEpisode On EpisodeID;

Index IdxReqUser On RequestUserID;

Index IdxReqDt On RequestDate;

Index IdxReqDtUser On (RequestDate, RequestUserID);

Index IdxReqDtDeptUser On (RequestDate, RequestDept);

Storage Default
{
<Data name="AuthRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RequestUserID</Value>
</Value>
<Value name="4">
<Value>RequestDept</Value>
</Value>
<Value name="5">
<Value>RequestDate</Value>
</Value>
<Value name="6">
<Value>RequestTime</Value>
</Value>
<Value name="7">
<Value>RequestReason</Value>
</Value>
<Value name="8">
<Value>BeforeRequestContent</Value>
</Value>
<Value name="9">
<Value>AfterRequestContent</Value>
</Value>
<Value name="10">
<Value>RequestCateCharpter</Value>
</Value>
<Value name="11">
<Value>RequestAction</Value>
</Value>
<Value name="12">
<Value>RequestNumber</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AuthRequestD</DataLocation>
<DefaultData>AuthRequestDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AuthRequestD</IdLocation>
<IndexLocation>^DHCEMRI.AuthRequestI</IndexLocation>
<StreamLocation>^DHCEMRI.AuthRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
