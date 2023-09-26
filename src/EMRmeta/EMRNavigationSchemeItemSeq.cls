/// 名称:EMRmeta.EMRNavigationSchemeItemSeq
/// 描述:患者完整病历内容的组织方案明细项目按科室排序
/// 编写者：yejian
/// 编写日期: 2019-11-4
Class EMRmeta.EMRNavigationSchemeItemSeq Extends %Persistent
{

/// EMRmeta.EMRNavigationScheme表SchemeCode关联（冗余）
Property SchemeCode As %String;

/// EMRmeta.EMRNavigationSchemeItem表的ItemCode（冗余）
Property ItemCode As %String;

/// EMRmeta.EMRNavigationSchemeItem表的ItemName
Property ItemName As %String;

/// EMRmeta.EMRNavigationSchemeItem表rowid关联
Property ItemID As %String;

/// 科室组ID
Property CTLocGroupID As %String;

/// 科室组名称(冗余字段)
Property CTLocGroupName As %String;

/// 顺序
Property ItemSeq As %Integer;

Index IdxItemID On ItemID;

Index IdxLocGID On CTLocGroupID;

Index IdxLocGItemID On (CTLocGroupID, ItemID);

Index IdxLocGItemSeq On (CTLocGroupID, ItemSeq);

Index IdxSchemeLocGSeq On (CTLocGroupID, SchemeCode, ItemSeq);

Storage Default
{
<Data name="EMRNavigationSchemeItemSeqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeCode</Value>
</Value>
<Value name="3">
<Value>ItemID</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>ItemCode</Value>
</Value>
<Value name="6">
<Value>ItemSeq</Value>
</Value>
<Value name="7">
<Value>ItemName</Value>
</Value>
<Value name="8">
<Value>CTLocDesc</Value>
</Value>
<Value name="9">
<Value>CTLocGroupID</Value>
</Value>
<Value name="10">
<Value>CTLocGroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRNavSchemeItemSeqD</DataLocation>
<DefaultData>EMRNavigationSchemeItemSeqDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRNavSchemeItemSeqD</IdLocation>
<IndexLocation>^DHCEMRM.EMRNavSchemeItemSeqI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRNavSchemeItemSeqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
