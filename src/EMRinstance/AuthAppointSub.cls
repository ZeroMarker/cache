Class EMRinstance.AuthAppointSub Extends %Persistent
{

Index IdxEpisodeID On EpisodeID;

Index IdxStatusEpisodeIDObjID On (Status, EpisodeID, ObjID);

Index IdxStatusObjIDEpisodeID On (Status, ObjID, EpisodeID);

/// 类型(会诊授权:IC;检查授权:IP;检验授权:IL 等都是I开头，表示InterfaceService业务)
Property Status As %String(TRUNCATE = 1);

/// 相关业务模块ID
Property ObjID As %String(TRUNCATE = 1);

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 申请授权记录ID
Property AppointID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AuthAppointSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>ObjID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>AppointID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AuthAppointSubD</DataLocation>
<DefaultData>AuthAppointSubDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AuthAppointSubD</IdLocation>
<IndexLocation>^DHCEMRI.AuthAppointSubI</IndexLocation>
<StreamLocation>^DHCEMRI.AuthAppointSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
