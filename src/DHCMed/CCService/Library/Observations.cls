/// 名称: DHCMed.CCService.Library.Observations
/// 描述: 与体温单相关的函数库
/// 编写者：zhufei
/// 编写日期: 2014-02-14
Class DHCMed.CCService.Library.Observations Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.Observations).Test()
ClassMethod Test()
{
	New
	Set %FromDate="2013-06-01"
	Set %ToDate="2013-06-30"
	
	Set %EpisodeID=321160
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckOBSItem("36-37.5")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=321160
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckObsLastAbno("36-37.5",3)
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %FromDate=""
	Set %ToDate=""
	Set %EpisodeID=17
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckStoolFreq(3)
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-02-20
/// Description:  检查体温异常患者
/// Table：       MR_Observations
/// Input：       aBBTs  正常体温区间 "36-37.5"
/// Return：      返回体温异常数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.Observations).CheckOBSItem("36-37.5")
ClassMethod CheckOBSItem(aBBTs As %String) As %String
{
	New (aBBTs,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:(aBBTs="") return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckOBSItemErr"
	
	Set aBBTs=$tr(aBBTs,"~","-")
	Set aBBTs=$tr(aBBTs,"|","-")
	Set aBBTs=$tr(aBBTs,"/","-")
	Set aBBTs=$tr(aBBTs,"\","-")
	Set aBBTs=$tr(aBBTs,",","-")
	Set aBBTs=$tr(aBBTs,"、","-")
	Set aBBTs=$tr(aBBTs,"，","-")
	Set aBBTs=$tr(aBBTs," ","")
	Set tmpOBSL=+$p(aBBTs,"-",1)
	Set tmpOBSH=+$p(aBBTs,"-",2)
	Quit:(tmpOBSL<1)||(tmpOBSH<tmpOBSL) return
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.Observations).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"OBS-TEMP")
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ObsValue=+objRec.DataValue
		Continue:(ObsValue<34)||(ObsValue>45)
		Continue:(ObsValue>=tmpOBSL)&&(ObsValue<=tmpOBSH)
		
		Set ObsDate=objRec.ActDate
		Set ObsTime=objRec.ActTime
		Continue:(ObsDate="")||(ObsTime="")
		
		Set Count=Count+1
		
		Set return=return+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=objRec.DataValue_"度"
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.DataValue_"!!"_objRec.DataValue_"度"
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)="aBBTs="_aBBTs
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OBS"
		Set $p(TempData,$c(3),11)=""
		Set $p(TempData,$c(3),12)=""
		Set $p(TempData,$c(3),13)=""
		Set $p(TempData,$c(3),14)=""
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckOBSItemErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-02-14
/// Description:  检查体温持续异常患者
/// Table：       MR_Observations
/// Input：       aBBTs  正常体温区间 "36-37.5"
///               aDays  体温持续异常检查天数  3
/// Return：      返回体温异常数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.Observations).CheckObsLastAbno("36-37.5",3)
ClassMethod CheckObsLastAbno(aBBTs As %String, aDays As %String) As %String
{
	New (aBBTs,aDays,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0
	Quit:(aBBTs="")||(aDays="") return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckObsLastAbnoErr"
	
	Set aBBTs=$tr(aBBTs,"~","-")
	Set aBBTs=$tr(aBBTs,"|","-")
	Set aBBTs=$tr(aBBTs,"/","-")
	Set aBBTs=$tr(aBBTs,"\","-")
	Set aBBTs=$tr(aBBTs,",","-")
	Set aBBTs=$tr(aBBTs,"、","-")
	Set aBBTs=$tr(aBBTs,"，","-")
	Set aBBTs=$tr(aBBTs," ","")
	Set tmpOBSL=+$p(aBBTs,"-",1)
	Set tmpOBSH=+$p(aBBTs,"-",2)
	Quit:(tmpOBSL<1)||(tmpOBSH<tmpOBSL) return
	
	Kill arrResult
	Set aDays=+aDays
	
	Set:%FromDate["-" %FromDate=$zdh(%FromDate,3)
	Set:%ToDate["-" %ToDate=$zdh(%ToDate,3)
	Set tmpFromDate=%FromDate,tmpToDate=%ToDate
	Set:tmpFromDate'="" tmpFromDate=tmpFromDate-aDays
	Set arrRec=##Class(DHCMed.DPCustom.Data.Observations).GetDataByAdm(%EpisodeID,tmpFromDate,tmpToDate,"OBS-TEMP")
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ObsValue=+objRec.DataValue
		Continue:(ObsValue<34)||(ObsValue>45)
		Continue:(ObsValue>=tmpOBSL)&&(ObsValue<=tmpOBSH)
		
		Set ObsDate=objRec.ActDate
		Set ObsTime=objRec.ActTime
		Continue:(ObsDate="")||(ObsTime="")
		
		Set ObsDate=$zdh(ObsDate,3)
		Set ObsTime=$zth(ObsTime,1)
		Set arrResult(ObsDate,ObsTime)=""
	}
	
	Set xDate=0,Count=0,yDate=0
	For {
		Set xDate=$o(arrResult(xDate))
		Quit:xDate=""
		Continue:xDate<1
		Continue:(%FromDate'="")&&(xDate<tmpFromDate)  	// update by cpj 2015-11-12 修改bug，体温持续N天监控不显示 (xDate<%FromDate)
		Continue:(%ToDate'="")&&(xDate>tmpToDate)		//
		
		If yDate+1=xDate {
			Set Count=Count+1
		} Else {
			Set Count=1
		}
		Set yDate=xDate
		
		If Count>=aDays {
			Set return=return+1
			Set TempData=""
    		Set $p(TempData,$c(3),1)="体温持续异常("_aDays_"天)"
			Set $p(TempData,$c(3),2)=$zd(xDate,3)
			Set $p(TempData,$c(3),3)="23:59:00"
			Set $p(TempData,$c(3),4)="体温持续异常("_aDays_"天)"
			Set $p(TempData,$c(3),5)=%EpisodeID_"||"_xDate
			Set $p(TempData,$c(3),6)=""
			Set $p(TempData,$c(3),7)="aBBTs="_aBBTs_",aDays="_aDays
			Set $p(TempData,$c(3),8)=$zd(xDate,3)
			Set $p(TempData,$c(3),9)="23:59:00"
			Set $p(TempData,$c(3),10)="OBS"
			Set $p(TempData,$c(3),11)=""
			Set $p(TempData,$c(3),12)=""
			Set $p(TempData,$c(3),13)=""
			Set $p(TempData,$c(3),14)=""
			Set %ExtraData=%ExtraData_$lb(TempData)
		}
	}
	Kill arrResult
	
	Quit return
	
CheckObsLastAbnoErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-04-16
/// Description:  检查大便次数>3次患者
/// Table：       MR_Observations
/// Input：       aBBTs  大便次数
/// Return：      返回大便次数异常数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.Observations).CheckStoolFreq(3)
ClassMethod CheckStoolFreq(aNumber As %String) As %String
{
	New (aNumber,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:(aNumber="") return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckStoolFreqErr"
	
	Set aNumber=+aNumber
	Quit:aNumber<1 return
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.Observations).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"OBS-SF")
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ObsValue=objRec.DataValue
		Continue:$zcvt(ObsValue,"U")["ML"
		//Continue:ObsValue["E" //结果带E标识，表示灌肠
		Set ObsValue=+ObsValue
		Continue:ObsValue<1
		Continue:ObsValue>20
		Continue:ObsValue<=aNumber
		
		Set ObsDate=objRec.ActDate
		Set ObsTime=objRec.ActTime
		Continue:(ObsDate="")||(ObsTime="")
		
		Set Count=Count+1
		
		Set return=return+1
		Set TempData=""
		Set $p(TempData,$c(3),1)="大便次数:"_ObsValue_"次"
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)="大便次数>"_aNumber_"次"
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)="aNumber="_aNumber
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OBS"
		Set $p(TempData,$c(3),11)=""
		Set $p(TempData,$c(3),12)=""
		Set $p(TempData,$c(3),13)=""
		Set $p(TempData,$c(3),14)=""
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckStoolFreqErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}
