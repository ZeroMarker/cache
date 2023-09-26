/// 名称: EMRmeta.EMRNavigationSchemeItemSeqLoc
/// 描述: 患者完整病历内容的组织方案项目科室关联配置(科室)
/// 编写者：yejian	
/// 编写日期: 2019-11-11
Class EMRmeta.EMRNavigationSchemeItemSeqLoc Extends (%Persistent, %XML.Adaptor)
{

/// EMRmeta.EMRNavigationSchemeItemSeq表的CTLocGroupID
Property CTLocGroupID As %String;

/// EMRmeta.EMRNavigationSchemeItemSeq表的CTLocGroupName(冗余字段)
Property CTLocGroupName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

Index IdxLocGID On CTLocID;

Index IdxCTLocGID On CTLocGroupID;

Index IdxCodeCTLocID On (CTLocGroupID, CTLocID);

Storage Default
{
<Data name="EMRNavigationSchemeItemSeqLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTLocGroupID</Value>
</Value>
<Value name="3">
<Value>CTLocGroupName</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>CTLocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRNavSchemeItemSeqLocD</DataLocation>
<DefaultData>EMRNavigationSchemeItemSeqLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRNavSchemeItemSeqLocD</IdLocation>
<IndexLocation>^DHCEMRM.EMRNavSchemeItemSeqLocI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRNavSchemeItemSeqLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
