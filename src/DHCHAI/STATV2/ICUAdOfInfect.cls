/// 名称: DHCHAI.STATV2.ICUAdOfInfect
/// 描述: ICU调整感染率统计表（只统计ICU科室）
/// 编写者：chenR
/// 编写日期: 2020-08-24
Class DHCHAI.STATV2.ICUAdOfInfect Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenr
/// CreatDate：   2020-08-24
/// Description:  ICU调整感染率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aQryCon：  有效数据筛查
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ICUAdOfInfect","QryTubeInfo","1|2","2020-05","2020-05","W","1","43")
Query QryTubeInfo(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,PatAdmCnt:%Integer,PatAdmDays:%Integer,AvgInDays:%Integer,InfPatCnt:%Integer,InfCaseCnt:%Integer,InfPatRatio:%String,InfCaseRatio:%String,DayInfPatRatio:%String,DayInfCaseRatio:%String,AvgRiskLevel:%Integer,AssessNum:%Integer,TotalScore:%Float,AdPatRatio:%String,AdCaseRatio:%String,AdDayPatRatio:%String,AdDayCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryTubeInfoExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aStartYYMM=aDateFrom		//保留月份
	Set aEndYYMM=aDateTo
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom_"-01")
	Set xEndYear=+$p(aEndYYMM,"-",1)
	Set xEndMonth=+$p(aEndYYMM,"-",2)
	If (xEndMonth'=12){
		Set xEndMonth=xEndMonth+1
		Set Date = xEndYear_"-"_xEndMonth_"-01"
		Set aDateTo = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(Date)-1
	}Else {
		Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo_"-31")
	}
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryTubeInfo"
	Kill ^TMP($zn,$j,NIndex)

	Set xLocID=0
	For {
		Set xLocID = $o(^DHCHAI.BT.LocationD(xLocID))
		Quit:xLocID=""
		Continue:(aLocIDs'="")&&((","_aLocIDs_",")'[(","_xLocID_","))
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set IsICU=$lg(LocData,10)
		Continue:IsICU'=1
		Set TypeDr=$lg(LocData,5)
		Continue:TypeDr=""
		Set TypeDic=$g(^DHCHAI.BT.DictionaryD(TypeDr))
		Set TypeCode=$lg(TypeDic,2)
		Continue:(aLocType'="")&&(TypeCode'=aLocType)
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		
		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
		For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)
			Continue:TransInfo=""
			Set Paadm      = $LIST(TransInfo,1)
			Set LocID      = $LIST(TransInfo,2)
			Set TransType  = $LIST(TransInfo,3)
			Set TransDates = $LIST(TransInfo,4)
			Set LnkLocDr   = $LIST(TransInfo,5)
			Set TransIDs   = $LIST(TransInfo,6)
			If TransType="E" {
				Set LocDr  = LocID
				Set WardDr = ""
			} Else {
				Set LocDr  = LnkLocDr
				Set WardDr = LocID
			}
		   
	    	//在科天数
	    	Set InDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransIDs)
	  		//同期在科天数			
			Set ^TMP($zn,$j,NIndex,xLocID,"InDays") =+$g(^TMP($zn,$j,NIndex,xLocID,"InDays"))+InDays

	    	// 科室患者感染
			If ('$d(^TMP($zn,$j,NIndex,xLocID,"InfPosPat",Paadm)))  {  //不重复判断 
            	Set InfPosInfo =..GetInfInfo(Paadm,aDateFrom,aDateTo,LocDr,WardDr)		
            	Set ^TMP($zn,$j,NIndex,xLocID,"InfPosPat",Paadm)=InfPosInfo
				If (InfPosInfo'="") {
					Set InfCount=$Length(InfPosInfo,"|")
					Set ^TMP($zn,$j,NIndex,xLocID,"InfCase")=$g(^TMP($zn,$j,NIndex,xLocID,"InfCase"))+InfCount

					//记录感染人数
					If '$d(^TMP($zn,$j,NIndex,xLocID,"InfPat",Paadm)) {
						Set num=$i(^TMP($zn,$j,NIndex,xLocID,"InfPat"))
						Set ^TMP($zn,$j,NIndex,xLocID,"InfPat",Paadm)=""
					}
				}
			}
			//同期在科人数
			Continue:$d(^TMP($zn,$j,NIndex,xLocID,"PatAdm",Paadm)) 
			Set num=$i(^TMP($zn,$j,NIndex,xLocID,"PatAdm"))
			Set ^TMP($zn,$j,NIndex,xLocID,"PatAdm",Paadm)=""					
		}	
	}

	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,xLocID))
		Quit:xLocID=""
		
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Continue:LocData=""
		Set LocDesc = $lg(LocData,3)
		Set LocDesc2 = $lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
	    
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"PatAdm"))   		//在院患者数
		Set PatAdmDays  =+$g(^TMP($zn,$j,NIndex,xLocID,"InDays"))  			//患者住院天数
		set:PatAdmCnt'=0 AvgInDays=$fn(PatAdmDays/PatAdmCnt,"",2)			//平均住院天数
		set:PatAdmCnt=0 AvgInDays=0
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"InfCase"))    		//新发感染例次数
		Continue:(aQryCon="2")&&(PatAdmCnt=0)		

		Set InfPatRatio="0.00%",InfCaseRatio="0.00%"					
		Set DayInfPatRatio = "0.000‰",DayInfCaseRatio = "0.000‰"
		Set:PatAdmCnt>0 InfPatRatio		=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%" 	//感染率
		Set:PatAdmCnt>0 InfCaseRatio	=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%" 	//感染例次率
		Set:PatAdmDays>0 DayInfPatRatio	=$fn((InfPatCnt/PatAdmDays)*1000,"",3)_"‰" 	//千日感染率
		Set:PatAdmDays>0 DayInfCaseRatio	=$fn((InfCaseCnt/PatAdmDays)*1000,"",3)_"‰" //千日感染例次率
		
		Set ICULevelArr = ##class(DHCHAI.STATV2.S3TubeAdjInf).GetRiskLevel(xLocID,aStartYYMM,aEndYYMM)	
		Set TotalScore	 = $p(ICULevelArr,"^",1)			//总得分
		Set AssessNum 	 = $p(ICULevelArr,"^",2)			//评定人数
		Set AvgRiskLevel = $p(ICULevelArr,"^",3)			//平均危险等级系数
		
		Set AdPatRatio="0.00%",AdCaseRatio="0.00%"					
		Set DayAdPatRatio  = "0.000‰",DayAdCaseRatio= "0.000‰"
		Set:AvgRiskLevel>0 AdPatRatio    =$fn((InfPatRatio/AvgRiskLevel),"",2)_"%" 			//调整感染率
		Set:AvgRiskLevel>0 AdCaseRatio   =$fn((InfCaseRatio/AvgRiskLevel),"",2)_"%" 		//调整感染例次率
		Set:AvgRiskLevel>0 DayAdPatRatio =$fn((DayInfPatRatio/AvgRiskLevel),"",3)_"‰" 		//千日感染率
		Set:AvgRiskLevel>0 DayAdCaseRatio=$fn((DayInfCaseRatio/AvgRiskLevel),"",3)_"‰" 		//千日感染例次率		
				
		If (AvgRiskLevel=0){
			Set AvgRiskLevel	="-"
			Set AssessNum		="-"
			Set TotalScore		="-"
			Set AdPatRatio		="-"
			Set AdCaseRatio		="-"
			Set DayAdPatRatio	="-"
			Set DayAdCaseRatio	="-"
		}
		Set Data=$lb(xLocID,LocDesc,PatAdmCnt,PatAdmDays,AvgInDays,InfPatCnt,InfCaseCnt,InfPatRatio,InfCaseRatio,DayInfPatRatio,DayInfCaseRatio,AvgRiskLevel,AssessNum,TotalScore,AdPatRatio,AdCaseRatio,DayAdPatRatio,DayAdCaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
			
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTubeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS010InfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS010InfExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-08-28
/// Description:  ICU调整感染率明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocID:    科室ID
/// 			  aLocType： 科室类型
/// 			  aIsInf:    是否感染
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ICUAdOfInfect","QryICUAdOfInfectDtl","2020-05","2020-05","43","W")
Query QryICUAdOfInfectDtl(aDateFrom As %String, aDateTo As %String, aLocID As %String, aLocType As %String = "W", aIsInf As %String = "") As %Query(ROWSPEC = "AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagID:%String,InfPosDesc:%String,InfDate:%String,InfType:%String,EffectDesc:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryICUAdOfInfectDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aLocType As %String = "W", aIsInf As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:(aDateFrom="")||(aDateTo="")||(aLocID="") $$$OK
	Set flag = $p(aDateFrom,"-",3)		//判断传进来的日期是否有日期（YY-MM-DD）
	Set xEndYear=+$p(aDateTo,"-",1)
	Set xEndMonth=+$p(aDateTo,"-",2)
	
	If (flag=""){	//将日期拼成YY-MM-DD格式
		Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom_"-01")
		If (xEndMonth'=12){
			Set xEndMonth=xEndMonth+1
			Set Date = xEndYear_"-"_xEndMonth_"-01"
			Set aDateTo = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(Date)-1
		}Else{
			Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo_"-31")
		}
	}Else{
		Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
		Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	}
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set NIndex="QryICUAdOfInfectDtl"
	Kill ^TMP($zn,$j,NIndex)

	Set xLocID=0
	For {
		Set xLocID = $o(^DHCHAI.BT.LocationD(xLocID))
		Quit:xLocID=""
		Continue:(aLocID'="")&&(aLocID'=xLocID)
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set IsICU=$lg(LocData,10)
		Continue:IsICU'=1
		Set TypeDr=$lg(LocData,5)
		Continue:TypeDr=""
		Set TypeDic=$g(^DHCHAI.BT.DictionaryD(TypeDr))
		Set TypeCode=$lg(TypeDic,2)
		Continue:(aLocType'="")&&(TypeCode'=aLocType)
		Set LocDesc = $lg(LocData,3)
		Set LocDesc2 = $lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		
		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
		For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)
			Continue:TransInfo=""
			Set Paadm      = $LIST(TransInfo,1)
			Set LocID      = $LIST(TransInfo,2)
			Set TransType  = $LIST(TransInfo,3)
			Set TransDates = $LIST(TransInfo,4)
			Set LnkLocDr   = $LIST(TransInfo,5)
			Set TransIDs   = $LIST(TransInfo,6)
			If TransType="E" {
				Set LocDr  = LocID
				Set WardDr = ""
			} Else {
				Set LocDr  = LnkLocDr
				Set WardDr = LocID
			}
		
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
				
			Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
            Set AdmDate = $lg(AdmData,20)    //就诊日期 
            Set AdmTimes = $lg(AdmData,38)   //就诊次数
	     	     	
			For xTransInd=1:1:$l(TransIDs,",") {
			    Set TransID=$p(TransIDs,",",xTransInd)
			    Continue:TransID=""
			    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
			    Set TransDate	= $li(TranData,7)
			    Set OutLocDate	= $li(TranData,10)
			    Set TransTime	= $li(TranData,8)
				Set OutLocTime	= $li(TranData,11)
				//如果转科起止日期大于统计日期，以统计日期计算
				Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
				Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
				Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
				
				Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
				Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	   			Set:TransTime'="" TransTime=$zt(TransTime)
	 			Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	   			Set TransDateTime =TransDate_" "_TransTime
				Set OutLocDateTime =OutLocDate_" "_OutLocTime
				Set TransInfo=$lb(xTransID,LocID,LocDesc,TransDateTime,OutLocDateTime)
				
				Set InfPosInfo =..GetInfInfo(Paadm,DateFrom,DateTo,LocDr,WardDr)	
	     		Continue:(aIsInf=1)&(InfPosInfo="")	
			    Set (InfDatas,InfData)=""
				For InfNo=1:1:$l(InfPosInfo,"|") {
					Set InfPosMsg=$p(InfPosInfo,"|",InfNo)
					Continue:InfPosMsg=""
		
					Set DiagID     = $p(InfPosMsg,"^",1)	
					Set InfDate    = $p(InfPosMsg,"^",2)	
					Set InfPosDesc = $p(InfPosMsg,"^",3)	
					Set EffectDesc = $p(InfPosMsg,"^",4)
					Set InfXDate   = $p(InfPosMsg,"^",5)
				
					Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
					Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
					
					Set DiagData=$g(^DHCHAI.IR.INFDiagnosD(DiagID))
					Set InfType="医院感染"
					Set InfTypeCode=$lg(DiagData,18)
					If (InfTypeCode'=""){
						Set:InfTypeCode=0 InfType="社区感染"
					}Else{
				   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
					}
				    Set InfData=$lb(DiagID,InfPosDesc,InfDate,InfType,EffectDesc,InfXDate)
				    Set InfDatas=InfDatas_$lb(InfData)
				}
				Set Len=$ll(InfDatas)
				If (Len>0){
					For LenInd=1:1:Len {
						Set InfData=$lg(InfDatas,LenInd)
					   	Set Data = $lb(AdmTimes)_PatData_TransInfo_InfData
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}Else {  
					Set Data = $lb(AdmTimes)_PatData_TransInfo_$lb("","","","","","")
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryICUAdOfInfectDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS010InfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUAdOfInfectDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS010InfPatDtlExecute ]
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

/// 获取感染信息
/// w ##class(DHCHAI.STATV2.ICUAdOfInfect).GetInfInfo("615",$zdh("2020-05-01",3),$zdh("2020-05-31",3),43)
ClassMethod GetInfInfo(aPaadm As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aWardID As %String = "") As %String
{
	new (aPaadm,aDateFrom,aDateTo,aLocID,aWardID)

	Set return=""
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aPaadm,xDate))
		Quit:xDate=""
		Continue:xDate>aDateTo
		
		Set xRowID=""
		For {
			Set xRowID=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aPaadm,xDate,xRowID))
			Quit:xRowID=""
			
			Set xRepID=0
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xRowID,xRepID))
				Quit:xRepID=""
		
				Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
				Continue:RepData=""
		
				Set IRStatusDr=$lg(RepData,8)
				Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
				Continue:(RepStatus'=3) ;审核
				Set InfPos=$g(^DHCHAI.IR.INFDiagnosD(xRowID))
				Set InfType=$lg(InfPos,18)
				Continue:InfType=0
		
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aPaadm,xDate,"00:00:01")
				If (aWardID'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardID)				
				}
				If (aLocID'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocID)
				}
			
				Set IRInfPosDr=$lg(InfPos,3)
				Set IRInfPos=""
				If (IRInfPosDr'=""){
					Set IRInfPosData=$g(^DHCHAI.BT.InfPosD(IRInfPosDr))
					Set:IRInfPosData'="" IRInfPos = $lg(IRInfPosData,3)
				}
				Set IRInfEffectDr=$lg(InfPos,8)
				Set IRInfEffect=""
				If (IRInfEffectDr'=""){
					Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
					Set:IRInfEffectData'="" IRInfEffect = $lg(IRInfEffectData,3)
				}
				Set IRInfXDate=$lg(InfPos,7)
				Set return=return_"|"_xRowID_"^"_xDate_"^"_IRInfPos_"^"_IRInfEffect_"^"_IRInfXDate
			}
		}
	}

	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

}
