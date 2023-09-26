/// 名称: DHCHAI.STATV2.S901Inf
/// 描述: 出院患者社区感染统计
/// 编写者：ShenC
/// 编写日期: 2020-08-01
Class DHCHAI.STATV2.S901Inf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2020-08-01
/// Description:  出院患者社区感染统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S901Inf","QryInfByDischDate","2020-01-01","2020-03-27","1","W","1")
Query QryInfByDischDate(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aStaType As %String = "", aQryCon As %String = "2") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,InfPatCnt:%String,PatInfRatio:%String,InfCaseCnt:%String,PatInfCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfByDischDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aStaType As %String = "", aQryCon As %String = "2") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	//统计维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)	
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //病区或科室
	
    Set NIndex="QryS901DischInf"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")	//只统计住院患者,急诊另外统计
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					//就诊信息
					Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmInfo=""
					//入院时间
					Set AdmDate	=$List(AdmInfo,20)
					
					//出院科室/病区
					Set DishLocID	= $List(AdmInfo,28)
					Set DishWardID	= $List(AdmInfo,29)
					Continue:DishLocID=""
					Continue:DishWardID=""
					//出院医院
					Set DishHospID=$List($g(^DHCHAI.BT.LocationD(DishLocID)),8)
					Continue:(aHospIDs'="")&(DishHospID'="")&($listfind(aHospIDs,DishHospID)<1)
					//科室所在组
					Set:StatType="E" GroupID=$List($g(^DHCHAI.BT.LocationD(DishLocID)),7)
					Set:StatType="W" GroupID=$List($g(^DHCHAI.BT.LocationD(DishWardID)),7)
					If (GroupID="") {
						Set GroupID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}		
					//获取感染信息
					Set InfPosDescs=""
					If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",xPaadm)) // 避免重复获取感染部位
					{
						Set InfPosDescs =..GetInfPosInfo(xPaadm,AdmDate,aDateTo)
						if (InfPosDescs'="") {
							for InfNo=1:1:$L(InfPosDescs,"|") {
								Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
								continue:InfPosMsg=""
								Set DiagID	= $p(InfPosMsg,"^",1)
								Set InfDate	= $p(InfPosMsg,"^",3)
								Set InfType	= $p(InfPosMsg,"^",7)
								Continue:InfType'="社区感染"
								Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",xPaadm,DiagID)=""
							}
						}
					}
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,DishHospID,GroupID,DishLocID,DishWardID)
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						
						//各科室出院人数
						Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
						
						//记录感染人数和例次数
						if ($o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",xPaadm,""))'=""){
							Set xDiagID=""
							for {
								Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",xPaadm,xDiagID))
								Quit:xDiagID=""
								//记录感染人数
								If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfFlg",xPaadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfFlg"))
									Set ^TMP($zn,$j,NIndex,DimensKey,"InfFlg",xPaadm)=""
								}		
								//记录感染例次数	
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCaseFlg"))
							}
						}
					}
				}
			}
		}
    }
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
    // 输出Data
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey=$lg(DimList,1)
		Set DimensDesc=$lg(DimList,3)
		Set IsActive=$lg(DimList,4)
		Continue:xDimensKey=""
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  //出院患者人数
		Set InDaysCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InLocDays"))  //患者住院天数
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfFlg"))  //感染人数
		Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCaseFlg")) //感染例数
		Continue:((IsActive=0)||(DimensDesc["停用")||(DimensDesc["作废"))&&((PatAdmCnt=0)&&(InDaysCnt=0)) //无效科室数据为空时过滤
		Continue:(aQryCon="2")&&(InfPatCnt=0) //是否仅显示有数据的科室
		
		Set PatInfRatio="0.00%",PatInfCaseRatio="0.00%"
		Set:PatAdmCnt>0 PatInfRatio=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%" //感染率
		Set:PatAdmCnt>0 PatInfCaseRatio=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%" //感染例次率
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InfPatCnt,PatInfRatio,InfCaseCnt,PatInfCaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfByDischDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfByDischDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfByDischDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfByDischDateExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-08-01
/// Description:  出院患者社区感染（例次）发病率明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey： 统计维度
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S901Inf","QryS901InfDtl","2020-03-01","2020-03-27","0000-00-0000-A-1")
Query QryS901InfDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryS901InfDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:+aHospIDs=0 aHospIDs=""
	Set aLocType="",aLocDr=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set aStaType=aDimensType
    Set:aStaType'="W" aStaType="E"	//不是病区就是科室(默认科室)
    Set NIndex="QryS901InfDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					//循环转科表
					Set xDate=0	//转科日期
					For {
						Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aStaType,xPaadm,xDate))
						Quit:xDate=""
						
						Set xTransID=0
						For {
							Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aStaType,xPaadm,xDate,xTransID))
							Quit:xTransID=""
							
							Set TransInfo=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
							Continue:TransInfo=""
							
							Set TransLocID	= $List(TransInfo,5) //科室或病区
							Continue:(aLocType'="")&(TransLocID'=aLocDr)
							
							Set LocData = $g(^DHCHAI.BT.LocationD(TransLocID))
							If LocData'="" {
								Set LocDesc2 = $li(LocData,4)
								Set LocDesc  = $li(LocData,3)
								Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
							}
							//转科医院
							Set xHospID=$List(LocData,8)
							Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
							//科室所在组
							Set xGroupID=$List(LocData,7)
							If (xGroupID="") {
								Set GroupDesc="其他科"
								Set xGroupID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
							}
							Set GroupData=$g(^DHCHAI.BT.LocGroupD(xGroupID))
							Set GroupDesc=$li(GroupData,3)
							Continue:(aLocGroup'="")&(aLocGroup'=xGroupID)
							
							Set PatData=..BuildPaadmData(xPaadm)
							Continue:PatData=""
							
							Set TransDate	= $List(TransInfo,7)		//转科日期
							Set OutLocDate	= $List(TransInfo,10)		//出科日期
							Set EndDate=OutLocDate
							Set:EndDate="" EndDate=aDateTo //未出科
							Set InfPosDescs=..GetInfPosInfo(xPaadm,TransDate,EndDate)
							Continue:InfPosDescs=""
							For indxi=1:1:$l(InfPosDescs,"|") {
								Set InfPosMsg      	= $p(InfPosDescs,"|",indxi)
								Continue:InfPosMsg=""
								
								Set DiagID	= $p(InfPosMsg,"^",1)
								Set InfPosDescsMsg = $p(InfPosMsg,"^",2)	//感染诊断
								Set InfDate	= $p(InfPosMsg,"^",3)
								Set InfEffect= $p(InfPosMsg,"^",5)
								Set InfType	= $p(InfPosMsg,"^",7)
								Continue:InfType'="社区感染"
								
								Set InfDate  		= $zd(InfDate,3)
								Set InfData=$lb(InfPosDescsMsg,InfDate,InfEffect)
								Set Data=PatData_InfData_$lb(xTransID,xGroupID,GroupDesc,TransLocID,AdmLocDesc,TransDateTime,OutLocDateTime)
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1
							}
						}
					}
				}
			}
		}
    }
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS901InfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS011InfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS901InfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS011InfDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2020-08-01
/// Description:  出院患者社区感染明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S901Inf","QryInfPatDtl","2020-01-01","2020-02-27","0001-07-0082-W-4","W")
Query QryInfPatDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfPatDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:+aHospIDs=0 aHospIDs=""
	Set aLocType="",aLocDr=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	Set StatType=aDimensType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set NIndex="QryInfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					Set AdmData =$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmData=""
					
					// 出院科室/病区
					Set DishLocID = $li(AdmData,28)
				    Set DishWardID = $li(AdmData,29)
				    Set LocDr=DishLocID
				    Set:aDimensType="W" LocDr=DishWardID
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set HospDr=$li(LocData,8)
					//  医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
					Continue:(aLocType'="")&(LocDr'=aLocDr)
					
					Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData=""
					
					Set Data=PatData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
    }
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPatDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
