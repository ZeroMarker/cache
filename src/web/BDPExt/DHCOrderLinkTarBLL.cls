/// Description：医嘱项与收费项目对照关系导入程序
/// Creator：chenying
/// CreatDate: 2019-2-16
Class web.BDPExt.DHCOrderLinkTarBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：医嘱项与收费项目对照关系导入保存接口
/// Creator：chenying
/// CreatDate: 2019-2-16
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'OLTRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.DHCOrderLinkTarBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.DHCOrderLinkTarEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	///收费项
	//s TARIRowId=$o(^DHCTARI(0,"Code",Ceobj.OLTTARCode,0)) 
	s TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Ceobj.OLTTARCode,Ceobj.LinkHospId)
	///医嘱项
	/*s ARCIMRowId=""
	s sub=0
	for
	{
		s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.OLTARCCode),sub)) q:sub=""
		s version=0
		for
		{
			s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.OLTARCCode),sub,version)) q:version=""
			s Value=$p($g(^ARCIM(sub,version,1)),"^",1)
			IF (Value=Ceobj.OLTARCCode)
			{
				 S ARCIMRowId=sub_"||"_version
			}
		}
	}*/
	s ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.OLTARCCode,Ceobj.LinkHospId)
	Ts
	s olteobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCOrderLinkTar")
	s olteobj.OLTARCIMDR=ARCIMRowId
	s olteobj.OLTTariffDR=TARIRowId
	s SaveResult=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(olteobj)  
	s OLTRowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)		
	if (OLTRowId="")
	{
		s ImportResult="医嘱项与收费项关联:"_SaveResult			
	}
	if (ImportResult="")
	{
		Tc
		s ImportRetResult="{success:'true',id:'"_OLTRowId_"'}" 
	}
	else
	{
		Tro
		s ImportRetResult=ImportResult
	
	}
	q ImportRetResult
}

}
