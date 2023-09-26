/// Table:      EMRmeta.DPCTLoc
/// Desc:       科室-科室短语配置表
/// Creator:    Lina
/// CreateDate: 2012-10-08
Class EMRmeta.DPCTLoc Extends %Persistent
{

/// 关联表EMRmeta.DPCategory
Property CategoryID As %Integer;

/// 科室ID
Property CTLocID As %Integer;

/// 科室描述
Property CTLocDesc As %String;

/// 顺序
Property Sequence As %Integer;

Index IdxCategoryLocID On (CategoryID, CTLocID) [ Unique ];

Index IdxCategorySeq On (CategoryID, Sequence);

Storage Default
{
<Data name="DPCTLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>CTLocID</Value>
</Value>
<Value name="4">
<Value>CTLocDesc</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DPCTLocD</DataLocation>
<DefaultData>DPCTLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DPCTLocD</IdLocation>
<IndexLocation>^DHCEMRM.DPCTLocI</IndexLocation>
<StreamLocation>^DHCEMRM.DPCTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
