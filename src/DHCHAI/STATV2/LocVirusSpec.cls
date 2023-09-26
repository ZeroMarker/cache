/// 名称: DHCHAI.STATV2.LocVirusSpe
/// 描述: 科室病毒阳性标本分布统计
/// 编写者: pylian
/// 编写日期: 2021-05-25
Class DHCHAI.STATV2.LocVirusSpec Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2022-06-15
/// Description:  科室病毒阳性标本分布统计
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aSpecID    : 标本字典ID
///               aStatNum   : 统计数量
///               aStatUnit  : 统计单位 1：病区2：科室
///               aVirusTest     : 病毒项目
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.LocVirusSpec","QryLocVirusSpec","","1","2020-03-01","2021-05-26","","5","1","","")
Query QryLocVirusSpec(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aVirusTest As %String, aLocID As %String) As %Query(ROWSPEC = "SortSum:%String,LocID:%String,LocDesc:%String,Spec:%String,SpecNum:%Integer,SpecSum:%Integer,SpecYNum:%Integer,SpecYNumSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryLocVirusSpecExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aVirusTest As %String, aLocID As %String) As %Status
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
    Set NIndex="QryLocVirusSpec"
    Set:aStatNum="" aStatNum=5
	//Set:aLocID="0" aLocID=""
	
	// Add by zhaoyj 2022-06-15 Global方式
	Set ItemID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-TestAb",0))
	Set ItemData=$g(^DHCHAI.IR.CCItmMastD(ItemID))
	Quit:ItemData="" $$$OK
	Set CCIsActive=$lg(ItemData,4)
	Quit:CCIsActive'=1 $$$OK
	Set ItemDr=ItemID
	
	Kill ^TMP($zn,$j,NIndex)
	
    //送检日期
    If aDateType=1{ // 接收日期时间索引
		Set xSCode =""
		For {
			Set xSCode=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode))
			Quit:xSCode=""
			
			For xDate = aDateFrom:1:aDateTo{		
				Set xTime = ""
				For {
					Set xTime = $o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode,xDate,xTime))
					Quit:xTime=""
					Set xVisitNumberDr=""
					For {
						Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode,xDate,xTime,xVisitNumberDr))
						Quit:xVisitNumberDr=""
						
						Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
						Continue:VisitData=""
						Set LabIsActive		=$lg(VisitData,18)
						Continue:LabIsActive'=1
		
						Do BuildVirusVisit(xVisitNumberDr)
					}
				}
			}
		}
	} Else { //报告日期
		For xDate = aDateFrom:1:aDateTo{		
			Set xTime = ""
			For {
				Set xTime = $o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime))
				Quit:xTime=""
				
				Set xReportDr=""
				For {
					Set xReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime,xReportDr))
					Quit:xReportDr=""
					
					Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xReportDr))
					Continue:LabReportData=""				
					Set VisitNumberDr = $lg(LabReportData,2)
					Set LabIsActive		=$lg(LabReportData,18)
					Continue:LabIsActive'=1
						
					Do BuildVirusVisit(VisitNumberDr)
	    
				}
			}
		}
	}
	
	// 标本数
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"SpecStat",xLocID))
		Quit:xLocID=""
		Set xSpec=""
		For {
			Set xSpec=$o(^TMP($zn,$j,NIndex,"SpecStat",xLocID,xSpec))
			Quit:xSpec=""
			
			Set SpecNum     = +$g(^TMP($zn,$j,NIndex,"SpecStat",xLocID,xSpec))    //送检标本数
			Set SpecSum     = +$g(^TMP($zn,$j,NIndex,"SpecStat",xLocID))          //送检总数
			Set SpecYNum    = +$g(^TMP($zn,$j,NIndex,"SpecStatY",xLocID,xSpec))   //阳性标本
			Set SpecYNumSum = +$g(^TMP($zn,$j,NIndex,"SpecStatYSum",xLocID))      //阳性总数
			Set LocDesc=""
			Set LocData  = $g(^DHCHAI.BT.LocationD(xLocID))
			Set:LocData'="" LocDesc  = $lg(LocData,3)
			Set:xLocID="0" LocDesc="全院"				
			Set Data = $lb(xLocID,LocDesc,xSpec,SpecNum,SpecSum,SpecYNum,SpecYNumSum)
			
			Set ^TMP($zn,$j,NIndex,"SpecYNum",xLocID,SpecYNum,xSpec)=Data
		}
	}
	// 输出 阳性标本数排序
	Set SortSum=0
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"SpecYNum",xLocID))
		Quit:xLocID=""
		Set Count=0
		Set SortSum=SortSum+1
		Set xSpecYNum=""
		For {
			Set xSpecYNum=$o(^TMP($zn,$j,NIndex,"SpecYNum",xLocID,xSpecYNum),-1)
			Quit:xSpecYNum=""
			Set xSpecimen=""
			For {
				Set xSpecimen=$o(^TMP($zn,$j,NIndex,"SpecYNum",xLocID,xSpecYNum,xSpecimen))
				Quit:xSpecimen=""
				
				Set Data = $g(^TMP($zn,$j,NIndex,"SpecYNum",xLocID,xSpecYNum,xSpecimen))
				Set Count=Count+1
				Continue:(aLocID'="")&(aLocID'=xLocID)
				
				Quit:Count>aStatNum
				Set ^CacheTemp(repid,ind)=$lb(SortSum)_Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildVirusVisit(xVisitNumberDr)

	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
	Quit:VisitNumberData=""
	Set EpisodeDr   = $lg(VisitNumberData,2)
	Set LabSpecimen = $lg(VisitNumberData,6)
	Set LabSCode    = $lg(VisitNumberData,14)
	Set CollDate    = $lg(VisitNumberData,8)
	Set CollTime    = $lg(VisitNumberData,9)
	Set RecDate     = $lg(VisitNumberData,11)
	Set RecTime     = $lg(VisitNumberData,12)
	Set:CollDate="" CollDate=RecDate
	Set:CollTime="" CollTime=RecTime

	Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
	Quit:SpecMapID=""
	Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
	Quit:SpecMapData=""
	Set BTMapItemDr = $lg(SpecMapData,3)
	Quit:BTMapItemDr=""
	Quit:(aSpecID'="")&&(aSpecID'=BTMapItemDr) //标本过滤
	Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))
	Set SpecDesc=""
	Set:SpecData'="" SpecDesc = $lg(SpecData,3)
	Set:SpecDesc'="" LabSpecimen=SpecDesc
    
	Set ActLocDr  = $lg(VisitNumberData,7)    // 送检科室
	Set LabWardDr  = $lg(VisitNumberData,19)  // 送检病区
	If (aStatUnit=1){ // 按照病区统计
		 Set ActLocDr=LabWardDr
		 If (ActLocDr=""){
		 	Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,CollDate,CollTime)
			Set ActLocDr = $p(TransInfo,"^",2)
		 }
	}
	Quit:ActLocDr=""
	Quit:(aLocID'="")&(aLocID'=0)&(aLocID'=ActLocDr)
	Set LabLocData  = $g(^DHCHAI.BT.LocationD(ActLocDr))
	Quit:LabLocData=""
	Set HospDr = $lg(LabLocData,8)
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
	
	Set VirusFlg =0          //生化免疫检测标志
	Set xTestSetDesc = ""
	For {
		Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
		Quit:xTestSetDesc=""
		Quit:VirusFlg=1 
		Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",LabSCode,xTestSetDesc,0))
		if (TestSetMapID'=""){
			Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
			Continue:TestSetMapData=""
			Continue:'$lg(TestSetMapData,7) 		//无效判断
			Set TSMapItemDr=$lg(TestSetMapData,4)
			Set TSMapItemData=""
			Set:TSMapItemDr'="" TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(TSMapItemDr))		
			If (TSMapItemData'="") {    //检验医嘱对照
				Continue:'$lg(TSMapItemData,5)	//无效判断
				Set MapTSCode=$lg(TSMapItemData,2)
				Continue:(aVirusTest'="")&((","_aVirusTest_",")'[(","_MapTSCode_","))
				Set MapTSDesc = $lg(TSMapItemData,3)
				Set TestSetCatDr = $lg(TSMapItemData,4)
				Set LabTestSetCatData=""
				Set:TestSetCatDr'="" LabTestSetCatData = $g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))
				If (LabTestSetCatData'="") {
					Set MapTSCatDesc=$lg(LabTestSetCatData,3)
					Set:MapTSCatDesc="生化免疫检测" VirusFlg =1   	//update 20211129  病毒支原体检测修改为生化免疫检测
				}	
			}				
		}
	}

	If (VirusFlg=0) {  //检查检验项目是否存在于检验结果中
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			Quit:VirusFlg=1
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Quit:xOrder=""
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				Quit:VirusFlg=1
				
				Set xTestCode=""
				For {
					Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
					Quit:xTestCode=""
					Quit:VirusFlg=1
				 
					Set xMapItemDr=0
					For {
						Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
						Quit:xMapItemDr=""
						
						Set TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
						Continue:TSMapItemData=""	  //检验医嘱对照
						Continue:'$lg(TSMapItemData,5)	//无效判断
						Set TestSet	= $lg(TSMapItemData,3)					
						Set MapTSCode=$lg(TSMapItemData,2)
						Continue:(aVirusTest'="")&((","_aVirusTest_",")'[(","_MapTSCode_","))					
						Set TestSetCatDr=$lg(TSMapItemData,4)
						Continue:TestSetCatDr=""
						Set TestSetCatData=$g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))				
						Continue:TestSetCatData=""
						Set MapTSCatDesc = $lg(TestSetCatData,3)
						Set:(MapTSCatDesc="生化免疫检测") VirusFlg=1  	//update 20211129  病毒支原体检测修改为生化免疫检测
						Quit														
					}
				}
			}
		}
	}
	Quit:VirusFlg=0	  //过滤非指定类型的送检

	Set IsAbFlag =0    //是否异常结果	
	Set xActDate=0
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:IsAbFlag=1

		Set xRstID=0
		For {
			Set xRstID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,ItemDr,xActDate,xRstID))
			Quit:xRstID=""
			Set RstData = $g(^DHCHAI.IR.CCResultD(xRstID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Continue:$lg(RstData,21)'=1
			Set LabResultID=$p($lg(RstData,19),"=",2)
			
			Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(LabResultID))
			Continue:RepRstData=""
			Set LabReportDr      = $lg(RepRstData,2)
			Continue:LabReportDr=""
			Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
			Continue:LabReportData=""
			Set LabVisitNumberDr = $lg(LabReportData,2)
			Continue:LabVisitNumberDr=""
			Set:LabVisitNumberDr=xVisitNumberDr IsAbFlag=1
		}
	}
	
								
	//送检数
  	Set num=$i(^TMP($zn,$j,NIndex,"SpecStat","0"))   //全院
	Set num=$i(^TMP($zn,$j,NIndex,"SpecStat",ActLocDr)) 
    
	//送检格标本数
  	Set num=$i(^TMP($zn,$j,NIndex,"SpecStat","0",LabSpecimen))   //全院
	Set num=$i(^TMP($zn,$j,NIndex,"SpecStat",ActLocDr,LabSpecimen)) 
	
	//送阳性数
	If (IsAbFlag=1){
		//阳性总数
		Set num=$i(^TMP($zn,$j,NIndex,"SpecStatYSum","0"))   //全院
		Set num=$i(^TMP($zn,$j,NIndex,"SpecStatYSum",ActLocDr))
	
	    //各阳性标本数
		Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY","0",LabSpecimen))  //全院
		Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY",ActLocDr,LabSpecimen)) 
	}
	
	Quit
}

ClassMethod QryLocVirusSpecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocVirusSpecExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocVirusSpecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocVirusSpecExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-06-15
/// Description:  科室病毒阳性标本分布统计数据明细
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aSpecID    : 标本字典ID
///               aStatNum   : 统计数量
///               aStatUnit  : 统计单位 1：病区2：科室
///               aLocID     : 科室/护理单元
///               aVirusTest : 病毒项目
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.LocVirusSpec","QryLocVirusSpecDtl","","1","2020-04-01","2021-05-26","","5","","","","1")
Query QryLocVirusSpecDtl(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aLocID As %String, aSpecDesc As %String = "", aVirusTest As %String, aAbFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,VisitNumberDr:%String,EpisodeNo:%String,RecDate:%String,RepDate:%String,LabSpecimen:%String,AbTestDescList:%String,VirusItem:%String,LabLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLocVirusSpecDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aLocID As %String, aSpecDesc As %String = "", aVirusTest As %String, aAbFlag As %String) As %Status
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
    Set NIndex="QryLocVirusSpecDtl"
    Set:aStatNum="" aStatNum=5
    Set:aLocID="0" aLocID=""
    
    // Add by zhaoyj 2022-06-15 Global方式
	Set ItemID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-TestAb",0))
	Set ItemData=$g(^DHCHAI.IR.CCItmMastD(ItemID))
	Quit:ItemData="" $$$OK
	Set CCIsActive=$lg(ItemData,4)
	Quit:CCIsActive'=1 $$$OK
	Set ItemDr=ItemID
	
	Kill ^TMP($zn,$j,NIndex)
    //送检日期
    If aDateType=1{ // 接收日期时间索引
		Set xSCode =""
		For {
			Set xSCode=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode))
			Quit:xSCode=""
			
			For xDate = aDateFrom:1:aDateTo{		
				Set xTime = ""
				For {
					Set xTime = $o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode,xDate,xTime))
					Quit:xTime=""
					Set xVisitNumberDr=""
					For {
						Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode,xDate,xTime,xVisitNumberDr))
						Quit:xVisitNumberDr=""
						
						Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
						Continue:VisitData=""
						Set LabIsActive		=$lg(VisitData,18)
						Continue:LabIsActive'=1
		
						Do BuildVirusDtl(xVisitNumberDr)
					}
				}
			}
		}
	} Else { //报告日期
		For xDate = aDateFrom:1:aDateTo{		
			Set xTime = ""
			For {
				Set xTime = $o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime))
				Quit:xTime=""
				
				Set xReportDr=""
				For {
					Set xReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime,xReportDr))
					Quit:xReportDr=""
					
					Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xReportDr))
					Continue:LabReportData=""				
					Set VisitNumberDr = $lg(LabReportData,2)
					Set LabIsActive		=$lg(VisitData,18)
					Continue:LabIsActive'=1
						
					Do BuildVirusDtl(VisitNumberDr)
	    
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildVirusDtl(xVisitNumberDr)
	
	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
	Quit:VisitNumberData=""
	Set EpisodeDr =$lg(VisitNumberData,2)
	Set EpisodeNo =$lg(VisitNumberData,3)
	Set LabSpecimen = $lg(VisitNumberData,6)
	Set LabSCode    = $lg(VisitNumberData,14)
	Set CollDate    = $lg(VisitNumberData,8)
	Set CollTime    = $lg(VisitNumberData,9)
	Set RecDate     = $lg(VisitNumberData,11)
	Set RecTime     = $lg(VisitNumberData,12)
	Set:CollDate="" CollDate=RecDate
	Set:CollTime="" CollTime=RecTime
	
	Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
	Quit:SpecMapID=""
	Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
	Quit:SpecMapData=""
	Set BTMapItemDr = $lg(SpecMapData,3)
	Quit:BTMapItemDr=""
	Quit:(aSpecID'="")&&(aSpecID'=BTMapItemDr) //标本过滤
	Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))
	Set SpecDesc=""
	Set:SpecData'="" SpecDesc = $lg(SpecData,3)
	Set:SpecDesc'="" LabSpecimen=SpecDesc
	Quit:(aSpecDesc'="")&&(aSpecDesc'=LabSpecimen)
	Set ActLocDr  = $lg(VisitNumberData,7)    // 送检科室
	Set LabWardDr  = $lg(VisitNumberData,19)  // 送检病区
	If (aStatUnit=1){ // 按照病区统计
		 Set ActLocDr=LabWardDr
		 If (ActLocDr=""){
		 	Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,CollDate,CollTime)
			Set ActLocDr = $p(TransInfo,"^",2)
		 }

	}
	Quit:ActLocDr=""
	Quit:(aLocID'="")&(aLocID'=ActLocDr)
	Set LabLocData  = $g(^DHCHAI.BT.LocationD(ActLocDr))
	Quit:LabLocData=""
	Set LabLocDesc  = $lg(LabLocData,4)
	Set HospDr = $lg(LabLocData,8)
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
	
	Set VirusFlg =0          //生化免疫检测标志
	Set VirusItem=""
	Set xTestSetDesc = ""
	For {
		Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
		Quit:xTestSetDesc=""
		Quit:VirusFlg=1 
		Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",LabSCode,xTestSetDesc,0))
		if (TestSetMapID'=""){
			Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
			Continue:TestSetMapData=""
			Continue:'$lg(TestSetMapData,7) 		//无效判断
			Set TSMapItemDr=$lg(TestSetMapData,4)
			Set TSMapItemData=""
			Set:TSMapItemDr'="" TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(TSMapItemDr))		
			If (TSMapItemData'="") {    //检验医嘱对照
				Continue:'$lg(TSMapItemData,5)	//无效判断
				Set MapTSCode=$lg(TSMapItemData,2)
				Continue:(aVirusTest'="")&((","_aVirusTest_",")'[(","_MapTSCode_","))
				Set MapTSDesc = $lg(TSMapItemData,3)
				Set VirusItem = MapTSDesc
				Set TestSetCatDr = $lg(TSMapItemData,4)
				Set LabTestSetCatData=""
				Set:TestSetCatDr'="" LabTestSetCatData = $g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))
				If (LabTestSetCatData'="") {
					Set MapTSCatDesc=$lg(LabTestSetCatData,3)
					Set:MapTSCatDesc="生化免疫检测" VirusFlg =1  	//update 20211129  病毒支原体检测修改为生化免疫检测
				}	
			}				
		}
	}

	If (VirusFlg=0) {  //检查检验项目是否存在于检验结果中
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			Quit:VirusFlg=1
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Quit:xOrder=""
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				Quit:VirusFlg=1
				
				Set xTestCode=""
				For {
					Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
					Quit:xTestCode=""
					Quit:VirusFlg=1
				 
					Set xMapItemDr=0
					For {
						Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
						Quit:xMapItemDr=""
						
						Set TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
						Continue:TSMapItemData=""	  //检验医嘱对照
						Continue:'$lg(TSMapItemData,5)	//无效判断
						Set TestSet	= $lg(TSMapItemData,3)					
						Set VirusItem = TestSet				
						Set MapTSCode=$lg(TSMapItemData,2)
						Continue:(aVirusTest'="")&((","_aVirusTest_",")'[(","_MapTSCode_","))					
						Set TestSetCatDr=$lg(TSMapItemData,4)
						Continue:TestSetCatDr=""
						Set TestSetCatData=$g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))				
						Continue:TestSetCatData=""
						Set MapTSCatDesc = $lg(TestSetCatData,3)
						Set:(MapTSCatDesc="生化免疫检测") VirusFlg=1   	//update 20211129  病毒支原体检测修改为生化免疫检测
						Quit														
					}
				}
			}
		}
	}
	Quit:VirusFlg=0	  //过滤非指定类型的送检
    
	Set IsAbFlag =0    //是否异常结果	
	Set AbTestDescList=""
	Set xActDate=0
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:IsAbFlag=1

		Set xRstID=0
		For {
			Set xRstID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,ItemDr,xActDate,xRstID))
			Quit:xRstID=""
			Set RstData = $g(^DHCHAI.IR.CCResultD(xRstID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Continue:$lg(RstData,21)'=1
			Set LabResultID=$p($lg(RstData,19),"=",2)
				
			Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(LabResultID))
			Continue:RepRstData=""
			Set LabReportDr      = $lg(RepRstData,2)
			Set TestDesc         = $lg(RepRstData,3)
			Continue:LabReportDr=""
			Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
			Continue:LabReportData=""
			Set LabVisitNumberDr = $lg(LabReportData,2)
			Continue:LabVisitNumberDr=""
			Set:LabVisitNumberDr=xVisitNumberDr IsAbFlag=1
			
			If (IsAbFlag=1) {
				Set AbTestDescList=AbTestDescList_","_TestDesc	
			}		
		}
	}	
	Set:AbTestDescList'="" AbTestDescList=$e(AbTestDescList,2,$l(AbTestDescList))	
	Quit:(aAbFlag'="")&&(aAbFlag'=IsAbFlag)
	Set RepDate =""
	Set xTestSetDr=""
	For {
		Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
		Quit:xTestSetDr=""
	    Quit:RepDate'=""
	    
		//最新检验报告
		Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
		Quit:xOrder=""
		Set xVisitReportDr=0
		For {
			Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
			Quit:xVisitReportDr=""
			
			Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xVisitReportDr))
			Continue:LabReportData=""
			Set RepDate = $lg(LabReportData,10)
			Quit:RepDate'=""
		}
	}
	//患者转科基本信息
	Set PatData =..BuildPaadmData(EpisodeDr)
	Quit:PatData=""
	Set:RecDate'="" RecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RecDate)
	Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		
	Set ^CacheTemp(repid,ind)=PatData_$lb(xVisitNumberDr,EpisodeNo,RecDate,RepDate,LabSpecimen,AbTestDescList,VirusItem,LabLocDesc)
	Set ind=ind+1
	
	Quit
}

ClassMethod QryLocVirusSpecDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocVirusSpecDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocVirusSpecDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocVirusSpecDtlExecute ]
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
