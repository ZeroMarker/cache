/// 名称:EMRmeta.KBTreeCTLoc
/// 描述:科室-知识库配置表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.KBTreeCTLoc Extends %Persistent
{

Index IdxKBTreeID On KBTreeID;

Index IdxKBTreeCTLocID On (KBTreeID, CTLocID);

Index IdxCTLocKBTreeFlag On (CTLocID, KBTreeID, ActiveFlag);

Index IdxCTLocKBTreeID On (CTLocID, KBTreeID) [ Unique ];

Property CTLocID As %String(TRUNCATE = 1) [ Required ];

Property KBTreeID As %String(TRUNCATE = 1) [ Required ];

Property ActiveFlag As %String(TRUNCATE = 1);

Storage Default
{
<Data name="KBTreeCTLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTLocID</Value>
</Value>
<Value name="3">
<Value>KBTreeID</Value>
</Value>
<Value name="4">
<Value>ActiveFlag</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBTreeCTLocD</DataLocation>
<DefaultData>KBTreeCTLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBTreeCTLocD</IdLocation>
<IndexLocation>^DHCEMRM.KBTreeCTLocI</IndexLocation>
<StreamLocation>^DHCEMRM.KBTreeCTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
