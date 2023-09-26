/// Table:      EMRmeta.DPCategory
/// Desc:       科室短语目录
/// Creator:    Lina
/// CreateDate: 2012-10-08
Class EMRmeta.DPCategory Extends %Persistent
{

/// 描述信息
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 目录名称、子节点名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 目录类型（科室目录:"DPTree",个人目录:"PersonalDPTree",科室节点:"DPNode",个人节点:"PersonalDPNode"）
Property Type As %String;

/// 父节点
Property ParentID As %Integer;

/// 目录顺序
Property Sequence As %Integer;

/// 个人科室短语标识
Property PersonalDPUserID As %String(TRUNCATE = 1);

/// 是否有效 （Y：有效-默认，N：无效）
Property IsValid As %String(TRUNCATE = 1) [ InitialExpression = "Y" ];

Index IdxName On Name;

Index IdxParentIDSeq On (ParentID, Sequence);

Index IdxParentUserID On (ParentID, PersonalDPUserID);

Index IdxParentIDName On (ParentID, Name);

Index IdxType On Type;

Index IdxParentID On ParentID;

Storage Default
{
<Data name="DPCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>PersonalDPUserID</Value>
</Value>
<Value name="8">
<Value>IsValid</Value>
</Value>
<Value name="9">
<Value>IsShare</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DPCategoryD</DataLocation>
<DefaultData>DPCategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DPCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.DPCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.DPCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
