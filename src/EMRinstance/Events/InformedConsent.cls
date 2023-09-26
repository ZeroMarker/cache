/// 名称:EMRinstance.Events.InformedConsent
/// 描述:实例数据-医疗活动事件-知情同意书
/// 编写者：王煜
/// 编写日期: 2021-09-07
Class EMRinstance.Events.InformedConsent Extends %Persistent
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

/// 是否活动
Property IsActive As %String;

Index IdxEpisodeIsActive On (EpisodeID, IsActive, OEordItemDate, OEordItemTime);

Storage Default
{
<Data name="InformedConsentDefaultData">
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
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
<Value name="9">
<Value>OEordItemCreatorID</Value>
</Value>
<Value name="10">
<Value>OEordItemCreatorName</Value>
</Value>
<Value name="11">
<Value>OEordItemDate</Value>
</Value>
<Value name="12">
<Value>OEordItemTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.InformedConD</DataLocation>
<DefaultData>InformedConsentDefaultData</DefaultData>
<IdLocation>^DHCEMRI.Events.InformedConD</IdLocation>
<IndexLocation>^DHCEMRI.Events.InformedConI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.InformedConS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
