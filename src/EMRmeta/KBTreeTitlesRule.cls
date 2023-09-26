/// 名称：		EMRmeta.KBTreeTitlesRule
/// 描述：		知识库树节点和标题关联关系表
/// 编写者：	yejian
/// 编写时间：	2014-4-5
Class EMRmeta.KBTreeTitlesRule Extends %Persistent
{

/// 索引
Index IdxIDCode On (KBTreeID, TitlesCode) [ Unique ];

Index IdxKBTreeID On KBTreeID;

/// 知识库KBTree表Rowid
Property KBTreeID As %String(TRUNCATE = 1);

/// 标题Titles表的Code
Property TitlesCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="KBTreeTitlesRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KBTreeID</Value>
</Value>
<Value name="3">
<Value>TitlesCode</Value>
</Value>
<Value name="4">
<Value>TitlesDescription</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBTreeTitlesRuleD</DataLocation>
<DefaultData>KBTreeTitlesRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBTreeTitlesRuleD</IdLocation>
<IndexLocation>^DHCEMRM.KBTreeTitlesRuleI</IndexLocation>
<StreamLocation>^DHCEMRM.KBTreeTitlesRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
