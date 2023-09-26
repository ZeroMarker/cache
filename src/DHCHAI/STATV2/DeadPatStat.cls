/// 名称: DHCHAI.STATV2.DeadPatStat
/// 描述: 出院死亡患者医院感染情况分析
/// 编写者：pylian
/// 编写日期: 2022-01-05
Class DHCHAI.STATV2.DeadPatStat Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo    	
/// CreatDate：   2022-12-08	
/// Description:  出院死亡患者医院感染情况分析
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aStatDimens :  展示维度    
///               aLocIDs:    科室 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.DeadPatStat","QryDeathInf","1|2","2020-05-01","2022-12-01","W","")
Query QryDeathInf(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatDishCnt:%Integer,PatDeathCnt:%Integer,DeathRatio:%String,InfPatCnt:%Integer,InfRatio:%String,DeathInfCnt:%Integer,DeathInfRatio:%String,InfInCnt:%Integer,DeathInCnt:%Integer,DeathInRatio:%String,InfOutCnt:%Integer,DeathOutCnt:%Integer,DeathOutRatio:%String") [ SqlProc ]
{
}

ClassMethod QryDeathInfExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
	
    Set NIndex="QryDeathInf"
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
					Set Paadm=xPaadm
					//出院科室/病区
					Set DishLocID	= $List(AdmInfo,28)
					Set DishWardID	= $List(AdmInfo,29)
					Set LocDr=DishLocID
				    Set:aLocType="W" LocDr=DishWardID
				    Continue:LocDr=""
				    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
					
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set HospDr=$li(LocData,8)
					//  医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					 
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					Set IsDeath=$lg(AdmInfo,15)
					Set IsInf=0,IsInfIn=0,IsInfOut=0
					//Set InfPosInfo=##class(DHCHAI.STATV2.DeadPatStat).GetInfInfo(xPaadm)
					//本次住院区间感染信息
					Set AdmDate   = $li(AdmInfo,20)
					Set DischDate = $li(AdmInfo,26)
					Set InfPosInfo=..GetInfPosInfo(xPaadm,AdmDate,DischDate)
					
					For indPos=1:1:$l(InfPosInfo,"|") {
						Set tmpInfPos   = $p(InfPosInfo,"|",indPos)
						Continue:tmpInfPos=""
						Set DiagID      = $p(tmpInfPos,"^",1)
						Set InfPosDescs = $p(tmpInfPos,"^",2)
						Set InfDate		= $p(tmpInfPos,"^",3)
						Set InfType	    = $p(tmpInfPos,"^",7)
						If (DiagID'="") {
							Set IsInf=1
							If (InfType["社区感染") {
								Set IsInfOut =1
							}Else {
								Set IsInfIn=1
							}
						}
					}
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID) 
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// 全院出院患者人数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatDish",xPaadm))
						{
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatDish"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatDish",xPaadm)=""
						}
						//死亡人数
						If (IsDeath=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatDeath",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatDeath"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"PatDeath",Paadm)=""
							}
						}
						//感染人数
						If (IsInf=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
							}			
						}
						//死亡感染人数
						If (IsDeath=1)&(IsInf=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"DeathInfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"DeathInfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"DeathInfPat",Paadm)=""
							}			
						}
					    //医院感染人数	
						If (IsInfIn=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatInfIn",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatInfIn"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"PatInfIn",Paadm)=""
							}			
						}
						//死亡医院感染人数	
						If (IsDeath=1)&(IsInfIn=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"DeathInfIn",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"DeathInfIn"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"DeathInfIn",Paadm)=""
							}			
						}
						//社区感染人数
						If (IsInfOut=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatInfOut",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatInfOut"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"PatInfOut",Paadm)=""
							}			
						}
						//死亡社区感染人数
						If (IsDeath=1)&(IsInfOut=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"DeathInfOut",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"DeathInfOut"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"DeathInfOut",Paadm)=""
							}			
						}
						If (LocCount>1) {
							// 全院出院患者人数
							If '$d(^TMP($zn,$j,NIndex,"Sum","PatDish",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatDish"))
								Set ^TMP($zn,$j,NIndex,"Sum","PatDish",xPaadm)=""
							}
							//死亡人数
							If (IsDeath=1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","PatDeath",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatDeath"))
									Set ^TMP($zn,$j,NIndex,"Sum","PatDeath",Paadm)=""
								}
							}
							//感染人数
							If (IsInf=1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfPat"))
									Set ^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)=""
								}			
							}
							//死亡感染人数
							If (IsDeath=1)&(IsInf=1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","DeathInfPat",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","DeathInfPat"))
									Set ^TMP($zn,$j,NIndex,"Sum","DeathInfPat",Paadm)=""
								}			
							}
						    //医院感染人数	
							If (IsInfIn=1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","PatInfIn",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatInfIn"))
									Set ^TMP($zn,$j,NIndex,"Sum","PatInfIn",Paadm)=""
								}			
							}
							//死亡医院感染人数	
							If (IsDeath=1)&(IsInfIn=1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","DeathInfIn",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","DeathInfIn"))
									Set ^TMP($zn,$j,NIndex,"Sum","DeathInfIn",Paadm)=""
								}			
							}
							//社区感染人数
							If (IsInfOut=1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","PatInfOut",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatInfOut"))
									Set ^TMP($zn,$j,NIndex,"Sum","PatInfOut",Paadm)=""
								}			
							}
							//死亡社区感染人数
							If (IsDeath=1)&(IsInfOut=1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","DeathInfOut",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","DeathInfOut"))
									Set ^TMP($zn,$j,NIndex,"Sum","DeathInfOut",Paadm)=""
								}			
							}
						}
					}
				}
			}
		}
    }
	// 输出Data
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	= $lg(DimList,1)
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:xDimensKey=""
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
		
		Set PatDishCnt     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatDish"))  		    //出院患者数
		Set InfPatCnt  	   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  		    //感染人数
		Set InfInCnt       =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatInfIn"))		    //医院感染人数
		Set InfOutCnt      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatInfOut"))		    //社区感染人数
		Set PatDeathCnt    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatDeath"))  		//死亡患者数
		Set DeathInfCnt    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"DeathInfPat"))  		//死亡感染人数
		Set DeathInCnt     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"DeathInfIn"))		//死亡医院感染人数
		Set DeathOutCnt    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"DeathInfOut"))		//死亡社区感染人数

		Set DeathRatio="0.00%",InfRatio="0.00%",DeathInfRatio="0.00%",DeathInRatio="0.00%",DeathOutRatio="0.00%"
		Set:PatDishCnt>0 DeathRatio=$fn((PatDeathCnt/PatDishCnt)*100,"",2)_"%"   	//出院死亡率
		Set:PatDishCnt>0 InfRatio=$fn((InfPatCnt/PatDishCnt)*100,"",2)_"%" 	        //出院感染率
		Set:PatDeathCnt>0 DeathInfRatio=$fn((DeathInfCnt/PatDeathCnt)*100,"",2)_"%" 	//感染死亡率
		Set:InfInCnt>0 DeathInRatio=$fn((DeathInCnt/InfInCnt)*100,"",2)_"%"   	//医院感染死亡率
		Set:InfOutCnt>0 DeathOutRatio=$fn((DeathOutCnt/InfOutCnt)*100,"",2)_"%" 	//社区感染死亡率
		
		Continue:(IsActive="0")&&(PatDishCnt=0)	
		Continue:(aQryCon="2")&&(PatDeathCnt=0)
		Continue:(aQryCon="3")&&(PatDishCnt=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,PatDishCnt,PatDeathCnt,DeathRatio,InfPatCnt,InfRatio,DeathInfCnt,DeathInfRatio,InfInCnt,DeathInCnt,DeathInRatio,InfOutCnt,DeathOutCnt,DeathOutRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	
	If (LocCount>1) {
		Set PatDishCnt     =+$g(^TMP($zn,$j,NIndex,"Sum","PatDish"))  		    //出院患者数
		Set InfPatCnt  	   =+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  		    //感染人数
		Set InfInCnt       =+$g(^TMP($zn,$j,NIndex,"Sum","PatInfIn"))		    //医院感染人数
		Set InfOutCnt      =+$g(^TMP($zn,$j,NIndex,"Sum","PatInfOut"))		    //社区感染人数
		Set PatDeathCnt    =+$g(^TMP($zn,$j,NIndex,"Sum","PatDeath"))  		//死亡患者数
		Set DeathInfCnt    =+$g(^TMP($zn,$j,NIndex,"Sum","DeathInfPat"))  		//死亡感染人数
		Set DeathInCnt     =+$g(^TMP($zn,$j,NIndex,"Sum","DeathInfIn"))		//死亡医院感染人数
		Set DeathOutCnt    =+$g(^TMP($zn,$j,NIndex,"Sum","DeathInfOut"))		//死亡社区感染人数

		Set DeathRatio="0.00%",InfRatio="0.00%",DeathInfRatio="0.00%",DeathInRatio="0.00%",DeathOutRatio="0.00%"
		Set:PatDishCnt>0 DeathRatio=$fn((PatDeathCnt/PatDishCnt)*100,"",2)_"%"   	//出院死亡率
		Set:PatDishCnt>0 InfRatio=$fn((InfPatCnt/PatDishCnt)*100,"",2)_"%" 	        //出院感染率
		Set:PatDeathCnt>0 DeathInfRatio=$fn((DeathInfCnt/PatDeathCnt)*100,"",2)_"%" 	//感染死亡率
		Set:InfInCnt>0 DeathInRatio=$fn((DeathInCnt/InfInCnt)*100,"",2)_"%"   	//医院感染死亡率
		Set:InfOutCnt>0 DeathOutRatio=$fn((DeathOutCnt/InfOutCnt)*100,"",2)_"%" 	//社区感染死亡率
		
		Set Data=$lb("","全部",PatDishCnt,PatDeathCnt,DeathRatio,InfPatCnt,InfRatio,DeathInfCnt,DeathInfRatio,InfInCnt,DeathInCnt,DeathInRatio,InfOutCnt,DeathOutCnt,DeathOutRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryDeathInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDeathInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDeathInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDeathInfExecute ]
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
/// CreatDate：   2022-01-05	
/// Description:  出院死亡患者医院感染情况明细
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey: 科室维度
/// 			  aLocType:  统计类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.DeadPatStat","QryDeathInfDtl","","2019-01-28","2023-02-28","0001-00-0000-H-2","W","","","1")
Query QryDeathInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aIsDeath As %String = "", aIsInf As %String = "", aInfType As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsDeath:%String,DeathDateTime:%String,DiagID:%String,InfPosDescs:%String,InfDate:%String,InfType:%String,InfEffect:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryDeathInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aIsDeath As %String = "", aIsInf As %String = "", aInfType As %String = "") As %Status
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
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	
	Set aLocDr = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
  	Set NIndex="QryDeathInfDtl"
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
					Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:(PAAdmData="")
					//就诊开始结束日期
					Set AdmDate   = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes  = $lg(PAAdmData,38)   //就诊次数
					Set VisitStatus = $lg(PAAdmData,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					// 出院科室/病区
					Set DishLocID  = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set LocDr=DishLocID
				    Set:aLocType="W" LocDr=DishWardID
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
					
					Set IsDeath=$lg(PAAdmData,15)
					Continue:(aIsDeath'="")&&(aIsDeath'=IsDeath)
					Set IsDeathDesc=$s(IsDeath=1:"是",1:"")
					
					Set DeathDateTime=""
					Set PADeathDate = $lg(PAAdmData,16)
					Set:PADeathDate'="" PADeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PADeathDate)
					Set PADeathTime = $lg(PAAdmData,17)
					Set:PADeathTime'="" PADeathTime=$zt(PADeathTime)
					SeT:PADeathDate'="" DeathDateTime = PADeathDate_" "_PADeathTime
					//获取病人基本信息
					Set PatData =..BuildPaadmData(xPaadm)
					Continue:PatData=""
					Set InfPosInfo=..GetInfPosInfo(xPaadm,AdmDate,DischDate)
					If (InfPosInfo'="") {
						For indPos=1:1:$l(InfPosInfo,"|") {
							Set tmpInfPos   = $p(InfPosInfo,"|",indPos)
							Continue:tmpInfPos=""
							Set DiagID      = $p(tmpInfPos,"^",1)
							Set InfPosDescs = $p(tmpInfPos,"^",2)
							Set InfDate		= $p(tmpInfPos,"^",3)
							Set InfXDate	= $p(tmpInfPos,"^",4)
							Set InfEffect   = $p(tmpInfPos,"^",5)
							Set InfType	    = $p(tmpInfPos,"^",7)
							Continue:DiagID=""
							Continue:((aIsInf=1)&&(DiagID=""))
							Continue:((aInfType=0)&&(InfType'["社区感染"))
							Continue:((aInfType=1)&&(InfType'["医院感染"))
							b:xPaadm=10948 ;12
							Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
							Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
							
							Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(IsDeathDesc,DeathDateTime,DiagID,InfPosDescs,InfDate,InfType,InfEffect,InfXDate)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1	
						}
					}Else {	
						Continue:(aIsInf=1)&(InfPosInfo="")
						Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(IsDeathDesc,DeathDateTime,"","","","","","")
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1	
					}
				}
			}
		}
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryDeathInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDeathInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDeathInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDeathInfDtlExecute ]
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
/// CreatDate：   2021-01-05
/// Description:  判断患者是否发生医院感染,返回感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.DeadPatStat).GetInfInfo("172")
ClassMethod GetInfInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return

	Set InfPosDescs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:RepType'="1"
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			//报告日期
			Set RepDate=$lg(INFRepData,4)
			Set RepTime=$lg(INFRepData,5)
			//报告人
			Set RepUser=""
			Set RepUserDr=$lg(INFRepData,7)
			Set:RepUserDr'="" RepUser=$lg($g(^DHCHAI.BT.SysUserD(RepUserDr)),3)
			
			// Add by zhaoyj 2022-06-14 Global方式
			// 感染诊断信息
	
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
			
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
			   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
				}
				// 感染诊断
				Set InfPosDr = $lg(DiagsData,3)
				Set PosCode=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr)),2)
				Set BigCode=$e(PosCode,1,2)
				Set PosDiagData=""
				Continue:BigCode=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				
			    
			    //转归情况
				Set InfEffect="",IRInfEffectData=""
				Set IRInfEffectDr=$lg(DiagsData,8)
				Set:IRInfEffectDr'="" IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
				Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
				If (InfPosDr'=""){
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg($g(^DHCHAI.BT.InfPosD(InfPosDr)),3)_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_RepDate_"^"_RepTime_"^"_RepUser
				}
			}
		}
	}
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

}
