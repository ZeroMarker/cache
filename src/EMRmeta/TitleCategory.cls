/// 名称: EMRmeta.TitleCategory
/// 描述: 标题目录
/// 编写者：yejian
/// 编写日期: 2015-12-17
Class EMRmeta.TitleCategory Extends (%Persistent, %XML.Adaptor)
{

/// 目录名称
Property TitleCategoryName As %String(TRUNCATE = 1);

/// 目录类型 	
Property TitleCategoryType As %String(TRUNCATE = 1);

/// 目录属性扩展参数
Property PropertyParams As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 标题目录顺序
Property Sequence As %Integer;

/// 索引
Index IdxSequence On Sequence;

/// 索引
Index IdxCategoryName On TitleCategoryName;

Storage Default
{
<Data name="TitleCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TitleCategoryName</Value>
</Value>
<Value name="3">
<Value>TitleCategoryType</Value>
</Value>
<Value name="4">
<Value>PropertyParams</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TitleCategoryD</DataLocation>
<DefaultData>TitleCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TitleCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.TitleCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.TitleCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
