/// 描述: 	插管趋势分析
/// 编写者：lzhe
/// 编写日期: 2020-12-02
Class DHCHAI.STATV2.ICUTubeTrend Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     lzhe
/// CreatDate：   2022-06-13
/// Description:  插管趋势分析
/// Table：       DHCHAI.IR.ICULogDtl
/// Input:        
/// 			  aHospIDs   : 多个医院用"|"连接
///               aLocType   : 统计单位
///               aLocIDs    : 科室/病区ID
///               aStatUnit  : 单位 1：月   2：季度 3：年
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aTubeType  ：插管类型 All 全部;VAP 呼吸机；PICC 导尿管；UC静脉导管
///               aQryCon	 : 筛选条件 1全部 2 有数据
///               aFlag		 : 出入科标记I或者O  分别代表住院、出院      
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ICUTubeTrend","QryTubeTrendInfo","","W","",1,"2020-05","2020-07","ALL",1,"O")
Query QryTubeTrendInfo(aHospIDs As %String, aLocType As %String, aLocIDs As %Text, aStatUnit As %String, aDateFrom As %String, aDateTo As %String, aTubeType As %String, aQryCon As %String, aFlag As %String = "I") As %Query(ROWSPEC = "TimeDimens:%String,InPat:%String,InDays:%Integer,VAPDays:%Integer,VAPRatio:%String,VAPCount:%Integer,VAPInfectPat:%String,VAPINFCount:%Integer,VAPINFRatio:%String,PICCDays:%Integer,PICCRatio:%String,PICCCount:%Integer,PICCInfectPat:%String,PICCINFCount:%Integer,PICCINFRatio:%String,UCDays:%Integer,UCRatio:%String,UCCount:%Integer,UCInfectPat:%String,UCINFCount:%Integer,UCINFRatio:%String,TubeDays:%Integer,TubeRadio:%String,DateFrom:%String,DateTo:%String") [ SqlProc ]
{
}

ClassMethod QryTubeTrendInfoExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %Text, aStatUnit As %String, aDateFrom As %String, aDateTo As %String, aTubeType As %String, aQryCon As %String, aFlag As %String = "I") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:(aFlag'="I")&&(aFlag'="O") aFlag="I" 
	Set:aTubeType="" aTubeType="ALL"
	Set aTubeType=$zcvt(aTubeType,"U")
	Quit:(aLocType="")||(aDateFrom="")||(aDateTo="")||(aStatUnit="") $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set TubeTypeList=$lb("VAP","UC","PICC")   //插管类型
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")
	If (ICUPatLogSplit=1) {
	    Set TubeTypeList=$lb("VAP","UC","PICC","CVC","CRRT","PORT","PICCs")
    }
    Set ListLen=$ll(TubeTypeList)
    Quit:ListLen=0 $$$OK
    	
    Set NIndex="QryTubeTrendInfo"
	Kill ^TMP($zn,$j,NIndex)
	// 跟据单位划分维度
	If (aStatUnit=1){ // 按月统计
		If +aDateFrom=+aDateTo {
			//同年
			Set StatYear = +aDateFrom
			Set MonthFrom=+$p(aDateFrom,"-",2)
			Set MonthTo=+$p(aDateTo,"-",2)
			Quit:MonthFrom>MonthTo $$$OK
		
			For StatMonth=MonthFrom:1:MonthTo {
				Set StatName = StatYear_"年"_StatMonth_"月" 
				Set DateFrom = StatYear_"-"_StatMonth_"-01"
				Set DateTo	 = StatYear_"-"_StatMonth_"-"_..GetMonthDate(StatYear,StatMonth)
				Do BuildTubeTrend()
			}
		} Else {
			//不同年
			Set FromYear=+aDateFrom
			Set ToYear=+aDateTo
			Set FromMonth=+$p(aDateFrom,"-",2)
			Set ToMonth=+$p(aDateTo,"-",2)
			Quit:FromYear>ToYear $$$OK
			
			For StatYear=FromYear:1:ToYear {
				Set MonthFrom=FromMonth
				Set MonthTo=ToMonth
				If (StatYear=FromYear) {
					Set MonthTo=12
				}
				If (StatYear=ToYear) {
					Set MonthFrom=1
				}
				If (StatYear'=FromYear)&&(StatYear'=ToYear) {
					Set MonthFrom=1
					Set MonthTo=12
				}
				For StatMonth=MonthFrom:1:MonthTo {
					Set StatName = StatYear_"年"_StatMonth_"月" 
					Set DateFrom = StatYear_"-"_StatMonth_"-01"
					Set DateTo	 = StatYear_"-"_StatMonth_"-"_..GetMonthDate(StatYear,StatMonth)
					Do BuildTubeTrend()
				}
			}
		}
	}ElseIf (aStatUnit=2){ // 按季度统计
		If +aDateFrom=+aDateTo {
			Set StatYear  = +aDateFrom
			Set QuarterFrom=(+$p(aDateFrom,"-",2)-1)\3 +1
			Set QuarterTo=(+$p(aDateTo,"-",2)-1)\3 +1
			Quit:QuarterFrom>QuarterTo $$$OK
		
			For StatQuarter=QuarterFrom:1:QuarterTo {
				Set StatName = StatYear_"年第"_StatQuarter_"季度"
			
				Set StatMonthFrom=StatQuarter*3-2
				Set StatMonthto=StatQuarter*3
				Set DateFrom = StatYear_"-"_StatMonthFrom_"-01"
				Set DateTo	 = StatYear_"-"_StatMonthto_"-"_..GetMonthDate(StatYear,StatMonthto)
			
				Do BuildTubeTrend()
			}
		} Else {
			//不同年
			Set FromYear=+aDateFrom
			Set ToYear=+aDateTo
			
			Set FromQuarter=(+$p(aDateFrom,"-",2)-1)\3 +1
			Set ToQuarter=(+$p(aDateTo,"-",2)-1)\3 +1
			Quit:FromYear>ToYear $$$OK
			For StatYear=FromYear:1:ToYear {
				Set QuarterFrom=FromQuarter
				Set QuarterTo=ToQuarter
				If (StatYear=FromYear){
					Set QuarterTo=4
				}
				If (StatYear=ToYear){
					Set QuarterFrom=1
				}
				if (StatYear'=FromYear)&&(StatYear'=ToYear){
					Set QuarterFrom=1
					Set QuarterTo=4
				}
				For StatQuarter=QuarterFrom:1:QuarterTo {
					Set StatName = StatYear_"年第"_StatQuarter_"季度"
			
					Set StatMonthFrom=StatQuarter*3-2
					Set StatMonthto=StatQuarter*3				
					Set DateFrom = StatYear_"-"_StatMonthFrom_"-01"
					Set DateTo	 = StatYear_"-"_StatMonthto_"-"_..GetMonthDate(StatYear,StatMonthto)
			
					Do BuildTubeTrend()
				}
			}
		}
	}ElseIf (aStatUnit=3){  // 按年统计
		Set aDateFrom=+aDateFrom,aDateTo=+aDateTo
		Quit:(aDateFrom>aDateTo) $$$OK
		For StatYear=aDateFrom:1:aDateTo {
			Set StatName = StatYear_"年"
			Set DateFrom = StatYear_"-01-01"
			Set DateTo = StatYear_"-12-31"
			Do BuildTubeTrend()
		}
	}Else {	// 按天统计
		Set StatName=aDateFrom_"至"_aDateTo
		Quit:$p(aDateFrom,"-",3)=""
		Quit:$p(aDateTo,"-",3)=""
		Set DateFrom=aDateFrom
		Set DateTo=aDateTo
		
		Do BuildTubeTrend()
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
	
BuildTubeTrend()
	Set DateFrom=$zdh(DateFrom,3)
	Set DateTo=$zdh(DateTo,3)
	Quit:(DateFrom>DateTo) 
 	Quit:DateFrom>+$h 
 	Set:DateTo>+$h DateTo=+$h

	Set (InPat,InDays)=0
	Set (VAPCount,VAPDays,VAPInfectPat,VAPINFCount)=0
	Set (PICCCount,PICCDays,PICCInfectPat,PICCINFCount)=0
	Set (UCCount,UCDays,UCInfectPat,UCINFCount)=0
	Set (CVCCount,CVCDays,CRRTCount,CRRTDays)=0
	Set (PORTCount,PORTDays,PICCsCount,PICCsDays)=0 	
   
    Set VAPRatio="0.00%",VAPINFRatio="0.000‰",PICCRatio="0.00%",PICCINFRatio="0.000‰",UCRatio="0.00%",UCINFRatio="0.000‰"
	Set CVCRatio="0.00%",CRRTRatio="0.00%",PORTRatio="0.00%",PICCsRatio="0.00%"

 	If (aFlag="O") { //出院患者		
		Set DishPatArr=..GetDishPatient(aHospIDs,DateFrom,DateTo)
	    For index=1:1:DishPatArr.Count() {
		    Set DishPat=DishPatArr.GetAt(index)
		    Set Paadm	= $li(DishPat,1)
		    Set HospDr	= $li(DishPat,2)
		    Set GroupDr	= $li(DishPat,3)
		    Set LocDr	= $li(DishPat,4)
		    Set WardDr	= $li(DishPat,5)
		    Set AdmDate	= $li(DishPat,6)
		    Set DishDate= $li(DishPat,7)
		    
		    Set LocID = LocDr
			Set:aLocType="W" LocID=WardDr
		    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))    
			// 全院出院患者人数
			If '$d(^TMP($zn,$j,NIndex,"PatAdm",StatName,Paadm)){
				Set InPat=InPat+1
				Set ^TMP($zn,$j,NIndex,"PatAdm",StatName,Paadm)=""
			}
			
			//患者住院天数
			Set InDays=DishDate-AdmDate
			Set:InDays>0 ^TMP($zn,$j,NIndex,"InDays",StatName) = +$g(^TMP($zn,$j,NIndex,"InDays",StatName))+InDays 
	
			//插管天数
			For xType = 1:1:ListLen {
				Set TubeType=$lg(TubeTypeList,xType)	
				Set PatTubeDays=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays("",Paadm,AdmDate,DishDate,"",TubeType,aLocType)
				
				If PatTubeDays>0 {   //插管人数
					If '$d(^TMP($zn,$j,NIndex,"TubePat",StatName,Paadm,TubeType)){
						Set ^TMP($zn,$j,NIndex,"TubePat",StatName,Paadm,TubeType)=""
						Set Num=$i(^TMP($zn,$j,NIndex,"TubeCount",StatName,TubeType))  //插管人数
					}
					Set ^TMP($zn,$j,NIndex,"TubeDays",StatName,TubeType)=$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,TubeType))+PatTubeDays
				}
				// 科室患者插管感染(不判断是否插管患者)
				Continue:((",VAP,UC,PICC,")'[(","_TubeType_","))   //其他类型无需判断
				Set InfPosInfo=##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,TubeType,AdmDate,DishDate)
				If (InfPosInfo'="") {
					If ('$d(^TMP($zn,$j,NIndex,"InfPat",StatName,Paadm,TubeType))) {
						Set ^TMP($zn,$j,NIndex,"InfPat",StatName,Paadm,TubeType)=""												
						Set Num=$i(^TMP($zn,$j,NIndex,"InfPat",StatName,TubeType))   //感染人数
					}
					Set InfCount=$Length(InfPosInfo,"|")
					Set ^TMP($zn,$j,NIndex,"InfCount",StatName,TubeType)=$g(^TMP($zn,$j,NIndex,"InfCount",StatName,TubeType))+InfCount
				}
			}
	    }
	} Else {   //住院患者
	    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
	    Quit:TypeDr="" 
	    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aLocType,0))
	    Quit:LocTypeDr="" 
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
						
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set HospDr=$li(LocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		
		    Set ListLocArray=..GetLocEpisByDate(DateFrom,DateTo,aLocType,xLocID,"I")  
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
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
				}
				Continue:Paadm=""
				// 全院住院患者人数
				If '$d(^TMP($zn,$j,NIndex,"PatAdm",StatName,Paadm)){
					Set InPat=InPat+1
					Set ^TMP($zn,$j,NIndex,"PatAdm",StatName,Paadm)=""
				}
				
				//计算插管人数+插管天数
				Set InDays=..GetInDays(Paadm,DateFrom,DateTo,TransIDs)
				//同期在科天数
				Set:InDays>0 ^TMP($zn,$j,NIndex,"InDays",StatName) = +$g(^TMP($zn,$j,NIndex,"InDays",StatName))+InDays 

				Set DaysInfo =##class(DHCHAI.STATV2.ICUTotalStat).GetDaysInfo(LocID,Paadm,DateFrom,DateTo,"")
	            Set VAPDays  = +$p(DaysInfo,"^",1)
				Set PICCDays = +$p(DaysInfo,"^",2)
				Set UCDays   = +$p(DaysInfo,"^",3)
				Set CVCDays  = +$p(DaysInfo,"^",4)
				Set CRRTDays = +$p(DaysInfo,"^",5)
				Set PORTDays = +$p(DaysInfo,"^",6)
				Set PICCsDays = +$p(DaysInfo,"^",7)
				Set arrTubeDays=$lb(VAPDays,UCDays,PICCDays,CVCDays,CRRTDays,PORTDays,PICCsDays)
				
				// 全院科室患者
				For xType = 1:1:ListLen {
					Set TubeType=$lg(TubeTypeList,xType)	
					If ($lg(arrTubeDays,xType)>0){
						If ('$d(^TMP($zn,$j,NIndex,"TubePat",StatName,Paadm,TubeType))) {
							Set ^TMP($zn,$j,NIndex,"TubePat",StatName,Paadm,TubeType)=""												
							Set Num=$i(^TMP($zn,$j,NIndex,"TubeCount",StatName,TubeType))  //插管人数
						}
						Set ^TMP($zn,$j,NIndex,"TubeDays",StatName,TubeType)=$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,TubeType))+$lg(arrTubeDays,xType)
					}
					
					// 科室患者插管感染(不判断是否插管患者)
					Continue:((",VAP,UC,PICC,")'[(","_TubeType_","))   //其他类型无需判断
					Set InfPosInfo=##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,TubeType,DateFrom,DateTo,LocDr,WardDr)
					If (InfPosInfo'="") {
						If ('$d(^TMP($zn,$j,NIndex,"InfPat",StatName,Paadm,TubeType))) {
							Set ^TMP($zn,$j,NIndex,"InfPat",StatName,Paadm,TubeType)=""												
							Set Num=$i(^TMP($zn,$j,NIndex,"InfPat",StatName,TubeType))   //感染人数
						}
						Set InfCount=$Length(InfPosInfo,"|")
						Set ^TMP($zn,$j,NIndex,"InfCount",StatName,TubeType)=$g(^TMP($zn,$j,NIndex,"InfCount",StatName,TubeType))+InfCount
					}
				}			
		    }
		}
	}
	
	Set InDays		 =+$g(^TMP($zn,$j,NIndex,"InDays",StatName))			// 住院天数
	Set VAPCount	 =+$g(^TMP($zn,$j,NIndex,"TubeCount",StatName,"VAP"))	// 呼吸机插管人数
	Set VAPDays		 =+$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,"VAP"))	// 呼吸机插管天数
	Set VAPInfectPat =+$g(^TMP($zn,$j,NIndex,"InfPat",StatName,"VAP"))		// 呼吸机感染人数
	Set VAPINFCount	 =+$g(^TMP($zn,$j,NIndex,"InfCount",StatName,"VAP"))	// 呼吸机感染例次数
	Set PICCCount	 =+$g(^TMP($zn,$j,NIndex,"TubeCount",StatName,"PICC")) 	// 血管导管插管人数
	Set PICCDays	 =+$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,"PICC"))	// 血管导管插管天数
	Set PICCInfectPat=+$g(^TMP($zn,$j,NIndex,"InfPat",StatName,"PICC"))		// 血管导管感染人数
	Set PICCINFCount =+$g(^TMP($zn,$j,NIndex,"InfCount",StatName,"PICC"))	// 血管导管感染例次数
	Set UCCount		 =+$g(^TMP($zn,$j,NIndex,"TubeCount",StatName,"UC"))	// 导尿管插管人数
	Set UCDays		 =+$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,"UC"))		// 导尿管插管天数
	Set UCInfectPat	 =+$g(^TMP($zn,$j,NIndex,"InfPat",StatName,"UC"))		// 导尿管感染人数
	Set UCINFCount   =+$g(^TMP($zn,$j,NIndex,"InfCount",StatName,"UC"))		// 导尿管感染例次数
	
	Set CVCCount	 =+$g(^TMP($zn,$j,NIndex,"TubeCount",StatName,"CVC"))	// 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管人数
	Set CVCDays	     =+$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,"CVC"))	// 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管天数
	Set CRRTCount	 =+$g(^TMP($zn,$j,NIndex,"TubeCount",StatName,"CRRT"))	// 中央血管导管(CRRT)插管人数
	Set CRRTDays	 =+$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,"CRRT"))	// 中央血管导管(CRRT)插管天数
	Set PORTCount	 =+$g(^TMP($zn,$j,NIndex,"TubeCount",StatName,"PORT"))	// 中央血管导管(PORT)插管人数
	Set PORTDays	 =+$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,"PORT"))	// 中央血管导管(PORT)插管天数
	Set PICCsCount	 =+$g(^TMP($zn,$j,NIndex,"TubeCount",StatName,"PICCs"))	// 总中央血管导管插管人数
	Set PICCsDays	 =+$g(^TMP($zn,$j,NIndex,"TubeDays",StatName,"PICCs"))	// 总中央血管导管插管天数
	
	If (ICUPatLogSplit=1) {
		Set PICCCount=PICCsCount
		Set PICCDays=PICCsDays
	}
	Set:InDays>0 VAPRatio=$fn((VAPDays/InDays)*100,"",2)_"%"
	Set:VAPDays>0 VAPINFRatio=$fn((VAPINFCount/VAPDays)*1000,"",3)_"‰"
	Set:InDays>0 PICCRatio=$fn((PICCDays/InDays)*100,"",2)_"%"
	Set:PICCDays>0 PICCINFRatio=$fn((PICCINFCount/PICCDays)*1000,"",3)_"‰"
	Set:InDays>0 UCRatio=$fn((UCDays/InDays)*100,"",2)_"%"
	Set:UCDays>0 UCINFRatio=$fn((UCINFCount/UCDays)*1000,"",3)_"‰"
	
	//总插管日 插管使用率
	Set TubeDays=0,TubeRadio="0.00%"
	Set TubeDays = VAPDays+UCDays+PICCDays
	Set:InDays>0 TubeRadio=$fn((TubeDays/InDays)*100,"",2)_"%"
	
	Set DateFrom=$zd(DateFrom,3)
	Set DateTo=$zd(DateTo,3)
    Set Data=$lb(StatName,InPat,InDays,VAPDays,VAPRatio,VAPCount,VAPInfectPat,VAPINFCount,VAPINFRatio,PICCDays,PICCRatio,PICCCount,PICCInfectPat,PICCINFCount,PICCINFRatio,UCDays,UCRatio,UCCount,UCInfectPat,UCINFCount,UCINFRatio,TubeDays,TubeRadio,DateFrom,DateTo)   //DateFrom,DateTo 用于明细查询
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryTubeTrendInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeTrendInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeTrendInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeTrendInfoExecute ]
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

/// 名称: GetMonthDate
/// 描述: 获取月份天数
/// 编写者：lzhe
/// 编写日期: 2020-12-11
/// w ##class(DHCHAI.STATV2.ICUTubeTrend).GetMonthDate("2020","2")
ClassMethod GetMonthDate(aYear, aMonth)
{
	New (aYear,aMonth)
	
	Set return="30"
	Quit:aMonth="" return
	
	If (+aMonth="1")||(+aMonth="3")||(+aMonth="5")||(+aMonth="7")||(+aMonth="8")||(aMonth="10")||(aMonth="12") {
		Set return="31"
	} ElseIf (+aMonth="4")||(+aMonth="6")||(+aMonth="9")||(aMonth="11") {
		Set return="30"
	} ElseIf (+aMonth="2") {
		If (aYear'="")&&((aYear#400=0)||((aYear#4=0) && (aYear#100'=0))) {	//闰年
			Set return ="29"
		} Else {
			Set return="28"
		}
	}
	Quit return
}

}
