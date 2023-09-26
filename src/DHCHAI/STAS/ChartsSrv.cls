/// 名称: DHCHAI.STAS.ChartsSrv
/// 描述: 院感统计图相关服务
/// 编写者：蒋朋朋
/// 编写日期: 2018-05-22
Class DHCHAI.STAS.ChartsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-05-22
/// Description:  查询当月科室感染发病率
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.ChartsSrv","QryLocInfRatio","2","2018-08")
Query QryLocInfRatio(aLocID As %String, aMonth As %String) As %Query(ROWSPEC = "ind:%String,LocID:%String,LocDesc:%String,InfRatio:%String,InfCount:%String,InLocCount:%String") [ SqlProc ]
{
}

ClassMethod QryLocInfRatioExecute(ByRef qHandle As %Binary, aLocID As %String, aMonth As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set DateFrom=$zdh(aMonth_"-01",3)
	Set DateTo=$zdh($e($zd(DateFrom+31,3),1,7)_"-01",3)-1
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	
	Set NIndex="QryLocInfRatio"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	
	// 同期在科人数
    Set num=0
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLoc(DateFrom,DateTo,"E","","I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)
		Continue:TransInfo=""
		Set EpisodeID  = $LIST(TransInfo,1)
		Set TransLocDr = $LIST(TransInfo,2)
		Set TransID    = $LIST(TransInfo,3)
		
        Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(TransLocDr)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(HospGrpID'="")&(HospGrpID'=objLoc.BTHospDr.BTGroupDr.%Id())  // 按登录科室院区过滤
		
		Continue:$d(^TMP($zn,$j,NIndex,TransLocDr,EpisodeID,1))  //同科多次转入转出重复计算
		Set ^TMP($zn,$j,NIndex,TransLocDr,EpisodeID,1)=""
		Set num=$i(^TMP($zn,$j,NIndex,TransLocDr,"同期在科人数"))
    }
    Set RepList=""
    // 同期感染人数,感染日期
	For xDate=DateFrom:1:DateTo {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xID))
			Quit:xID=""
			
			Set objDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(objDiagnos)
			Set EpisodeID=objDiagnos.IREpisodeDr.%Id()
			Set InfLocDr=""
			Set:$IsObject(objDiagnos.IRInfLocDr) InfLocDr=objDiagnos.IRInfLocDr.%Id()  // 感染科室
			If InfLocDr="" {
				Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,xDate,"")	//取感染日期所在科室
				Continue:TransInfo=""
				Set InfLocDr=$p(TransInfo,"^",1)
				Continue:InfLocDr=""
			}
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(InfLocDr)
			Continue:'$IsObject(objLoc)
			
			Set ReportID = $o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xID,""))
			Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
			Continue:'$IsObject(objRep)
			//Continue:$listfind(RepList,ReportID)>0
			Set RepList=RepList_$lb(ReportID)
			Set (StatusCode,StatusDesc)=""
			If $IsObject(objRep.IRStatusDr) {
				Set StatusCode = objRep.IRStatusDr.BTCode
				Set StatusDesc = objRep.IRStatusDr.BTDesc
			}
			Continue:StatusCode'=3  // 过滤非审核状态的报告
			
			Continue:'$IsObject(objLoc.BTHospDr)
			Continue:(HospGrpID'="")&(HospGrpID'=objLoc.BTHospDr.BTGroupDr.%Id())  // 按登录科室院区过滤
			
			Set arrRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xID)
			Continue:arrRep.Count()<1
			//同科一人多份报告不会被统计到，所以注释 2020-04-02
			//Continue:$d(^TMP($zn,$j,NIndex,InfLocDr,EpisodeID,2))  //同科多次转入转出重复计算
			//Set ^TMP($zn,$j,NIndex,InfLocDr,EpisodeID,2)=""
			Set num=$i(^TMP($zn,$j,NIndex,InfLocDr,"同期感染人数"))
		}
	}
	Set xLoc=""
	For {
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLoc)
		Continue:'$isobject(objLoc)
		Set LocDesc=objLoc.BTDesc2
		Set:LocDesc="" LocDesc=objLoc.BTDesc
		Set InfRatio=0
      	Set InLocCount =+$g(^TMP($zn,$j,NIndex,xLoc,"同期在科人数"))
      	Set InfCount   =+$g(^TMP($zn,$j,NIndex,xLoc,"同期感染人数"))
      	//w LocDesc_"^"_InLocCount_"^"_InfCount,!
		Continue:InLocCount=0
      	Set InfRatio = (InfCount/InLocCount)*100  // 科室感染率
      	Set ^TMP($zn,$j,"RatioSort",InfRatio,LocDesc,InfCount)=1
      	Set ^TMP($zn,$j,"RatioSort",LocDesc)=xLoc_"^"_InLocCount
	}
	set Count=0
	Set xRatio=""
	For {
		Set xRatio=$o(^TMP($zn,$j,"RatioSort",xRatio),-1)
		Quit:((xRatio="")||(Count>9))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"RatioSort",xRatio,xLocDesc))
			Quit:((xLocDesc="")||(Count>9))
			Set LocDesc=xLocDesc
			Set InfCount=$o(^TMP($zn,$j,"RatioSort",xRatio,xLocDesc,""))
			Set InLocID=$p($g(^TMP($zn,$j,"RatioSort",LocDesc)),"^",1)
			Set InLocCount=$p($g(^TMP($zn,$j,"RatioSort",LocDesc)),"^",2)
			set Count=Count+1
      		Set Data=$lb(ind,InLocID,LocDesc,xRatio,InfCount,InLocCount)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	Quit $$$OK
}

ClassMethod QryLocInfRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocInfRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocInfRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocInfRatioExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-05-22
/// Description:  统计感染部位/诊断
/// Input:        aHospIDs： 多个医院用|连接
/// 			  aDateType：日期类型(1：报告日期、2：感染日期)
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.ChartsSrv","QryInfPosByRep","2","1","2018-01-01","2018-01-29")
Query QryInfPosByRep(aHospIDs As %String, aDateType As %String, aMonth As %String) As %Query(ROWSPEC = "ind:%String,PosDesc:%String,PosCount:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosByRepExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aMonth As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateType="")||(aMonth="") $$$OK
	
 	Set aDateFrom=$zdh(aMonth_"-01",3)
	Set aDateTo=$zdh($e($zd(aDateFrom+31,3),1,7)_"-01",3)-1
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	
 	Set NIndex="QryInfPosByRep"
	Kill ^TMP($zn,$j,NIndex)
	
	//报告日期
	if aDateType=1 {
		For xDate=aDateFrom:1:aDateTo {
			Set xReportID = 0
			For {
				Set xReportID = $o(^DHCHAI.IR.INFReportI("IndexRepDate",1,xDate,xReportID))
				Quit:xReportID=""
				
				Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xReportID)
				Continue:'$IsObject(objRep)
				
				Set EpisodeID = objRep.IREpisodeDr.%Id()
				Set PatientID = objRep.IREpisodeDr.PAPatientIDx
				Set ReportID  = xReportID
				Set ReportLocDr = objRep.IRRepLocDr
				Continue:'$IsObject(objRep.IRRepLocDr.BTHospDr)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,objRep.IRRepLocDr.BTHospDr.%Id())<1)  //按医院过滤	
	
				Set ReportLoc = ""
				If ReportLocDr'=""{
					Set ReportLoc = ReportLocDr.BTDesc
					Set ReportLoc2 = ReportLocDr.BTDesc2
					Set:ReportLoc2'="" ReportLoc = ReportLoc2
				}
				Set (StatusCode,StatusDesc)=""
				If $IsObject(objRep.IRStatusDr) {
					Set StatusCode = objRep.IRStatusDr.BTCode
					Set StatusDesc = objRep.IRStatusDr.BTDesc
				}
				Continue:StatusCode'=3  // 过滤非审核状态的报告
				
				Set LinkDiags      = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
				
				For indx = 1:1:$l(LinkDiags,","){
					Set xDiagID = $p(LinkDiags,",",indx)
					Continue:xDiagID=""
					
					Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
					Continue:'$IsObject(objDiags)
					
					// 感染部位/感染诊断
					Set objInfPos = objDiags.IRInfPosDr
					Set PosDesc=""
					If $IsObject(objInfPos){
						Set PosCode=objInfPos.BTCode
						Set BigCode=$e(PosCode,1,2)
						Set objDiag=##class(DHCHAI.BT.InfPos).GetObjByCode(BigCode)
						Set PosDesc=objDiag.BTDesc
					}
					If (PosDesc'="") {
						Set ^TMP($zn,$j,NIndex,PosDesc)=1
						Set ^TMP($zn,$j,NIndex,PosDesc,"Count")=$i(^TMP($zn,$j,NIndex,PosDesc,"Count"))
					}
				}
			}
		}
	//感染日期
	}Else{
		For xDate=aDateFrom:1:aDateTo {
			Set xInfDiagID = ""
			For {
				Set xInfDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xInfDiagID))
				Quit:xInfDiagID=""
				
				Set objDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagID)
				Quit:'$IsObject(objDiagnos)
				Set EpisodeID = objDiagnos.IREpisodeDr.%Id()
				Set PatientID = objDiagnos.IREpisodeDr.PAPatientIDx
				Set ReportID = $o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xInfDiagID,""))
				Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
				Continue:'$IsObject(objRep)
				Set ReportLocDr = objRep.IRRepLocDr
				Continue:'$IsObject(objRep.IRRepLocDr.BTHospDr)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,objRep.IRRepLocDr.BTHospDr.%Id())<1)  //按医院过滤	

				Set ReportLoc = ""
				If ReportLocDr'="" {
					Set ReportLoc = ReportLocDr.BTDesc
					Set ReportLoc2 = ReportLocDr.BTDesc2
					Set:ReportLoc2'="" ReportLoc = ReportLoc2
				}
				Set (StatusCode,StatusDesc)=""
				If $IsObject(objRep.IRStatusDr) {
					Set StatusCode = objRep.IRStatusDr.BTCode
					Set StatusDesc = objRep.IRStatusDr.BTDesc
				}
				Continue:StatusCode'=3  // 过滤非审核状态的报告
				
				Set LinkDiags      = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
				Set InfPosDescs=""
				For indx = 1:1:$l(LinkDiags,","){
					Set xDiagID = $p(LinkDiags,",",indx)
					Continue:xDiagID=""
					
					Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
					Continue:'$IsObject(objDiags)
					
					// 感染部位/感染诊断
					Set PosDesc=""
					Set objInfPos = objDiags.IRInfPosDr
					If $IsObject(objInfPos){
						Set PosCode=objInfPos.BTCode
						Set BigCode=$e(PosCode,1,2)
						Set objDiag=##class(DHCHAI.BT.InfPos).GetObjByCode(BigCode)
						Set PosDesc=objDiag.BTDesc
					}
					If (PosDesc'="") {
						Set ^TMP($zn,$j,NIndex,PosDesc)=1
						Set ^TMP($zn,$j,NIndex,PosDesc,"Count")=$i(^TMP($zn,$j,NIndex,PosDesc,"Count"))
					}
				}
			}
		}
	}
	
	Set xPosDesc=""
	For {
		Set xPosDesc=$o(^TMP($zn,$j,NIndex,xPosDesc))
		Quit:xPosDesc=""
		
		Set PosCount=$g(^TMP($zn,$j,NIndex,xPosDesc,"Count"))
		
		Set Data=$lb(ind,xPosDesc,PosCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryInfPosByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosByRepExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-13
/// Description:  查询一个科室各时间点的数与率
/// Input:        aLocID：科室ID
/// 			  aMonthFrom:开始月份
/// 			  aMonthTo:结束月份
/// 			  aNumerator:分子
/// 			  aDenominator:分母
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.ChartsSrv","QryECResultByTime","","2018-01","2018-08","BabyHAICase","BabyInHosp")
Query QryECResultByTime(aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aNumerator As %String, aDenominator As %String, aHospID As %String = "") As %Query(ROWSPEC = "ind:%String,Value1:%String,Value2:%String,Ratio:%String,ECTime:%String,LocID:%String")
{
}

ClassMethod QryECResultByTimeExecute(ByRef qHandle As %Binary, aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aNumerator As %String, aDenominator As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aMonthFrom=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthFrom)
	Set aMonthFrom=$p(aMonthFrom,"^",1)
	Set aMonthTo=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthTo)
	Set aMonthTo=$p(aMonthTo,"^",1)
	Quit:(aMonthFrom="")||(aMonthTo="") $$$OK
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode("DataMonth")
	Quit:'$IsObject(objType) $$$OK
	Set TypeDr=objType.%Id()
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode(aNumerator)
	Quit:'$IsObject(objTarget1) $$$OK
	Set TargetDr1=objTarget1.%Id()
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode(aDenominator)
	Quit:'$IsObject(objTarget2) $$$OK
	Set TargetDr2=objTarget2.%Id()
	
	Set NIndex="MonthCount"
	Kill ^TMP($zn,$j,NIndex)
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID))
		Quit:xLocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:(aLocID'="")&&(xLocID'=aLocID)
		If (aHospID'="") {
			Continue:'$IsObject(objLoc.BTHospDr)
			Continue:(aHospID'[objLoc.BTHospDr.%Id())
		}
		
		Set xECTime=aMonthFrom
		For {
			Set xECTime=$zdh(xECTime,3)
			Set (Numerator,Denominator)=0
			
			Set NumeratorID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID,TypeDr,xECTime,TargetDr1,""))
			Set objNumerator=##class(DHCHAI.STA.ECResult).GetObjById(NumeratorID)
			Set:$IsObject(objNumerator) Numerator=objNumerator.ECValue	//分子
			
			Set DenominatorID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID,TypeDr,xECTime,TargetDr2,""))
			Set objDenominator=##class(DHCHAI.STA.ECResult).GetObjById(DenominatorID)
			Set:$IsObject(objDenominator) Denominator=objDenominator.ECValue	//分母
			
			Set ^TMP($zn,$j,NIndex,xECTime,"Numerator")=+$g(^TMP($zn,$j,NIndex,xECTime,"Numerator"))+Numerator
			Set ^TMP($zn,$j,NIndex,xECTime,"Denominator")=+$g(^TMP($zn,$j,NIndex,xECTime,"Denominator"))+Denominator
			
			Set xECTime=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xECTime)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xECTime,aMonthTo)=0
		}
	}
	Set xECTime=aMonthFrom
	For {
		Set xECTime=$zdh(xECTime,3)
		Set Numerator=+$g(^TMP($zn,$j,NIndex,xECTime,"Numerator"))
		Set Denominator=+$g(^TMP($zn,$j,NIndex,xECTime,"Denominator"))
		If (+Denominator'=0) {
			Set Ratio=(Numerator/Denominator)*100
		} Else {
			Set Ratio=0
		}
		Set ECTime=$e($zd(xECTime,3),1,7)
		Set ^CacheTemp(repid,ind)=$lb(ind,Numerator,Denominator,Ratio,ECTime,aLocID)
		Set ind=ind+1
		
		Set xECTime=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xECTime)
		Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xECTime,aMonthTo)=0
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryECResultByTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryECResultByTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryECResultByTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryECResultByTimeExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-09-25
/// Description:  查询各科室某时间点(或时间段)的数与率
/// Input:        aLocID：科室ID
/// 			  aMonthFrom:开始月份
/// 			  aMonthTo:结束月份
/// 			  aNumerator:分子
/// 			  aDenominator:分母
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.ChartsSrv","QryECResultLocByTime","","2018-08","2018-08","HAICase","InHospCount","")
Query QryECResultLocByTime(aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aNumerator As %String, aDenominator As %String, aLocCount As %String) As %Query(ROWSPEC = "ind:%String,Value1:%String,Value2:%String,Ratio:%String,LocID:%String,LocDesc:%String")
{
}

ClassMethod QryECResultLocByTimeExecute(ByRef qHandle As %Binary, aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aNumerator As %String, aDenominator As %String, aLocCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aMonthFrom=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthFrom)
	Set aMonthFrom=$p(aMonthFrom,"^",1)
	Set aMonthTo=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthTo)
	Set aMonthTo=$p(aMonthTo,"^",1)
	Quit:(aMonthFrom="")||(aMonthTo="") $$$OK
	
	Set:+$g(aLocCount)=0 aLocCount=10 //显示的科室数(默认为10，按率从大到小排列)
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode("DataMonth")
	Quit:'$IsObject(objType) $$$OK
	Set TypeDr=objType.%Id()
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode(aNumerator)
	Quit:'$IsObject(objTarget1) $$$OK
	Set TargetDr1=objTarget1.%Id()
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode(aDenominator)
	Quit:'$IsObject(objTarget2) $$$OK
	Set TargetDr2=objTarget2.%Id()
	
	Set NIndex="MonthLocCount"
	Kill ^TMP($zn,$j,NIndex)
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID))
		Quit:xLocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:(aLocID'="")&&(xLocID'=aLocID)
		
		Set (Numerator,Denominator)=0
		Set xECTime=aMonthFrom
		For {
			Set xECTime=$zdh(xECTime,3)
			
			Set NumeratorID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID,TypeDr,xECTime,TargetDr1,""))
			Set objNumerator=##class(DHCHAI.STA.ECResult).GetObjById(NumeratorID)
			Set:$IsObject(objNumerator) Numerator=Numerator+objNumerator.ECValue	//分子
			
			Set DenominatorID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID,TypeDr,xECTime,TargetDr2,""))
			Set objDenominator=##class(DHCHAI.STA.ECResult).GetObjById(DenominatorID)
			Set:$IsObject(objDenominator) Denominator=Denominator+objDenominator.ECValue	//分母
			
			Set xECTime=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xECTime)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xECTime,aMonthTo)=0
		}
		Set:Numerator'=0 ^TMP($zn,$j,NIndex,xLocID,"Numerator")=+$g(^TMP($zn,$j,NIndex,xLocID,"Numerator"))+Numerator
		Set:Denominator'=0 ^TMP($zn,$j,NIndex,xLocID,"Denominator")=+$g(^TMP($zn,$j,NIndex,xLocID,"Denominator"))+Denominator
	}
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,xLocID))
		Quit:xLocID=""
		
		Set Numerator=+$g(^TMP($zn,$j,NIndex,xLocID,"Numerator"))
		Set Denominator=+$g(^TMP($zn,$j,NIndex,xLocID,"Denominator"))
		
		If (+Denominator'=0) {
			Set Ratio=(Numerator/Denominator)*100
		} Else {
			Set Ratio=0
		}
		Set ^TMP($zn,$j,NIndex,"Ratio",Ratio)=xLocID
	}
	//排序输出
	Set xCount=0
	Set xRatio=""
	For {
		Set xRatio=$o(^TMP($zn,$j,NIndex,"Ratio",xRatio),-1)
		Quit:xRatio=""
		Set xCount=$i(xCount)
		Quit:xCount>aLocCount
		
		Set LocID=$g(^TMP($zn,$j,NIndex,"Ratio",xRatio))
		Continue:LocID=""
		Set Numerator=+$g(^TMP($zn,$j,NIndex,LocID,"Numerator"))
		Set Denominator=+$g(^TMP($zn,$j,NIndex,LocID,"Denominator"))
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set LocDesc=objLoc.BTDesc
		Set LocDesc2=objLoc.BTDesc2
		Set:LocDesc2="" LocDesc2 = LocDesc
		Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
		
		Set ^CacheTemp(repid,ind)=$lb(ind,Numerator,Denominator,xRatio,LocID,LocDesc2)
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryECResultLocByTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryECResultLocByTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryECResultLocByTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryECResultLocByTimeExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-22
/// Description:  查询一段时间各科室的数与率
/// Input:        aLocID：科室ID
/// 			  aMonthFrom:开始月份
/// 			  aMonthTo:结束月份
/// 			  aNumerator:分子
/// 			  aDenominator:分母
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.ChartsSrv","QryECResultByLoc","575","2018-01","2018-07","BactCount","OperCount")
Query QryECResultByLoc(aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aNumerator As %String, aDenominator As %String) As %Query(ROWSPEC = "ind:%String,Value1:%String,Value2:%String,Ratio:%String,ECTime:%String,LocID:%String,LocDesc:%String")
{
}

ClassMethod QryECResultByLocExecute(ByRef qHandle As %Binary, aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aNumerator As %String, aDenominator As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aMonthFrom=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthFrom)
	Set aMonthFrom=$p(aMonthFrom,"^",1)
	Set aMonthTo=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthTo)
	Set aMonthTo=$p(aMonthTo,"^",1)
	Quit:(aMonthFrom="")||(aMonthTo="") $$$OK
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode("DataMonth")
	Quit:'$IsObject(objType) $$$OK
	Set TypeDr=objType.%Id()
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode(aNumerator)
	Quit:'$IsObject(objTarget1) $$$OK
	Set TargetDr1=objTarget1.%Id()
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode(aDenominator)
	Quit:'$IsObject(objTarget2) $$$OK
	Set TargetDr2=objTarget2.%Id()
	
	Set ECTime=$e(aMonthFrom,1,7)_"~"_$e(aMonthTo,1,7)
	Set NIndex="QryECResultByLoc"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID))
		Quit:xLocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:(aLocID'="")&&(xLocID'=aLocID)
		
		Set (Numerator,Denominator)=0
		Set xECTime=aMonthFrom
		For {
			Set xECTime=$zdh(xECTime,3)
			
			Set NumeratorID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID,TypeDr,xECTime,TargetDr1,""))
			Set objNumerator=##class(DHCHAI.STA.ECResult).GetObjById(NumeratorID)
			Set:$IsObject(objNumerator) Numerator=Numerator+objNumerator.ECValue	//分子
			
			Set DenominatorID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID,TypeDr,xECTime,TargetDr2,""))
			Set objDenominator=##class(DHCHAI.STA.ECResult).GetObjById(DenominatorID)
			Set:$IsObject(objDenominator) Denominator=Denominator+objDenominator.ECValue	//分母
			
			Set xECTime=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xECTime)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xECTime,aMonthTo)=0
		}
		If aLocID=""{
			Set xxLocID="ALL"
		} Else {
			Set xxLocID=xLocID
		}
		Set:Numerator'=0 ^TMP($zn,$j,NIndex,xxLocID,"Numerator")=+$g(^TMP($zn,$j,NIndex,xxLocID,"Numerator"))+Numerator
		Set:Denominator'=0 ^TMP($zn,$j,NIndex,xxLocID,"Denominator")=+$g(^TMP($zn,$j,NIndex,xxLocID,"Denominator"))+Denominator
	}
	
	Set xxLocID=""
	For {
		Set xxLocID=$o(^TMP($zn,$j,NIndex,xxLocID))
		Quit:xxLocID=""
		
		Set TValue1=$g(^TMP($zn,$j,NIndex,xxLocID,"Numerator"))
		Set TValue2=$g(^TMP($zn,$j,NIndex,xxLocID,"Denominator"))
		
		If (+TValue2'=0) {
			Set Ratio=(TValue1/TValue2)*100
		} Else {
			Set Ratio=0
		}
		If (xxLocID'="ALL") {
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xxLocID)
			Continue:'$IsObject(objLoc)
			Set LocDesc=objLoc.BTDesc
			Set:LocDesc'="" LocDesc=$p(LocDesc,"-",2)
		} Else {
			Set LocDesc="全院"
		}
		Set ^CacheTemp(repid,ind)=$lb(ind,TValue1,TValue2,Ratio,ECTime,xxLocID,LocDesc)
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryECResultByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryECResultByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryECResultByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryECResultByLocExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-22
/// Description:  查询饼图数据
/// Input:        aLocID：科室ID
/// 			  aMonthFrom:开始月份
/// 			  aMonthTo:结束月份
/// 			  aItemStr:项目
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.ChartsSrv","QryECResultForPie","","2018-01","2018-03","INFSuperInc^INFDeepInc^INFOrganInc")
Query QryECResultForPie(aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aItemStr As %String) As %Query(ROWSPEC = "ind:%String,ItemDesc:%String,Value:%String,ECTime:%String,LocID:%String")
{
}

ClassMethod QryECResultForPieExecute(ByRef qHandle As %Binary, aLocID As %String, aMonthFrom As %String, aMonthTo As %String, aItemStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aMonthFrom=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthFrom)
	Set aMonthFrom=$p(aMonthFrom,"^",1)
	Set aMonthTo=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aMonthTo)
	Set aMonthTo=$p(aMonthTo,"^",1)
	Quit:(aMonthFrom="")||(aMonthTo="") $$$OK
	
	Quit:aItemStr="" $$$OK
	Set HospID=2
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode("DataMonth")
	Quit:'$IsObject(objType) $$$OK
	Set TypeDr=objType.%Id()
	
	Set ECTime=aMonthFrom_"~"_aMonthTo
	Set NIndex="QryECResultForPie"
	Kill ^TMP($zn,$j,NIndex)
	
	
	Set TLocID=aLocID
	Set:aLocID="" TLocID="ALL"	
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID))
		Quit:xLocID=""
		Continue:(aLocID'="")&&(aLocID'=xLocID)
		
		Set xECTime=aMonthFrom
		For {
			Set xECTime=$zdh(xECTime,3)
			
			For indItem=1:1:$l(aItemStr,"^") {
				Set tmpItem=$p(aItemStr,"^",indItem)
				Set objTarget=##class(DHCHAI.STA.ECTarget).GetObjByCode(tmpItem)
				Continue:'$IsObject(objTarget)
				Set TargetDr=objTarget.%Id()
				Set TargetDesc=objTarget.ECDesc
				
				Set NumeratorID=$o(^DHCHAI.STA.ECResultI("IndexLocTypeTimeTar",xLocID,TypeDr,xECTime,TargetDr,""))
				Set objNumerator=##class(DHCHAI.STA.ECResult).GetObjById(NumeratorID)
				Continue:'$IsObject(objNumerator)
				Set value=objNumerator.ECValue
				
				Set ^TMP($zn,$j,NIndex,TLocID,"Item",TargetDesc)=$g(^TMP($zn,$j,NIndex,TLocID,"Item",TargetDesc))+value
			}
			Set xECTime=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xECTime)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xECTime,aMonthTo)=0
		}
		
	}
	
	Set xxLocID=""
	For {
		Set xxLocID=$o(^TMP($zn,$j,NIndex,xxLocID))
		Quit:xxLocID=""
		
		Set xTargetDesc=""
		For {
			Set xTargetDesc=$o(^TMP($zn,$j,NIndex,xxLocID,"Item",xTargetDesc))
			Quit:xTargetDesc=""
			
			Set Value=$g(^TMP($zn,$j,NIndex,xxLocID,"Item",xTargetDesc))
			Set ^CacheTemp(repid,ind)=$lb(ind,xTargetDesc,Value,ECTime,xxLocID)
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryECResultForPieClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryECResultForPieExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryECResultForPieFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryECResultForPieExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-20
/// Description:  查询感染明细
/// 			  aLocID：感染科室
/// 			  aMonth：查询月份
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.ChartsSrv","QryInfPatList","","2018-04","1")
Query QryInfPatList(aLocID As %String, aMonth As %String, aType As %String) As %Query(ROWSPEC = "ind:%String,PatName:%String,PatMrNo:%String,PatSex:%String,InfPosDescs:%String,InfLocDesc:%String,IRInfDate:%String,StatusDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfPatListExecute(ByRef qHandle As %Binary, aLocID As %String, aMonth As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aMonth="") $$$OK
	
	//s ^tmpQry=$lb(aLocID,aMonth,aType)
	Set RepList=""
	Set LocID=aLocID
	Set aDateFrom=$zdh(aMonth_"-01",3)
	Set aDateTo=$zdh($e($zd(aDateFrom+31,3),1,7)_"-01",3)-1
	Set xType=$s(aType=1:"CAUTI",aType=2:"VAP",aType=3:"CRBSI",aType=4:"INFOper",aType=1:"INFOper1",1:"")
	For xDate=aDateFrom:1:aDateTo {
		Set xInfDiagID = ""
		For {
			Set xInfDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xInfDiagID))
			Quit:xInfDiagID=""
			
			Set objDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagID)
			Quit:'$IsObject(objDiagnos)
			Set EpisodeID = objDiagnos.IREpisodeDr.%Id()
			Set PatientID = objDiagnos.IREpisodeDr.PAPatientIDx
			Set ReportID = $o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xInfDiagID,""))
			Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
			Continue:'$IsObject(objRep)
			Continue:$listfind(RepList,ReportID)>0
			Set RepList=RepList_$lb(ReportID)
			
			Set (StatusCode,StatusDesc)=""
			If $IsObject(objRep.IRStatusDr) {
				Set StatusCode = objRep.IRStatusDr.BTCode
				Set StatusDesc = objRep.IRStatusDr.BTDesc
			}
			Continue:StatusCode'=3  // 过滤非审核状态的报告
			
			Set LinkDiags      = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			Set (InfPosDescs,IRInfDate,InfLocDesc,IRInfLocList,IRInfDateList,InfLocFlag,InfDiagIDList,InfDiagDesc,InfType,IsOperInf,IsOperInf1)=""
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				Set (InfLoc,SubCode,DiagCode)=""
				If $IsObject(objDiags.IRInfLocDr) {
					Set IRInfLoc = objDiags.IRInfLocDr.BTDesc2
					Set:IRInfLoc="" IRInfLoc=objDiags.IRInfLocDr.BTDesc
					Continue:$listfind(IRInfLocList,IRInfLoc)>0
					Set IRInfLocList=IRInfLocList_$lb(IRInfLoc)
					Set InfLocDesc=InfLocDesc_","_IRInfLoc
					Set InfLoc = objDiags.IRInfLocDr.%Id()
					Set:InfLoc=LocID InfLocFlag=1
				}
				
				Set xInfDiagDesc=""
				If $IsObject(objDiags.IRInfSubDr) {
				    Set xInfDiagDesc=objDiags.IRInfSubDr.BTDesc
					If xInfDiagDesc'="" {
						Set InfDiagID = objDiags.IRInfSubDr.%Id()
						//"CAUTI","CRBSI","VAP"
						Set SubCode=objDiags.IRInfSubDr.BTCode
						Set:SubCode[xType InfType=1
						Set:SubCode="0402" IsOperInf=1
						Continue:$listfind(InfDiagIDList,InfDiagID)>0
						Set InfDiagIDList=InfDiagIDList_$lb(InfDiagID)
						Set InfDiagDesc=InfDiagDesc_","_xInfDiagDesc
					}
			    }
			    
				// 感染部位/感染诊断
				Set PosDesc="",PosDescList=""
				Set objInfPos = objDiags.IRInfPosDr
				If $IsObject(objInfPos){
					Set PosDesc=objDiags.IRInfPosDr.BTDesc
					Set:xInfDiagDesc'="" PosDesc=PosDesc_"["_xInfDiagDesc_"]"
					Set InfPosDescs=InfPosDescs_","_PosDesc
					Set DiagCode=objDiags.IRInfPosDr.BTCode
					Set:$e(DiagCode,1,2)="07" IsOperInf=1
				}
				
			    If (($e(DiagCode,1,2)="07")||(SubCode="0402")) {
					Set xOperID=""
					For {
						Set xOperID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",EpisodeID,xOperID))
						Quit:xOperID=""
						Set objOper=##class(DHCHAI.DP.OROperAnaes).GetObjById(xOperID)
						Continue:'$IsObject(objOper)
						Continue:'objOper.ORIsActive
						Set Incision=objOper.ORIncision
						Set:Incision="I" IsOperInf1=1
					}
				}
				
				If (objDiags.IRInfDate'="") {
					Set xTmpDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objDiags.IRInfDate)
					Continue:$listfind(IRInfDateList,xTmpDate)>0
					Set IRInfDateList=IRInfDateList_$lb(xTmpDate)
					Set IRInfDate=IRInfDate_","_xTmpDate
				}
				
			}
			Continue:(LocID'="")&&(InfLocFlag'=1)
			Continue:(+aType>0)&&(+aType<4)&&(InfType'=1)
			Continue:(+aType=4)&&(IsOperInf'=1)
			Continue:(+aType=5)&&(IsOperInf1'=1)
			Set:InfPosDescs'="" InfPosDescs=$e(InfPosDescs,2,$l(InfPosDescs))
			Set:IRInfDate'="" IRInfDate=$e(IRInfDate,2,$l(IRInfDate))
			Set:InfLocDesc'="" InfLocDesc=$e(InfLocDesc,2,$l(InfLocDesc))
			
			Set PatName=objDiagnos.IREpisodeDr.PAPatName
			Set PatMrNo=objDiagnos.IREpisodeDr.PAMrNo
			Set PatSex=objDiagnos.IREpisodeDr.PASex
			Set PatSex=$s(PatSex="M":"男",PatSex="F":"女",1:"其他")
			
			Set ^CacheTemp(repid,ind)=$lb(ind,PatName,PatMrNo,PatSex,InfPosDescs,InfLocDesc,IRInfDate,StatusDesc)
			Set ind=ind+1
		}
	}

	
	Quit $$$OK
}

ClassMethod QryInfPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPatListExecute ]
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
