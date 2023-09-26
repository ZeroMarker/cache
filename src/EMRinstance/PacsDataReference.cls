/// 名称:EMRinstance.PacsDataReference
/// 描述:检查引用记录信息表
/// 编写者：DongLulu
Class EMRinstance.PacsDataReference Extends %Persistent
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

Index IdxEpisodeIDOEordItemID On (EpisodeID, OEordItemID);

Storage Default
{
<Data name="PacsDataReferenceDefaultData">
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
<Value>OEordItemID</Value>
</Value>
<Value name="5">
<Value>OEordItemDesc</Value>
</Value>
<Value name="6">
<Value>ReferenceDate</Value>
</Value>
<Value name="7">
<Value>ReferenceTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PacsDataReferenceD</DataLocation>
<DefaultData>PacsDataReferenceDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PacsDataReferenceD</IdLocation>
<IndexLocation>^DHCEMRI.PacsDataReferenceI</IndexLocation>
<StreamLocation>^DHCEMRI.PacsDataReferenceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
