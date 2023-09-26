Class web.BDPExt.OrderCategoryBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// /update2020-02-11
ClassMethod SaveEntity(Ceobj As web.BDPExt.OrderCategoryEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	///默认值
	
	s Ceobj.ARCICOrderType=$$ALPHAUP^SSUTIL4(Ceobj.ARCICOrderType)
	
	s Ceobj.ARCICOrderType=$CASE(Ceobj.ARCICOrderType,
		"DRUG":"R",
		"DIET":"D",
		"IV":"I",
		"CONSULTATION":"C",
		"NORMAL":"N",
		"DENTAL":"T",
		"LABTRAK":"L",
		"REHABMEDICINE":"X",
		"PRICE":"P",
		"BLOODBANK":"B",
		"DIETSUPPLEMENT":"S",
		"HARDWARE":"H",
		"DAYBOOK":"A",
		"DFT":"F",
		"DIETTHICKENEDFLUID":"DTF",
		"BULKMEAL":"BM",
		"PROSTHETICS":"PROS",
		"MATERIAL":"M"
		,:"")  ///子类类型
	
	ts
	s cateobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.OECOrderCategory")
	s subcatobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItemCat")
	///医嘱大类
	s ORCATRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("OEC_OrderCategory",Ceobj.ORCATCode,Ceobj.LinkHospId)
	if (ORCATRowId="") 
	{
		s cateobj.ORCATRowId=""
		s cateobj.LinkHospId=Ceobj.LinkHospId
		s ORCATSaveResult=##class(web.DHCBL.CT.OECOrderCategory).SaveEntity(cateobj)
		s ORCATRowId=##class(web.BDPExt.FunLib).GetResultRowId(ORCATSaveResult)
		if (ORCATRowId="")
		{
			s ImportResult="医嘱大类:"_ORCATSaveResult	
		}
	
	}
	
	if (ORCATRowId'="")
	{
		s subcatobj.ARCICOrdCatDR=ORCATRowId
		s subcatobj.LinkHospId=Ceobj.LinkHospId
		s SubCatSaveResult=##class(web.DHCBL.CT.ARCItemCat).SaveEntity(subcatobj)
		s SubCatRowId=##class(web.BDPExt.FunLib).GetResultRowId(SubCatSaveResult)
		if (SubCatRowId="")
		{
			s ImportResult="医嘱子类:"_SubCatSaveResult	
		}
	}
	
	
	if (ImportResult="")
	{
		tc
		s ImportResult="{success:'true',id:'"_SubCatRowId_"'}" 
	}
	else
	{
		tro
	}
	q ImportResult
}

/// Creator:陈莹
/// CreatDate:2017-04-18
/// Description:新装医嘱子类时 ，清除大类，子类，安全组医嘱授权
/// Other:d ##class(web.BDPExt.SSUserBLL).ClearData()
ClassMethod ClearData()
{
	n
	k ^OEC("ORCAT"),^ARC("IC")
	s SSGRPRowId=0
	for  
	{	
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)  //Demo Group
		s sub=0
		for 
		{
			s sub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",sub)) q:sub=""
			s RowId=SSGRPRowId_"||"_sub
			d ##class(User.SSGroupOrderCategory).%DeleteId(RowId)
		}
		k ^SSU("SSGRP",SSGRPRowId,"SSORD",0)	
	}
}

}
