/// 名称:EMR.DB.Events.LinkDocumnent
/// 描述:实例数据-医疗活动事件-医疗活动记录链接表
/// 编写者：Guozongtao(lifengbo)
/// 编写日期: 2014-08-16(20230428)
Class EMR.DB.Events.LinkDocument Extends %Persistent
{

Index IdxMain On (EpisodeID, EventType, EventsID, DocumentID) [ Unique ];

Index IdxEpisodeEventID On (EpisodeID, EventType, EventsID);

Index IdxEpisodeEventDocumentID On (EpisodeID, EventType, EventsID, DocumentID);

Index IdxInstanceType On (DocumentID, EventType);

Property EpisodeID As User.PAAdm;

/// EMR.DB.Events.CriticalValue.ID
Property EventsID As %String;

///  枚举值：BloodTransfusion 输血 CriticalValue 危急值  Operation 手术操作 Rescue 抢救  Manipulate 操作 Consult:会诊 MDTConsult:MDT会诊
Property EventType As %String;

Property DocumentID As EMR.DB.DocumentData;

/// 事件产品唯一标识，例如危急值ID会诊ID等
Property FromCode As %String;

/// 关联用户ID
Property UserID As User.SSUser;

Storage Default
{
<Data name="LinkDocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EventsID</Value>
</Value>
<Value name="4">
<Value>EventType</Value>
</Value>
<Value name="5">
<Value>DocumentID</Value>
</Value>
<Value name="6">
<Value>FromCode</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.Events.LinkDocumentD</DataLocation>
<DefaultData>LinkDocumentDefaultData</DefaultData>
<IdLocation>^EMR.DB.Events.LinkDocumentD</IdLocation>
<IndexLocation>^EMR.DB.Events.LinkDocumentI</IndexLocation>
<StreamLocation>^EMR.DB.Events.LinkDocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
