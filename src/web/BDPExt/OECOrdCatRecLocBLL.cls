/// 名称: 医嘱大类接收科室导入用类
/// 描述: 用于医嘱大类接收科室导入
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-04-03
Class web.BDPExt.OECOrdCatRecLocBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod SaveEntity(Ceobj As web.BDPExt.OECOrdCatRecLocEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	Ts			
				
	///医嘱大类
	s ParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("OEC_OrderCategory",Ceobj.ORCATCode,Ceobj.LinkHospId)	
	
	s:Ceobj.RLDateFrom="" Ceobj.RLDateFrom=+$h
	s eobj =##class(web.Entity.CT.OECOrdCatRecLoc).%New()
	s eobj.RLParRef=ParRef
	s eobj.RLOrdLocDR=Ceobj.RLOrdLocDR
	s eobj.RLRecLocDR=Ceobj.RLRecLocDR
	s eobj.RLFunction=Ceobj.RLFunction
	s eobj.RLDefaultFlag=Ceobj.RLDefaultFlag
	s eobj.RLCTHospitalDR=Ceobj.RLCTHospitalDR
	S eobj.RLDateFrom=Ceobj.RLDateFrom
	S eobj.RLDateTo=Ceobj.RLDateTo
	S eobj.RLTimeFrom=Ceobj.RLTimeFrom
	S eobj.RLTimeTo=Ceobj.RLTimeTo
	S eobj.RLOrderPriorityDR=Ceobj.RLOrderPriorityDR
	S eobj.RLClinicType=Ceobj.RLClinicType
	s SaveResult=##class(web.DHCBL.CT.OECOrdCatRecLoc).SaveEntity(eobj)
	s RLRowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)
	if (RLRowId="")
	{
		s ImportResult="医嘱大类接收科室:"_SaveResult			
	}
	
	if (ImportResult="")
	{
		Tc
		s Result="{success:'true',id:'"_RLRowId_"'}" 
	}
	else
	{
		Tro
		s Result=ImportResult
	
	}
	q Result
}

/// Creator:陈莹
/// CreatDate:2022-07-13
/// Description:清除医嘱大类接收科室相关数据
/// Other:d ##class(web.BDPExt.OECOrdCatRecLocBLL).ClearData()
ClassMethod ClearData()
{
	s ParRef=0
	for
	{
		s ParRef=$o(^OEC("ORCAT",ParRef)) q:ParRef=""
		K ^OEC("ORCAT",ParRef,"RL")
		s ChildSub=0
		for
		{
			
			s ChildSub=$o(^OEC("ORCAT",ParRef,"RL",ChildSub)) q:ChildSub=""
			s RLRowId=ParRef_"||"_ChildSub
			s sc=##class(User.OECOrdCatRecLoc).%DeleteId(RLRowId)
		}
	}
	q ""
}

}
