/// 名称: DHCHAI.STATV2.BactSpecDist
/// 描述: 检出菌标本分布统计
/// 编写者: zhoubo
/// 编写日期: 2021-04-07
Class DHCHAI.STATV2.BactSpecDist Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-04-07
/// Description:  检出菌标本分布统计
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aTypeCode  : 感染类型Code
///               aBactID    : 细菌字典ID
///               aStatNum   : 统计数量
///               aBacDesc   : 细菌名称
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactSpecDist","QryBactSpecDist","","1","2022-03-01","2022-03-31","","","","")
Query QryBactSpecDist(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aTypeCode As %String, aBactID As %String, aStatNum As %String, aBacDesc As %String = "") As %Query(ROWSPEC = "SortSum:%String,xBacDesc:%String,xSpec:%String,SpecSum:%Integer,SpecNumSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryBactSpecDistExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aTypeCode As %String, aBactID As %String, aStatNum As %String, aBacDesc As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryBactSpecDist"
    Set:aStatNum="" aStatNum=5
	Kill ^TMP($zn,$j,NIndex)
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	
    //送检日期
    If aDateType=1{
	    Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
			Quit:xItemID=""
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBData
				}
			}
		}
	} Else { //报告日期
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
			Quit:xItemID=""
			
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBData
				}
			}
		}
	}
	// 标本数排序
	Set xBacDesc=""
	For {
		Set xBacDesc=$o(^TMP($zn,$j,NIndex,"BactSpecStat",xBacDesc))
		Quit:xBacDesc=""
		Set xSpec=""
		For {
			Set xSpec=$o(^TMP($zn,$j,NIndex,"BactSpecStat",xBacDesc,xSpec))
			Quit:xSpec=""
			
			Set SpecNum    = +$g(^TMP($zn,$j,NIndex,"BactSpecStat",xBacDesc,xSpec))
			Set SpecNumSum = +$g(^TMP($zn,$j,NIndex,"BactSpecStatSum",xBacDesc))
			
			Set tmpBacDesc = xBacDesc
			Set:xBacDesc="A全院" tmpBacDesc="全院"
			
			Set Data = $lb(tmpBacDesc,xSpec,SpecNum,SpecNumSum)
			
			Set ^TMP($zn,$j,NIndex,"BactSpecNum",xBacDesc,SpecNum,xSpec)=Data
		}
	}
	// 输出
	Set SortSum=0
	Set xBacDesc=""
	For {
		Set xBacDesc=$o(^TMP($zn,$j,NIndex,"BactSpecNum",xBacDesc))
		Quit:xBacDesc=""
		Set Count=0
		Set SortSum=SortSum+1
		Set xSpecNum=""
		For {
			Set xSpecNum=$o(^TMP($zn,$j,NIndex,"BactSpecNum",xBacDesc,xSpecNum),-1)
			Quit:xSpecNum=""
            Set (tBacDesc,SpecDesc,OtherSpecNum,OtherSpecNumSum)=""
			Set xSpecimen=""
			For {
				Set xSpecimen=$o(^TMP($zn,$j,NIndex,"BactSpecNum",xBacDesc,xSpecNum,xSpecimen))
				Quit:xSpecimen=""
				
				Set Data = $g(^TMP($zn,$j,NIndex,"BactSpecNum",xBacDesc,xSpecNum,xSpecimen))
				Set Count=Count+1
                if Count>aStatNum {
                    Set tBacDesc=$lg(Data,1)
                    Set SpecDesc=SpecDesc_$lg(Data,2)_","
                    Set SpecNum=$lg(Data,3)
                    Set OtherSpecNum=OtherSpecNum+SpecNum
                    Set OtherSpecNumSum=+$lg(Data,4)
                   
                    continue
                }
                
                Set ^CacheTemp(repid,ind)=$lb(SortSum)_Data
                Set ind=ind+1
            }
        }
        if OtherSpecNum>0 {
             Set SpecDesc=$e(SpecDesc,1,*-1)
             Set ^CacheTemp(repid,ind)=$lb(SortSum)_$lb(tBacDesc,"其他,"_SpecDesc,OtherSpecNum,OtherSpecNumSum)
             Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildMRBData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	Quit:$li(RstData,14)'=1
	Set IsAbFlag = $li(RstData,21)   //异常标志
	//Quit:IsAbFlag'=1 //过滤非耐药菌
	Set CCMRBTpDr = $li(RstData,24)  // 是否是多耐菌

	Set AdmID    = $li(RstData,2)
	Set ResultID = $p($li(RstData,19),"=",2)  //检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	
	Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType      = $lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型
	Set LabReportDr      = $lg(RepRstData,2)
	Quit:LabReportDr=""
	Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
	Quit:LabReportData=""
	Set LabVisitNumberDr = $lg(LabReportData,2)
	Quit:LabVisitNumberDr=""
	Quit:$d(^TMP($zn,$j,NIndex,"AdmVisitRepeat",AdmID,LabVisitNumberDr))
	Set ^TMP($zn,$j,NIndex,"AdmVisitRepeat",AdmID,LabVisitNumberDr)=""
	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(LabVisitNumberDr))
	Quit:VisitNumberData=""
	Set LabSpecimen = $lg(VisitNumberData,6)
	Set LabSCode    = $lg(VisitNumberData,14)
	Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
	Quit:SpecMapID=""
	Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
	Quit:SpecMapData=""
	Set BTMapItemDr = $lg(SpecMapData,3)
	Quit:BTMapItemDr=""
	Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))
	Set SpecDesc=""
	Set:SpecData'="" SpecDesc = $li(SpecData,3)
	Set:SpecDesc'="" LabSpecimen=SpecDesc
	Quit:LabSpecimen=""
	Set SCode       = $li(RstData,17)   //子系统代码
	Set PAadmData   = $g(^DHCHAI.DP.PAAdmD(AdmID))
	Quit:PAadmData=""
	Set AdmLocID    = $li(PAadmData,22)
	Quit:AdmLocID=""
	Set AdmLocData  = $g(^DHCHAI.BT.LocationD(AdmLocID))
	Set AdmLocDesc  = $li(AdmLocData,3)
	Set AdmLocDesc2 = $li(AdmLocData,4)
	Set:AdmLocDesc2'="" AdmLocDesc = AdmLocDesc2
	Set HospDr = $li(AdmLocData,8)
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
		
	Set AdmWardID = $li(PAadmData,23)
	Quit:AdmWardID=""
	Set AdmWardData  = $g(^DHCHAI.BT.LocationD(AdmWardID))
	Set AdmWardDesc  = $li(AdmWardData,3)
	Set AdmWardDesc2 = $li(AdmWardData,4)
	Set:AdmWardDesc2'="" AdmWardDesc = AdmWardDesc2
	
	Set Bacteria = $li(RstData,23)   //原始细菌名称
	Set BacDesc="",BacID=""
	Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
	If (Bacteria'=""){
		Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,""))
		If MapItemDr'="" {
			Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
			If BactMapData'=""{
				Set BacID=$li(BactMapData,3)
				If (BacID'=""){
					Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
					Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)
				}
			}
		}
	}
	Quit:BacDesc="" 	// 过滤未对照细菌
	Quit:(aBactID'="")&&(BacID'=aBactID)  // 细菌过滤
	Quit:BacDesc=""
	Set CCActDate   = $li(RstData,8)  // 送检日期
	Set CCActLocDr  = $li(RstData,7)  // 送检科室
	Quit:CCActLocDr=""
	Set ActLocData  = $g(^DHCHAI.BT.LocationD(CCActLocDr))
	Quit:ActLocData=""
	Set ActLocDesc  = $li(ActLocData,3)
	Set ActLocDesc2 = $li(ActLocData,4)
	Set:ActLocDesc2'="" ActLocDesc=ActLocDesc2
	//去重
	If (IsUnRepeat="1"){
		Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(AdmID,xID,UnRepeatType,"1")
		Quit:IsFirstSend'=1
	}
	
	If (aBacDesc'=""){
		If (aBacDesc="全院"){
			Set num=$i(^TMP($zn,$j,NIndex,"BactSpecStat","A全院",LabSpecimen))
		}Else{
			Quit:(BacDesc'=aBacDesc)
			Set num=$i(^TMP($zn,$j,NIndex,"BactSpecStat",BacDesc,LabSpecimen))
		}
	}Else{
		Set num=$i(^TMP($zn,$j,NIndex,"BactSpecStat","A全院",LabSpecimen))
		Set num=$i(^TMP($zn,$j,NIndex,"BactSpecStat",BacDesc,LabSpecimen)) 
		Set num=$i(^TMP($zn,$j,NIndex,"BactSpecStatSum","A全院"))
		Set num=$i(^TMP($zn,$j,NIndex,"BactSpecStatSum",BacDesc))
	}
	
	 
	Quit
}

ClassMethod QryBactSpecDistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactSpecDistExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactSpecDistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactSpecDistExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2021-04-07
/// Description:  检出菌标本分布统计明细
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aTypeCode  : 感染类型Code
///               aBactID    : 细菌字典ID
///               aStatNum   : 统计数量
///               aBacDesc   : 细菌名称
///               aSpecDesc  : 标本
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactSpecDist","QryBactSpecDistDtl","","1","2020-01-01","2020-05-12","","","","","")
Query QryBactSpecDistDtl(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aTypeCode As %String, aBactID As %String, aStatNum As %String, aBacDesc As %String, aSpecDesc As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryBactSpecDistDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aTypeCode As %String, aBactID As %String, aStatNum As %String, aBacDesc As %String, aSpecDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aSpecDesc=$replace(aSpecDesc,"其他,","")
    Set listSpec=$listfromstring(aSpecDesc,",")
    Set NIndex="QryBactSpecDistDtl"
    Set:aStatNum="" aStatNum=5
    Set:aBacDesc="全院" aBacDesc=""
	Kill ^TMP($zn,$j,NIndex)
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	
    //送检日期
    If aDateType=1{
	    Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
			Quit:xItemID=""
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBDtlData
				}
			}
		}
	} Else { //报告日期
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
			Quit:xItemID=""
			
			Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
			Continue:ItemData=""
			Set ItemCode = $li(ItemData,2)
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBDtlData
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildMRBDtlData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	//过滤无效数据
	Quit:$li(RstData,14)'=1
	Set CCMRBTpDr = $li(RstData,24)  // 是否是多耐菌
	//过滤感染类型
	Set ResultID =$p( $li(RstData,19),"=",2) 		//检验结果ID->DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型
	
	Set AdmID    = $li(RstData,2)
	Set LabReportDr      = $lg(RepRstData,2)
	Quit:LabReportDr=""
	Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
	Quit:LabReportData=""
	Set LabVisitNumberDr = $lg(LabReportData,2)
	Quit:LabVisitNumberDr=""
	//过滤重复标本
	Quit:$d(^TMP($zn,$j,NIndex,"AdmVisitRepeat",AdmID,LabVisitNumberDr))
	Set ^TMP($zn,$j,NIndex,"AdmVisitRepeat",AdmID,LabVisitNumberDr)=""
	
	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(LabVisitNumberDr))
	Quit:VisitNumberData=""
	Set LabSpecimen = $lg(VisitNumberData,6)
	Set LabSCode    = $lg(VisitNumberData,14)
	Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
	Quit:SpecMapID=""
	Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
	Quit:SpecMapData=""
	Set BTMapItemDr = $lg(SpecMapData,3)
	Quit:BTMapItemDr=""
	Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))
	Set SpecDesc=""
	Set:SpecData'="" SpecDesc = $li(SpecData,3)
	Set:SpecDesc'="" LabSpecimen=SpecDesc
	Quit:LabSpecimen=""
   
    Quit:($ll(listSpec)>0)&&'($lf(listSpec,LabSpecimen)>0)
	Set SCode       = $li(RstData,17)   //子系统代码
	Set PAadmData   = $g(^DHCHAI.DP.PAAdmD(AdmID))
	Quit:PAadmData=""
	Set AdmLocID    = $li(PAadmData,22)
	Quit:AdmLocID=""
	Set AdmLocData  = $g(^DHCHAI.BT.LocationD(AdmLocID))
	Set AdmLocDesc  = $li(AdmLocData,3)
	Set AdmLocDesc2 = $li(AdmLocData,4)
	Set:AdmLocDesc2'="" AdmLocDesc = AdmLocDesc2
	Set HospDr = $li(AdmLocData,8)
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
		
	Set AdmWardID = $li(PAadmData,23)
	Quit:AdmWardID=""
	Set AdmWardData  = $g(^DHCHAI.BT.LocationD(AdmWardID))
	Set AdmWardDesc  = $li(AdmWardData,3)
	Set AdmWardDesc2 = $li(AdmWardData,4)
	Set:AdmWardDesc2'="" AdmWardDesc = AdmWardDesc2
	
	Set Bacteria = $li(RstData,23)   //原始细菌名称
	Set BacDesc="",BacID=""
	Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
	If (Bacteria'=""){
		Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,""))
		If MapItemDr'="" {
			Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
			If BactMapData'=""{
				Set BacID=$li(BactMapData,3)
				If (BacID'=""){
					Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
					Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)
				}
			}
		}
	}
	Quit:BacDesc="" 	// 过滤未对照细菌
	Quit:(aBactID'="")&&(BacID'=aBactID)  // 细菌过滤
	Quit:(aBacDesc'="")&&(aBacDesc'=BacDesc)
	Set CCActDate   = $li(RstData,8)  // 送检日期
	Set CCActLocDr  = $li(RstData,7)  // 送检科室
	Set CCRepDate   = $li(RstData,11) // 报告日期
	Quit:CCActLocDr=""
	Set ActLocData  = $g(^DHCHAI.BT.LocationD(CCActLocDr))
	Quit:ActLocData=""
	Set ActLocDesc  = $li(ActLocData,3)
	Set ActLocDesc2 = $li(ActLocData,4)
	Set:ActLocDesc2'="" ActLocDesc=ActLocDesc2
		
	Set LabVisitID  	= $lg(LabReportData,2)		//检验标本号
	Set LabVisitData   	= $g(^DHCHAI.DP.LabVisitNumberD(LabVisitID))
	Quit:LabVisitData=""	
	Set LabEpisodeNo	= $lg(LabVisitData,3)		//标本号
	Set LabReportDr	= $lg(RepRstData,2)				//检验医嘱	
	Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
	Quit:LabReportData=""			
	Set LabTestSet=""	
	Set LabTestSetID	= $lg(LabReportData,13)	
	If (LabTestSetID'=""){
		Set LabTestSet=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetID)),3)
	}
	//去重
	If (IsUnRepeat="1"){
		Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(AdmID,xID,UnRepeatType,"1")
		Quit:IsFirstSend'=1
	}
	
	//->检验标本号
	Set LabVisitID  	= $lg(LabReportData,2)	
	Set LabVisitData   	= $g(^DHCHAI.DP.LabVisitNumberD(LabVisitID))
	Quit:LabVisitData=""	
	Set LabEpisodeNo	= $lg(LabVisitData,3)		//标本号
	//->送检日期时间
	Set ActDate=$lg(RstData,8)				//送检日期		
	Set ActTime=$lg(RstData,9)				//送检时间
	Set ActDateTime =$zd(ActDate,3)_" "_$zt(ActTime,1)	
	//->报告日期时间		
	Set RepDate =$lg(RstData,11)			
	Set RepTime =$lg(RstData,12)			
	Set RepDateTime=$zd(RepDate,3)_" "_$zt(RepTime,1)		
	//->多耐基本信息
	Set (MRBID,MRBCode,MRBDesc,MRB2ID,MRB2Code,MRB2Desc)=""
	Set MRBTpDr=$lg(RstData,24)			//多耐类型-1
	If (MRBTpDr) {
		Set MRBInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
		Set MRBID    = MRBTpDr
		Set MRBDesc  = $lg(MRBInfo,3)
		Set MRBCode  = $lg(MRBInfo,2)
	}
	Set MRBTp2Dr=$lg(RstData,31)		//多耐类型-2
	If (MRBTp2Dr) {
		Set MRB2Info=$g(^DHCHAI.IR.CRuleMRBD(MRBTp2Dr))
		Set MRB2ID    = MRBTp2Dr
		Set MRB2Desc  = $lg(MRB2Info,3)
		Set MRB2Code  = $lg(MRB2Info,2)
	}
	Set:MRB2Desc'="" MRBDesc=MRBDesc_","_MRB2Desc		//合并
	//->感染类型
	Set InfType=""
	Set:MakeInfType="1" InfType="HA(院内感染)"
	Set:MakeInfType="2" InfType="CA(社区感染)"
	Set:MakeInfType="3" InfType="定植"
	Set:MakeInfType="4" InfType="污染"
	Set:MakeInfType="5" InfType="HA重复"
	Set:MakeInfType="6" InfType="CA重复"
	Set:MakeInfType="7" InfType="定植重复"
	
	Set LabInfo=$lb(xID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,LabSpecimen,BacDesc,InfType)
	//患者基本信息
	Set PatData =..BuildPaadmData(AdmID)
	Quit:PatData=""
	Set AdmData=$g(^DHCHAI.DP.PAAdmD(AdmID))
	Set AdmTimes = $lg(AdmData,38)   	//就诊次数
	//患者转科基本信息(默认病区)
	Set aLocType="W"
	
	Set xTransDate=""
	For {
		Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,AdmID,xTransDate))
		Quit:xTransDate=""
		Quit:xTransDate>aDateTo  //转入日期大于截止日期
			
		Set xTransID=""
		For {
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,AdmID,xTransDate,xTransID))
			Quit:xTransID=""
	
			Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(xTransID))
			Set TransDate	= $lg(TranData,7)		//转科日期
			Set OutLocDate	= $lg(TranData,10)		//出科日期
			Set TransTime	= $lg(TranData,8)		//转科时间
			Set OutLocTime	= $lg(TranData,11)		//出科时间
			Continue:(OutLocDate'="")&&(OutLocDate<aDateFrom)	//转出日期小于起始日期
			
			//过滤'送检/报告'不在转科期间	
			Set TransDateFrom=TransDate,TransDateTo=OutLocDate,TransTimeFrom=TransTime,TransTimeTo=OutLocTime
			Set:TransDate<aDateFrom TransDateFrom = aDateFrom,TransTimeFrom="0"
			Set:(OutLocDate="")||(OutLocDate>aDateTo) TransDateTo = aDateTo,TransTimeTo="86399"
					
			If aDateType=1{		//送检
				Continue:(ActDate<TransDateFrom)||(ActDate>TransDateTo)
				Continue:(ActDate=TransDateFrom)&&(ActTime<TransTimeFrom)
				Continue:(ActDate=TransDateTo)&&(ActTime>TransTimeTo)
			}
			else{				//报告	
				Continue:(RepDate<TransDateFrom)||(RepDate>TransDateTo)
				Continue:(RepDate=TransDateFrom)&&(RepTime<TransTimeFrom)
				Continue:(RepDate=TransDateTo)&&(RepTime>TransTimeTo)
			}
			Set LabInfo=$lb(xID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpecDesc,BacDesc,InfType)
				
			//转换转科日期格式
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set:TransTime'="" TransTime=$zt(TransTime)
			Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
			//存储转科基本信息
			Set TransInfo=$lb(xTransID,"","","",LocDesc,TransDateTime,OutLocDateTime)
			
			Set Data = $lb(BacDesc,AdmTimes)_PatData_TransInfo_LabInfo
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit
}

ClassMethod QryBactSpecDistDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactSpecDistDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactSpecDistDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactSpecDistDtlExecute ]
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

}
