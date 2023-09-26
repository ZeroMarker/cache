/// Table:      EMRmeta.DPShare
/// Desc:       共享个人科室短语
/// Creator:    Lina
/// CreateDate: 2012-10-08
Class EMRmeta.DPShare Extends %Persistent
{

/// 关联表EMRmeta.DPCategory
Property CategoryID As %Integer;

/// 分享者UserID
Property UserID As %String;

/// 分享科室ID
Property CTLocID As %String;

/// 分享时间
Property ShareDate As %String;

/// 顺序
Property Sequence As %Integer;

Index IdxCTLocIDSeq On (CTLocID, Sequence);

Index IdxUserIDCTLocIDCategoryID On (UserID, CTLocID, CategoryID);

Storage Default
{
<Data name="DPShareDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>ShareDate</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DPShareD</DataLocation>
<DefaultData>DPShareDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DPShareD</IdLocation>
<IndexLocation>^DHCEMRM.DPShareI</IndexLocation>
<StreamLocation>^DHCEMRM.DPShareS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
