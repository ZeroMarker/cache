/// 名称:	EMR.GB.Router
/// 描述:	数据路由表,按照就诊号的数据分片策略,管理就诊号与数据节点的关系。
/// 编写者：yejian
/// 编写日期: 2020-9-29
/// 产品组：电子病历产品组
Class EMR.GB.Router Extends %Persistent
{

Index IdxEpisodeIDNodeID On (EpisodeID, NodeID);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 数据节点ID（CF.EMR.DOC.NodeConfig表的，NodeID）
Property NodeID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="RouterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>NodeID</Value>
</Value>
</Data>
<DataLocation>^EMR.GB.RouterD</DataLocation>
<DefaultData>RouterDefaultData</DefaultData>
<IdLocation>^EMR.GB.RouterD</IdLocation>
<IndexLocation>^EMR.GB.RouterI</IndexLocation>
<StreamLocation>^EMR.GB.RouterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
