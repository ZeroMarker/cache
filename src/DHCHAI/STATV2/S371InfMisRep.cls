/// 名称: DHCHAI.STATV2.S371InfMisRep
/// 描述: 感染漏报统计[出院口径]
/// 编写者：ShenC
/// 编写日期: 2022-06-13
Class DHCHAI.STATV2.S371InfMisRep Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2022-06-13
/// Description:  感染漏报统计[出院口径]
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aStaType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S371InfMisRep","QryInfMisRepByDD","","2021-01-01","2021-12-31","W")
Query QryInfMisRepByDD(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatCount:%Integer,InfPatCount:%Integer,InfPatRatio:%String,InfCaseCount:%Integer,InfCaseRatio:%String,InfLatePatCount:%Integer,LateRepRatio:%String,InfLateCaseCount:%Integer,LateCaseRepRatio:%String,InfMissPatCount:%Integer,MissRepRatio:%String,InfMissCaseCount:%Integer,MissCaseRepRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfMisRepByDDExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
	//定义临时Global
    Set NIndex="QryInfMisRepByDD"
	Kill ^TMP($zn,$j,NIndex)
	Set LateRepDay=##class(DHCHAI.BT.Config).GetValByCode("INFLateRepDay")
	Set StatLateMissShow=##class(DHCHAI.BT.Config).GetValByCode("StatLateMissShow")
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
					Set Paadm = xPaadm
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
					//本次住院区间感染信息
					Set AdmDate = $li(AdmInfo,20)
					Set DischDate = $li(AdmInfo,26)
					Set InfFlg=0
					Set InfPosDescs=..GetInfPosInfo(xPaadm,AdmDate,DischDate,1)
					Set:InfPosDescs'="" InfFlg=1
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID) 
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// 出院患者人数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
						{
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
						}
						// 感染人数
						If (InfFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
							}
						}
						If (InfPosDescs'="") {
							For xPosI = 1:1:$l(InfPosDescs,"|") {
								Set InfPosMsg = $p(InfPosDescs,"|",xPosI)
								Continue:InfPosMsg=""
								Set DiagID	    = $p(InfPosMsg,"^",1)
								Set InfDate	    = $p(InfPosMsg,"^",3)	//感染日期
								Set ReplaceFlag = $p(InfPosMsg,"^",10)		//代报
								
								Continue:$d(^TMP($zn,$j,NIndex,DimensKey,"DiagDr",DiagID)) // 输出去重
								Set ^TMP($zn,$j,NIndex,DimensKey,"DiagDr",DiagID)=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))   // 感染例数
								//2.迟报报告
								Set RepDate	= $p(InfPosMsg,"^",9)
								Set tRepDate=""
								Set:RepDate'="" tRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate) 
								If ((ReplaceFlag'="1")&&((tRepDate-InfDate)>LateRepDay)){
									If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfLateFlg",Paadm)) {			//去重判断使用
										Set ^TMP($zn,$j,NIndex,DimensKey,"InfLateFlg",Paadm)=""
										Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfLateFlg")) //迟报人数
									}
									Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfLateCase")) //迟报例数
								}
								//3.漏报报告
								//3.1.院感科代报
								If (ReplaceFlag="1"){
									If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfMissFlg",Paadm)) {			//去重判断使用
										Set ^TMP($zn,$j,NIndex,DimensKey,"InfMissFlg",Paadm)=""
										Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfMissFlg")) //漏报人数
									}
									Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfMissCase")) //漏报例数
								}Else{
									//3.2.患者出院后补报(剔除手术部位感染)
									Set DischDate=$li(^DHCHAI.DP.PAAdmD(Paadm),26)
									If ((DischDate'="")&&(tRepDate>DischDate)){
										Set PosDesc = $p(InfPosMsg,"^",2)		// 感染诊断
										Continue:((PosDesc="表浅手术切口感染")||((PosDesc="深部手术切口感染"))||((PosDesc="器官和腔隙感染")))
										If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfMissFlg",Paadm)) {			//去重判断使用
											Set ^TMP($zn,$j,NIndex,DimensKey,"InfMissFlg",Paadm)=""
											Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfMissFlg")) //漏报人数
										}
										Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfMissCase")) //漏报例数	
									}
								}
							}
						}
					}
					If (LocCount>1) {
						// 合计住院患者
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
						}
						// 合计感染人数
						If (InfFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfPat"))
								Set ^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)=""
							}
						}
						If (InfPosDescs'="") {
							For xPosI = 1:1:$l(InfPosDescs,"|") {
								Set InfPosMsg = $p(InfPosDescs,"|",xPosI)
								Continue:InfPosMsg=""
								Set DiagID	= $p(InfPosMsg,"^",1)
								Set InfDate	= $p(InfPosMsg,"^",3)	//感染日期
								//2.迟报报告
								Continue:$d(^TMP($zn,$j,NIndex,"Sum","DiagDr",DiagID)) // 输出去重
								Set ^TMP($zn,$j,NIndex,"Sum","DiagDr",DiagID)=""
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfCase"))   // 感染例数
								
								Set RepDate	= $p(InfPosMsg,"^",9)
								Set ReplaceFlag = $p(InfPosMsg,"^",10)		//代报
								Set tRepDate=""
								Set:RepDate'="" tRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate)  
								If ((ReplaceFlag'="1")&&((tRepDate-InfDate)>LateRepDay)){
									If '$d(^TMP($zn,$j,NIndex,"Sum","InfLateFlg",Paadm)) {			//去重判断使用
										Set ^TMP($zn,$j,NIndex,"Sum","InfLateFlg",Paadm)=""
										Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfLateFlg")) //迟报人数
									}
									Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfLateCase")) //迟报例数
								}
								//3.漏报报告
								//3.1.院感科代报
								If (ReplaceFlag="1"){
									If '$d(^TMP($zn,$j,NIndex,"Sum","InfMissFlg",Paadm)) {			//去重判断使用
										Set ^TMP($zn,$j,NIndex,"Sum","InfMissFlg",Paadm)=""
										Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfMissFlg")) //漏报人数
									}
									Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfMissCase")) //漏报例数
								}
								//3.2.患者出院后补报(剔除手术部位感染)
								Set DischDate=$li(^DHCHAI.DP.PAAdmD(Paadm),26)
								If ((DischDate'="")&&(tRepDate>DischDate)){
									Set PosDesc = $p(InfPosMsg,"^",2)		// 感染诊断
									Continue:((PosDesc="表浅手术切口感染")||((PosDesc="深部手术切口感染"))||((PosDesc="器官和腔隙感染")))
									If '$d(^TMP($zn,$j,NIndex,"Sum","InfMissFlg",Paadm)) {			//去重判断使用
										Set ^TMP($zn,$j,NIndex,"Sum","InfMissFlg",Paadm)=""
										Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfMissFlg")) //漏报人数
									}
									Set:ReplaceFlag'="1" num = $i(^TMP($zn,$j,NIndex,"Sum","InfMissCase")) //漏报例数	
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
		
		Set PatCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))				//住院患者人数
		Set InfPatCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))				//新发生医院感染人数
		Set InfPatRatio="0.00%"
		Set:InfPatCount>0 InfPatRatio=$fn((InfPatCount/PatCount)*100,"",2)_"%" 	//医院感染发病率
		Set InfCaseCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase"))			//新发生医院感染例次数
		Set InfCaseRatio="0.00%"
		Set:InfPatCount>0 InfCaseRatio=$fn((InfCaseCount/PatCount)*100,"",2)_"%" 	//医院感染例次发病率
		Set InfLatePatCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfLateFlg"))		//迟报感染人数
		Set InfLateCaseCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfLateCase"))	//迟报感染例次数
		Set InfMissPatCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfMissFlg"))		//漏报感染人数
		Set InfMissCaseCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfMissCase"))	//漏报感染例次数
		
		Set (LateRepRatio,LateCaseRepRatio,MissRepRatio,MissCaseRepRatio)="0.00%"
		Set:InfPatCount>0 LateRepRatio=$fn((InfLatePatCount/InfPatCount)*100,"",2)_"%" 	//医院感染例次迟报率
		Set:InfCaseCount>0 LateCaseRepRatio=$fn((InfLateCaseCount/InfCaseCount)*100,"",2)_"%" 	//医院感染例次迟报率
		
		Set:InfPatCount>0 MissRepRatio=$fn((InfMissPatCount/InfPatCount)*100,"",2)_"%" 	//医院感染病例漏报率
		Set:InfCaseCount>0 MissCaseRepRatio=$fn((InfMissCaseCount/InfCaseCount)*100,"",2)_"%" 	//医院感染例次漏报率
		
		Continue:(IsActive="0")&&(PatCount=0)	
		Continue:(aQryCon="2")&&(InfPatCount=0)
		Continue:(aQryCon="3")&&(PatCount=0)
		If (StatLateMissShow'=1){
			Set (InfLatePatCount,InfLateCaseCount,InfMissPatCount,InfMissCaseCount)="0"
			Set (LateRepRatio,LateCaseRepRatio,MissRepRatio,MissCaseRepRatio)="0.00%"
		}
		Set Data=$lb(xDimensKey,DimensDesc,PatCount,InfPatCount,InfPatRatio,InfCaseCount,InfCaseRatio,InfLatePatCount,LateRepRatio,InfLateCaseCount,LateCaseRepRatio,InfMissPatCount,MissRepRatio,InfMissCaseCount,MissCaseRepRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If (LocCount>1) {
		Set PatCount=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))				//住院患者人数
		Set InfPatCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))				//新发生医院感染人数
		Set InfPatRatio="0.00%"
		Set:InfPatCount>0 InfPatRatio=$fn((InfPatCount/PatCount)*100,"",2)_"%" 	//医院感染发病率
		Set InfCaseCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))			//新发生医院感染例次数
		Set InfCaseRatio="0.00%"
		Set:InfPatCount>0 InfCaseRatio=$fn((InfCaseCount/PatCount)*100,"",2)_"%" 	//医院感染例次发病率
		Set InfLatePatCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfLateFlg"))		//迟报感染人数
		Set InfLateCaseCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfLateCase"))	//迟报感染例次数
		Set InfMissPatCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfMissFlg"))		//漏报感染人数
		Set InfMissCaseCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfMissCase"))	//漏报感染例次数
		
		Set (LateRepRatio,LateCaseRepRatio,MissRepRatio,MissCaseRepRatio)="0.00%"
		Set:InfPatCount>0 LateRepRatio=$fn((InfLatePatCount/InfPatCount)*100,"",2)_"%" 	//医院感染例次迟报率
		Set:InfCaseCount>0 LateCaseRepRatio=$fn((InfLateCaseCount/InfCaseCount)*100,"",2)_"%" 	//医院感染例次迟报率
		
		Set:InfPatCount>0 MissRepRatio=$fn((InfMissPatCount/InfPatCount)*100,"",2)_"%" 	//医院感染病例漏报率
		Set:InfCaseCount>0 MissCaseRepRatio=$fn((InfMissCaseCount/InfCaseCount)*100,"",2)_"%" 	//医院感染例次漏报率
		If (StatLateMissShow'=1){
			Set (InfLatePatCount,InfLateCaseCount,InfMissPatCount,InfMissCaseCount)="0"
			Set (LateRepRatio,LateCaseRepRatio,MissRepRatio,MissCaseRepRatio)="0.00%"
		}
		Set Data=$lb("","全部",PatCount,InfPatCount,InfPatRatio,InfCaseCount,InfCaseRatio,InfLatePatCount,LateRepRatio,InfLateCaseCount,LateCaseRepRatio,InfMissPatCount,MissRepRatio,InfMissCaseCount,MissCaseRepRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfMisRepByDDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfMisRepByDDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfMisRepByDDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfMisRepByDDExecute ]
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
/// CreatDate：   2022-06-13
/// Description:  出院患者感染漏报率明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型
///               aLocIDs:   合计科室 
/// 			  aType：统计类型（1-应报例数  2-漏报人数 3-迟报人数 4-新发）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S371InfMisRep","QryDisPatDtl","","2021-01-01","2021-12-31","0001-00-0000-H-2","W")
Query QryDisPatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aType As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,InfRepDate:%String,InfRepUser:%String") [ SqlProc ]
{
}

ClassMethod QryDisPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aType As %String = "") As %Status
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
	Set LateRepDay=##class(DHCHAI.BT.Config).GetValByCode("INFLateRepDay")
	Set StatLateMissShow=##class(DHCHAI.BT.Config).GetValByCode("StatLateMissShow")
	//定义临时Global
    Set NIndex="QryDisPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"		//只统计住院患者,急诊单独统计
		
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
					
					//获取病人基本信息
					Set PatData =..BuildPaadmData(xPaadm)
					Continue:PatData=""
					Set TransInfoArr =..GetTransInfo(xPaadm,"","",aLocType)  //存在转科日期早于入院日期情况，取全部转科记录
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
						If aLocType="E" {
							Set LocDr  = LocID
							Set WardDr = ""
						} Else {
							Set LocDr  = LnkLocDr
							Set WardDr = LocID
						}
						Set InfPosDescs=..GetInfPosInfo(xPaadm,TransDate,OutLocDate,1,LocDr,WardDr)
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
		                    //应报+迟报+漏报
							Set (IsInf,IsLate,IsMiss)=0
							//1.应报
							Set:InfDate'="" IsInf=1
							//2.迟报(发生感染后超过X天上报,剔除代报)
							Set ReplaceFlag= $p(InfPosInfo,"^",10)		//代报
							Set tRepDate=""
							Set:InfRepDate'="" tRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(InfRepDate) 
							If ((ReplaceFlag'=1)&&((tRepDate-InfDate)>LateRepDay)){
								Set IsLate=1
							}
							//3.漏报
							//3.1.院感科代报
							If (ReplaceFlag="1"){
								Set IsMiss=1
							}
							//3.2.患者出院后补报(剔除手术部位感染)
							Set DischDate=$li(PAAdmData,26)
							If ((DischDate'="")&&(tRepDate>DischDate)){
								Set PosDesc = $p(InfPosInfo,"^",2)		// 感染诊断
								If (ReplaceFlag'="1"){
									Set:'((PosDesc="表浅手术切口感染")||((PosDesc="深部手术切口感染"))||((PosDesc="器官和腔隙感染"))) IsMiss=1
								}
							}
							If (StatLateMissShow'=1){
								Set (IsLate,IsMiss)=0
							}
							Continue:(aType=1)&&(IsInf'=1)
							Continue:(aType=2)&&(IsLate'=1)
							Continue:(aType=3)&&(IsMiss'=1)
							
		                    Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
		                    Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
		                    
		                    Continue:$d(^TMP($zn,$j,NIndex,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"DiagDr",DiagDr)=""
							
							Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,InfRepDate,InfRepUser)
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

ClassMethod QryDisPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDisPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDisPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDisPatDtlExecute ]
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
