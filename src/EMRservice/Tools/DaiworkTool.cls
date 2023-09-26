Class EMRservice.Tools.DaiworkTool Extends %Persistent
{

/// 清除病历相关配置数据（HIS科室、HIS安全组）
/// 入参：AIsCleanLoc,Y\N，Y清除科室相关配置数据。
/// 	 AIsCleanGroup,Y\N，Y清除安全组相关配置数据。
/// date20170703
/// ceatet:lifengbo	
/// debugger
/// d ##class(EMRservice.Tools.DaiworkTool).EMRCleanMetaDataOnLocGrp("Y","N")	
ClassMethod EMRCleanMetaDataOnLocGrp(AIsCleanLoc As %String = "", AIsCleanGroup As %String = "N")
{
	q:(AIsCleanLoc="") "是否清楚科室关联数据"
	if (AIsCleanLoc="Y")
	{
		//1. 知识库可见科室配置
		//EMRmeta.KBTreeCTLoc
		k ^DHCEMRM.KBTreeCTLocD
		k ^DHCEMRM.KBTreeCTLocI
		k ^DHCEMRM.KBTreeCTLocS
		
		//2. 病历展现结构，模板组科室配置 
		//EMRmeta.EMRDocRestriction.CatalogSSGroup
		k ^DHCEMRM.DocRes.DocRestrictionD
		k ^DHCEMRM.DocRes.DocRestrictionI
		k ^DHCEMRM.DocRes.DocRestrictionS

		//3. 病历导航分类，分类科室配置
		//EMRmeta.EMRNavigationSchemeItemLoc
		k ^DHCEMRM.EMRNavItemLocD
		k ^DHCEMRM.EMRNavItemLocI
		k ^DHCEMRM.EMRNavItemLocS
		//EMRmeta.EMROrganizationSchemeLoc
		k ^DHCEMRM.EMROrgSchemeLocD
		k ^DHCEMRM.EMROrgSchemeLocI
		k ^DHCEMRM.EMROrgSchemeLocS
		//4. 标题科室配置
		//EMRmeta.TitleLoc
		k ^DHCEMRM.TitleLocD
		k ^DHCEMRM.TitleLocI


		//5. 病种科室配置
		//EMRmeta.DiagnosCTLoc
		k ^DHCEMRM.DiagnosCTLocD
		k ^DHCEMRM.DiagnosCTLocI
		k ^DHCEMRM.DiagnosCTLocS
		
		//6.批量创建病历方案关联科室
		k ^DHCEMRM.EMRTemplateGroupLocD
		k ^DHCEMRM.EMRTemplateGroupLocI
		k ^DHCEMRM.EMRTemplateGroupLocS
		
		w !,"Loc Clean Over"
	
	}
	
	if (AIsCleanGroup="Y")
	{
	
		
		//3. 病历导航分类，分类科室配置
		//EMRmeta.EMRNavigationSchemeItemSSGroup
		k ^DHCEMRM.EMRNavItemSSGroupD
		k ^DHCEMRM.EMRNavItemSSGroupI
		k ^DHCEMRM.EMRNavItemSSGroupS
		
		//5. 病种科室配置
		//EMRmeta.DiagnosGroup [?是否在用]
		k ^DHCEMRM.DiagnosGroupD
		k ^DHCEMRM.DiagnosGroupI
		k ^DHCEMRM.DiagnosGroupS
		
		w !,"SSGroup Clean Over"
	
	}
	w !,"Finish"
}

Storage Default
{
<Data name="DaiworkToolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EMRservice.Tools.DaiworkToolD</DataLocation>
<DefaultData>DaiworkToolDefaultData</DefaultData>
<IdLocation>^EMRservice.Tools.DaiworkToolD</IdLocation>
<IndexLocation>^EMRservice.Tools.DaiworkToolI</IndexLocation>
<StreamLocation>^EMRservice.Tools.DaiworkToolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
