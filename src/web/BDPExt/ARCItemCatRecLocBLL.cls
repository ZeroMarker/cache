/// 名称: 医嘱子类接收科室导入用类
/// 描述: 用于医嘱子类接收科室导入
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-04-03
Class web.BDPExt.ARCItemCatRecLocBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod SaveEntity(Ceobj As web.BDPExt.ARCItemCatRecLocEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	
	Ts						
	s ParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItemCat",Ceobj.ARCICCode,Ceobj.LinkHospId)
	s:Ceobj.RLDateFrom="" Ceobj.RLDateFrom=+$h
	s eobj =##class(web.Entity.CT.ARCItemCatRecLoc).%New()
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
	s SaveResult=##class(web.DHCBL.CT.ARCItemCatRecLoc).SaveEntity(eobj)
	s RLRowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)
	if (RLRowId="")
	{
		s ImportResult="医嘱子类接收科室:"_SaveResult			
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
/// Description:清除医嘱子分类接收科室相关数据
/// Other:d ##class(web.BDPExt.ARCItemCatRecLocBLL).ClearData()
ClassMethod ClearData()
{
	s ParRef=0
	for
	{
		s ParRef=$o(^ARC("IC",ParRef)) q:ParRef=""
		K ^ARC("IC",ParRef,"RL")
		s ChildSub=0
		for
		{
			
			s ChildSub=$o(^ARC("IC",ParRef,"RL",ChildSub)) q:ChildSub=""
			s RLRowId=ParRef_"||"_ChildSub
			s sc=##class(User.ARCItemCatRecLoc).%DeleteId(RLRowId)
		}
	}
	q ""
}

}
