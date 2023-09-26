/// Desc:       患者三级医师级别设置
/// Creaotr:    Donglulu
/// CreateDate: 2019-11-13
Class EMRinstance.PatientDoctor Extends (%Persistent, %XML.Adaptor)
{

/// 就诊ID
Property EpisodeID As %String;

/// 患者医师ID
Property DoctorUserID As %String(TRUNCATE = 1);

/// 患者医师级别代码
Property DoctorLevelCode As %String(TRUNCATE = 1);

/// 登录用户ID
Property UserID As %String(TRUNCATE = 1);

/// 登录科室
Property LocID As %String;

/// 设置日期
Property AppDate As %Date;

/// 设置时间
Property AppTime As %Time;

Index IdxEpisodeIDLevelCode On (EpisodeID, DoctorLevelCode) [ Unique ];

Index IdxEpisodeIDLevelDoc On (EpisodeID, DoctorLevelCode, DoctorUserID);

Index IdxEpisodeIDDoctorID On (EpisodeID, DoctorUserID);

Storage Default
{
<Data name="PatientDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>UserLevel</Value>
</Value>
<Value name="5">
<Value>SuperDoctorID</Value>
</Value>
<Value name="6">
<Value>SuperDoctorLevel</Value>
</Value>
<Value name="7">
<Value>LocID</Value>
</Value>
<Value name="8">
<Value>SSGroupID</Value>
</Value>
<Value name="9">
<Value>LevelCode</Value>
</Value>
<Value name="10">
<Value>AppDate</Value>
</Value>
<Value name="11">
<Value>AppTime</Value>
</Value>
<Value name="12">
<Value>DoctorUserID</Value>
</Value>
<Value name="13">
<Value>DoctorLevelCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PatientDoctorD</DataLocation>
<DefaultData>PatientDoctorDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PatientDoctorD</IdLocation>
<IndexLocation>^DHCEMRI.PatientDoctorI</IndexLocation>
<StreamLocation>^DHCEMRI.PatientDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
