Class DHCWL.util.ModeManagerUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ban
/// CreatDate：    2013-09-10
/// Description:： 获取指标或维度或维度属性的配置
/// Table：       DHCWL_MKPI_ModeMagKpiCfg
/// Input：       rptCode:报表编码.
/// Output：      
/// Return：      retDimRule：指标或维度或维度属性的配置
/// Others：      
/// s dimRule=##class(DHCWL.util.ModeManagerUtil).GetDimRuleByCode("TMPCODE2")
ClassMethod GetDimRuleByCode(rptCode As %String) As %String
{
	
	n (rptCode,dimId)
	s retDimRule=""
	s dimRule=""
	;使用索引：^DHCWLMKPIKPICFG(0,"PCode",{KpiCfg_PCode},{KpiCfg_RowID}) 
	s kpiCfgRowID=0
	f  s kpiCfgRowID=$o(^DHCWLMKPIKPICFG(0,"PCode",rptCode,kpiCfgRowID)) q:kpiCfgRowID=""  d
	.s kpiCode=$p(^DHCWLMKPIKPICFG(kpiCfgRowID),"^",1)
	.s kpiRule=$p(^DHCWLMKPIKPICFG(kpiCfgRowID),"^",2)
	.i $g(kpiRule)="" s dimRule=kpiCode
	.e  s dimRule=kpiCode_":"_kpiRule
	.i $g(retDimRule)'="" s retDimRule=$g(retDimRule)_","
	.s retDimRule=$g(retDimRule)_dimRule
	
	s retDimRule=$TRANSLATE(retDimRule,"%","^")
	q $g(retDimRule)
}

}
