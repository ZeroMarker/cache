/// 名称: DHCMed.CCService.Library.ICUIntubate
/// 描述: 与插管相关的函数库
/// 编写者：zhufei
/// 编写日期: 2014-07-04
Class DHCMed.CCService.Library.ICUIntubate Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.ICUIntubate).Test()
ClassMethod Test()
{
	New
	Set %FromDate=""
	Set %ToDate=""
	
	Set %EpisodeID=125
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckIntuOE("UC")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=125
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckNewIntuOE("UC")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  检查患者插管情况（插管医嘱）
/// Table：       OE_OrdExec
/// Input：       IntuType: 导尿管(UC)、呼吸机(VAP)、中心静脉置管(PICC)、新生儿导尿管(NUC)、新生儿中央导管(NPICC)、气管插管(NVNT)、血透(HD)
/// 						aOpType:1:插管 0:拔管
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.OEOrdItem).CheckOEItem()
ClassMethod CheckIntuOE(aIntuType As %String, aOpType As %String = "1") As %String
{
	New (aIntuType,aOpType,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:aIntuType="" return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	/*If aOEItem'="" {
		Set ArcimID=$p(aOEItem,"||",2)
		Set:ArcimID'="" ArcimID=ArcimID_"||1"
	} Else {
		Set ArcimID=..GetIntuOEList(aIntuType)
	}*/
	Set ArcimID=..GetIntuOEList(aIntuType,aOpType)
	
	Set $ZT="CheckIntuOEErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdExec).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"",ArcimID)
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
	
CheckIntuOEErr
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
ClassMethod CheckNewIntuOE(aIntuType As %String, aOpType As %String = "1") As %String
{
	New (aIntuType,aOpType,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:aIntuType="" return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	/*If aOEItem'="" {
		Set ArcimID=$p(aOEItem,"||",2)
		Set:ArcimID'="" ArcimID=ArcimID_"||1"
	} Else {
		Set ArcimID=..GetIntuOEList(aIntuType)
	}*/
	Set ArcimID=..GetIntuOEList(aIntuType,aOpType)
	
	Set $ZT="CheckNewIntuOEErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"",ArcimID)
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
	
CheckNewIntuOEErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-07-04
/// Description:  获取插管医嘱列表,多值逗号分隔
/// Table：       DHCMed.NINF.Dic.ICUIntubate
/// Input：       导管类型：导尿管(UC)、呼吸机(VAP)、中心静脉置管(PICC)、新生儿导尿管(NUC)、新生儿中央导管(NPICC)、气管插管(NVNT)、血透(HD)
/// Return：      return'="":成功  return="":失败
/// w ##Class(DHCMed.CCService.Library.ICUIntubate).GetIntuOEList("UC")
ClassMethod GetIntuOEList(aCategory As %String, aOpType As %String = "1") As %String
{
	New (aCategory,aOpType)
	Set return=""
	Quit:aCategory="" return
	
	Set $ZT="GetIntuOEListErr"
	
	If (aCategory'["InfRep")||(aCategory'["Arcim") {
		If aOpType=1 {
			Set aCategory="InfRep"_aCategory_"Arcim"
		} Else {
			Set aCategory="InfRep"_aCategory_"EndArcim"
		}
	}
	
	Set return=##Class(DHCMed.NINF.Dic.ICUIntubate).GetIntuOEList(aCategory)
    Quit return
    
GetIntuOEListErr
	Quit ""
}

}
