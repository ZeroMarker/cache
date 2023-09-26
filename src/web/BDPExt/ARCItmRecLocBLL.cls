/// 名称: 医嘱项接收科室导入用类
/// 描述: 用于医嘱项接收科室导入
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-04-03
Class web.BDPExt.ARCItmRecLocBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod SaveEntity(Ceobj As web.BDPExt.ARCItmRecLocEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	///医嘱项
	s ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId)
	s:Ceobj.ARCRLDateFrom="" Ceobj.ARCRLDateFrom=+$h	
	//病人科室为空，后台可以不保存医嘱项接收科室里的医院
	if Ceobj.ARCRLOrdLocDR'="" s Ceobj.ARCRLCTHospitalDR=""			
	s str=ARCIMRowId_"^"_Ceobj.ARCRLOrdLocDR_"^"_Ceobj.ARCRLRecLocDR_"^"_Ceobj.ARCRLOrderPriorityDR_"^"_Ceobj.ARCRLDateFrom_"^"_Ceobj.ARCRLDateTo_"^"_Ceobj.ARCRLTimeFrom_"^"_Ceobj.ARCRLTimeTo_"^"_Ceobj.ARCRLDefaultFlag_"^"_"^"_Ceobj.ARCRLCTHospitalDR_"^"_Ceobj.ARCRLClinicType
	s ImportResult= ##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc(str)
	q ImportResult
}

}
