Class EMRinstance.AuthAppointDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 授权记录ID
Property AppointID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 模板ID(DocID或InstanceID)
Property CateCharpter As %String(MAXLEN = 8192, TRUNCATE = 1);

/// 操作类型
/// 保存-save 打印-print 删除-delete 浏览-view 创建-creat
Property Action As %String(TRUNCATE = 1);

/// 授权状态(1:权限已授予; 0:权限未授予)
Property DetailStatus As %String(TRUNCATE = 1);

/// 授权记录(1:进行过授权记录或修改过操作类型; 0:未操作过)
Property Modify As %String(TRUNCATE = 1);

Index IdxEpisode On EpisodeID;

Index IdxAppoint On AppointID;

Index IdxCharpterAppoint On (CateCharpter, AppointID);

Index IdxActionAppoint On (Action, AppointID);

Index IdxAppointCharpter On (AppointID, CateCharpter);

Index IdxAppointAction On (AppointID, Action);

Index IdxEpisodeCharpter On (EpisodeID, CateCharpter);

Storage Default
{
<Data name="AuthAppointDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppointID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>CateCharpter</Value>
</Value>
<Value name="5">
<Value>Action</Value>
</Value>
<Value name="6">
<Value>DetailStatus</Value>
</Value>
<Value name="7">
<Value>Modify</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AuthAppointDetailD</DataLocation>
<DefaultData>AuthAppointDetailDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AuthAppointDetailD</IdLocation>
<IndexLocation>^DHCEMRI.AuthAppointDetailI</IndexLocation>
<StreamLocation>^DHCEMRI.AuthAppointDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
