/// 交叉分配信息
Class EPRinstance.Quality.AssignInfo Extends %Persistent
{

Index IdxUserID On UserID;

Index IdxEpisodeID On EpisodeID;

Index IdxIsActive On IsActive;

Index IdxLastAssignDate On LastAssignDate;

// 质控医师ID

Property UserID As %String;

// 患者就诊号

Property EpisodeID As %String;

// 是否有效

Property IsActive As %String(VALUELIST = ",Y,N");

// 分配次数

Property CKGrade As %String;

// 病历类型 门诊O\环节IA\终末ID

Property AdmType As %String;

// 上次分配时间

Property LastAssignDate As %String;

Storage Default
{
<Data name="AssignInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<Data name="DHCEPRQ.AssignInfoD">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>CKGrade</Value>
</Value>
<Value name="2">
<Value>AdmType</Value>
</Value>
<Value name="3">
<Value>LastAssignDate</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.AssignInfoD</DataLocation>
<DefaultData>DHCEPRQ.AssignInfoD</DefaultData>
<IdLocation>^DHCEPRQ.AssignInfoD</IdLocation>
<IndexLocation>^DHCEPRQ.AssignInfoI</IndexLocation>
<StreamLocation>^DHCEPRQ.AssignInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
