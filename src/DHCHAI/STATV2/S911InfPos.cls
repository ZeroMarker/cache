/// 名称: DHCHAI.STATV2.S391InfPos
/// 描述: 出院患者医院感染部位分布统计表
/// 编写者：蒋朋朋
/// 编写日期: 2019-10-21
Class DHCHAI.STATV2.S911InfPos Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-19
/// Description:  医院感染部位分布统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aStaType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S911InfPos","QryInfPosCSS","2020-02-01","2020-03-01","","W")
Query QryInfPosCSS(aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aStaType As %String = "W") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,InfPatCnt:%String,InfCaseCnt:%String,InfPosDesc:%String,InfDiagDesc:%String,InfDiagCnt:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aStaType As %String = "W") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
	
	Set NIndex="QryInfPosCSS"
	Kill ^TMP($zn,$j,NIndex)
	
	//统计维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //病区或科室

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
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,DishHospID,GroupID,DishLocID,DishWardID)
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						//各科室出院人数
						Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
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
								Set InfPosDesc=$p(InfPosMsg,"^",6)
								Set InfDate	= $p(InfPosMsg,"^",3)
								Set PosDesc=$p(InfPosMsg,"^",2)
								Set InfType	= $p(InfPosMsg,"^",7)
								Continue:InfType'="社区感染"
								//统计维度
								Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,DishHospID,GroupID,DishLocID,DishWardID)
								Continue:StatDimensInfo=""
								For indDimens=1:1:$l(StatDimensInfo,"^") {
									Set DimensKey=$p(StatDimensInfo,"^",indDimens)
									Continue:DimensKey=""
									// 感染人数
									If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",xPaadm)) {
										Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
										Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",xPaadm)=""
									}
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase")) // 感染例数
									// 记录感染部位数量
									Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,InfPosDesc))
									Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",InfPosDesc,PosDesc) = ""
								}
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
		Set DimensKey	=$lg(DimList,1)
		Set DimensDesc	=$lg(DimList,3)
		Set IsActive	=$lg(DimList,4)
		Continue:DimensKey=""
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))  //出院患者人数
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))  //感染人数
		Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,DimensKey,"InfCase")) //感染例数
		
		Set xDiag=""
		For {
			Set xDiag=$o(^TMP($zn,$j,NIndex,DimensKey,"InfPosList",xDiag))
			Quit:xDiag=""
			Set InfDiagDesc =xDiag
			Set InfDiagCnt  =+$g(^TMP($zn,$j,NIndex,DimensKey,xDiag)) //感染部位例数
			Set PosDesc     =$o(^TMP($zn,$j,NIndex,DimensKey,"InfPosList",xDiag,""))
			Set Data=$lb(DimensKey,DimensDesc,PatAdmCnt,InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPosCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
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
/// CreatDate：   2020-05-12
/// Description:  医院感染部位分布统计-感染患者明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensType ：W -病区 E -科室(统计单位)
/// 			  aPosDesc ：感染部位
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S391InfPos","QryInfPosCSSDtl","2020-02-01","2020-03-01","0000-00-0000-A-1","W","")
Query QryInfPosCSSDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "W", aPosDesc As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "W", aPosDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
	
	Set NIndex="QryInfPosCSSDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set aLocDr=""
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
  	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    //同期在科、在病区
    Set:aDimensType="" aDimensType=aLocType
    Set:aDimensType'="W" aDimensType="E"  //不是病区就是科室
    
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
					Set:aDimensType="E" GroupID=$List($g(^DHCHAI.BT.LocationD(DishLocID)),7)
					Set:aDimensType="W" GroupID=$List($g(^DHCHAI.BT.LocationD(DishWardID)),7)
					If (GroupID="") {
						Set GroupID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}		
						Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData=""
					Set InfPosDescs=..GetInfPosInfo(xPaadm,AdmDate,aDateTo)
					Continue:InfPosDescs=""
					For indxi=1:1:$l(InfPosDescs,"|") {
								Set tmpInfPos      	= $p(InfPosDescs,"|",indxi)
								Set tmpInfPosID    	= $p(tmpInfPos,"^",1)
								Set tmpInfPosDescs 	= $p(tmpInfPos,"^",2)	//感染诊断
								Set InfDate		   	= $p(tmpInfPos,"^",3)
								Set InfEffect	    = $p(tmpInfPos,"^",5)
								Set InfType			= $p(tmpInfPos,"^",7)
								Continue:InfType'="社区感染"
								Continue:(aPosDesc'="")&&(aPosDesc'=tmpInfPosDescs)
								Set InfDate  		= $zd(InfDate,3)
								Set InfData=$lb(tmpInfPosDescs,InfDate,InfEffect)
								Set Data=PatData_InfData
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

ClassMethod QryInfPosCSSDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
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
/// CreatDate：   2022-06-17
/// Description:  查询感染部位-诊断信息 报表使用 按照Code排序
/// Table：       DHCHAI.BT.InfPos
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S911InfPos","QryInfPosToSelect")
Query QryInfPosToSelect() As %Query(ROWSPEC = "PosCode:%String,PosDesc:%String,DiagDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosToSelectExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Kill ^TMP($zn,$j,"QryInfPosToSelect")
	//感染部位
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-17 Global方式
			Set InfPosData = $g(^DHCHAI.BT.InfPosD(xID))
			Continue:InfPosData=""
			
			Set Code     = $lg(InfPosData,2)
			Set Desc     = $lg(InfPosData,3)
			Set DiagFlag = $lg(InfPosData,4)
			Set GCode    = $lg(InfPosData,5)
			Set:GCode="" GCode="9999"
			Set IsActive = $lg(InfPosData,6)
			Continue:IsActive'=1
			Continue:DiagFlag'=0  //查询所有部位
			Set ^TMP($zn,$j,"QryInfPosToSelect","InfPos",xID)=$lb(xID,Code,Desc)
		}
	}
	//感染诊断
	Set PosID=""
	for{
		Set PosID=$o(^TMP($zn,$j,"QryInfPosToSelect","InfPos",PosID))
		QUit:PosID=""
		Set PosCode=$li($g(^TMP($zn,$j,"QryInfPosToSelect","InfPos",PosID)),2)
		Set PosDesc=$li($g(^TMP($zn,$j,"QryInfPosToSelect","InfPos",PosID)),3)
	
		Set xCode = ""
		For {
			Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
			Quit:xCode=""
			Continue:$e(xCode,1,2)'=PosCode
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
				Quit:xID=""
				Set InfPosData = $g(^DHCHAI.BT.InfPosD(xID))
				Continue:InfPosData=""
				
				Set DiagDesc =$lg(InfPosData,3)
				Set IsActive =$lg(InfPosData,6)
				Continue:IsActive'=1
				Continue:DiagFlag'=1  //查询所有诊断	
				Continue:PosDesc=DiagDesc
				Set Data=$lb(PosCode,PosDesc,DiagDesc)
				Set ^CacheTemp(repid,ind) = Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP($zn,$j,"QryInfPosToSelect")
	Quit $$$OK
}

ClassMethod QryInfPosToSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfPosToSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2022-06-17
/// Description:  住院患者抗菌药物联用级别(同一天使用抗菌药物种类)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期   
/// Return：      返回抗菌药物级别(1,2,3,4),error(-1)
/// w ##class(DHCHAI.STATV2.S132AntComb).GetAntComb("1887",$zdh("2020-01-01",3),$zdh("2020-04-28",3))
ClassMethod GetAntComb(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aEpisodeID,aDateFrom,aDateTo)
	Set return=-1
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
	
	Set NIndex="GetAntComb"
	Kill ^TMP($zn,$j,NIndex)
	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0	
	           
	            Set SttDate = $li(OEOrdItemData,15)	
				Set EndDate = $li(OEOrdItemData,17)
				Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				Continue:PriorityMap="OUT"   //add 20211217 过滤出院带药医嘱
				
	            If PriorityMap="N"{
					Set EndDate = SttDate
				}else{
					If EndDate=""{		// 长期医嘱未停止只计算到传入结束日期
						Set EndDate = aDateTo
					}
				}
				Continue:EndDate<aDateFrom  // 停药日期在转入日期前
				Continue:SttDate>aDateTo	// 用药日期在转出日期后
				
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
                Set InstrucList=","_InstrucList_","
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				//记录抗菌药物使用
				Set AntiDesc = $li(OEOrdItemData,4)
				
				Set AntiDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(AntiDesc)  //去掉特殊字符
				Set AntiID = $o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc","HIS01",AntiDesc,""))
				Continue:AntiID=""
				Set AntiMapDr=$g(^DHCHAI.DP.OEAntiMastMapD(AntiID))
				Quit:AntiMapDr=""
				Set BTMapItemDr=$li(AntiMapDr,3)
				Set AntiMapDesc=$li($g(^DHCHAI.DP.OEAntiMastD(BTMapItemDr)),3)
				Quit:AntiMapDesc=""
				for xDate=SttDate:1:EndDate{
					Set ^TMP($zn,$j,NIndex,"AntComb",xDate,AntiMapDesc)=""
				}
			}
		}
	}
	//取最大抗菌药物联用日期和级别
	Set CombCount=0
	Set xDate=""
	for{
		Set xDate=$o(^TMP($zn,$j,NIndex,"AntComb",xDate))
		Quit:xDate=""
		Continue:(xDate<aDateFrom)||(xDate>aDateTo)
		
		Set Count=0,xAntiDesc=""
		for{
			Set xAntiDesc=$o(^TMP($zn,$j,NIndex,"AntComb",xDate,xAntiDesc))	
			Quit:xAntiDesc=""
			
			Set Count=Count+1
		}
		Set:Count>CombCount CombCount=Count
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit CombCount
}

}
