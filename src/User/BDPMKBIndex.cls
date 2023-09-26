/// 名称: User.BDPMKBIndex
/// 描述: 基础数据医用知识库索引表
/// 编写者：谷雪萍
/// 编写日期: 2017-11-10
Class User.BDPMKBIndex Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = BDP_MKBIndex ]
{

/// ID串  术语ID_"D"_术语内容ID^术语ID
Property BDPCode As %String(MAXLEN = "");

/// 描述
Property BDPDesc As %String(MAXLEN = "");

Index DescIndex On (BDPDesc, BDPCode As Exact);

Storage Default
{
<Data name="BDPMKBIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPCode</Value>
</Value>
<Value name="3">
<Value>BDPDesc</Value>
</Value>
</Data>
<DataLocation>^User.BDPMKBIndexD</DataLocation>
<DefaultData>BDPMKBIndexDefaultData</DefaultData>
<IdLocation>^User.BDPMKBIndexD</IdLocation>
<IndexLocation>^User.BDPMKBIndexI</IndexLocation>
<StreamLocation>^User.BDPMKBIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
