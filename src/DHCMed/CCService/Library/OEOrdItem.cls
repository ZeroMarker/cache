/// 名称: DHCMed.CCService.Library.OEOrdItem
/// 描述: 与医嘱相关的函数库
/// 编写者：zhufei
/// 编写日期: 2014-03-19
Class DHCMed.CCService.Library.OEOrdItem Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.OEOrdItem).Test()
ClassMethod Test()
{
	New
	Set %FromDate=$zdh("2013-11-01",3)
	Set %ToDate=$zdh("2013-11-03",3)
	
	Set %EpisodeID=2212
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckOEItem("","医嘱||26003||HXJFZHX-呼吸机辅助呼吸(含吸氧")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	/*
	Set %EpisodeID=422
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckAntiByCateg("抗感染药")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=11314
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckAntiByCateg("KSS2")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  检查非药品医嘱使用情况
/// Table：       OE_OrdExec
/// Input：       
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.OEOrdItem).CheckOEItem()
ClassMethod CheckOEItem(aOECat As %String = "", aOEItem As %String = "") As %String
{
	New (aOECat,aOEItem,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:(aOECat="")&&(aOEItem="") return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set ArcimID=$p(aOEItem,"||",2)
	Set:ArcimID'="" ArcimID=ArcimID_"||1"
	
	Set $ZT="CheckOEItemErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdExec).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,aOECat,ArcimID)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set Summary=objRec.ItemDesc
		
		Set Count=Count+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.DrgGeneric_"!!"_objRec.ItemDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OE"
		Set $p(TempData,$c(3),11)=objRec.SttDate
		Set $p(TempData,$c(3),12)=objRec.SttTime
		Set $p(TempData,$c(3),13)=objRec.XDate
		Set $p(TempData,$c(3),14)=objRec.XTime
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckOEItemErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  检查非药品医嘱使用情况（新开医嘱）
/// Table：       OE_OrdItem
/// Input：       
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.OEOrdItem).CheckNewOEItem()
ClassMethod CheckNewOEItem(aOECat As %String = "", aOEItem As %String = "") As %String
{
	New (aOECat,aOEItem,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:(aOECat="")&&(aOEItem="") return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set ArcimID=$p(aOEItem,"||",2)
	Set:ArcimID'="" ArcimID=ArcimID_"||1"
	
	Set $ZT="CheckNewOEItemErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,aOECat,ArcimID)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set Summary=objRec.ItemDesc
		
		Set Count=Count+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.DrgGeneric_"!!"_objRec.ItemDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OE"
		Set $p(TempData,$c(3),11)=objRec.SttDate
		Set $p(TempData,$c(3),12)=objRec.SttTime
		Set $p(TempData,$c(3),13)=objRec.XDate
		Set $p(TempData,$c(3),14)=objRec.XTime
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckNewOEItemErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  通过药学大类、药学子类、管制分类、抗生素标记（ANTI）检查使用抗生素情况
/// Table：       OE_OrdItem
/// Input：       aPHCCat : 药学大类或药学子类
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.OEOrdItem).CheckAntiByCateg()
ClassMethod CheckAntiByCateg(aCategory As %String = "") As %String
{
	New (aCategory,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set AnitPHCCat=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-AnitPHCCat","")
	Quit:AnitPHCCat="" return
	Quit:(aCategory'="")&&(AnitPHCCat'[aCategory) return
	Set:aCategory'="" AnitPHCCat=aCategory
	
	Set $ZT="CheckAntiByCategErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdExec).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,AnitPHCCat)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
	 	Set ArcimType=objRec.Category
	 	Continue:ArcimType'="R"
	 	
	 	//过滤皮试用医嘱
	 	Set flg=..CheckPSYOE(objRec.RecordID)
	 	Continue:flg<1
	 	
		Set Summary=objRec.ItemDesc
		
		Set Count=Count+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.DrgGeneric_"!!"_objRec.ItemDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OE"
		Set $p(TempData,$c(3),11)=objRec.SttDate
		Set $p(TempData,$c(3),12)=objRec.SttTime
		Set $p(TempData,$c(3),13)=objRec.XDate
		Set $p(TempData,$c(3),14)=objRec.XTime
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckAntiByCategErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  通过药学大类、药学子类、管制分类、抗生素标记（ANTI）检查使用抗生素情况(新开医嘱)
/// Table：       OE_OrdItem
/// Input：       aPHCCat : 药学大类或药学子类
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.OEOrdItem).CheckNewAntiByCateg()
ClassMethod CheckNewAntiByCateg(aCategory As %String = "") As %String
{
	New (aCategory,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set AnitPHCCat=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-AnitPHCCat","")
	Quit:AnitPHCCat="" return
	Quit:(aCategory'="")&&(AnitPHCCat'[aCategory)
	Set:aCategory'="" AnitPHCCat=aCategory
	
	Set $ZT="CheckNewAntiByCategErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,AnitPHCCat)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
	 	Set ArcimType=objRec.Category
	 	Continue:ArcimType'="R"
	 	
	 	//过滤皮试用医嘱
	 	Set flg=..CheckPSYOE(objRec.RecordID)
	 	Continue:flg<1
	 	
		Set Summary=objRec.ItemDesc
		
		Set Count=Count+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.DrgGeneric_"!!"_objRec.ItemDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OE"
		Set $p(TempData,$c(3),11)=objRec.SttDate
		Set $p(TempData,$c(3),12)=objRec.SttTime
		Set $p(TempData,$c(3),13)=objRec.XDate
		Set $p(TempData,$c(3),14)=objRec.XTime
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckNewAntiByCategErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  通过药学大类、药学子类检查药品使用情况
/// Table：       OE_OrdItem
/// Input：       aPHCCat : 药学大类或药学子类
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.OEOrdItem).CheckDrugByCateg()
ClassMethod CheckDrugByCateg(aCategory As %String) As %String
{
	New (aCategory,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckDrugByCategErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdExec).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,aCategory)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
	 	Set ArcimType=objRec.Category
	 	Continue:ArcimType'="R"
	 	
	 	//过滤皮试用医嘱
	 	Set flg=..CheckPSYOE(objRec.RecordID)
	 	Continue:flg<1
	 	
		Set Summary=objRec.ItemDesc
		
		Set Count=Count+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.DrgGeneric_"!!"_objRec.ItemDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OE"
		Set $p(TempData,$c(3),11)=objRec.SttDate
		Set $p(TempData,$c(3),12)=objRec.SttTime
		Set $p(TempData,$c(3),13)=objRec.XDate
		Set $p(TempData,$c(3),14)=objRec.XTime
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckDrugByCategErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  通过药学大类、药学子类检查药品使用情况(新开医嘱)
/// Table：       OE_OrdItem
/// Input：       aPHCCat : 药学大类或药学子类
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.OEOrdItem).CheckNewDrugByCateg()
ClassMethod CheckNewDrugByCateg(aCategory As %String) As %String
{
	New (aCategory,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckNewDrugByCategErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,aCategory)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
	 	Set ArcimType=objRec.Category
	 	Continue:ArcimType'="R"
	 	
	 	//过滤皮试用医嘱
	 	Set flg=..CheckPSYOE(objRec.RecordID)
	 	Continue:flg<1
	 	
		Set Summary=objRec.ItemDesc
		
		Set Count=Count+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.DrgGeneric_"!!"_objRec.ItemDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OE"
		Set $p(TempData,$c(3),11)=objRec.SttDate
		Set $p(TempData,$c(3),12)=objRec.SttTime
		Set $p(TempData,$c(3),13)=objRec.XDate
		Set $p(TempData,$c(3),14)=objRec.XTime
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckNewDrugByCategErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// 检查药品医嘱皮试医嘱过滤
ClassMethod CheckPSYOE(aOEItemID As %String) As %String
{
	new (aOEItemID)
	set return=0
	quit:aOEItemID="" return
	
	set PHCInstrID=$p($g(^OEORD(+aOEItemID,"I",$p(aOEItemID,"||",2),2)),"^",7)
	quit:PHCInstrID="" return
	set PHCInstrDesc=$p($g(^PHCIN(+PHCInstrID)),"^",2)
	quit:PHCInstrDesc["皮试" return
	set PHCInstrDesc=$p($g(^PHCIN(+PHCInstrID)),"^",3)
	quit:PHCInstrDesc["皮试" return
	
	set return=1
	quit return
}

}
