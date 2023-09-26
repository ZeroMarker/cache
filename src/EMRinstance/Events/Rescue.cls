/// 名称:EMRinstance.Events.Rescue
/// 描述:实例数据-医疗活动事件-抢救信息
/// 编写者：Guozongtao
/// 编写日期: 2014-08-16
Class EMRinstance.Events.Rescue Extends %Persistent
{

Index IdxEpisodeIsActive On (EpisodeID, IsActive, RescueDate, RescueTime);

Property PatientID As %String;

Property EpisodeID As %String;

/// 救医嘱ID
Property OEordItemID As %String;

/// 救医嘱描述
Property OEordItemDesc As %String;

/// 抢救日期
Property RescueDate As %Date;

Property RescueTime As %Time;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 不否活动
Property IsActive As %String;

Storage Default
{
<Data name="RescueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>OEordItemID</Value>
</Value>
<Value name="5">
<Value>RescueDate</Value>
</Value>
<Value name="6">
<Value>RescueTime</Value>
</Value>
<Value name="7">
<Value>OEordItemDesc</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.RescueD</DataLocation>
<DefaultData>RescueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.Events.RescueD</IdLocation>
<IndexLocation>^DHCEMRI.Events.RescueI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.RescueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
