/// 名称: DHCHAI.STATV2.S370InfMisRep
/// 描述: 感染漏报统计[新]
/// 编写者：ShenC
/// 编写日期: 2021-09-09
Class DHCHAI.STATV2.S370InfMisRep Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2021-09-09
/// Description:  医院感染病例迟报/漏报率统计
/// Table：       DHCHAI.DP.PAAdm,DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aQryCon：  有效数据筛查
///               aStatDimens :  展示维度
///               aLocIDs :    科室 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S370InfMisRep","QryInfMisRep","1","2022-12-01","2022-12-05","W")
Query QryInfMisRep(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatCount:%Integer,InfPatCount:%Integer,InfPatRatio:%String,InfCaseCount:%Integer,InfCaseRatio:%String,InfLatePatCount:%Integer,LateRepRatio:%String,InfLateCaseCount:%Integer,LateCaseRepRatio:%String,InfMissPatCount:%Integer,MissRepRatio:%String,InfMissCaseCount:%Integer,MissCaseRepRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfMisRepExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//日期处理
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set IsLc = 0
 	Set xLocID = ""
 	Set xLcDimensKey = ""
 	if (aQryCon="9999")&(aHospIDs'="")
 	{
	 	//如果是临床打开报表进行特殊处理,借用aHospIDs传入科室ID
	 	Set IsLc =1
	 	Set aQryCon =1
	 	Set xLocID = aHospIDs
	 	Set xLocData = $g(^DHCHAI.BT.LocationD(xLocID))
	 	Set BTTypeDr=$lg(xLocData,5)
	 	Set:BTTypeDr'="" aLocType=$lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
	 	Set BTHospDr=$lg(xLocData,8)
	 	Set:BTHospDr'="" aHospIDs=BTHospDr
	 	Set xLcDimensKey=$e("0000"_xLocID,*-3,*)_"-"_aLocType        	//科室ID	 	
	}
	
 	Set:aLocType'="W" aLocType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
	Set LateRepDay=##class(DHCHAI.BT.Config).GetValByCode("INFLateRepDay")
	Set StatLateMissShow=##class(DHCHAI.BT.Config).GetValByCode("StatLateMissShow")
    Set NIndex="QryInfMisRep"
	Kill ^TMP($zn,$j,NIndex)
	//同期在科
    Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set HospDr=$li(LocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
			
			Set GroupDr  = $li(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}
		    //同期在科:某段时间的在科人数
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
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
					Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
				}
				Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))   // add by zhoubo 
				Set HospDr=$li(LocData,8)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
				Set GroupDr  = $li(LocData,7)
				If GroupDr="" {
					Set GroupDesc="其他科"
					Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
				}
				//获取感染信息
				Set InfFlg=0,InfPosDescs=""
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    //Quit:InfFlg=1    //同一次就诊同一个科室感染过即为使用
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
				    Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)
					// 如果转科起止日期大于统计日期，以统计日期计算
					Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
					Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
					Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""

					// 查询医院感染的感染信息
					Set InfPosDesc =..GetInfPosInfo(Paadm,DateFrom,DateTo,1,LocDr,WardDr)	
					Set:InfPosDesc'="" InfFlg=1,InfPosDescs=InfPosDescs_"|"_InfPosDesc
				}
				Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
				// 计算感染人数及感染例次数
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					// 住院患者人数
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
					// 感染例数
					If (InfFlg=1) {
						For PosInd=1:1:$l(InfPosDescs,"|") {
							Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
							Continue:InfPosInfo=""
							Set DiagDr = $p(InfPosInfo,"^",1)
							
							Continue:$d(^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)=""
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
						}
					}
					If (InfPosDescs'="") {
						For xPosI = 1:1:$l(InfPosDescs,"|") {
							Set InfPosMsg = $p(InfPosDescs,"|",xPosI)
							Continue:InfPosMsg=""
							Set DiagID	= $p(InfPosMsg,"^",1)
							Set InfDate	= $p(InfPosMsg,"^",3)	//感染日期
							//2.迟报报告
							Set RepDate	= $p(InfPosMsg,"^",9)
							Set tRepDate=""
							Set:RepDate'="" tRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate) 
							 
							If ((tRepDate-InfDate)>LateRepDay){
								If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfLateFlg",Paadm)) {			//去重判断使用
									Set ^TMP($zn,$j,NIndex,DimensKey,"InfLateFlg",Paadm)=""
									Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfLateFlg")) //迟报人数
								}
								Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfLateCase")) //迟报例数
							}
							//3.漏报报告
							//3.1.院感科代报
							Set ReplaceFlag= $p(InfPosMsg,"^",10)		//代报
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
					// 合计感染例数
					If (InfFlg=1) {
						For PosInd=1:1:$l(InfPosDescs,"|") {
							Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
							Continue:InfPosInfo=""
							Set DiagDr = $p(InfPosInfo,"^",1)
							
							Continue:$d(^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)=""
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfCase"))
						}
					}
					If (InfPosDescs'="") {
						For xPosI = 1:1:$l(InfPosDescs,"|") {
							Set InfPosMsg = $p(InfPosDescs,"|",xPosI)
							Continue:InfPosMsg=""
							Set DiagID	= $p(InfPosMsg,"^",1)
							Set InfDate	= $p(InfPosMsg,"^",3)	//感染日期
							//2.迟报报告
							Set RepDate	= $p(InfPosMsg,"^",9)
							Set tRepDate=""
							Set:RepDate'="" tRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate) 
							 
							If ((tRepDate-InfDate)>LateRepDay){
								If '$d(^TMP($zn,$j,NIndex,"Sum","InfLateFlg",Paadm)) {			//去重判断使用
									Set ^TMP($zn,$j,NIndex,"Sum","InfLateFlg",Paadm)=""
									Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfLateFlg")) //迟报人数
								}
								Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfLateCase")) //迟报例数
							}
							//3.漏报报告
							//3.1.院感科代报
							Set ReplaceFlag= $p(InfPosMsg,"^",10)		//代报
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
		//限制临床科室查看内容
		Continue:(IsLc=1)&(xLcDimensKey'="")&(xDimensKey'[xLcDimensKey)
		
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
	k ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfMisRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfMisRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfMisRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfMisRepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
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
/// CreatDate：   2021-09-10
/// Description:  医院感染病例迟报/漏报率统计明细
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型
///               aLocIDs:   合计科室 
/// 			  aType：统计类型（1-应报例数  2-漏报人数 3-迟报人数 4-新发）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S370InfMisRep","QryInfMisRepDtl","2020-03-01","2020-04-24","0001-07-0024-W-4",1)
Query QryInfMisRepDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aType As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,InfRepDate:%String,InfRepUser:%String") [ SqlProc ]
{
}

ClassMethod QryInfMisRepDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//日期处理
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark	= $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	Set LateRepDay=##class(DHCHAI.BT.Config).GetValByCode("INFLateRepDay")
	Set StatLateMissShow=##class(DHCHAI.BT.Config).GetValByCode("StatLateMissShow")
	Set NIndex="QryInfMisRepDtl"
	Kill ^TMP($zn,$j,NIndex)
	//同期在科
    Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocDr'="")&(aLocDr'=xLocID)
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
				
			Set HospDr=$lg(LocData,8)
			//医院分组过滤
			Continue:HospDr=""
			Set HospInfo="",HospGroupDr="",HospGrpInfo=""
			Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
			Set HospGroupDr=$lg(HospInfo,5)
			Continue:HospGroupDr="" 
			Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
			Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
			//院区过滤
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
			
			Set GroupDr  = $lg(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}	
			Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
			Set GroupDesc=$lg(GroupData,3)
			//按科室组、科室/病区过滤
			Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)

            //取统计维度
			Set DimensDesc =""
			Set:DimensMark="" DimensDesc="全部"
			Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
			Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
			Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
			Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
			
		    //同期在科、在病区
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
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
					Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
				}
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2	
				//患者转科基本信息
				Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
	            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
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

					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
					
					//获取感染信息
					Set InfPosDescs =..GetInfPosInfo(Paadm,DateFrom,DateTo,1,LocDr,WardDr)	
					Continue:InfPosDescs=""
					//感染信息输出
					For PosInd=1:1:$l(InfPosDescs,"|"){
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
	                    Set tRepDate=""
						Set:InfRepDate'="" tRepDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(InfRepDate) 
							
	                    //迟报报告
						If (aType=2){
							Continue:StatLateMissShow'=1
							Set LateFlag="0"
							If ((tRepDate-InfDate)>LateRepDay){
								Set LateFlag="1"
							}
							Continue:LateFlag="0"
						}
						//漏报报告
						If (aType=3){
							Continue:StatLateMissShow'=1
							Set MissFlag="0"
							//1.院感科代报
							Set ReplaceFlag= $p(InfPosInfo,"^",10)
							Set:ReplaceFlag="1" MissFlag="1"
							//2.患者出院后补报(剔除手术部位感染)
							Set DischDate=$li(^DHCHAI.DP.PAAdmD(Paadm),26)
							If ((DischDate'="")&&(tRepDate>DischDate)){
								Set PosDesc = $p(InfPosInfo,"^",2)		// 感染诊断
								if ((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染"))){
									Set MissFlag="1"	
								}
							}
							Continue:MissFlag="0"
						}
	                    
	                    Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
	                    Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
	                    Continue:$d(^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)=""
						Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,InfRepDate,InfRepUser)
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

ClassMethod QryInfMisRepDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfMisRepDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfMisRepDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfMisRepDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
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
