/// Desc:       上级医师设置
/// Creaotr:    Candy
/// CreateDate: 2016-09-18
Class EMRmeta.SuperDoctor Extends (%Persistent, %XML.Adaptor)
{

Index IdxUser On (UserID, LocID) [ Unique ];

Index IdxUserSuper On (UserID, SuperDoctorID);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 用户级别
Property UserLevel As %String(TRUNCATE = 1);

/// 上级医师ID
Property SuperDoctorID As %String(TRUNCATE = 1);

/// 上级医师级别
Property SuperDoctorLevel As %String(TRUNCATE = 1);

/// 用户科室
Property LocID As %String;

/// 用户安全组
Property SSGroupID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SuperDoctorDefaultData">
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
<Value>SuperDoctorID</Value>
</Value>
<Value name="5">
<Value>SuperDoctorLevel</Value>
</Value>
<Value name="6">
<Value>LocID</Value>
</Value>
<Value name="7">
<Value>SSGroupID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SuperDoctorD</DataLocation>
<DefaultData>SuperDoctorDefaultData</DefaultData>
<IdLocation>^DHCEMRM.SuperDoctorD</IdLocation>
<IndexLocation>^DHCEMRM.SuperDoctorI</IndexLocation>
<StreamLocation>^DHCEMRM.SuperDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
