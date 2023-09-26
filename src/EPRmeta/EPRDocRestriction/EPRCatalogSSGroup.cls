/// 名称: 目录查看权限规则
/// 描述: 新框架病历结构目录的查看权限（只控制第一层）
/// 编写者：chenwenjun
/// 编写日期: 09/07/24
Class EPRmeta.EPRDocRestriction.EPRCatalogSSGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病历显示结构的目录节点ID
Property EPRDocID As %String(TRUNCATE = 1);

/// 规则条件的ID（只使用安全组，即安全组的ID）
Property SSGroupID As %String(TRUNCATE = 1);

/// 规则条件的描述（只使用安全组，即安全组的名称）
Property SSGroupName As %String(TRUNCATE = 1);

Index IdxCatalogSSGroup On (EPRDocID, SSGroupID) [ Unique ];

ClassMethod GetEPRCatalogSSGroupCount(parEPRDocID As %String) As %String
{
	
	q:(parEPRDocID=0) 0 
	s count=0	
	&sql(select count(ID) into :count from EPRmeta_EPRDocRestriction.EPRCatalogSSGroup WHERE EPRDocID = :parEPRDocID)
	q count
}

Storage Default
{
<Data name="EPRCatalogSSGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPRCatalogID</Value>
</Value>
<Value name="3">
<Value>SSGroupID</Value>
</Value>
<Value name="4">
<Value>SSGroupName</Value>
</Value>
<Value name="5">
<Value>EPRDocID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRDOC.EPRSSGroupD</DataLocation>
<DefaultData>EPRCatalogSSGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRDOC.EPRSSGroupD</IdLocation>
<IndexLocation>^DHCEPRM.EPRDOC.EPRSSGroupI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRDOC.EPRSSGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
