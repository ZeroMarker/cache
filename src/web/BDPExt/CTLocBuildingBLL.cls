/// Description：医院楼导入
/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-19
Class web.BDPExt.CTLocBuildingBLL Extends %RegisteredObject
{

/// Description：医院楼导入保存方法
/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-19
/// Table: User.CTLocBuilding, User.CTLocBuildingFloor
/// Input: 
ClassMethod SaveEntity(Ceobj As web.BDPExt.CTLocBuildingEntity) As %String
{
	s result=""
	s reF=""
	s reC=""
	s eobjF=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.CTLocBuilding")
	s reF=##class(web.DHCBL.CT.CTLocBuilding).SaveEntity(eobjF)		//保存父表
	s CTLBRowId=$o(^CT("CTLB",0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.CTLBCode),Ceobj.CTLBHospitalDR,0))
	if (Ceobj.CTLBFFloor'="")&&(CTLBRowId'="")
	{
		s eobjC=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.CTLocBuildingFloor")
		s eobjC.CTLBFParRef=CTLBRowId
		s reC=##class(web.DHCBL.CT.CTLocBuildingFloor).SaveEntity(eobjC)		//保存子表
	}
	s:(reF["success:'true'") result=reF
	s:(reC["success:'true'") result=result_reC
	q result
}

}
