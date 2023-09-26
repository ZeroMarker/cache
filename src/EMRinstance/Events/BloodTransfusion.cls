/// 名称:EMRinstance.Events.BloodTransfusion
/// 描述:实例数据-医疗活动事件-输血
/// 编写者：Guozongtao
/// 编写日期: 2014-08-16
Class EMRinstance.Events.BloodTransfusion Extends (%Persistent, %XML.Adaptor)
{

Index IdxEpisodeIsActive On (EpisodeID, IsActive, TransDate, TransTime);

Property PatientID As %String;

Property EpisodeID As %String;

/// 输血医嘱ID
Property OEordItemID As %String;

Property OEordItemDesc As %String;

/// 输血日期
Property TransDate As %Date;

Property TransTime As %Time;

/// abo血型
Property BloodTypeabo As %String;

/// rh血型
Property BloodTyperh As %String;

/// 申请内容
Property Content As %String;

/// 说明
Property Description As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 不否活动
Property IsActive As %String;

/// 输血申请单ID
Property BloodID As %String;

Storage Default
{
<Data name="BloodTransfusionDefaultData">
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
<Value>TransDate</Value>
</Value>
<Value name="7">
<Value>TransTime</Value>
</Value>
<Value name="8">
<Value>BloodTypeabo</Value>
</Value>
<Value name="9">
<Value>BloodTyperh</Value>
</Value>
<Value name="10">
<Value>Content</Value>
</Value>
<Value name="11">
<Value>Description</Value>
</Value>
<Value name="12">
<Value>CreateDate</Value>
</Value>
<Value name="13">
<Value>CreateTime</Value>
</Value>
<Value name="14">
<Value>IsActive</Value>
</Value>
<Value name="15">
<Value>BloodID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.BloodD</DataLocation>
<DefaultData>BloodTransfusionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.Events.BloodD</IdLocation>
<IndexLocation>^DHCEMRI.Events.BloodI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.BloodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IdxBloodID On BloodID [ Unique ];

}
