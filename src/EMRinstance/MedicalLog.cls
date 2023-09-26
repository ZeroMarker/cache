/// 名称:EMRinstance.MedicalLog
/// 描述:编目传送记录表
/// 编写者：lina
/// 编写日期: 2020-03-04
Class EMRinstance.MedicalLog Extends %Persistent
{

Index IdxEpisodeIDMedicalDateTime On (EpisodeID, MedicalDate, MedicalTime);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 编目日期
Property MedicalDate As %Date;

/// 编目时间
Property MedicalTime As %Time;

/// 操作用户ID
Property OperateUserID As %String(TRUNCATE = 1);

/// 操作用户名称
Property OperateUserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property OperateMachineIP As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>MedicalDate</Value>
</Value>
<Value name="4">
<Value>MedicalTime</Value>
</Value>
<Value name="5">
<Value>OperateUserID</Value>
</Value>
<Value name="6">
<Value>OperateUserName</Value>
</Value>
<Value name="7">
<Value>OperateMachineIP</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalLogD</DataLocation>
<DefaultData>MedicalLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.MedicalLogD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalLogI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
