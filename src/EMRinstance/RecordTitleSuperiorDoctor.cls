/// Desc:       记录病程记录中选择的医师信息
/// Creator:    董璐璐
/// CreateDate: 2018-7-20
Class EMRinstance.RecordTitleSuperiorDoctor Extends (%Persistent, %XML.Adaptor)
{

/// 用户ID(=TrakID)
Property UserID As %String(TRUNCATE = 1);

/// 医生级别 Resident, Attending, Chief
Property UserLevel As %String(TRUNCATE = 1);

/// 医生级别描述
Property UserLevelDesc As %String(TRUNCATE = 1);

/// 医生姓名
Property UserName As %String(TRUNCATE = 1);

/// 病历ID
Property InstanceID As %String(TRUNCATE = 1);

Index IdxInstanceIDUserID On (InstanceID, UserID) [ Unique ];

Index IdxInstanceID On InstanceID [ Unique ];

Storage Default
{
<Data name="RecordTitleSuperiorDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>UserLevel</Value>
</Value>
<Value name="4">
<Value>UserLevelDesc</Value>
</Value>
<Value name="5">
<Value>UserName</Value>
</Value>
<Value name="6">
<Value>InstanceID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.TitleDoctorD</DataLocation>
<DefaultData>RecordTitleSuperiorDoctorDefaultData</DefaultData>
<IdLocation>^DHCEMRI.TitleDoctorD</IdLocation>
<IndexLocation>^DHCEMRI.TitleDoctorI</IndexLocation>
<StreamLocation>^DHCEMRI.TitleDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
