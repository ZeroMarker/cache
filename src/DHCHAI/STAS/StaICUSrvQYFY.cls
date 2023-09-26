/// 名称: DHCHAI.STAS.StaService
/// 描述: 青医附院ICU(NICU)统计报表服务
/// 编写者：pylian
/// 编写日期: 2018-04-13
Class DHCHAI.STAS.StaICUSrvQYFY Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-04-13
/// Description:  三管感染发病率统计
/// Table：       DHCHAI.IR.ICULog
/// Input:        aHospIDs： 多个医院用"|"连接
///               aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 			  aFromDate：开始日期
/// 			  aToDate：  结束日期     
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaICUSrvQYFY","StaICUSurvery","","","2018-03-01","2018-04-13")
Query StaICUSurvery(aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,TotalInHospSum:%Integer,NewInHospSum:%Integer,InHospSum:%Integer,UCSum:%Integer,PICCSum:%Integer,VAPSum:%Integer,InfPICCPatSum:%Integer,InfPICCSum:%Integer,InfUCPatSum:%Integer,InfUCSum:%Integer,InfVAPPatSum:%Integer,InfVAPSum:%Integer") [ SqlProc ]
{
}

ClassMethod StaICUSurveryExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
 	Quit:(aFromDate>aToDate) $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	Kill ^TMP($zn,$j,"StaICUSurvery")
	Kill ^TMP($zn,$j,"StaICUInfection")

	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID))
		Quit:xLocID=""
		Continue:(aLocIDs'="")&($listfind(aLocIDs,xLocID)<1)  //按科室过滤
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set IsICU = objLoc.BTIsICU
		Continue:IsICU'=1
		Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xLocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		
		//插管信息
		For xDate=aFromDate:1:aToDate {
			Quit:xDate>(+$h)			
			Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
			Continue:'$IsObject(objLog)
			Set PICCCnt=objLog.ILIsPICC             //中心静脉置管日数
			Set VAPCnt=objLog.ILIsVAP               //呼吸机置管日数
			Set UCCnt=objLog.ILIsUC                 //导尿管置管日数
			
			Set InHospNewCnt=objLog.ILNewCnt        //每日新入人数
			Set InHospCnt=objLog.ILAdmCnt           //每日住在人数
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum")=num+InHospNewCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum")=num+InHospCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum")=num+UCCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum")=num+VAPCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum")=num+PICCCnt
			
			Set xDtlID=0
			For {
				Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexLocDate",xLocID,xDate,xDtlID))
				Quit:xDtlID=""
			 
				Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xDtlID)
				Continue:'$IsObject(objDtl)
				Continue:'$IsObject(objDtl.ILEpisodeDr)
				Set EpisodeDr=objDtl.ILEpisodeDr.%Id()
				
				//三管感染信息从感染报告取值
				Do ICUINFInfoByInfRep(EpisodeDr,xDate,xLocID)
			}
		}
	}
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaICUSurvery",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set NewInHospSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum"))
		Set InHospSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum"))
		Set UCSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum"))
		Set PICCSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum"))
		Set VAPSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum"))
		
		Set InfPICCPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum"))
		Set InfPICCSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum"))
		Set InfUCPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum"))
		Set InfUCSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum"))
		Set InfVAPPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum"))
		Set InfVAPSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum"))
		
		Set TotalInHospSum=InHospSum
		
		Set Data=$lb(xLocID,LocDesc)
		Set Data=Data_$lb(TotalInHospSum,NewInHospSum,InHospSum,UCSum,PICCSum,VAPSum)
		Set Data=Data_$lb(InfPICCPatSum,InfPICCSum,InfUCPatSum,InfUCSum,InfVAPPatSum,InfVAPSum)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaICUSurvery")
	Kill ^TMP($zn,$j,"StaICUInfection")
	Quit $$$OK
	
ICUINFInfoByInfRep(xEpisodeDr,xInfDate,xLocID)
	// 三管感染信息（感染报告） 
	Set xDiagID=0
	For {
		Set xDiagID=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",xEpisodeDr,xInfDate,xDiagID))
		Quit:xDiagID=""

		Set objDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiagnos)
		Continue:'$IsObject(objDiagnos.IREpisodeDr)
		Continue:'$IsObject(objDiagnos.IRInfSubDr)
		Set InfSubCode=objDiagnos.IRInfSubDr.BTCode
		Continue:(InfSubCode'["CAUTI")&(InfSubCode'["VAP")&(InfSubCode'["CLABSI")&(InfSubCode'["CRBSI")
		Set EpisodeDr=objDiagnos.IREpisodeDr.%Id()
		Set InfDate=objDiagnos.IRInfDate
		
		Set arrInfRepIDs=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xDiagID)
		Continue:arrInfRepIDs.Count()<1
		
		If InfSubCode["CAUTI" {
			//导尿管相关泌尿系感染(CA-UTI)
			
			// UC插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum")=num+1
			
			// UC插管感染人次
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum")=num+1
		}
		If InfSubCode["VAP" {
			//呼吸机相关性肺炎(VAP)
			// VAP插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum")=num+1
			
			// VAP插管感染人次
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum")=num+1
		}
		If (InfSubCode["CLABSI")||(InfSubCode["CRBSI") {
			//导管相关血流感染（CLABSI）
			//导管所致血流感染（CRBSI）
			
			// PICC插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum")=num+1
			
			// PICC插管感染人次
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum")=num+1
		}
	}
	Quit 1
}

ClassMethod StaICUSurveryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaICUSurveryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaICUSurveryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaICUSurveryExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-04-13
/// Description:  新生儿器械使用率及其相关感染发病率统计
/// Table：       DHCHAI.IR.ICULog、DHCHAI.IR.ICULogDtl
/// Input:        aHospIDs： 多个医院用"|"连接
///               aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 			  aFromDate：开始日期
/// 			  aToDate：  结束日期 
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaICUSrvQYFY","StaNICUSurvery","","","2018-03-01","2018-04-13")
Query StaNICUSurvery(aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,WtCat:%Integer,NewInHospSum:%Integer,InHospSum:%Integer,PICCSum:%Integer,VAPSum:%Integer,TQZZSum:%Integer,WtCatQTZZ:%Integer,InfPatSum:%Integer,InfSum:%Integer,InfPICCPatSum:%Integer,InfPICCSum:%Integer,InfVAPPatSum:%Integer,InfVAPSum:%Integer") [ SqlProc ]
{
}

ClassMethod StaNICUSurveryExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
 	Quit:(aFromDate>aToDate) $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	Kill ^TMP($zn,$j,"StaNICUSurvery")
	Kill ^TMP($zn,$j,"StaNICUInfection")
	
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID))
		Quit:xLocID=""
		Continue:(aLocIDs'="")&($listfind(aLocIDs,xLocID)<1)  //按科室过滤
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set IsNICU = objLoc.BTIsNICU
		Continue:IsNICU'=1
		Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xLocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		
		For xDate=aFromDate:1:aToDate {
			Quit:xDate>(+$h)
			
			Set xWtCat=0
			For {
				Set xWtCat=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",xLocID,xDate,xWtCat))
		        Quit:xWtCat=""
		         
				Set xLogID=0
				For {
					Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",xLocID,xDate,xWtCat,xLogID))
			        Quit:xLogID=""
					Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
					Continue:'$IsObject(objLog)
					Set PICCCnt=objLog.ILIsPICC             //中心静脉置管日数
					Set VAPCnt=objLog.ILIsVAP               //呼吸机置管日数
				
					Set InHospNewCnt=objLog.ILNewCnt        //每日新入人数
					Set InHospCnt=objLog.ILAdmCnt           //每日住在人数
					
					Set xDtlID=0
					For {
						Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexLocDate",xLocID,xDate,xDtlID))
						Quit:xDtlID=""
					
						Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xDtlID)
						Continue:'$IsObject(objDtl)
						Continue:'$IsObject(objDtl.ILEpisodeDr)
						Set EpisodeDr=objDtl.ILEpisodeDr.%Id()
					    
						If '$d(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PatAdm",EpisodeDr))
						{
							Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PatAdm",EpisodeDr)=""
							Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PatAdm"))
							Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PatAdm")=num+1
						}
						
						//器械相关感染信息从新生儿感染报告取值
						Do NICUINFInfoByInfRep(EpisodeDr,xDate,xLocID,xWtCat)
					}
				}	
				Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"NewInHospSum"))
				Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"NewInHospSum")=num+InHospNewCnt
				Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"InHospSum"))
				Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"InHospSum")=num+InHospCnt
				Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"PICCSum"))
				Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"PICCSum")=num+PICCCnt
				Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"VAPSum"))
				Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"VAPSum")=num+VAPCnt	
			}
		}
	}
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaNICUSurvery",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		
		Set TQZZSum=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PatAdm"))
	    Set xPaAdm=""
		For {
			Set xPaAdm=$o(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PatAdm",xPaAdm))
			Quit:xPaAdm=""
			
			Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(xPaAdm)
			Continue:'$IsObject(objAdm)
			Set Weigth=objAdm.PAAdmitWeight
			Set Weigth=+Weigth
			Set:(Weigth<=1000) WtCat=1
			Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
			Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
			Set:(Weigth>2500) WtCat=4
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,WtCat,"WtCatTQZZ"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,WtCat,"WtCatTQZZ")=num+1
		}
		Set xWtCat=0
		For {
			Set xWtCat=$o(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat))
			Quit:xWtCat=""
			Continue:xWtCat="PatAdm"
			Set NewInHospSum=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"NewInHospSum"))
			Set InHospSum=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"InHospSum"))
			Set PICCSum=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"PICCSum"))
			Set VAPSum=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"VAPSum"))
			Set WtCatQTZZ=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,xWtCat,"WtCatTQZZ"))
			
			Set InfPatSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfPatSum"))
			Set InfSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfSum"))
			Set InfPICCPatSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfPICCPatSum"))
			Set InfPICCSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfPICCSum"))
			Set InfVAPPatSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfVAPPatSum"))
			Set InfVAPSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfVAPSum"))
			
			Set Data=$lb(xLocID,LocDesc)
			Set Data=Data_$lb(xWtCat,NewInHospSum,InHospSum,PICCSum,VAPSum,TQZZSum,WtCatQTZZ,InfPatSum,InfSum,InfPICCPatSum,InfPICCSum,InfVAPPatSum,InfVAPSum)
		  	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}

	}
	Kill ^TMP($zn,$j,"StaNICUSurvery")
	Kill ^TMP($zn,$j,"StaNICUInfection")
	Quit $$$OK
NICUINFInfoByInfRep(xEpisodeDr,xInfDate,xLocID,xWtCat)
	//器械相关感染信息（新生儿感染报告）
	Set xDiagID=0
	For {
		Set xDiagID=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",xEpisodeDr,xInfDate,xDiagID))
		Quit:xDiagID=""
		
		Set objDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiagnos)
		Continue:'$IsObject(objDiagnos.IREpisodeDr)
		Continue:'$IsObject(objDiagnos.IRInfSubDr)
		Set InfSubCode=objDiagnos.IRInfSubDr.BTCode
		Set InfSubDesc=objDiagnos.IRInfSubDr.BTDesc
		Set EpisodeDr=objDiagnos.IREpisodeDr.%Id()
		Set InfDate=objDiagnos.IRInfDate
		
		Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
		Continue:'$IsObject(objAdm)
		Set Weigth=objAdm.PAAdmitWeight
		Set Weigth=+Weigth
		Set:(Weigth<=1000) WtCat=1
		Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
		Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
		Set:(Weigth>2500) WtCat=4
		Continue:WtCat'=xWtCat	
		Set arrInfRepIDs=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xDiagID)
		Continue:arrInfRepIDs.Count()<1
        Set objRep=arrInfRepIDs.GetAt(1)	
		Continue:objRep=""
		Set IRRepID=objRep.%Id()
		Set IRRepType=objRep.IRRepType
		Continue:IRRepType'=2
		
		If InfSubDesc="呼吸机相关肺炎" {
			//呼吸机相关肺炎(VAP)
			
			// VAP插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfVAPSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfVAPSum")=num+1
			
			// VAP插管感染人次
			Continue:$d(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfVAPAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfVAPAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfVAPPatSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfVAPPatSum")=num+1
		}
		If (InfSubDesc="脐静脉置管相关性血流感染")||(InfSubDesc="PICC置管相关性血流感染") {
			//脐静脉置管相关性血流感染
			//PICC置管相关性血流感染
			
			// PICC插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPICCSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPICCSum")=num+1
			
			// PICC插管感染人次
			Continue:$d(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPICCAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPICCAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPICCPatSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPICCPatSum")=num+1
		}
		If (InfSubDesc'="") {
			// 感染例次
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfSum")=num+1
			
			// 感染人次
			Continue:$d(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPatSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,WtCat,"InfPatSum")=num+1
		}
	}
	Quit 1
}

ClassMethod StaNICUSurveryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaNICUSurveryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaNICUSurveryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaNICUSurveryExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-04-16
/// Description:  ICU感染发病率统计
/// Table：       DHCHAI.IR.ICULog，DHCHAI.IR.ICULogDtl，DHCHAI.IR.INFReport，DHCHAI.IR.INFDiagnos
/// Input:        aHospIDs： 多个医院用"|"连接
///               aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 			  aFromDate：开始日期
/// 			  aToDate：  结束日期     
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaICUSrvQYFY","StaICUInf","","","2018-03-01","2018-04-13")
Query StaICUInf(aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,TQZZSum:%Integer,TotalInHospSum:%Integer,NewInHospSum:%Integer,InHospSum:%Integer,InfPatSum:%Integer,InfSum:%Integer") [ SqlProc ]
{
}

ClassMethod StaICUInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
 	Quit:(aFromDate>aToDate) $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	Kill ^TMP($zn,$j,"StaICUInf")
	Kill ^TMP($zn,$j,"StaICUInfection")

	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID))
		Quit:xLocID=""
		Continue:(aLocIDs'="")&($listfind(aLocIDs,xLocID)<1)  //按科室过滤
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set IsICU = objLoc.BTIsICU
		Continue:IsICU'=1
		Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xLocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		
		//插管信息
		For xDate=aFromDate:1:aToDate {
			Quit:xDate>(+$h)			
			Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
			Continue:'$IsObject(objLog)
		
			Set InHospNewCnt=objLog.ILNewCnt        //每日新入人数
			Set InHospCnt=objLog.ILAdmCnt           //每日住在人数
			
			Set num=+$g(^TMP($zn,$j,"StaICUInf",xLocID,"NewInHospSum"))
			Set ^TMP($zn,$j,"StaICUInf",xLocID,"NewInHospSum")=num+InHospNewCnt
			Set num=+$g(^TMP($zn,$j,"StaICUInf",xLocID,"InHospSum"))
			Set ^TMP($zn,$j,"StaICUInf",xLocID,"InHospSum")=num+InHospCnt
		
			Set xDtlID=0
			For {
				Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexLocDate",xLocID,xDate,xDtlID))
				Quit:xDtlID=""
			 
				Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xDtlID)
				Continue:'$IsObject(objDtl)
				Continue:'$IsObject(objDtl.ILEpisodeDr)
				Set EpisodeDr=objDtl.ILEpisodeDr.%Id()
				If '$d(^TMP($zn,$j,"StaICUInf",xLocID,"PatAdm",EpisodeDr))
				{
					Set ^TMP($zn,$j,"StaICUInf",xLocID,"PatAdm",EpisodeDr)=""
					Set num=+$g(^TMP($zn,$j,"StaICUInf",xLocID,"PatAdm"))
					Set ^TMP($zn,$j,"StaICUInf",xLocID,"PatAdm")=num+1
				}
				//三管感染信息从感染报告取值
				Do ICUInfoByInfRep(EpisodeDr,xDate,xLocID)
			}
		}
	}
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaICUInf",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set NewInHospSum=+$g(^TMP($zn,$j,"StaICUInf",xLocID,"NewInHospSum"))
		Set InHospSum=+$g(^TMP($zn,$j,"StaICUInf",xLocID,"InHospSum"))
		
		Set InfPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPatSum"))
		Set InfSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfSum"))
		Set TQZZSum=+$g(^TMP($zn,$j,"StaICUInf",xLocID,"PatAdm"))       //同期住院人数	
		Set TotalInHospSum=InHospSum                                    //同期住院天数
		
		Set Data=$lb(xLocID,LocDesc,TQZZSum,TotalInHospSum,NewInHospSum,InHospSum,InfPatSum,InfSum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaICUInf")
	Kill ^TMP($zn,$j,"StaICUInfection")
	Quit $$$OK
	
ICUInfoByInfRep(xEpisodeDr,xInfDate,xLocID)
	// 三管感染信息（感染报告）  
	Set xRepID=0
	For {
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeDr,1,xRepID))
		Quit:xRepID=""
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		
		Set objStatus = objRep.IRStatusDr
		Set RepStatus="" ,StatusCode= ""
		If $IsObject(objStatus){
			Set RepStatus = objStatus.BTDesc
			Set StatusCode=objStatus.BTCode
		}
		Continue:StatusCode'=3  //过滤非审核状态
		Set LinkDiags      = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		
		// 感染诊断信息
		Set (InfPosDescs,InfSubDescs,InfDateDescs)=""
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			// 感染日期
			Set InfDate = objDiags.IRInfDate
			Continue:InfDate'=xInfDate
			// 感染部位/感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_","_objInfPos.BTDesc
			}
			// 感染分类
			Set objInfSub = objDiags.IRInfSubDr
			If $IsObject(objInfSub){
				Set InfSubDescs = InfSubDescs_","_objInfSub.BTDesc
			}
			//青医附院要求感染例次按报告例次计算，并且说明一份报告中只存在一个感染诊断，存在多个感染诊断是错误报告
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfRepList",xRepID))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfRepList",xRepID)=""
			//感染例次
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfSum")=num+1
		
			//感染人次
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfAdmList",xEpisodeDr))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfAdmList",xEpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPatSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPatSum")=num+1
			
		}
		
	}
	Quit 1
}

ClassMethod StaICUInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaICUInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaICUInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaICUInfExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-04-16
/// Description:  NICU感染发病率统计
/// Table：       DHCHAI.IR.ICULog，DHCHAI.IR.ICULogDtl，DHCHAI.IR.INFReport，DHCHAI.IR.INFDiagnos
/// Input:        aHospIDs： 多个医院用"|"连接
///               aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 			  aFromDate：开始日期
/// 			  aToDate：  结束日期     
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaICUSrvQYFY","StaNICUInf","","","2018-03-01","2018-04-13")
Query StaNICUInf(aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,WtCat:%Integer,WtCatQTZZ:%Integer,InfPatSum:%Integer,InfSum:%Integer,NewInHospSum:%Integer,InHospSum:%Integer") [ SqlProc ]
{
}

ClassMethod StaNICUInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
 	Quit:(aFromDate>aToDate) $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	Kill ^TMP($zn,$j,"StaNICUInf")
	Kill ^TMP($zn,$j,"StaNICUInfection")

	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID))
		Quit:xLocID=""
		Continue:(aLocIDs'="")&($listfind(aLocIDs,xLocID)<1)  //按科室过滤
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set IsNICU = objLoc.BTIsNICU
		Continue:IsNICU'=1
		Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xLocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		For xDate=aFromDate:1:aToDate {
			Quit:xDate>(+$h)
			//插管信息
			Set xWtCat=0
			For {
				Set xWtCat=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",xLocID,xDate,xWtCat))
		        Quit:xWtCat=""
		         
				Set xLogID=0
				For {
					Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",xLocID,xDate,xWtCat,xLogID))
			        Quit:xLogID=""
					Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
					Continue:'$IsObject(objLog)			
					Set InHospNewCnt=objLog.ILNewCnt        //每日新入人数
					Set InHospCnt=objLog.ILAdmCnt           //每日住在人数
					
					Set xDtlID=0
					For {
						Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexLocDate",xLocID,xDate,xDtlID))
						Quit:xDtlID=""
					
						Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xDtlID)
						Continue:'$IsObject(objDtl)
						Continue:'$IsObject(objDtl.ILEpisodeDr)
						Set EpisodeDr=objDtl.ILEpisodeDr.%Id()
						If '$d(^TMP($zn,$j,"StaNICUInf",xLocID,"PatAdm",EpisodeDr))
						{
							Set ^TMP($zn,$j,"StaNICUInf",xLocID,"PatAdm",EpisodeDr)=""
							Set num=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,"PatAdm"))
							Set ^TMP($zn,$j,"StaNICUInf",xLocID,"PatAdm")=num+1
						}
						
						//从新生儿感染报告取值
						Do NICUInfoByInfRep(EpisodeDr,xDate,xLocID,xWtCat)
					}
				}	
				Set num=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat,"NewInHospSum"))
				Set ^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat,"NewInHospSum")=num+InHospNewCnt
				Set num=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat,"InHospSum"))
				Set ^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat,"InHospSum")=num+InHospCnt
			}
		}	
	}
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaNICUInf",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
	    Set TQZZSum=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,"PatAdm"))
	    
	    Set xPaAdm=""
		For {
			Set xPaAdm=$o(^TMP($zn,$j,"StaNICUInf",xLocID,"PatAdm",xPaAdm))
			Quit:xPaAdm=""
			
			Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(xPaAdm)
			Continue:'$IsObject(objAdm)
			Set Weigth=objAdm.PAAdmitWeight
			Set Weigth=+Weigth
			Set:(Weigth<=1000) WtCat=1
			Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
			Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
			Set:(Weigth>2500) WtCat=4
			
			Set num=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,WtCat,"WtCatTQZZ"))
			Set ^TMP($zn,$j,"StaNICUInf",xLocID,WtCat,"WtCatTQZZ")=num+1
		}

		Set xWtCat=""
		For {
			Set xWtCat=$o(^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat))
			Quit:xWtCat=""
		    Continue:xWtCat="PatAdm"
			Set NewInHospSum=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat,"NewInHospSum"))
			Set InHospSum=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat,"InHospSum"))
			Set WtCatQTZZ=+$g(^TMP($zn,$j,"StaNICUInf",xLocID,xWtCat,"WtCatTQZZ"))
					
			Set InfPatSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfPatSum"))
			Set InfSum=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfSum"))
					
			Set Data=$lb(xLocID,LocDesc,xWtCat,WtCatQTZZ,InfPatSum,InfSum,NewInHospSum,InHospSum)
		  	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}

	}
	Kill ^TMP($zn,$j,"StaNICUInf")
	Kill ^TMP($zn,$j,"StaNICUInfection")

	Quit $$$OK
	
NICUInfoByInfRep(xEpisodeDr,xInfDate,xLocID,xWtCat)
	// 三管感染信息（感染报告） 
	Set xRepID=0
	For {
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeDr,2,xRepID))
		Quit:xRepID=""
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		
		Set objStatus = objRep.IRStatusDr
		Set RepStatus="" ,StatusCode= ""
		If $IsObject(objStatus){
			Set RepStatus = objStatus.BTDesc
			Set StatusCode=objStatus.BTCode
		}
		Continue:StatusCode'=3  //过滤非审核状态
		Set LinkDiags      = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		
		Set EpisodeDr=objRep.IREpisodeDr.%Id()
		Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
		Continue:'$IsObject(objAdm)
		Set Weigth=objAdm.PAAdmitWeight
		Set Weigth=+Weigth
		Set:(Weigth<=1000) WtCat=1
		Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
		Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
		Set:(Weigth>2500) WtCat=4
		Continue:WtCat'=xWtCat	
		// 感染诊断信息
		Set (InfPosDescs,InfSubDescs,InfDateDescs)=""
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			// 感染日期
			Set InfDate = objDiags.IRInfDate
			Continue:InfDate'=xInfDate
			// 感染部位/感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_","_objInfPos.BTDesc
			}
			// 感染分类
			Set objInfSub = objDiags.IRInfSubDr
			If $IsObject(objInfSub){
				Set InfSubDescs = InfSubDescs_","_objInfSub.BTDesc
			}
			//青医附院要求感染例次按报告例次计算，并且说明一份报告中只存在一个感染诊断，存在多个感染诊断是错误报告
			Continue:$d(^TMP($zn,$j,"StaNICUInfection",xLocID,"InfRepList",xRepID))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,"InfRepList",xRepID)=""
			//感染例次
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfSum")=num+1
		
			//感染人次
			Continue:$d(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfPatSum"))
			Set ^TMP($zn,$j,"StaNICUInfection",xLocID,xWtCat,"InfPatSum")=num+1
			
		}
		
	}
	Quit 1
}

ClassMethod StaNICUInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaNICUInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaNICUInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaNICUInfExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-04-16
/// Description:  统计ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input:        aHospIDs： 多个医院用"|"连接
///               aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 			  aFromDate：开始日期
/// 			  aToDate：  结束日期 
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaICUSrvQYFY","StaICUGrade","","","2018-03-01","2018-04-18")
Query StaICUGrade(aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "IGLocID:%String,IGLocDesc:%String,IGYear:%String,IGMonth:%String,IGItem1:%Integer,IGItem2:%Integer,IGItem3:%Integer,IGItem4:%Integer,IGItem5:%Integer,IGItemCount:%Integer,IGScoreCount:%Integer") [ SqlProc ]
{
}

ClassMethod StaICUGradeExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocIDs As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aFromDate="")||(aToDate="") $$$OK
 	Quit:(aFromDate>aToDate) $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set aFromDate=$zd(aFromDate,3)
	Set YearFrom=$p(aFromDate,"-",1)
	Set MonthFrom=$p(aFromDate,"-",2)
	Set WeekFrom=$p(aFromDate,"-",3)\7
	Set:WeekFrom>4 WeekFrom=4
	
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set aToDate=+aToDate
	Set aToDate=$zd(aToDate,3)
	Set YearTo=$p(aToDate,"-",1)
	Set MonthTo=$p(aToDate,"-",2)
	Set WeekTo=$p(aToDate,"-",3)\7
	Set:WeekTo>4 WeekFrom=4
	
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",xLocID))
		Quit:xLocID=""
	    Continue:(aLocIDs'="")&($listfind(aLocIDs,xLocID)<1)  //按科室过滤
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xLocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		
		Set xYear=YearFrom-1
		For {
			Set xYear=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",xLocID,xYear))
			Quit:xYear=""
			Quit:xYear>YearTo
			Set xMonth=0
			For {
				Set xMonth=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",xLocID,xYear,xMonth))
				Quit:xMonth=""
				Continue:(xYear=YearFrom)&&(xMonth<MonthFrom)
				Continue:(xYear=YearTo)&&(xMonth>MonthTo)
				Set xWeek=0
				For {
					Set xWeek=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",xLocID,xYear,xMonth,xWeek))
					Quit:xWeek=""
					Continue:(xYear=YearFrom)&&(xMonth=MonthFrom)&&(xWeek<WeekFrom)
					Continue:(xYear=YearTo)&&(xMonth=MonthTo)&&(xWeek>WeekTo)
					
					Set (IGItem1,IGItem2,IGItem3,IGItem4,IGItem5,IGItemCount,IGScoreCount)=""
					Set xGradeID=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",xLocID,xYear,xMonth,xWeek,0))
				
					Set objGrade=##class(DHCHAI.IR.ICUGrade).GetObjById(xGradeID)
					If $IsObject(objGrade)
					{
						Set IGItem1=objGrade.IGItem1
						Set IGItem2=objGrade.IGItem2
						Set IGItem3=objGrade.IGItem3
						Set IGItem4=objGrade.IGItem4
						Set IGItem5=objGrade.IGItem5	
						Set IGItemCount=(+IGItem1)+(+IGItem2)+(+IGItem3)+(+IGItem4)+(+IGItem5)
						Set IGScoreCount=((+IGItem1)*1)+((+IGItem2)*2)+((+IGItem3)*3)+((+IGItem4)*4)+((+IGItem5)*5)
						Set Data=$lb(xLocID,LocDesc,xYear,xMonth,IGItem1,IGItem2,IGItem3,IGItem4,IGItem5,IGItemCount,IGScoreCount)
						Set ^CacheTemp(repid,ind)=Data
	    				Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod StaICUGradeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaICUGradeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaICUGradeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaICUGradeExecute ]
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

}
