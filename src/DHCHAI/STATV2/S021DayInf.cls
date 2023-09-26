/// 名称: DHCHAI.STATV2.S021DayInf
/// 描述: 出院患者千日医院感染（例次）发病率统计表
/// 编写者: zhoubo
/// 编写日期: 2018-08-29
Class DHCHAI.STATV2.S021DayInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2019-10-17
/// Description:  出院患者千日医院感染（例次）发病率
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aStatDimens:  展示维度    
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S021DayInf","QryS021DischInf","1|2","2022-01-01","2022-01-31","W")
Query QryS021DischInf(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,InDaysCnt:%Integer,InfPatCnt:%Integer,PatInfRatio:%String,InfCaseCnt:%Integer,PatInfCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryS021DischInfExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	
	Set:aLocType'="W" aLocType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
	
    Set NIndex="QryS021DischInf"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
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
					Set VisitStatus = $lg(AdmInfo,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//出院科室/病区
					Set DishLocID	= $List(AdmInfo,28)
					Set DishWardID	= $List(AdmInfo,29)
					Set LocDr=DishLocID
				    Set:aLocType="W" LocDr=DishWardID
				    Continue:LocDr=""
				    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
					//同期住院天数
					Set AdmDays=$List(AdmInfo,31)
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set HospDr=$li(LocData,8)
					//  医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					//本次住院区间感染信息
					Set AdmDate = $li(AdmInfo,20)
					Set DischDate = $li(AdmInfo,26)
					Set InfPosDescs=..GetInfPosInfo(xPaadm,AdmDate,DischDate,1)
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID) 
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						
						//同期住院天数
						Set ^TMP($zn,$j,NIndex,DimensKey,"InDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"InDays"))+AdmDays 
						
						// 全院出院患者人数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm))
						{
			 				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm)=""
						}
						If (InfPosDescs'="") {
							for InfNo=1:1:$L(InfPosDescs,"|") {
								Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
								continue:InfPosMsg=""
								Set DiagID=$p(InfPosMsg,"^",1)
								Continue:$d(^TMP($zn,$j,NIndex,"InfDiag",DimensKey,DiagID))
								Set ^TMP($zn,$j,NIndex,"InfDiag",DimensKey,DiagID)="" 			//去重判断使用
								
								If '$d(^TMP($zn,$j,NIndex,"InfAdm",DimensKey,xPaadm)) {			//去重判断使用
									Set ^TMP($zn,$j,NIndex,"InfAdm",DimensKey,xPaadm)=""
									Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfPat")) //感染人次
								}
								Set num = +$g(^TMP($zn,$j,NIndex,DimensKey,"InfCase")) //感染例次
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfCase")=num+1
							}
						}
					}
				}
			}
		}
    }
    Set (PatDishSum,InfPatSum,InfCaseSum,InDaysSum)=""
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
    // 输出Data
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	=$lg(DimList,1)
		Set DimensDesc	=$lg(DimList,3)
		Set IsActive	=$lg(DimList,4)
		Continue:xDimensKey=""
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  //出院患者人数
		Set InDaysCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InDays"))  //患者住院天数
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数
		Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例数
		
		Set PatInfRatio="0.00‰"
		Set:InDaysCnt>0 PatInfRatio=$fn((InfPatCnt/InDaysCnt)*1000,"",2)_"‰" //千日感染发病率
		Set PatInfCaseRatio="0.00‰"
		Set:InDaysCnt>0 PatInfCaseRatio=$fn((InfCaseCnt/InDaysCnt)*1000,"",2)_"‰" //千日感染例次发病率
		Continue:(IsActive="0")&&(PatAdmCnt=0)	
		Continue:(aQryCon="2")&&(InfPatCnt=0)
		Continue:(aQryCon="3")&&(PatAdmCnt=0)
		If (LocCount>1) {
			Set PatDishSum = PatDishSum + PatAdmCnt
			Set InfPatSum  = InfPatSum + InfPatCnt
			Set InfCaseSum = InfCaseSum + InfCaseCnt
			Set InDaysSum  = InDaysSum + InDaysCnt
		}
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InDaysCnt,InfPatCnt,PatInfRatio,InfCaseCnt,PatInfCaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	//出院患者住院人数及感染人数可以直接累加
	If (LocCount>1) {
		Set PatAdmCnt  = PatDishSum  		    //出院患者数
		Set InfPatCnt  = InfPatSum 		        //感染人数
		Set InfCaseCnt = InfCaseSum 		    //感染例数
		Set InDaysCnt  = InDaysSum
		
		Set PatInfRatio="0.00‰"
		Set:InDaysCnt>0 PatInfRatio=$fn((InfPatCnt/InDaysCnt)*1000,"",2)_"‰" //千日感染发病率
		Set PatInfCaseRatio="0.00‰"
		Set:InDaysCnt>0 PatInfCaseRatio=$fn((InfCaseCnt/InDaysCnt)*1000,"",2)_"‰" //千日感染例次发病率
		
		Set Data=$lb("","全部",PatAdmCnt,InDaysCnt,InfPatCnt,PatInfRatio,InfCaseCnt,PatInfCaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS021DischInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS021DischInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS021DischInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS021DischInfExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  出院患者千日医院感染（例次）发病率明细表（分子）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey: 科室维度
/// 			  aStaType:  统计类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S021DayInf","QryS021InfDtl","1","2020-01-26","2023-02-28","0001-07-0029-W-4","W")
Query QryS021InfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,AdmDays:%String,InDays:%String,InfRepDate:%String,InfRepUser:%String") [ SqlProc ]
{
}

ClassMethod QryS021InfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
    Set NIndex="QryS021InfDtl"
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
					Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:(PAAdmData="")
					Set VisitStatus = $lg(PAAdmData,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//就诊开始结束日期
					Set AdmDate   = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes  = $lg(PAAdmData,38)   //就诊次数
					//同期住院天数
					Set AdmDays=$List(PAAdmData,31)
					// 出院科室/病区
					Set DishLocID  = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set LocDr=DishLocID
				    Set:aStaType="W" LocDr=DishWardID
				    Continue:LocDr=""
				    Continue:(aLocDr'="")&(aLocDr'=LocDr)
				    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
				    
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set LocDesc	= $lg(LocData,3)
					Set LocDesc2= $lg(LocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Set HospDr=$lg(LocData,8)
					Continue:HospDr=""
					//医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					//医院分组过滤
					Set HospInfo="",HospGroupDr=""
					Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
					Set HospGroupDr=$lg(HospInfo,5) 
					Continue:HospGroupDr="" 
					Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
					Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
					
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
					Set GroupDesc=$li(GroupData,3)
					//按科室组、科室/病区过滤
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
				   
				   	//取统计维度
					Set DimensDesc =""
					Set:DimensMark="" DimensDesc="全部"
					Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
					Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
					Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
					Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
					
					//获取病人基本信息
					Set PatData =..BuildPaadmData(xPaadm)
					Continue:PatData=""
					Set TransInfoArr =..GetTransInfo(xPaadm,"","",aStaType)  //存在转科日期早于入院日期情况，取全部转科记录
					For TransInd=1:1:TransInfoArr.Count(){
						Set TransInfo=TransInfoArr.GetAt(TransInd)
						Set TransID=$lg(TransInfo,1)
					    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
					    Set TransDate	= $li(TranData,7)
					    Set OutLocDate	= $li(TranData,10)
					    Set TransTime	= $li(TranData,8)
						Set OutLocTime	= $li(TranData,11)
						Set LocID       = $lg(TranData,5)
						Set LnkLocDr    = $lg(TranData,14)
						Continue:LocID=""
						If aStaType="E" {
							Set LocDr  = LocID
							Set WardDr = ""
						} Else {
							Set LocDr  = LnkLocDr
							Set WardDr = LocID
						}
						//如果转科起止日期大于统计日期，以统计日期计算
						Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
						Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
						Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
						// 住院天数
		    			Set InDays=..GetInDays(xPaadm,DateFrom,DateTo,TransID)
						Set InfPosDescs=..GetInfPosInfo(xPaadm,DateFrom,DateTo,1,LocDr,WardDr)
						Continue:InfPosDescs=""
						For PosInd=1:1:$l(InfPosDescs,"|") {
							Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
							Continue:InfPosInfo=""
							Set DiagDr    = $p(InfPosInfo,"^",1)
							Set DiagDesc  = $p(InfPosInfo,"^",2)
		                    Set InfDate   = $p(InfPosInfo,"^",3)
		                    Set InfXDate  = $p(InfPosInfo,"^",4)
		                    Set InfEffect = $p(InfPosInfo,"^",5)
		                    Set InfType   = $p(InfPosInfo,"^",7)
		                    Set InfRepDate= $p(InfPosInfo,"^",9)
                        	Set InfRepUser= $p(InfPosInfo,"^",11)
		                    Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
		                    Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
		                    Continue:$d(^TMP($zn,$j,NIndex,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"DiagDr",DiagDr)=""
							Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,AdmDays,InDays,InfRepDate,InfRepUser)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
    }
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS021InfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS021InfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS021InfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS021InfDtlExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  出院患者明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接    
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：  维度信息
///               aStaType :  科室类型
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S021DayInf","QryS021PatDtl","","2020-01-01","2020-02-18","0001-07-0031-W-3","W")
Query QryS021PatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AdmDays:%String,InfFlag:%String") [ SqlProc ]
{
}

ClassMethod QryS021PatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	
 	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
    Set NIndex="QryInfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					Set PAAdmData =$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:PAAdmData=""
					Set VisitStatus = $lg(PAAdmData,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//就诊开始结束日期
					Set AdmDate   = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes  = $lg(PAAdmData,38)   //就诊次数
					//同期住院天数
					Set AdmDays=$List(PAAdmData,31)
					// 出院科室/病区
					Set DishLocID  = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set LocDr=DishLocID
				    Set:aStaType="W" LocDr=DishWardID
				    Continue:LocDr=""
				    Continue:(aLocDr'="")&(aLocDr'=LocDr)
				    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
				   
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set LocDesc	= $lg(LocData,3)
					Set LocDesc2= $lg(LocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Set HospDr=$lg(LocData,8)
					Continue:HospDr=""
					//医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					//医院分组过滤
					Set HospInfo="",HospGroupDr=""
					Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
					Set HospGroupDr=$lg(HospInfo,5) 
					Continue:HospGroupDr="" 
					Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
					Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
				
					Set GroupDr = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc = "其他科"
						Set GroupDr   = $o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
					Set GroupDesc=$li(GroupData,3)
					//按科室组、科室/病区过滤
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
				   
				   	//取统计维度
					Set DimensDesc =""
					Set:DimensMark="" DimensDesc="全部"
					Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
					Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
					Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
					Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
					
					Set InfFlag="否"
                    Set tInfFlag=##class(DHCHAI.STATV2.AbstractComm).GetInfPosInfo(xPaadm,AdmDate,DischDate,1)
                    Set:tInfFlag'="" InfFlag="是"
                    
					Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData=""
					Set TransInfoArr =..GetTransInfo(xPaadm,"","",aStaType)    //存在转科日期早于入院日期情况，取全部转科记录
					For TransInd=1:1:TransInfoArr.Count(){
						Set TransInfo=TransInfoArr.GetAt(TransInd)
						
						Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(AdmDays,InfFlag)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
    }
	Quit $$$OK
}

ClassMethod QryS021PatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS021PatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPatDtlExecute ]
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
