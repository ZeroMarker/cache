/// 名称:EMRinstance.Events.Manipulate
/// 描述:实例数据-医疗活动事件-操作信息
/// 编写者：DongLulu
/// 编写日期: 2017-09-12
Class EMRinstance.Events.Manipulate Extends %Persistent
{

Property PatientID As %String;

Property EpisodeID As %String;

/// 操作医嘱ID
Property OEordItemID As %String;

/// 操作医嘱描述
Property OEordItemDesc As %String;

/// 操作医嘱创建用户ID
Property OEordItemCreatorID As %String;

/// 操作医嘱创建用户姓名描述
Property OEordItemCreatorName As %String;

/// 开医嘱日期
Property OEordItemDate As %Date;

/// 开医嘱时间
Property OEordItemTime As %Time;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 不否活动
Property IsActive As %String;

Index IdxEpisodeIsActive On (EpisodeID, IsActive, OEordItemDate, OEordItemTime);

Storage Default
{
<Data name="ManipulateDefaultData">
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
<Value>OEordItemDesc</Value>
</Value>
<Value name="6">
<Value>OEordItemCreator</Value>
</Value>
<Value name="7">
<Value>OEordItemDate</Value>
</Value>
<Value name="8">
<Value>OEordItemTime</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>AOEordItemCreatorID</Value>
</Value>
<Value name="13">
<Value>AOEordItemCreatorName</Value>
</Value>
<Value name="14">
<Value>OEordItemCreatorID</Value>
</Value>
<Value name="15">
<Value>OEordItemCreatorName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.ManipulateD</DataLocation>
<DefaultData>ManipulateDefaultData</DefaultData>
<IdLocation>^DHCEMRI.Events.ManipulateD</IdLocation>
<IndexLocation>^DHCEMRI.Events.ManipulateI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.ManipulateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
