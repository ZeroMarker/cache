/// 名称: DHCHAI.STATV2.BactTrendStat
/// 描述: 检出菌趋势分析统计
/// 编写者: zhoubo
/// 编写日期: 2021-04-07
Class DHCHAI.STATV2.BactTrendStat Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-04-07
/// Description:  病原体耐药性趋势分析
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
///               aStatType  : 统计单位
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aLocID     : 科室/病区ID
///               aBactID    : 细菌字典ID
///               aDrugLevel : 耐药级别 1：多耐菌 2：敏感
///               aStatUnit  : 统计单位 1：月   2：季度 3：年
///               aTypeCode  : 感染类型Code
///               aBactDesc  : 细菌名称
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactTrendStat","QryBactTrend","","1","","2021-04","2021-12","","","","","","")
Query QryBactTrend(aHospIDs As %String, aDateType As %String, aStatType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBactID As %String, aDrugLevel As %String, aStatUnit As %String, aTypeCode As %String, aBactDesc As %String = "") As %Query(ROWSPEC = "xBacDesc:%String,xStatName:%String,CntSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryBactTrendExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aStatType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBactID As %String, aDrugLevel As %String, aStatUnit As %String, aTypeCode As %String, aBactDesc As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set:aLocID'="" aLocID=$tr(aLocID,",","|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocID,"|")
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryBactTrend"
    Set:aStatUnit="" aStatUnit=1
	Kill ^TMP($zn,$j,NIndex)
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	
	// 跟据单位划分维度
	If (aStatUnit=1){ // 按月统计
		If +aDateFrom=+aDateTo {
			//同年
			Set StatYear = +aDateFrom
			Set MonthFrom=+$p(aDateFrom,"-",2)
			Set MonthTo=+$p(aDateTo,"-",2)
			Quit:MonthFrom>MonthTo $$$OK
		
			For StatMonth=MonthFrom:1:MonthTo{
			
				If (StatMonth<10){
					Set StatName = StatYear_"年0"_StatMonth_"月"
				}Else{
					Set StatName = StatYear_"年"_StatMonth_"月" 
				}
				Set DateFrom = StatYear_"-"_StatMonth_"-01"
				Set DateTo	 = StatYear_"-"_StatMonth_"-"_..GetMonthDate(StatYear,StatMonth)
				Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
				Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)

				Continue:(DateFrom>DateTo) 
			 	Set:DateFrom>+$h DateFrom=+$h
			 	Set:DateTo>+$h DateTo=+$h
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
						
						Set xDate=DateFrom-1
						For {
							Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
							Quit:xDate=""
							Quit:(xDate>DateTo)
							
							Set xID=""
							For {
								Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
								Quit:xID=""
								
								Do BuildRstTrendData
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
						
						Set xDate=DateFrom-1
						For {
							Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
							Quit:xDate=""
							Quit:(xDate>DateTo)
							
							Set xID=""
							For {
								Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
								Quit:xID=""
								
								Do BuildRstTrendData
							}
						}
					}
				}
			}
		}Else{
			//不同年
			Set FromYear=+aDateFrom
			Set ToYear=+aDateTo
			
			Set FromMonth=+$p(aDateFrom,"-",2)
			Set ToMonth=+$p(aDateTo,"-",2)
			
			Quit:FromYear>ToYear $$$OK
			For StatYear=FromYear:1:ToYear{
				Set MonthFrom=FromMonth
				Set MonthTo=ToMonth
				if (StatYear=FromYear){
					Set MonthTo=12
				}
				if (StatYear=ToYear){
					Set MonthFrom=1
				}
				if (StatYear'=FromYear)&&(StatYear'=ToYear){
					Set MonthFrom=1
					Set MonthTo=12
				}
				for StatMonth=MonthFrom:1:MonthTo{
					If (StatMonth<10){
						Set StatName = StatYear_"年0"_StatMonth_"月"
					}Else{
						Set StatName = StatYear_"年"_StatMonth_"月" 
					}
					Set DateFrom = StatYear_"-"_StatMonth_"-01"
					Set DateTo	 = StatYear_"-"_StatMonth_"-"_..GetMonthDate(StatYear,StatMonth)
					Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
					Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)

					Continue:(DateFrom>DateTo) 
				 	Set:DateFrom>+$h DateFrom=+$h
				 	Set:DateTo>+$h DateTo=+$h
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
							
							Set xDate=DateFrom-1
							For {
								Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
								Quit:xDate=""
								Quit:(xDate>DateTo)
								
								Set xID=""
								For {
									Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
									Quit:xID=""
									
									Do BuildRstTrendData
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
							
							Set xDate=DateFrom-1
							For {
								Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
								Quit:xDate=""
								Quit:(xDate>DateTo)
								
								Set xID=""
								For {
									Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
									Quit:xID=""
									
									Do BuildRstTrendData
								}
							}
						}
					}
				}
			}
		}
		
	}ElseIf (aStatUnit=2){ // 按季度统计
		if +aDateFrom=+aDateTo {
			Set StatYear  = +aDateFrom
			Set QuarterFrom=(+$p(aDateFrom,"-",2)-1)\3 +1
			Set QuarterTo=(+$p(aDateTo,"-",2)-1)\3 +1
			Quit:QuarterFrom>QuarterTo $$$OK
		
			for StatQuarter=QuarterFrom:1:QuarterTo {
				Set StatName = StatYear_"年"_StatQuarter_"季度"
			
				Set StatMonthFrom=StatQuarter*3-2
				Set StatMonthto=StatQuarter*3
				
				Set DateFrom = StatYear_"-"_StatMonthFrom_"-01"
				Set DateTo	 = StatYear_"-"_StatMonthto_"-"_..GetMonthDate(StatYear,StatMonthto)
			
				Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
				Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)

				Continue:(DateFrom>DateTo) 
			 	Set:DateFrom>+$h DateFrom=+$h
			 	Set:DateTo>+$h DateTo=+$h
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
						
						Set xDate=DateFrom-1
						For {
							Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
							Quit:xDate=""
							Quit:(xDate>DateTo)
							
							Set xID=""
							For {
								Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
								Quit:xID=""
								
								Do BuildRstTrendData
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
						
						Set xDate=DateFrom-1
						For {
							Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
							Quit:xDate=""
							Quit:(xDate>DateTo)
							
							Set xID=""
							For {
								Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
								Quit:xID=""
								
								Do BuildRstTrendData
							}
						}
					}
				}
			}
		}else{
			//不同年
			Set FromYear=+aDateFrom
			Set ToYear=+aDateTo
			
			Set FromQuarter=(+$p(aDateFrom,"-",2)-1)\3 +1
			Set ToQuarter=(+$p(aDateTo,"-",2)-1)\3 +1
			Quit:FromYear>ToYear $$$OK
			for StatYear=FromYear:1:ToYear{
				Set QuarterFrom=FromQuarter
				Set QuarterTo=ToQuarter
				if (StatYear=FromYear){
					Set QuarterTo=4
				}
				if (StatYear=ToYear){
					Set QuarterFrom=1
				}
				if (StatYear'=FromYear)&&(StatYear'=ToYear){
					Set QuarterFrom=1
					Set QuarterTo=4
				}
				for StatQuarter=QuarterFrom:1:QuarterTo {
					Set StatName = StatYear_"年"_StatQuarter_"季度"
			
					Set StatMonthFrom=StatQuarter*3-2
					Set StatMonthto=StatQuarter*3
				
					Set DateFrom = StatYear_"-"_StatMonthFrom_"-01"
					Set DateTo	 = StatYear_"-"_StatMonthto_"-"_..GetMonthDate(StatYear,StatMonthto)
			
					Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
					Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)

					Continue:(DateFrom>DateTo) 
				 	Set:DateFrom>+$h DateFrom=+$h
				 	Set:DateTo>+$h DateTo=+$h
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
							
							Set xDate=DateFrom-1
							For {
								Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
								Quit:xDate=""
								Quit:(xDate>DateTo)
								
								Set xID=""
								For {
									Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
									Quit:xID=""
									
									Do BuildRstTrendData
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
							
							Set xDate=DateFrom-1
							For {
								Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
								Quit:xDate=""
								Quit:(xDate>DateTo)
								
								Set xID=""
								For {
									Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
									Quit:xID=""
									
									Do BuildRstTrendData
								}
							}
						}
					}
				}
			}
		}
		
	}Else{  // 按年统计
		Set aDateFrom=+aDateFrom,aDateTo=+aDateTo
		Quit:(aDateFrom>aDateTo) $$$OK
		for StatYear=aDateFrom:1:aDateTo {
			Set StatName = StatYear_"年"
			Set DateFrom = StatYear_"-01-01"
			Set DateTo = StatYear_"-12-31"
			Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
			Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)

			Continue:(DateFrom>DateTo) 
		 	Set:DateFrom>+$h DateFrom=+$h
		 	Set:DateTo>+$h DateTo=+$h
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
					
					Set xDate=DateFrom-1
					For {
						Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
						Quit:xDate=""
						Quit:(xDate>DateTo)
						
						Set xID=""
						For {
							Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
							Quit:xID=""
							
							Do BuildRstTrendData
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
					
					Set xDate=DateFrom-1
					For {
						Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
						Quit:xDate=""
						Quit:(xDate>DateTo)
						
						Set xID=""
						For {
							Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
							Quit:xID=""
							
							Do BuildRstTrendData
						}
					}
				}
			}
		}
	}
	// 输出
	Set xStatName=""
	For {
		Set xStatName=$o(^TMP($zn,$j,NIndex,"BactStat",xStatName))
		Quit:xStatName=""
		Set xBacDesc=""
		For {
			Set xBacDesc=$o(^TMP($zn,$j,NIndex,"BactStat",xStatName,xBacDesc))
			Quit:xBacDesc=""
			Set CntSum = +$g(^TMP($zn,$j,NIndex,"BactStat",xStatName,xBacDesc))
				
			Set ^CacheTemp(repid,ind)=$lb(xBacDesc,xStatName,CntSum)
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK

BuildRstTrendData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	Quit:$li(RstData,14)'=1
	Set IsAbFlag = $li(RstData,21)   //异常标志
	//Quit:IsAbFlag'=1 //过滤非耐药菌
	//过滤耐药级别
	Set CCMRBTpDr = $li(RstData,24)  // 是否是多耐菌
	If (aDrugLevel="1"){
		Quit:CCMRBTpDr=""
	}ElseIf (aDrugLevel="2"){
		Quit:CCMRBTpDr'=""
	}
	Set AdmID = $li(RstData,2)
	Set ResultID =$p( $li(RstData,19),"=",2)  //检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型
	Set LabReportDr      = $lg(RepRstData,2)
	Quit:LabReportDr=""
	Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
	Quit:LabReportData=""
	Set LabVisitNumberDr = $lg(LabReportData,2)
	Quit:LabVisitNumberDr=""
	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(LabVisitNumberDr))
	Quit:VisitNumberData=""
	Set LabSpecimen = $lg(VisitNumberData,6)
	Set LabSCode    = $lg(VisitNumberData,14)
	Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
	Quit:SpecMapID=""
	Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
	Quit:SpecMapData=""
	Set BTMapItemDr = $lg(SpecMapData,3)
	
	Set SpecData=""
	Set:BTMapItemDr'="" SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))
	Set SpecDesc=""
	Set:SpecData'="" SpecDesc = $li(SpecData,3)
	Set:SpecDesc'="" LabSpecimen=SpecDesc
	Quit:LabSpecimen=""
	Set SCode = $li(RstData,17)   //子系统代码
	Set PAadmData=$g(^DHCHAI.DP.PAAdmD(AdmID))
	Quit:PAadmData=""
	Set AdmLocID = $li(PAadmData,22)
	Quit:AdmLocID=""
	Set AdmLocData  = $g(^DHCHAI.BT.LocationD(AdmLocID))
	Set AdmLocDesc  = $li(AdmLocData,3)
	Set AdmLocDesc2 = $li(AdmLocData,4)
	Set:AdmLocDesc2'="" AdmLocDesc=AdmLocDesc2
	Set HospDr = $li(AdmLocData,8)
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
		
	Set AdmWardID = $li(PAadmData,23)
	Quit:AdmWardID=""
	Set AdmWardData  = $g(^DHCHAI.BT.LocationD(AdmWardID))
	Set AdmWardDesc  = $li(AdmWardData,3)
	Set AdmWardDesc2 = $li(AdmWardData,4)
	Set:AdmWardDesc2'="" AdmWardDesc = AdmWardDesc2
	Set CCActDate   = $li(RstData,8)  // 送检日期
	Set CCActLocDr  = $li(RstData,7)  // 送检科室
	Set CCRepDate   = $li(RstData,11) // 报告日期
	If (aStatType=1){ // 按照病区统计
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,CCActDate,"")
		Set CCActLocDr = $p(TransInfo,"^",2)
	}
	Quit:CCActLocDr=""
	Quit:(aLocIDs'="")&&($listfind(aLocIDs,CCActLocDr)<1)  //允许增加科室入参查询
   
	Set Bacteria = $li(RstData,23)   //原始细菌名称
	Set BacDesc=""
	Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
	Quit:Bacteria=""
	Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,""))
	If MapItemDr'="" {
		Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
		If BactMapData'=""{
			Set IsActive = $li(BactMapData,7)
			Quit:IsActive'=1
			Set BacID=$li(BactMapData,3)
			If (BacID'=""){
				Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)
			}
		}
	}
	Quit:BacDesc=""
	Quit:(aBactID'="")&&(BacID'=aBactID)         // 细菌过滤
	Quit:(aBactDesc'="")&&(aBactDesc'=BacDesc)   // 细菌过滤
	//去重
	If (IsUnRepeat="1"){
		Set UnBact="1"					//细菌
		Set:aDrugLevel="1" UnBact="2"	//多耐
		
		Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(AdmID,xID,UnRepeatType,UnBact)
		Quit:IsFirstSend'=1
	}
	
	Set num=$i(^TMP($zn,$j,NIndex,"BactStat",StatName,BacDesc))
	Quit
}

ClassMethod QryBactTrendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactTrendExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactTrendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactTrendExecute ]
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
/// Description:  病原体耐药性趋势分析明细
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
///               aStatType  : 统计单位
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aLocID     : 科室/病区ID
///               aBactID    : 细菌字典ID
///               aDrugLevel : 耐药级别 1：多耐菌 2：敏感
///               aStatUnit  : 统计单位 1：月   2：季度 3：年
///               aBactDesc  : 细菌名称
///               aUnitDesc  : 统计单位名称（2020年1月）
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.BactTrendStat","QryBactTrendDtl","1|2","1","","2022-03","2022-03","","","","","","鲍曼不动杆菌","2022年3月")
Query QryBactTrendDtl(aHospIDs As %String, aDateType As %String, aStatType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBactID As %String, aDrugLevel As %String, aStatUnit As %String, aTypeCode As %String, aBactDesc As %String, aUnitDesc As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryBactTrendDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aStatType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBactID As %String, aDrugLevel As %String, aStatUnit As %String, aTypeCode As %String, aBactDesc As %String, aUnitDesc As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set:aLocID'="" aLocID=$tr(aLocID,",","|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocID,"|")
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryBactTrendDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	// 2019年2月  2020年1季度  2020年
	If (aUnitDesc["月"){
		Set aYear    =+aUnitDesc
		Set aMonth   =+$e(aUnitDesc,6,7)
		Set aLastDay =..GetMonthDate(aYear,aMonth)
		Set DateFrom=aYear_"-"_aMonth_"-01"
		Set DateTo=aYear_"-"_aMonth_"-"_aLastDay
	}ElseIf(aUnitDesc["季度"){
		Set aYear    =+aUnitDesc
		Set aJDSum   =+$e(aUnitDesc,6,7)
		If (aJDSum=1){
			Set DateFrom=aYear_"-01-01"
			Set DateTo=aYear_"-03-31"
		}
		If (aJDSum=2){
			Set DateFrom=aYear_"-04-01"
			Set DateTo=aYear_"-06-30"
		}
		If (aJDSum=3){
			Set DateFrom=aYear_"-07-01"
			Set DateTo=aYear_"-09-30"
		}
		If (aJDSum=4){
			Set DateFrom=aYear_"-10-01"
			Set DateTo=aYear_"-12-31"
		}
	}Else{ //年
		Set aYear    =+aUnitDesc
		Set DateFrom=aYear_"-01-01"
		Set DateTo=aYear_"-12-31"
	}
	Set DateFrom = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
	Set DateTo   = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)

	Quit:(DateFrom>DateTo) $$$OK
 	Set:DateFrom>+$h DateFrom=+$h
 	Set:DateTo>+$h DateTo=+$h
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
			
			Set xDate=DateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>DateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildRstTrendDtlData
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
			
			Set xDate=DateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>DateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildRstTrendDtlData
				}
			}
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK

BuildRstTrendDtlData
	Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
	Quit:RstData=""
	//过滤无效数据
	Quit:$li(RstData,14)'=1
	Set IsAbFlag = $li(RstData,21)   //异常标志
	//Quit:IsAbFlag'=1 //过滤非耐药菌
	//过滤耐药级别
	Set CCMRBTpDr = $li(RstData,24)  // 是否是多耐菌
	If (aDrugLevel="1"){
		Quit:CCMRBTpDr=""
	}ElseIf (aDrugLevel="2"){
		Quit:CCMRBTpDr'=""
	}
	Set AdmID = $li(RstData,2)
	Set ResultID =$p( $li(RstData,19),"=",2)  //检验结果ID：DHCHAI.DP.LabVisitRepResult
	Quit:ResultID=""
	Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
	Quit:RepRstData=""
	Set MakeInfType=$lg(RepRstData,13)
	Quit:(aTypeCode'="")&&(aTypeCode'=MakeInfType)  // 过滤感染类型
	Set LabReportDr      = $lg(RepRstData,2)
	Quit:LabReportDr=""
	Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
	Quit:LabReportData=""
	Set LabVisitNumberDr = $lg(LabReportData,2)
	Quit:LabVisitNumberDr=""
	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(LabVisitNumberDr))
	Quit:VisitNumberData=""
	Set LabSpecimen = $lg(VisitNumberData,6)
	Set LabSCode    = $lg(VisitNumberData,14)
	Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
	Quit:SpecMapID=""
	Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
	Quit:SpecMapData=""
	Set BTMapItemDr = $lg(SpecMapData,3)
	
	Set:BTMapItemDr'="" SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))
	Set SpecDesc=""
	Set:SpecData'="" SpecDesc = $li(SpecData,3)
	Set:SpecDesc'="" LabSpecimen=SpecDesc
	Quit:LabSpecimen=""
	Set SCode = $li(RstData,17)   //子系统代码
	Set PAadmData=$g(^DHCHAI.DP.PAAdmD(AdmID))
	Quit:PAadmData=""
	Set AdmLocID = $li(PAadmData,22)
	Quit:AdmLocID=""
	Set AdmLocData  = $g(^DHCHAI.BT.LocationD(AdmLocID))
	Set AdmLocDesc  = $li(AdmLocData,3)
	Set AdmLocDesc2 = $li(AdmLocData,4)
	Set:AdmLocDesc2'="" AdmLocDesc=AdmLocDesc2
	Set HospDr = $li(AdmLocData,8)
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
		
	Set AdmWardID = $li(PAadmData,23)
	Quit:AdmWardID=""
	Set AdmWardData  = $g(^DHCHAI.BT.LocationD(AdmWardID))
	Set AdmWardDesc  = $li(AdmWardData,3)
	Set AdmWardDesc2 = $li(AdmWardData,4)
	Set:AdmWardDesc2'="" AdmWardDesc = AdmWardDesc2
	Set CCActDate   = $li(RstData,8)  // 送检日期
	Set CCActLocDr  = $li(RstData,7)  // 送检科室
	Set CCRepDate   = $li(RstData,11) // 报告日期
	If (aStatType=1){ // 按照病区统计
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,CCActDate,"")
		Set CCActLocDr = $p(TransInfo,"^",2)
	}
	Quit:CCActLocDr=""
	Quit:(aLocIDs'="")&&($listfind(aLocIDs,CCActLocDr)<1)  //允许增加科室入参查询
   
	Set Bacteria = $li(RstData,23)   //原始细菌名称
	Set BacDesc=""
	Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
	Quit:Bacteria=""
	Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,""))
	If MapItemDr'="" {
		Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
		If BactMapData'=""{
			Set IsActive = $li(BactMapData,7)
			Quit:IsActive'=1
			Set BacID=$li(BactMapData,3)
			If (BacID'=""){
				Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)
			}
		}
	}
	Quit:BacDesc="" 	// 过滤未对照细菌
	Set:BacDesc="" BacDesc=Bacteria
	
	Quit:(aBactID'="")&&(BacID'=aBactID)         // 细菌过滤
	Quit:(aBactDesc'="")&&(aBactDesc'=BacDesc)   // 细菌过滤
	//去重
	If (IsUnRepeat="1"){
		Set UnBact="1"					//细菌
		Set:aDrugLevel="1" UnBact="2"	//多耐
		
		Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(AdmID,xID,UnRepeatType,UnBact)
		Quit:IsFirstSend'=1
	}
	
	//输出1-患者基本信息
	Set PatData =..BuildPaadmData(AdmID)
	Quit:PatData=""
	Set AdmData   = $g(^DHCHAI.DP.PAAdmD(AdmID))
	Quit:AdmData=""
	Set AdmTimes = $lg(AdmData,38)   	//就诊次数
	//输出2-患者转科信息
	Set ActDate=$lg(RstData,8)			//送检日期		
	Set ActTime=$lg(RstData,9)			//送检时间
	Set RepDate =$lg(RstData,11)		//报告日期
	Set RepTime =$lg(RstData,12)		//报告时间
	Set LocType="W"
	Set:aStatType="2" LocType="E"
	If (aDateType=1){	//送检科室
		//取转科信息
		Set TransInfo=##class(DHCHAI.STATV2.BactDrugfast).GetLocInfoByDate(AdmID,LocType,ActDate,ActTime)
	}					
	else{				//报告科室
		//取转科信息
		Set TransInfo=##class(DHCHAI.STATV2.BactDrugfast).GetLocInfoByDate(AdmID,LocType,RepDate,RepTime)
	}
	Set TransID		=$p(TransInfo,"^",1)
	Set GroupID		=$p(TransInfo,"^",2)
	Set GroupDesc	=$p(TransInfo,"^",3)
	Set LocID		=$p(TransInfo,"^",4)
	Set LocDesc		=$p(TransInfo,"^",5)
	Set TransDate	= $p(TransInfo,"^",6)
    Set OutLocDate	= $p(TransInfo,"^",7)
	Set TransTime	= $p(TransInfo,"^",8)
	Set OutLocTime	= $p(TransInfo,"^",9)
	//转换转科日期格式
	Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
	Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	Set:TransTime'="" TransTime=$zt(TransTime)
	Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	Set TransDateTime =TransDate_" "_TransTime
	Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
	Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
	//输出3-患者送检信息
	Set LabReportID     = $lg(RepRstData,2)			//检验报告		
	Set LabReportData   = $g(^DHCHAI.DP.LabVisitReportD(LabReportID))
	Quit:LabReportData=""			
	Set LabVisitID  	= $lg(LabReportData,2)		//检验标本
	Set LabVisitData   	= $g(^DHCHAI.DP.LabVisitNumberD(LabVisitID))
	Quit:LabVisitData=""	
	Set LabEpisodeNo	= $lg(LabVisitData,3)		//标本号
	//检验医嘱
	Set LabTestSet=""	
	Set LabTestSetID	= $lg(LabReportData,13)		//指向检验医嘱
	If (LabTestSetID'=""){
		Set LabTestSet=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetID)),3)
	}
	//采样时间(日期+时间)
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set ActDateTime=ActDate_" "_ActTime
	//报告时间(日期+时间)
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set RepDateTime=RepDate_" "_RepTime	
	//耐药级别
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
	//感染类型
	Set InfType=""
	Set:MakeInfType="1" InfType="HA(院内感染)"
	Set:MakeInfType="2" InfType="CA(社区感染)"
	Set:MakeInfType="3" InfType="定植"
	Set:MakeInfType="4" InfType="污染"
	Set:MakeInfType="5" InfType="HA重复"
	Set:MakeInfType="6" InfType="CA重复"
	Set:MakeInfType="7" InfType="定植重复"
	
	Set LabInfo=$lb(xID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpecDesc,BacDesc,InfType)
	
	Set Data = $lb(BacDesc,AdmTimes)_PatData_TransInfo_LabInfo
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryBactTrendDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactTrendDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactTrendDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactTrendDtlExecute ]
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

ClassMethod GetMonthDate(aYear, aMonth)
{
	New (aYear,aMonth)
	
	Set return="30"
	Quit:aMonth="" return
	
	if (+aMonth="1")||(+aMonth="3")||(+aMonth="5")||(+aMonth="7")||(+aMonth="8")||(aMonth="10")||(aMonth="12")
	{
		set return="31"
	}
	elseif (+aMonth="4")||(+aMonth="6")||(+aMonth="9")||(aMonth="11")
	{
		set return="30"
	}
	elseif (+aMonth="2")
	{
		if (aYear'="")&&((aYear#400=0)||((aYear#4=0) && (aYear#100'=0)))	//闰年
		{
			set return ="29"
		}
		else
		{
			set return="28"
		}
	}
	quit return
}

}
