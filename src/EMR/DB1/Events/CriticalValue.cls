/// 名称:EMRinstance.Events.CriticalValue
/// 描述:实例数据-医疗活动事件-检验结果危急值
/// 编写者：Guozongtao(lifengbo)
/// 编写日期: 2014-08-16(2023-04-28)
Class EMR.DB1.Events.CriticalValue Extends %Persistent
{

Index IdxEpisodeIDLabNo On (EpisodeID, LabNo);

Index IdxFromCode On FromCode [ Unique ];

Index IdxEpisodeIsActive On (EpisodeID, IsActive, CriticalValueDate, CriticalValueTime);

Property EpisodeID As User.PAAdm;

/// 危急值ID
Property FromCode As %String(MAXLEN = 100);

/// 危急值内容
Property Content As %String(MAXLEN = 9900);

/// 危急值唯一标示符
Property LabNo As %String;

/// 危机值
Property CriticalValue As %String;

/// 危急值描述
Property CriticalValueDesc As %String;

/// 发布危急值日期
Property CriticalValueDate As %Date;

Property CriticalValueTime As %Time;

/// 医嘱ID
Property OEordItemRowID As %String;

/// 医嘱项描述
Property OEordItemDesc As %String;

/// 值范围
Property ItemRanges As %String;

/// 单位
Property ItemUnit As %String;

/// 加入日期
Property CreateDate As %Date;

/// 加入时间
Property CreateTime As %Time;

/// 是否活动的
Property IsActive As %String;

Storage Default
{
<Data name="CriticalValueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>FromCode</Value>
</Value>
<Value name="4">
<Value>Content</Value>
</Value>
<Value name="5">
<Value>LabNo</Value>
</Value>
<Value name="6">
<Value>CriticalValue</Value>
</Value>
<Value name="7">
<Value>CriticalValueDesc</Value>
</Value>
<Value name="8">
<Value>CriticalValueDate</Value>
</Value>
<Value name="9">
<Value>CriticalValueTime</Value>
</Value>
<Value name="10">
<Value>OEordItemRowID</Value>
</Value>
<Value name="11">
<Value>OEordItemDesc</Value>
</Value>
<Value name="12">
<Value>ItemRanges</Value>
</Value>
<Value name="13">
<Value>ItemUnit</Value>
</Value>
<Value name="14">
<Value>CreateDate</Value>
</Value>
<Value name="15">
<Value>CreateTime</Value>
</Value>
<Value name="16">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.Events.CriticalValueD</DataLocation>
<DefaultData>CriticalValueDefaultData</DefaultData>
<IdLocation>^EMR.DB1.Events.CriticalValueD</IdLocation>
<IndexLocation>^EMR.DB1.Events.CriticalValueI</IndexLocation>
<StreamLocation>^EMR.DB1.Events.CriticalValueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
