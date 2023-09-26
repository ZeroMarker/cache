/// 名称: 病种目录
/// 描述: 病种目录表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRmeta.DiagnosCategory Extends %Persistent
{

Index IdxParentID On ParentID;

Index IdxCategoryCode On CategoryCode [ Unique ];

Index IdxSeq On (ParentID, Sequence);

/// 病种分组代码
Property CategoryCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种分组名称
Property CategoryName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Storage Default
{
<Data name="DiagnosCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupCode</Value>
</Value>
<Value name="3">
<Value>GroupName</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>CategoryCode</Value>
</Value>
<Value name="7">
<Value>CategoryName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosCategoryD</DataLocation>
<DefaultData>DiagnosCategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
