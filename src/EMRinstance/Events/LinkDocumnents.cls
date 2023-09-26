/// 名称:EMRinstance.Events.LinkDocumnents
/// 描述:实例数据-医疗活动事件-医疗活动记录链接表
/// 编写者：Guozongtao
/// 编写日期: 2014-08-16
Class EMRinstance.Events.LinkDocumnents Extends %Persistent
{

Index IdxMain On (EpisodeID, EventType, EventsID, InstanceID) [ Unique ];

Index IdxEpisodeEventChartItemID On (EpisodeID, EventType, EventsID, ChartItemID);

Index IdxEpisodeEventChartItemTitleCode On (EpisodeID, EventType, EventsID, ChartItemID, TitleCode);

Index IdxEpisodeEventChartItemInstanceID On (EpisodeID, EventType, EventsID, ChartItemID, InstanceID);

Index IdxInstanceType On (InstanceID, EventType);

Property PatientID As %String;

Property EpisodeID As %String;

/// EMRinstance.Events.BloodTransfusion.ID
/// EMRinstance.Events.CriticalValue.ID
/// EMRinstance.Events.Operation.ID
/// EMRinstance.Events.Rescue.ID
/// EMRinstance.Events.Manipulate.ID
Property EventsID As %String;

///  枚举值：BloodTransfusion 输血 CriticalValue 危急值  Operation 手术操作 Rescue 抢救  Manipulate 操作 Consult:会诊 MDTConsult:MDT会诊
Property EventType As %String;

Property InstanceID As %String;

Property ChartItemID As %String;

Property TitleCode As %String;

/// 事件产品唯一标识，例如危急值ID会诊ID等
Property FromCode As %String;

/// 关联用户ID
Property UserID As %String;

Storage Default
{
<Data name="LinkDocumnentsDefaultData">
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
<Value>EventsID</Value>
</Value>
<Value name="5">
<Value>EventType</Value>
</Value>
<Value name="6">
<Value>InstanceID</Value>
</Value>
<Value name="7">
<Value>ChartItemID</Value>
</Value>
<Value name="8">
<Value>TitleCode</Value>
</Value>
<Value name="9">
<Value>FromCode</Value>
</Value>
<Value name="10">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.LinkDocumnentsD</DataLocation>
<DefaultData>LinkDocumnentsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.Events.LinkDocumnentsD</IdLocation>
<IndexLocation>^DHCEMRI.Events.LinkDocumnentsI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.LinkDocumnentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
