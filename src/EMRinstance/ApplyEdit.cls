/// Desc:       申请编辑情况表（自动审批）
/// Creator:    DongLuLu
/// CreateDate: 2017-10-18
Class EMRinstance.ApplyEdit Extends (%Persistent, %XML.Adaptor)
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 实例ID
Property InstanceID As %String(TRUNCATE = 1);

/// 申请人
Property ApplyUserID As %String;

/// 申请日期
Property ApplyDate As %Date;

/// 申请时间
Property ApplyTime As %Time;

/// 申请ID(EMRinstance.AuthAppoint表的ID)
Property AppointID As %String(TRUNCATE = 1);

Index IndexApplyUserIDInstanceID On (ApplyUserID, InstanceID);

Index IndexEpisodeIDAppointID On (EpisodeID, AppointID);

Storage Default
{
<Data name="ApplyEditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>InstanceID</Value>
</Value>
<Value name="4">
<Value>ApplyUserID</Value>
</Value>
<Value name="5">
<Value>ApplyDate</Value>
</Value>
<Value name="6">
<Value>ApplyTime</Value>
</Value>
<Value name="7">
<Value>AppointID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ApplyEditD</DataLocation>
<DefaultData>ApplyEditDefaultData</DefaultData>
<IdLocation>^DHCEMRI.ApplyEditD</IdLocation>
<IndexLocation>^DHCEMRI.ApplyEditI</IndexLocation>
<StreamLocation>^DHCEMRI.ApplyEditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
