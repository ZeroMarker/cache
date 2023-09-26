/// 传染病门诊应报/未报统计
Class DHCMed.EPDService.EpidemicOPStat Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Do ##Class(DHCMed.EPDService.EpidemicOPStat).InitEpOPStatBat()
ClassMethod InitEpOPStatBat()
{
	Set flg=##Class(DHCMed.EPDService.EpidemicOPStat).InitEpdOPStatData(+$h-10,+$h)
	Quit
}

/// 初始化传染病门诊统计数据
/// w ##Class(DHCMed.EPDService.EpidemicOPStat).InitEpdOPStatData("2012-11-01","2012-11-01")
ClassMethod InitEpdOPStatData(aFromDate As %String, aToDate As %String) As %String
{
	New (aFromDate,aToDate)
	
	//Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	//Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	//Set:aToDate["-" aToDate=$zdh(aToDate,3)
	//Set:aToDate["/" aToDate=$zdh(aToDate,4)
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aFromDate'="" aFromDate=+aFromDate
	Set:aToDate'="" aToDate=+aToDate
	Quit:(aFromDate="")||(aToDate="") "Error"
	
	For xDate=aFromDate:1:aToDate {
		Quit:xDate>(+$h-1)
		Continue:$d(^DHCMed.EPD("OPStat",xDate))
		
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmStatus=$p($g(^PAADM(xPaadm)),"^",2)
			Continue:AdmStatus'="O"  //只统计门诊患者
			
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm)
			If objAdm'="" Do objAdm.%Close()
			Set AdmLoc=objAdm.DepartmentID
			Set AdmDate=objAdm.AdmitDate
			Set:AdmDate'="" AdmDate=$zdh(AdmDate,3)
			
			Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(AdmLoc)
			Continue:'$IsObject(objLoc)
			If objLoc'="" Do objLoc.%Close()
			Set HospitalID=objLoc.HospitalDr
			
			Set num=$i(^DHCMed.EPD("OPStat",+AdmDate,+HospitalID,+AdmLoc))
			
			//传染病未报统计
			Set ctlResult=##class(DHCMed.EPDService.Service).CheckDiagnosToEpd(xPaadm)
			If ctlResult'="" {
				Set ctlCode=$p(ctlResult,"^",1)
				Set ctlIFRowID=$p(ctlResult,"^",2)
				If (ctlCode=1)&&(ctlIFRowID'="") {
					If ctlIFRowID'="" {
						Set objEpdDic=##class(DHCMed.EPD.Infection).GetObjById(ctlIFRowID)
						If $IsObject(objEpdDic) {
							Set EpdGroup=objEpdDic.MIFKind
							Set EpdFlag=##class(DHCMed.EPDService.EpidemicOPStat).IsReported(xPaadm,"",EpdGroup)
							If (EpdGroup'="")&&(EpdFlag<1) {
								Set num=$i(^DHCMed.EPD("OPStat",+AdmDate,+HospitalID,+AdmLoc,EpdGroup,"未报"))
							}
						}
					}
				}
			}
			
			/* update by zf 2012-11-28
			//传染病已报统计
			Set PatientID=$p($g(^PAADM(xPaadm)),"^",1)
			If PatientID'="" {
				Set EpdDicID=""
				For {
					Set EpdDicID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,EpdDicID))
					Quit:EpdDicID=""
					
					Set objEpdDic=##class(DHCMed.EPD.Infection).GetObjById(EpdDicID)
					Continue:'$IsObject(objEpdDic)
					Set EpdGroup=objEpdDic.MIFKind
					Continue:EpdGroup=""
					
					Set ReportID=""
					For {
						Set ReportID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,EpdDicID,ReportID))
						Quit:ReportID=""
						
						Set objReport=##class(DHCMed.EPD.Epidemic).GetObjById(ReportID)
						Continue:'$IsObject(objReport)
						Continue:objReport.MEPDStatus'=2      //必须是 “已审” 状态
						Continue:objReport.MEPDText1'=xPaadm  //就诊号
						
						Set num=$i(^DHCMed.EPD("OPStat",+AdmDate,+HospitalID,+AdmLoc,EpdGroup,"已报"))
					}
				}
			}
			*/
		}
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set ReportID=""
			For {
				Set ReportID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLoc,ReportID))
				Quit:ReportID=""
				
				Set objReport=##class(DHCMed.EPD.Epidemic).GetObjById(ReportID)
				Continue:'$IsObject(objReport)
				Continue:objReport.MEPDStatus'=2      //必须是 “已审” 状态
				Set xPaadm=objReport.MEPDText1
				Continue:xPaadm=""
				
				Set AdmStatus=$p($g(^PAADM(xPaadm)),"^",2)
				Continue:AdmStatus'="O"  //只统计门诊患者
				
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(xLoc)
				Continue:'$IsObject(objLoc)
				If objLoc'="" Do objLoc.%Close()
				Set HospitalID=objLoc.HospitalDr
				
				Set EpdGroup=objReport.MEPDICDDR.MIFKind
				Continue:EpdGroup=""
				
				Set num=$i(^DHCMed.EPD("OPStat",+xDate,+HospitalID,+xLoc,EpdGroup,"已报"))
			}
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2012-11-19
/// Description:  传染病门诊统计
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicOPStat","QryEpdOPStat","2012-11-01","2012-11-01","","")
Query QryEpdOPStat(aFromDate As %String, aToDate As %String, aLocID As %String, aHospID As %String) As %Query(ROWSPEC = "StatDate:%String,HospDesc:%String,LocDesc:%String,AdmNum:%Integer,EpdGrpDesc:%String,YBCount:%Integer,WBCount:%Integer,YIBCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryEpdOPStatExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aLocID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	//Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	//Set:aToDate["-" aToDate=$zdh(aToDate,3)
	//Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aFromDate'="" aFromDate=+aFromDate
	Set:aToDate'="" aToDate=+aToDate
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	//Set flg=..InitEpdOPStatData(aFromDate,aToDate)
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.EPD("OPStat",xDate))
		Quit:(xDate="")||(xDate>aToDate)
		//Set StatDate=$zd(xDate,3)
		Set StatDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(StatDate)
		
		Set HospID=""
		For {
			Set HospID=$o(^DHCMed.EPD("OPStat",xDate,HospID))
			Quit:HospID=""
			Continue:(aHospID'="")&&(HospID'=aHospID)
			Set HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
			
			Set LocID=""
			For {
				Set LocID=$o(^DHCMed.EPD("OPStat",xDate,HospID,LocID))
				Quit:LocID=""
				Continue:(aLocID'="")&&(LocID'=aLocID)
				Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
				Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
				Continue:LocDesc=""
				
				Set AdmNum=+$g(^DHCMed.EPD("OPStat",xDate,HospID,LocID))
				Set Data=$lb(StatDate,HospDesc,LocDesc,AdmNum,"",0,0,0)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				
				Set EpdGroup=""
				For {
					Set EpdGroup=$o(^DHCMed.EPD("OPStat",xDate,HospID,LocID,EpdGroup))
					Quit:EpdGroup=""
					
					Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdemicType",EpdGroup,"")
					Continue:'$IsObject(objDic)
					Set EpdGroupDesc=objDic.Description
					
					Set YBCount=+$g(^DHCMed.EPD("OPStat",xDate,HospID,LocID,EpdGroup,"已报"))
					Set WBCount=+$g(^DHCMed.EPD("OPStat",xDate,HospID,LocID,EpdGroup,"未报"))
					Set YIBCount=YBCount+WBCount
					
					Set Data=$lb(StatDate,HospDesc,LocDesc,0,EpdGroupDesc,YBCount,WBCount,YIBCount)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryEpdOPStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpdOPStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEpdOPStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpdOPStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-11-19
/// Description:  查询传染病字典分类
/// Table：       DHCMed.EPD.Infection
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicOPStat","QryEpdGrpList")
Query QryEpdGrpList() As %Query(ROWSPEC = "DicID:%Integer,DicDesc:%String,DicGrp:%Integer,DicGrpDesc:%String") [ SqlProc ]
{
}

ClassMethod QryEpdGrpListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set IFRowid=0
	For {
		Set IFRowid=$o(^DHCMed.EPDC("IF",IFRowid))
		Quit:IFRowid=""
		
		Set objIF=##class(DHCMed.EPD.Infection).GetObjById(IFRowid)
		Continue:'$IsObject(objIF)
		Set IFKindID=objIF.MIFKind
		Set IFKind=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKindID,"")
		Set:$IsObject(objDic) IFKind=objDic.Description
		//Continue:IFKind="AFP"  //AFP暂时不考虑
		Set DicDesc=objIF.MIFDisease
		Continue:(DicDesc="")||(IFKind="")
		
		Set Data=$lb(IFRowid,DicDesc,IFKindID,IFKind)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEpdGrpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpdGrpListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEpdGrpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpdGrpListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 检查传染病是否已上报
/// w ##class(DHCMed.EPDService.EpidemicOPStat).IsReported()
ClassMethod IsReported(aPaadm As %String, aEpdDic As %String, aEpdGroup As %String) As %String
{
	New (aPaadm,aEpdDic,aEpdGroup)
	Set return=0
	Quit:aPaadm="" return
	Quit:(aEpdGroup="")&&(aEpdDic="") return
	
	Set PatientID=$p($g(^PAADM(aPaadm)),"^",1)
	Quit:PatientID="" return
	
	Set EpdDicID=""
	For {
		Set EpdDicID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,EpdDicID))
		Quit:EpdDicID=""
		Quit:return>0
		
		//根据传染病字典判断是否已报
		Continue:(aEpdDic'="")&&(aEpdDic'=EpdDicID)
		//根据传染病类别判断是否已报
		Set objEpdDic=##class(DHCMed.EPD.Infection).GetObjById(EpdDicID)
		Continue:$IsObject(objEpdDic)
		Set EpdGroup=objEpdDic.MIFKind
		Continue:(aEpdGroup'="")&&(aEpdGroup'=EpdGroup)
		
		Set ReportID=""
		For {
			Set ReportID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,EpdDicID,ReportID))
			Quit:ReportID=""
			Quit:return>0
			
			Set objReport=##class(DHCMed.EPD.Epidemic).GetObjById(ReportID)
			Continue:'$IsObject(objReport)
			Continue:objReport.MEPDStatus'=2 //必须是 “已审” 状态
			
			Set return=1
		}
	}
	
	Quit return
}

}
