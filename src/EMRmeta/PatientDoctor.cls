/// Desc:       患者三级医师级别基础数据
/// Creaotr:    Donglulu
/// CreateDate: 2019-11-13
Class EMRmeta.PatientDoctor Extends (%Persistent, %XML.Adaptor)
{

/// 用户级别代码
Property LevelCode As %String(TRUNCATE = 1);

/// 用户级别描述
Property LevelDesc As %String(TRUNCATE = 1);

/// 级别高低（1,2,3...）
Property RoleLevel As %Integer;

Index IdxLevelCode On LevelCode [ Unique ];

Index IdxRoleLevel On RoleLevel;

Index IdxLevelCodeRoleLevel On (LevelCode, RoleLevel);

Storage Default
{
<Data name="PatientDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserLevel</Value>
</Value>
<Value name="3">
<Value>RoleLevel</Value>
</Value>
<Value name="4">
<Value>LevelCode</Value>
</Value>
<Value name="5">
<Value>LevelDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PatientDoctorD</DataLocation>
<DefaultData>PatientDoctorDefaultData</DefaultData>
<IdLocation>^DHCEMRM.PatientDoctorD</IdLocation>
<IndexLocation>^DHCEMRM.PatientDoctorI</IndexLocation>
<StreamLocation>^DHCEMRM.PatientDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
