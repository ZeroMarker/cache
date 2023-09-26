/// 名称: DHCHAI.STAS.MonthStat
/// 描述: 院感月报表导出相关服务
/// 编写者: zhoubo
/// 编写日期: 2021-11-16
Class DHCHAI.STAS.MonthStat Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-11-25
/// Description:  细菌分布统计
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
/// 			  aBactType  : 细菌类型1：革兰阳性菌2：革兰阴性菌 空：所有
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.MonthStat","QryBactG","1|2","2017-10-02","2021-11-12","")
Query QryBactG(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aBactType As %String) As %Query(ROWSPEC = "BactDesc:%String,BactSum:%String,BactRatio:%String") [ SqlProc ]
{
}

ClassMethod QryBactGExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aBactType As %String) As %Status
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
    Set NIndex="QryBactG"
    
	Kill ^TMP($zn,$j,NIndex)
    
    Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
		Quit:xItemID=""
		Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
		Continue:ItemData=""
		Set ItemCode = $li(ItemData,2)
		Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
			Quit:xDate=""
			Quit:(xDate>aDateTo)
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
				Quit:xID=""
				Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
				Continue:RstData=""
				Continue:$lg(RstData,14)'=1
				Set EpisodeDr = $lg(RstData,2)
				Continue:EpisodeDr=""
				Set ActDate=$lg(RstData,8)
				Set ActTime=$lg(RstData,9)
				// 采集病区
			    Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
			   	Set LocDr  = $p(LocWardInfo,"^",1) // 科室
				Set WardDr = $p(LocWardInfo,"^",2) // 病区
				Continue:LocDr=""
				Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				Continue:LocData=""
				Set HospDr=$li(LocData,8)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
				
				Set SCode    = $lg(RstData,17)    // 子系统代码
				Set Bacteria = $lg(RstData,23)    // 原始细菌名称
		        Continue:Bacteria=""
		     	Set BactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,0))
				Continue:BactMapID=""
				Set BactMapData = $g(^DHCHAI.DP.LabBactMapD(BactMapID))
				Set BacID = $lg(BactMapData,3)
				Continue:BacID=""
				Set BactData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Continue:BactData=""
				Set BacCode = $li(BactData,2)
				Set BacDesc = $li(BactData,3)
				
				Set BacTypeCode="",BacTypeDesc=""
				Set BacTypeDr=$List(BactData,5)
				If (BacTypeDr'=""){
					Set TypeInfo = $g(^DHCHAI.DP.LabBactTypeD(BacTypeDr))
					If TypeInfo'="" {
						Set BacTypeCode = $List(TypeInfo,2)
						Set BacTypeDesc = $List(TypeInfo,3)
					}
				}
				If (aBactType=1){
					Continue:BacTypeCode'="+"
				}ElseIf (aBactType=2){
					Continue:BacTypeCode'="-"
				}Else{}
				Set num=$i(^TMP($zn,$j,NIndex,"BactStatNum","全院"))
				Set num=$i(^TMP($zn,$j,NIndex,"BactStatNum",BacDesc))
			}
		}
	}
     // 检出菌株数排序
	Set xBact=""
	For {
		Set xBact=$o(^TMP($zn,$j,NIndex,"BactStatNum",xBact))
		Quit:xBact=""
		Set BactSum = +$g(^TMP($zn,$j,NIndex,"BactStatNum",xBact))
		Set ^TMP($zn,$j,NIndex,"BactSortNum",BactSum,xBact)=""
	}
	Set BactAllSum=+$g(^TMP($zn,$j,NIndex,"BactStatNum","全院"))
    // 输出
	Set xNum=""
	For {
		Set xNum=$o(^TMP($zn,$j,NIndex,"BactSortNum",xNum),-1)
		Quit:xNum=""
		
		Set xBact=""
		For {
			Set xBact=$o(^TMP($zn,$j,NIndex,"BactSortNum",xNum,xBact))
			Quit:xBact=""
			Continue:(xBact="全院")
			Set BactDesc = xBact   // 细菌名称
			Set BactSum  = xNum    // 检出细菌数
			Set BactRatio="0.00%"  // 构成比
			Set:BactAllSum>0 BactRatio=$fn((BactSum/BactAllSum)*100,"",2)_"%"
			
			Set ^CacheTemp(repid,ind)=$lb(BactDesc,BactSum,BactRatio)
			Set ind=ind+1
		}
	}
	Set xNum=""
	For {
		Set xNum=$o(^TMP($zn,$j,NIndex,"BactSortNum",xNum),-1)
		Quit:xNum=""
		
		Set xBact=""
		For {
			Set xBact=$o(^TMP($zn,$j,NIndex,"BactSortNum",xNum,xBact))
			Quit:xBact=""
			Continue:(xBact'="全院")
			Set BactDesc = xBact   // 细菌名称
			Set BactSum  = xNum    // 检出细菌数
			Set BactRatio="0.00%"  // 构成比
			Set:BactAllSum>0 BactRatio=$fn((BactSum/BactAllSum)*100,"",2)_"%"
			
			Set ^CacheTemp(repid,ind)=$lb(BactDesc,BactSum,BactRatio)
			Set ind=ind+1
			Quit   // 只需要统计第一条数据即全院数据
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryBactGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactGExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactGExecute ]
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
/// CreatDate：   2021-11-24
/// Description:  标本分布统计
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aStatNum   : 统计数量
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.MonthStat","QryLocSpecDist","1|2","2017-10-02","2021-11-12","")
Query QryLocSpecDist(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStatNum As %String) As %Query(ROWSPEC = "xSpec:%String,SpecSum:%Integer,TQSpecSum:%Integer,AddRatio:%String,SpecYNum:%Integer,TQYSpecSum:%Integer,PosiRatio:%String,TQPosiRatio:%String,SpecBact1:%String,SpecBact2:%String,SpecBact3:%String,SpecBact4:%String,SpecBact5:%String,BactSumNub:%String") [ SqlProc ]
{
}

ClassMethod QryLocSpecDistExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStatNum As %String) As %Status
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
    Set NIndex="QryLocSpecDist"
    
	Kill ^TMP($zn,$j,NIndex)
    Set TQFlag=0
    Set SCode="LIS01"
    // 计算标本送检数量
	Do BuildData
	// 计算标本同期送检数量
	Set aDateFrom=$zd(aDateFrom,3)
	Set aDateFrom=((+aDateFrom)-1)_$e(aDateFrom,5,$l(aDateFrom))
	Set aDateFrom=$zdh(aDateFrom,3)
	Set aDateTo=$zd(aDateTo,3)
	Set aDateTo=((+aDateTo)-1)_$e(aDateTo,5,$l(aDateTo))
	Set aDateTo=$zdh(aDateTo,3)
	Set TQFlag=1
	Do BuildData
	
	//标本检出菌排序
	Set xSpec=""
	For {
		Set xSpec=$o(^TMP($zn,$j,NIndex,"SpecBactSum",xSpec))
		Quit:xSpec=""
		Set SpecBactASum = +$g(^TMP($zn,$j,NIndex,"SpecBactSum",xSpec))
		Set xBacteria=""
		For {
			Set xBacteria=$o(^TMP($zn,$j,NIndex,"SpecBactSum",xSpec,xBacteria))
			Quit:xBacteria=""
			Set SpecBactSum = +$g(^TMP($zn,$j,NIndex,"SpecBactSum",xSpec,xBacteria))
			Set SpecBactRatio="0.00%"  // 检出菌占比
			Set:SpecBactASum>0 SpecBactRatio=$fn((SpecBactSum/SpecBactASum)*100,"",2)_"%"
			Set Data = $lb(xBacteria,SpecBactSum,SpecBactRatio)
			
			Set ^TMP($zn,$j,NIndex,"SpecBactStat",xSpec,SpecBactSum)=Data
		}
	}
								
    // 标本数排序
	Set xSpec=""
	For {
		Set xSpec=$o(^TMP($zn,$j,NIndex,"SpecStatSum",xSpec))
		Quit:xSpec=""
		Set SpecSum = +$g(^TMP($zn,$j,NIndex,"SpecStatSum",xSpec))
		Set Data = $lb(xSpec,SpecSum)
		Set ^TMP($zn,$j,NIndex,"SpecSortNum",SpecSum,xSpec)=Data
	}
    // 输出
	Set Count=0
	Set xSpecNum=""
	For {
		Set xSpecNum=$o(^TMP($zn,$j,NIndex,"SpecSortNum",xSpecNum),-1)
		Quit:xSpecNum=""
		
		Set xSpec=""
		For {
			Set xSpec=$o(^TMP($zn,$j,NIndex,"SpecSortNum",xSpecNum,xSpec))
			Quit:xSpec=""
			Continue:(xSpec="全院")
			Set Data = $g(^TMP($zn,$j,NIndex,"SpecSortNum",xSpecNum,xSpec))
			Set TQSpecSum = +$g(^TMP($zn,$j,NIndex,"SpecStatSumTQ",xSpec))
			Set AddRatio="0.00%"
			Set:TQSpecSum>0 AddRatio=$fn(((+xSpecNum-TQSpecSum)/TQSpecSum)*100,"",2)_"%"
			
			Set TQYSpecSum = +$g(^TMP($zn,$j,NIndex,"SpecStatSumTQY",xSpec)) // 同期阳性标本例数
			Set SpecYNum   = +$g(^TMP($zn,$j,NIndex,"SpecStatSumY",xSpec))   // 阳性标本例数
			Set PosiRatio="0.00%"  // 阳性率
			Set:+xSpecNum>0 PosiRatio=$fn((SpecYNum/(+xSpecNum))*100,"",2)_"%"
			Set TQPosiRatio="0.00%"  // 同期阳性率
			Set:TQSpecSum>0 TQPosiRatio=$fn((TQYSpecSum/TQSpecSum)*100,"",2)_"%"
			
			//标本检出菌输出前五 
			Set BactSumNub=+$g(^TMP($zn,$j,NIndex,"SpecBactSum",xSpec))  // 菌株总数
			// 标本检出菌占比排位前五第①位
			Set SpecBact1="",SpecBact2="",SpecBact3="",SpecBact4="",SpecBact5=""
			Set xSpecBactNum="",BactCnt=0
			For {
				Set xSpecBactNum=$o(^TMP($zn,$j,NIndex,"SpecBactStat",xSpec,xSpecBactNum),-1)
				Quit:xSpecBactNum=""
				Set DataInfo = $g(^TMP($zn,$j,NIndex,"SpecBactStat",xSpec,xSpecBactNum))
				Set Bacteria = $li(DataInfo,1)
				Set SpecBactSum = $li(DataInfo,2)
				Set SpecBactRatio = $li(DataInfo,3)
				Set BactCnt=BactCnt+1
				Set Expxer="Set SpecBact"_BactCnt_"="""_Bacteria_":例数"_SpecBactSum_",占比："_SpecBactRatio_""""
				X Expxer
				Quit:BactCnt>5
			}
			Set Count=Count+1
			
			Quit:((+aStatNum)>0)&&(Count>(+aStatNum))
			Set ^CacheTemp(repid,ind)=Data_$lb(TQSpecSum,AddRatio,SpecYNum,TQYSpecSum,PosiRatio,TQPosiRatio,SpecBact1,SpecBact2,SpecBact3,SpecBact4,SpecBact5,BactSumNub)
			Set ind=ind+1
		}
	}
    Set xSpecNum=""
	For {
		Set xSpecNum=$o(^TMP($zn,$j,NIndex,"SpecSortNum",xSpecNum),-1)
		Quit:xSpecNum=""
		
		Set xSpec=""
		For {
			Set xSpec=$o(^TMP($zn,$j,NIndex,"SpecSortNum",xSpecNum,xSpec))
			Quit:xSpec=""
			Continue:(xSpec'="全院")
			Set Data = $g(^TMP($zn,$j,NIndex,"SpecSortNum",xSpecNum,xSpec))
			Set TQSpecSum = +$g(^TMP($zn,$j,NIndex,"SpecStatSumTQ",xSpec))
			Set AddRatio="0.00%"
			Set:TQSpecSum>0 AddRatio=$fn(((+xSpecNum-TQSpecSum)/TQSpecSum)*100,"",2)_"%"
			
			Set TQYSpecSum = +$g(^TMP($zn,$j,NIndex,"SpecStatSumTQY",xSpec)) // 同期阳性标本例数
			Set SpecYNum   = +$g(^TMP($zn,$j,NIndex,"SpecStatSumY",xSpec))   // 阳性标本例数
			Set PosiRatio="0.00%"  // 阳性率
			Set:+xSpecNum>0 PosiRatio=$fn((SpecYNum/(+xSpecNum))*100,"",2)_"%"
			Set TQPosiRatio="0.00%"  // 同期阳性率
			Set:TQSpecSum>0 TQPosiRatio=$fn((TQYSpecSum/TQSpecSum)*100,"",2)_"%"
			
			//标本检出菌输出前五 
			Set BactSumNub=+$g(^TMP($zn,$j,NIndex,"SpecBactSum",xSpec))  // 菌株总数
			// 标本检出菌占比排位前五第①位
			Set SpecBact1="",SpecBact2="",SpecBact3="",SpecBact4="",SpecBact5=""
			Set xSpecBactNum="",BactCnt=0
			For {
				Set xSpecBactNum=$o(^TMP($zn,$j,NIndex,"SpecBactStat",xSpec,xSpecBactNum),-1)
				Quit:xSpecBactNum=""
				Set DataInfo = $g(^TMP($zn,$j,NIndex,"SpecBactStat",xSpec,xSpecBactNum))
				Set Bacteria = $li(DataInfo,1)
				Set SpecBactSum = $li(DataInfo,2)
				Set SpecBactRatio = $li(DataInfo,3)
				Set BactCnt=BactCnt+1
				Set Expxer="Set SpecBact"_BactCnt_"="""_Bacteria_":例数"_SpecBactSum_",占比："_SpecBactRatio_""""
				X Expxer
				Quit:BactCnt>5
			}
			
			Set ^CacheTemp(repid,ind)=Data_$lb(TQSpecSum,AddRatio,SpecYNum,TQYSpecSum,PosiRatio,TQPosiRatio,SpecBact1,SpecBact2,SpecBact3,SpecBact4,SpecBact5,BactSumNub)
			Set ind=ind+1
			Quit
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
	
BuildData
	For xDate = aDateFrom:1:aDateTo{
		Set xTime = ""
		For {
			Set xTime = $o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," "_SCode,xDate,xTime))
			Quit:xTime=""
			Set xVisitNumberDr=""
			For {
				Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," "_SCode,xDate,xTime,xVisitNumberDr))
				Quit:xVisitNumberDr=""
				
				Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
				Continue:VisitData=""
				Set LabIsActive = $li(VisitData,18)
				Continue:LabIsActive'=1
				
				Set LabLocDr = $li(VisitData,7)
				Continue:LabLocDr=""
				Set LocData = $g(^DHCHAI.BT.LocationD(LabLocDr))
				Continue:LocData=""
				Set HospDr=$li(LocData,8)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	 
				
				Set LabSpecimen = $li(VisitData,6)  // 后期看是否按照对照后的标本去统计
				If (TQFlag=1){
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSumTQ","全院"))
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSumTQ",LabSpecimen))
				}Else{
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSum","全院"))
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSum",LabSpecimen))
				}
				//阳性标本
				Set xxDate=""
				For {
					Set xxDate=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitAuthDateTime",xVisitNumberDr,xxDate))
					Quit:xxDate=""
					
					Set xxTime=0
					For {
						Set xxTime=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitAuthDateTime",xVisitNumberDr,xxDate,xxTime))
						Quit:xxTime=""
						
						Set xRepID=0
						For {
							Set xRepID=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitAuthDateTime",xVisitNumberDr,xxDate,xxTime,xRepID))
							Quit:xRepID=""
							Set RepData=$g(^DHCHAI.DP.LabVisitReportD(xRepID))
							Set IsActive=$li(RepData,18)
							Continue:IsActive'=1
							
							Set LabTestSetDr=$li(RepData,13)
							Continue:LabTestSetDr=""
							Set TestData=$g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetDr))
							Continue:TestData=""
							Set TestSetDesc=$li(TestData,3)
							
							Set TestSetDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetDesc)  //去掉特殊字符
							Continue:TestSetDesc=""
							Set TestMapDr=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,TestSetDesc,0))
							Continue:TestMapDr=""
							Set MapData=$g(^DHCHAI.DP.LabTestSetMapD(TestMapDr))
							Continue:MapData=""
							Set BTMapItemDr = $li(MapData,4)
							Continue:BTMapItemDr=""
							Set TestSetData=$g(^DHCHAI.DP.LabTestSetD(BTMapItemDr))
							Continue:TestSetData=""
							Set BTCatDr=$li(TestSetData,4)
							Continue:BTCatDr=""
							set SetCatData=$g(^DHCHAI.DP.LabTestSetCatD(BTCatDr))
							Continue:SetCatData=""
							Set MapTSCatDesc=$li(SetCatData,3)
							Continue:MapTSCatDesc'="微生物送检"
							
							Set xRstID=0
							For {
								Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xRepID,xRstID))
								Quit:xRstID=""
								
								Set RstData=$g(^DHCHAI.DP.LabVisitRepResultD(xRstID))
								Continue:RstData=""
						
								Set TestCode=$li(RstData,4)
								Continue:TestCode=""
								Set TestDesc=$li(RstData,3)
								Set RstFormat=$li(RstData,5)
								Continue:RstFormat=""
								Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
								Continue:MapRstFormat=""
								Continue:MapRstFormat'="M"
								Set Bacteria=$li(RstData,6)
								Continue:Bacteria=""
								
								If (TQFlag=1){
									Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSumTQY","全院"))
									Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSumTQY",LabSpecimen))
								}Else{
									//标本检出菌总数
									Set num=$i(^TMP($zn,$j,NIndex,"SpecBactSum","全院"))
									Set num=$i(^TMP($zn,$j,NIndex,"SpecBactSum","全院",Bacteria))
									Set num=$i(^TMP($zn,$j,NIndex,"SpecBactSum",LabSpecimen))
									Set num=$i(^TMP($zn,$j,NIndex,"SpecBactSum",LabSpecimen,Bacteria))
									
									Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSumY","全院"))
									Set num=$i(^TMP($zn,$j,NIndex,"SpecStatSumY",LabSpecimen))
								}
							}
							
						}
					}
				}
			}
		}
	}
	Quit
}

ClassMethod QryLocSpecDistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocSpecDistExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocSpecDistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocSpecDistExecute ]
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
/// CreatDate：   2021-11-16
/// Description:  院感月报表导出列（按照科室/病区）统计数据项
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aLocDr ：  科室病区ID
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.MonthStat","QryMonthStat","1","2021-11-01","2021-11-19","W","")
Query QryMonthStat(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocDr As %String) As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,InDaysCnt:%String,AvgInDays:%String,InfPatCnt:%String,InfCaseCnt:%String,InfPatRatio:%String,InfCaseRatio:%String,DayInfPatRatio:%String,DayInfCaseRatio:%String,InfPosCase1Cnt:%String,InfPosCase2Cnt:%String,InfPosCase3Cnt:%String,InfPosCase4Cnt,InfPosCase5Cnt,InfPosCase6Cnt,InfPosCase7Cnt,InfPosCase8Cnt,InfPosCase9Cnt,InfPosCase10Cnt,InfPosCase11Cnt,InfPosCase12Cnt,InfPosCase13Cnt,InfPosCase14Cnt,InfPosCase15Cnt,InfPosCase16Cnt,InfPosCase17Cnt,InfPosCase18Cnt,InfPosCase19Cnt,InfPosCase20Cnt,InfPosCase21Cnt,InfPosCase22Cnt,InfPosCase23Cnt,InfPosCase24Cnt,InfPosCase25Cnt,InfPosCase26Cnt,InfPosCase27Cnt,InfPosCase28Cnt,InfPosCase29Cnt,InfPosCase30Cnt,InfPosCase31Cnt,InfPosCase32Cnt,InfPosCase33Cnt,InfPosCase34Cnt,InfPosCase35Cnt,InfPosCase36Cnt,InfPosCase37Cnt,InfPosCase38Cnt,InfPosCase39Cnt,InfPosCase40Cnt,InfPosCase41Cnt,InfPosCase42Cnt,InfPosCase43Cnt,OperCaseCnt,OperInfCnt,OperCase1Cnt,OperInf1Cnt,OperCase1Ratio,OperCase2Cnt,OperInf2Cnt,OperCase2Ratio,OperCase3Cnt,OperInf3Cnt,OperCase3Ratio,OperCase4Cnt,OperInf4Cnt,OperCase4Ratio,OperCaseRatio,MissPatCnt,MissCaseCnt,MissRatio,ICUFlag,AvgSeverity,AdjuInfPatRatio,AdjuInfCaseRatio,AdjuDayInfPatRatio,AdjuDayInfCaseRatio,VAPPatCnt,VAPUseDay,VAPUseRatio,VAPInfCaseCnt,VAPInfRatio,UCPatCnt,UCUseDay,UCUseRatio,UCInfCaseCnt,UCInfRatio,PICCPatCnt,PICCUseDay,PICCUseRatio,PICCInfCaseCnt,PICCInfRatio,ICUUseDays,ICUUseRatio") [ SqlProc ]
{
}

ClassMethod QryMonthStatExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	Set StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
   	Set:StatType'="W" StatType="E"  //不是病区就是科室
   	
    Set NIndex="QryMonthStat"
	Kill ^TMP($zn,$j,NIndex)
	
    //同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,aLocDr,"I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		// 统计各数据项
		// 获取感染,手术信息
		Set OperInfos=""
		Set InfPosDescs=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","AdmPat",Paadm)) // 避免重复取重复病人
		{
			Set ^TMP($zn,$j,NIndex,"Hosp","AdmPat",Paadm)=""
			Set InfPosDescs =..GetInfPosInfo(Paadm,aDateFrom,aDateTo)
			if (InfPosDescs'="") {
				for InfNo=1:1:$L(InfPosDescs,"|") {
					Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
					continue:InfPosMsg=""
					Set DiagID	 = $p(InfPosMsg,"^",1)
					Set DiagDesc = $p(InfPosMsg,"^",2)
					Set InfDate	 = $p(InfPosMsg,"^",3)
					Set InfType	 = $p(InfPosMsg,"^",7)
					Set RepDate  = $p(InfPosMsg,"^",9)
					Continue:InfType="社区感染"
					
					Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,DiagID)=DiagDesc
					//1.漏报报告院感科代报
					Set ReplaceFlag= $p(InfPosMsg,"^",10)		//代报
					If (ReplaceFlag="1"){
						Set ^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm,InfDate,DiagID)=""	
					}
					//2.患者出院后补报(剔除手术部位感染)
					Set DischDate=$li(^DHCHAI.DP.PAAdmD(Paadm),26)
					If ((DischDate'="")&&(RepDate>DischDate)){
						Continue:((DiagDesc="表浅手术切口感染")||((DiagDesc="深部手术切口感染"))||((DiagDesc="器官和腔隙感染")))
						Set ^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm,InfDate,DiagID)=""	
					}
				}
			}
			Set OperInfos =..GetOperInfo(Paadm,aDateFrom,aDateTo)
			if (OperInfos'="") {
				for InfNo=1:1:$L(OperInfos,"|") {
					Set InfOpMsg=$p(OperInfos,"|",InfNo)
					continue:InfOpMsg=""
					Set AnaeID	 = $p(InfOpMsg,"^",1)
					Set OperDesc = $p(InfOpMsg,"^",2)
					Set OperDate = +$p(InfOpMsg,"^",3)
					Set MapIncDicDesc = $p(InfOpMsg,"^",4)
					Set OperLocDr = $p(InfOpMsg,"^",5)
					Set IsInfOper = $p(InfOpMsg,"^",7)
					Continue:AnaeID=""
					
					Set ^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate,AnaeID)=OperDesc_"^"_MapIncDicDesc_"^"_IsInfOper_"^"_OperLocDr
				}
			}
		}
		//统计维度
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		Continue:StatDimensInfo=""
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			// 全院住院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			//同期在科天数
			Set ^TMP($zn,$j,NIndex,DimensKey,"InDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"InDays"))+$l(TransDates,",") 
			
			//如果该次就诊有手术信息，通过手术日期判断该次在科是否手术
			if ($o(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,""))'="") {
				if '$d(^TMP($zn,$j,NIndex,DimensKey,"OperPat",Paadm)) {
					if (DimensKey["A"){ //统计全院不判断转科,例次数直接累加
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperPat"))  //记录手术人数
						Set ^TMP($zn,$j,NIndex,DimensKey,"OperPat",Paadm)=""
						Set OperDate=""
						for {
							Set OperDate=$o(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate))
							Quit:OperDate=""
							Set xOperID=""
							for {
								Set xOperID=$o(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate,xOperID))
								Quit:xOperID=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase"))  //记录手术例次数
								Set tmpOperInfo = $g(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate,xOperID))
								Continue:tmpOperInfo=""
								Set OperDesc      =$p(tmpOperInfo,"^",1)
								Set MapIncDicDesc =$p(tmpOperInfo,"^",2)
								Set IsInfOper     =$p(tmpOperInfo,"^",3)
								If (IsInfOper=1){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase"))  //手术部位感染例次数
								}
								If (MapIncDicDesc["Ⅰ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase1"))  //I类切口手术例次数
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase1"))  //I类切口手术例次数
								}
								If (MapIncDicDesc["Ⅱ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase2"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase2"))
								}
								If (MapIncDicDesc["Ⅲ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase3"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase3"))
								}
								If (MapIncDicDesc["Ⅳ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase4"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase4"))
								}
							}
						}
					}ElseIf ((DimensKey["H")||(DimensKey["G")){  //统计院区+科室组(处理跨院区转科/跨科室组转科问题)
						Set OperDate=""
						For {
							Set OperDate=$o(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate))
							Quit:OperDate=""
							Set xOperID=""
							for {
								Set xOperID=$o(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate,xOperID))
								Quit:xOperID=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase"))  //记录手术例次数
								Set tmpOperInfo = $g(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate,xOperID))
								Continue:tmpOperInfo=""
								Set OperDesc      =$p(tmpOperInfo,"^",1)
								Set MapIncDicDesc =$p(tmpOperInfo,"^",2)
								Set IsInfOper     =$p(tmpOperInfo,"^",3)
								Set OperLocDr     =$p(tmpOperInfo,"^",4)
								Continue:OperLocDr=""
								Set LocData = $g(^DHCHAI.BT.LocationD(OperLocDr))
								Set OperHospDr   = $li(LocData,8)
								Set OperGroupDr  = $li(LocData,7)
								If OperHospDr="" {	
									Set OperHospDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
								}
								Continue:(OperHospDr'=HospDr)		//过滤非本院区
								Continue:(OperGroupDr'=GroupDr)	    //过滤非本科室组
								
								If (IsInfOper=1){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase"))  //手术部位感染例次数
								}
								If (MapIncDicDesc["Ⅰ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase1"))  //I类切口手术例次数
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase1"))  //I类切口手术例次数
								}
								If (MapIncDicDesc["Ⅱ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase2"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase2"))
								}
								If (MapIncDicDesc["Ⅲ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase3"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase3"))
								}
								If (MapIncDicDesc["Ⅳ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase4"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase4"))
								}
							}
						}
					} Else{ //科室-病区的手术人数需要判断转科日期，计算到手术科室（科别）
						Set OperDate=""
						for {
							Set OperDate=$o(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate))
							Quit:OperDate=""
							Continue:(","_TransDates_",")'[(","_OperDate_",")
							Set xOperID=""
							for {
								Set xOperID=$o(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate,xOperID))
								Quit:xOperID=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase"))  //记录手术例次数
								Set tmpOperInfo = $g(^TMP($zn,$j,NIndex,"Hosp","OperFlg",Paadm,OperDate,xOperID))
								Continue:tmpOperInfo=""
								Set OperDesc      =$p(tmpOperInfo,"^",1)
								Set MapIncDicDesc =$p(tmpOperInfo,"^",2)
								Set IsInfOper     =$p(tmpOperInfo,"^",3)
								Set OperLocDr     =$p(tmpOperInfo,"^",4)
								Continue:OperLocDr=""
								Set LocData = $g(^DHCHAI.BT.LocationD(OperLocDr))
								Set OperHospDr   = $li(LocData,8)
								Set OperGroupDr  = $li(LocData,7)
								If OperHospDr="" {	
									Set OperHospDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
								}
								Continue:(OperHospDr'=HospDr)		//过滤非本院区
								Continue:(OperGroupDr'=GroupDr)	    //过滤非本科室组
								
								If (IsInfOper=1){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase"))  //手术部位感染例次数
								}
								If (MapIncDicDesc["Ⅰ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase1"))  //I类切口手术例次数
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase1"))  //I类切口手术例次数
								}
								If (MapIncDicDesc["Ⅱ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase2"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase2"))
								}
								If (MapIncDicDesc["Ⅲ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase3"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase3"))
								}
								If (MapIncDicDesc["Ⅳ"){
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperCase4"))
									Set:IsInfOper=1 num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperInfCase4"))
								}
							}
						}
					}
				}
			}
			//如果该次就诊有感染信息，通过感染日期判断该次在科是否感染
			if ($o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,""))'="") {
				if '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
					if (DimensKey["A"){ //统计全院不判断转科,例次数直接累加
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))  //记录感染人数
						//漏报人数
						If ($d(^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm))) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfMissPat"))	
						}	
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
						Set InfDate=""
						for {
							Set InfDate=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate))
							Quit:InfDate=""
							Set xDiagID=""
							for {
								Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Quit:xDiagID=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))  //记录感染例次数
								//漏报例次数
								If ($d(^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm,InfDate,xDiagID))) {
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfMissCase"))	
								}
								Set tmpDiagDesc = $g(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Continue:tmpDiagDesc=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPosCase",tmpDiagDesc))  //记录感染部位例次数
							}
						}
					}ElseIf ((DimensKey["H")||(DimensKey["G")){  //统计院区+科室组(处理跨院区转科/跨科室组转科问题)
						Set InfDate=""
						For {
							Set InfDate=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate))
							Quit:InfDate=""
							Set xDiagID=""
							for {
								Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Quit:xDiagID=""
								Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
								Continue:'$IsObject(objDiags)
								//感染科室(报告填写)
								Set IRInfLocDr=objDiags.IRInfLocDr
								If (($IsObject(IRInfLocDr))&&(TransType="E")){
									Set IRInfHospDr  = IRInfLocDr.BTHospDr.%Id()
									Set IRInfGroupDr = IRInfLocDr.BTGroupDr.%Id()
								}Else{	//根据感染日期判断
									Set AdmTransData=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(Paadm,InfDate,"")
									If TransType="E" {
										Set LocData = $g(^DHCHAI.BT.LocationD($p(AdmTransData,"^",1)))
									}Else {
										Set LocData = $g(^DHCHAI.BT.LocationD($p(AdmTransData,"^",2)))
									}
									Set IRInfHospDr   = $li(LocData,8)
									Set IRInfGroupDr  = $li(LocData,7)
								}
								If IRInfGroupDr="" {	
									Set IRInfGroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
								}
								Continue:(IRInfHospDr'=HospDr)		//过滤非本院区
								Continue:(IRInfGroupDr'=GroupDr)	//过滤非本科室组
								//记录感染人数
								If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
									Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
									//漏报人数
									If ($d(^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm))) {
										Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfMissPat"))	
									}
								}
								//记录感染例次数
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
								//漏报例次数
								If ($d(^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm,InfDate,xDiagID))) {
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfMissCase"))	
								}
								Set tmpDiagDesc = $g(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Continue:tmpDiagDesc=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPosCase",tmpDiagDesc))  //记录感染部位例次数
							}
						}
					} Else{ //科室-病区的感染人数需要判断转科日期，计算到感染科室（科别）
						Set InfDate=""
						for {
							Set InfDate=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate))
							Quit:InfDate=""
							Continue:(","_TransDates_",")'[(","_InfDate_",")
							//记录感染人数
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
								//漏报人数
								If ($d(^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm))) {
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfMissPat"))	
								}
							}
							Set xDiagID=""
							for {
								Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Quit:xDiagID=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))  //记录感染例次数
								//漏报例次数
								If ($d(^TMP($zn,$j,NIndex,"Hosp","InfMissFlg",Paadm,InfDate,xDiagID))) {
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfMissCase"))	
								}
								Set tmpDiagDesc = $g(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Continue:tmpDiagDesc=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPosCase",tmpDiagDesc))  //记录感染部位例次数
							}
						}
					}
				}
			}
			// 三管信息统计
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)) {
				// 科室患者插管
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)=""
				for xTypeCode = 1:1:3 {
					Set TubeType=$CASE(xTypeCode,"1":"VAP","2":"PICC","3":"UC","4":"0")				
					Set Days=##class(DHCHAI.STATV2.ICUTotalStat).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",TubeType,aLocType)
					If (Days'=0){
						If ('$d(^TMP($zn,$j,NIndex,DimensKey,"TubePat",Paadm,TubeType))) {
							Set ^TMP($zn,$j,NIndex,DimensKey,"TubePat",Paadm,TubeType)=""												
							Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"TubeCount",TubeType))
							Set ^TMP($zn,$j,NIndex,DimensKey,"TubeDays",TubeType)=$g(^TMP($zn,$j,NIndex,DimensKey,"TubeDays",TubeType))+Days
						}
					}
					// 科室患者插管感染(不判断是否插管患者)
					Set InfPosInfo=##class(DHCHAI.STATV2.ICUTotalStat).GetTubeInf(Paadm,TubeType,aDateFrom,aDateTo,LocDr,WardDr)
					If (InfPosInfo'="") {
						Set InfCount=$Length(InfPosInfo,"|")
						Set ^TMP($zn,$j,NIndex,DimensKey,"TubeInfCount",TubeType)=$g(^TMP($zn,$j,NIndex,DimensKey,"InfCount",TubeType))+InfCount
					}
				}
			}
		}
    }
    
    Set aYYMM=$zd(aDateFrom,3)
	Set aYYMM=$e(aYYMM,1,7)
	// 输出Data
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I|E")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	= $lg(DimList,1)
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:xDimensKey=""
		Continue:(xDimensKey["G")
		Set DimensMark = $p(xDimensKey,"-",4)
		If (aHospIDs["|"){
			Continue:(xDimensKey["H")
		}
		Set AvgSeverity=0,ICUFlag=""
		If (DimensMark="W"){
			//平均危险等级程度
			Set aWardDr=+$p(xDimensKey,"-",3)
			Set AdOfInfo=##class(DHCHAI.STATV2.ICUAdOfInfect).GetRiskLevel(aWardDr,aYYMM,aYYMM)
			Set:AdOfInfo'="" AvgSeverity=$p(AdOfInfo,"^",3)
			//计算ICU科室标志 1：ICU  2：NICU
			Set WardData = $g(^DHCHAI.BT.LocationD(aWardDr))
			Continue:WardData=""
			Set BTIsICU=$lg(WardData,10)
			Set BTIsNICU=$lg(WardData,11)
			Set:ICUFlag=1 ICUFlag=1
			Set:BTIsNICU=1 ICUFlag=2
		}
		Set AvgInDays="0"
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  //住院患者人数
		Set InDaysCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InDays"))  //患者住院天数
		Set:PatAdmCnt>0 AvgInDays=$fn((InDaysCnt/PatAdmCnt),"",2)     //平均住院天数
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数InfMissPat
		Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例次数
		Set InfPatRatio="0.00%",InfCaseRatio="0.00%"
		Set:PatAdmCnt>0 InfPatRatio=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%" 	//感染率
		Set AdjuInfPatRatio="0.00%",AdjuInfCaseRatio="0.00%"
		If (PatAdmCnt>0)&&(AvgSeverity>0){
			Set AdjuInfPatRatio=$fn(((InfPatCnt/PatAdmCnt)/AvgSeverity)*100,"",2)_"%" 	    //调正感染率
			Set AdjuInfCaseRatio=$fn(((InfCaseCnt/PatAdmCnt)/AvgSeverity)*100,"",2)_"%" 	//调正例次感染率
		}
		Set:PatAdmCnt>0 InfCaseRatio=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%"   	//感染例次率
		Set DayInfPatRatio="0.00‰",DayInfCaseRatio="0.00‰"
		Set:InDaysCnt>0 DayInfPatRatio=$fn((InfPatCnt/InDaysCnt)*1000,"",2)_"‰"     //千日感染发病率
		Set:InDaysCnt>0 DayInfCaseRatio=$fn((InfCaseCnt/InDaysCnt)*1000,"",2)_"‰"   //千日感染例次发病率
		Set AdjuDayInfPatRatio="0.00%",AdjuDayInfCaseRatio="0.00%"
		If (InDaysCnt>0)&&(AvgSeverity>0){
			Set AdjuDayInfPatRatio=$fn(((InfPatCnt/InDaysCnt)/AvgSeverity)*100,"",2)_"%"    //调正千日感染发病率
			Set AdjuDayInfCaseRatio=$fn(((InfCaseCnt/InDaysCnt)/AvgSeverity)*100,"",2)_"%" 	//调正千日感染例次发病率
		}
		Set MissPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfMissPat"))  //漏报人数
		Set MissCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfMissCase")) //漏报例次数
		Set MissRatio="0.00%"
		Set:PatAdmCnt>0 MissRatio=$fn((MissPatCnt/PatAdmCnt)*100,"",2)_"%" 	//漏报率
		Set OperCaseCnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase"))      //手术例次数
		Set OperInfCnt    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInfCase"))   //手术部位感染例次数
		Set OperCaseRatio="0.00%"  //手术例次感染率
		Set:OperCaseCnt>0 OperCaseRatio=$fn((OperInfCnt/OperCaseCnt)*100,"",2)_"%" 	//感染率
		Set OperCase1Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase1"))     //I类切口手术例次数
		Set OperInf1Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInfCase1"))  //I类切口手术部位感染例次数
		Set OperCase1Ratio="0.00%"  //I类切口例次感染率
		Set:OperCase1Cnt>0 OperCase1Ratio=$fn((OperInf1Cnt/OperCase1Cnt)*100,"",2)_"%" 	//感染率
		Set OperCase2Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase2"))
		Set OperInf2Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInfCase2"))
		Set OperCase2Ratio="0.00%"
		Set:OperCase2Cnt>0 OperCase2Ratio=$fn((OperInf2Cnt/OperCase2Cnt)*100,"",2)_"%"
		Set OperCase3Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase3"))
		Set OperInf3Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInfCase3"))
		Set OperCase3Ratio="0.00%" 
		Set:OperCase3Cnt>0 OperCase3Ratio=$fn((OperInf3Cnt/OperCase3Cnt)*100,"",2)_"%"
		Set OperCase4Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase4"))
		Set OperInf4Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInfCase4"))
		Set OperCase4Ratio="0.00%"  //I类切口例次感染率
		Set:OperCase4Cnt>0 OperCase4Ratio=$fn((OperInf4Cnt/OperCase4Cnt)*100,"",2)_"%"
		
		//感染部位例次数
		Set InfPosCase1Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","上呼吸道感染"))
		Set InfPosCase2Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","下呼吸道感染"))
		Set InfPosCase3Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","胸膜腔感染"))
		Set InfPosCase4Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","心内膜炎"))
		Set InfPosCase5Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","心肌炎或心包炎"))
		Set InfPosCase6Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","纵隔炎"))
		Set InfPosCase7Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","血管导管相关局部感染"))
		Set InfPosCase8Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","血流感染"))
		Set InfPosCase9Cnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","输血相关感染"))
		Set InfPosCase10Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","感染性腹泻"))
		Set InfPosCase11Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","胃肠道感染"))
		Set InfPosCase12Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","抗菌药物相关性腹泻"))
		Set InfPosCase13Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","病毒性肝炎"))
		Set InfPosCase14Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","腹（盆）腔内组织感染"))
		Set InfPosCase15Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","腹水感染"))
		Set InfPosCase16Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","细菌性脑膜炎"))
		Set InfPosCase17Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","脑室炎"))
		Set InfPosCase18Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","颅内脓肿"))
		Set InfPosCase19Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","椎管内感染"))
		Set InfPosCase20Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","有症状的泌尿道感染"))
		Set InfPosCase21Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","无症状菌尿症"))
		Set InfPosCase22Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","其它泌尿系感染"))
		Set InfPosCase23Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","表浅手术切口感染"))
		Set InfPosCase24Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","深部手术切口感染"))
		Set InfPosCase25Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","器官和腔隙感染"))
		Set InfPosCase26Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","皮肤感染"))
		Set InfPosCase27Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","软组织感染"))
		Set InfPosCase28Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","褥疮感染"))
		Set InfPosCase29Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","烧伤感染"))
		Set InfPosCase30Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","乳腺脓肿或乳腺炎"))
		Set InfPosCase31Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","脐炎"))
		Set InfPosCase32Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","婴儿脓疱病"))
		Set InfPosCase33Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","关节和关节囊感染"))
		Set InfPosCase34Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","骨髓炎"))
		Set InfPosCase35Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","椎间盘感染"))
		Set InfPosCase36Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","外阴切口感染"))
		Set InfPosCase37Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","阴道穹隆部感染"))
		Set InfPosCase38Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","急性盆腔炎"))
		Set InfPosCase39Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","子宫内膜炎"))
		Set InfPosCase40Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","男女性生殖道的其它感染"))
		Set InfPosCase41Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","口腔、舌、牙龈部位感染"))
		Set InfPosCase42Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","新生儿感染"))
		Set InfPosCase43Cnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosCase","其它部位感染"))
		
		Set VAPPatCnt	  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","VAP"))	// 呼吸机插管人数
		Set VAPUseDay	  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","VAP"))		// 呼吸机插管天数
		Set VAPInfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeInfCount","VAP"))	// 呼吸机感染例次数
		Set VAPUseRatio="0.00%",VAPInfRatio="0.00‰"
		Set:InDaysCnt>0 VAPUseRatio=$fn((VAPUseDay/InDaysCnt)*100,"",2)_"%"
		Set:InDaysCnt>0 VAPInfRatio=$fn((VAPInfCaseCnt/InDaysCnt)*1000,"",2)_"‰"
		
		Set PICCPatCnt	  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","PICC"))
		Set PICCUseDay	  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","PICC"))	
		Set PICCInfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeInfCount","PICC"))
		Set PICCUseRatio="0.00%",PICCInfRatio="0.00‰"
		Set:InDaysCnt>0 PICCUseRatio=$fn((PICCUseDay/InDaysCnt)*100,"",2)_"%"
		Set:InDaysCnt>0 PICCInfRatio=$fn((PICCInfCaseCnt/InDaysCnt)*1000,"",2)_"‰"
		
		Set UCPatCnt	  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","UC"))
		Set UCUseDay	  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","UC"))	
		Set UCInfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeInfCount","UC"))
		Set UCUseRatio="0.00%",UCInfRatio="0.00‰"
		Set:InDaysCnt>0 UCUseRatio=$fn((UCUseDay/InDaysCnt)*100,"",2)_"%"
		Set:InDaysCnt>0 UCInfRatio=$fn((UCInfCaseCnt/InDaysCnt)*1000,"",2)_"‰"
		Set ICUUseDays=UCUseDay+PICCUseDay+VAPUseDay
		Set ICUUseRatio="0.00%"
		Set:InDaysCnt>0 UCUseRatio=$fn((ICUUseDays/InDaysCnt)*100,"",2)_"%"
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InDaysCnt,AvgInDays,InfPatCnt,InfCaseCnt,InfPatRatio,InfCaseRatio,DayInfPatRatio,DayInfCaseRatio,InfPosCase1Cnt,InfPosCase2Cnt,InfPosCase3Cnt,InfPosCase4Cnt,InfPosCase5Cnt,InfPosCase6Cnt,InfPosCase7Cnt,InfPosCase8Cnt,InfPosCase9Cnt,InfPosCase10Cnt,InfPosCase11Cnt,InfPosCase12Cnt,InfPosCase13Cnt,InfPosCase14Cnt,InfPosCase15Cnt,InfPosCase16Cnt,InfPosCase17Cnt,InfPosCase18Cnt,InfPosCase19Cnt,InfPosCase20Cnt,InfPosCase21Cnt,InfPosCase22Cnt,InfPosCase23Cnt,InfPosCase24Cnt,InfPosCase25Cnt,InfPosCase26Cnt,InfPosCase27Cnt,InfPosCase28Cnt,InfPosCase29Cnt,InfPosCase30Cnt,InfPosCase31Cnt,InfPosCase32Cnt,InfPosCase33Cnt,InfPosCase34Cnt,InfPosCase35Cnt,InfPosCase36Cnt,InfPosCase37Cnt,InfPosCase38Cnt,InfPosCase39Cnt,InfPosCase40Cnt,InfPosCase41Cnt,InfPosCase42Cnt,InfPosCase43Cnt,OperCaseCnt,OperInfCnt,OperCase1Cnt,OperInf1Cnt,OperCase1Ratio,OperCase2Cnt,OperInf2Cnt,OperCase2Ratio,OperCase3Cnt,OperInf3Cnt,OperCase3Ratio,OperCase4Cnt,OperInf4Cnt,OperCase4Ratio,OperCaseRatio,MissPatCnt,MissCaseCnt,MissRatio,ICUFlag)
		Set Data=Data_$lb(AvgSeverity,AdjuInfPatRatio,AdjuInfCaseRatio,AdjuDayInfPatRatio,AdjuDayInfCaseRatio,VAPPatCnt,VAPUseDay,VAPUseRatio,VAPInfCaseCnt,VAPInfRatio,UCPatCnt,UCUseDay,UCUseRatio,UCInfCaseCnt,UCInfRatio,PICCPatCnt,PICCUseDay,PICCUseRatio,PICCInfCaseCnt,PICCInfRatio,ICUUseDays,ICUUseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	 		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryMonthStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMonthStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMonthStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMonthStatExecute ]
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
/// CreatDate：   2021-11-22
/// Description:  获取患者一段期间手术信息
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aEpisodeID：就诊ID
/// return:       手术信息
/// w ##class(DHCHAI.STAS.MonthStat).GetOperInfo("383","65027","66067")
ClassMethod GetOperInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set OperInfos=""
	For xDate=aDateFrom:1:aDateTo {
		Set xID=""
		For {
 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate,xID))
			Quit:xID=""
			
			Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
		 	Continue:AnaesData=""
		 	Set ORIsActive=$li(AnaesData,31)
		 	Continue:ORIsActive'=1
		 	/// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
	 		Set OperStatus = $li(AnaesData,34)         // 手术状态
	 		Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
			Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
			Set:tOperStatus'="" OperStatus=tOperStatus
		 	//Continue:"ADC"[OperStatus    // 过滤手术状态
		 	Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
			Set SCode=$li(AnaesData,22)
		 	Set EpisodeDr   = $li(AnaesData,2)
		 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
			Continue:AdmData=""
			Continue:$li(AdmData,19)="C"
			Set TAdmType=$li(AdmData,18)
			Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
			// 手术信息
			Set OperICD     = $li(AnaesData,3)         // 手术ICD
			Set OperDesc    = $li(AnaesData,4)         // 手术名称
			Set OperDate  = $li(AnaesData,6)
			Set ORSttTime = $li(AnaesData,7)
			Set Incision = $li(AnaesData,16)       // 切口等级
			Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
			If (IncisionInfo'="") {
				Set MapIncDicCode = $p(IncisionInfo,"^",2)
				Set MapIncDicDesc = $p(IncisionInfo,"^",3)
			}Else {
				Set MapIncDicCode = ""
				Set MapIncDicDesc = Incision
			}
			// 患者手术时所在的科室病区
			Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
			Continue:OperLocWard=""
			Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室
			Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区
			Set IsInfOper=0 // 手术是否感染
		    Set xInfRepID=""
			For {
				Set xInfRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFOPS","U")," "_xID,xInfRepID))
				Quit:xInfRepID=""
				Set RepData=$g(^DHCHAI.IR.INFReportD(xInfRepID))
				Continue:RepData=""
				Set IRRepType=$li(RepData,3)
				Continue:(IRRepType'=1)
				Set IRStatusDr=$li(RepData,8)
				Set StatusData=$g(^DHCHAI.BT.DictionaryD(IRStatusDr))
				Continue:StatusData=""
				Set RepStaCode=$li(StatusData,2)
				Continue:RepStaCode=4
				
				Set xSub=0
				For {
					Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xInfRepID,xSub))
					Quit:xSub=""
					
					Set RepExtID=xInfRepID_"||"_xSub
					Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
					Continue:'$IsObject(obj)
					Set ObjectID=obj.IRObjectID
					Continue:ObjectID=""
					Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(ObjectID)
					Continue:'$IsObject(objDiags)
					// 感染诊断
					Set objInfPos = objDiags.IRInfPosDr
					If $IsObject(objInfPos){
						Set PosDesc=objInfPos.BTDesc
						Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
						Set IsInfOper=1
					}
				}
			}
			Set OperInfos = OperInfos_"|"_xID_"^"_OperDesc_"^"_OperDate_"^"_MapIncDicDesc_"^"_OperLocDr_"^"_OperWardDr_"^"_IsInfOper
		}
	}
	
	Set:OperInfos'="" OperInfos = $e(OperInfos,2,$l(OperInfos))
	Quit OperInfos
}

}
