/// 名称:EMRinstance.LisDataReference
/// 描述:检验引用记录信息表
/// 编写者：DongLulu
Class EMRinstance.LisDataReference Extends (%Persistent, %XML.Adaptor)
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// UserID
Property UserID As %String;

/// 医嘱ID
Property OEordItemID As %String;

Property OEordItemDesc As %String;

/// 引用日期
Property ReferenceDate As %Date;

/// 引用时间
Property ReferenceTime As %Time;

Index IdxEpisodeIDUserIDOEordItemID On (EpisodeID, UserID, OEordItemID);

Index IdxEpisodeIDOEordItemID On (EpisodeID, OEordItemID);

Storage Default
{
<Data name="LisDataReferenceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>OEordItemID</Value>
</Value>
<Value name="6">
<Value>OEordItemDesc</Value>
</Value>
<Value name="7">
<Value>ReferenceDate</Value>
</Value>
<Value name="8">
<Value>ReferenceTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.LisDataReferenceD</DataLocation>
<DefaultData>LisDataReferenceDefaultData</DefaultData>
<IdLocation>^DHCEMRI.LisDataReferenceD</IdLocation>
<IndexLocation>^DHCEMRI.LisDataReferenceI</IndexLocation>
<StreamLocation>^DHCEMRI.LisDataReferenceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
