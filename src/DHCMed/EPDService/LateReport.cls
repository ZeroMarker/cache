Class DHCMed.EPDService.LateReport Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: chenrui
/// CreateDate: 2023-02-20
/// Description:  传染病迟报漏报统计
/// Table：       User.PAAdm、User.PAPatMas、DHCMed.EPD.Epidemic
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocs：	 科室ID（可多个） 
///               aStaType:  统计类型E：科室W：病区 
/// 		 	  aQryCon:	 是否仅显示有数据的科室 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.LateReport","QryLateInfo","2","2023-03-07","2023-03-07","","E","")
Query QryLateInfo(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocs As %String, aStaType As %String, aQryCon As %String = "1") As %Query(ROWSPEC = "LocID:%String,DescStr:%String,LocPatCount:%String,EPDLocPatCount:%String,EPDRepRatio:%String,EPDLocRepCount:%String,EPDRepCaseRatio:%String,EPDLatePatCount:%String,EPDLateRepRatio:%String,EPDLateRepCount:%String,EPDLateRepCaseRatio:%String,EPDFailPatCount:%String,EPDFailRepRatio:%String,EPDFailRepCount:%String,EPDFailRepCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryLateInfoExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocs As %String, aStaType As %String, aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	kill ^QryLateInfo("Loc")
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set TDateFrom = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set TDateTo   = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Quit:(TDateFrom>TDateTo) $$$OK
 	
    Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
    Set:aLocs'="" aLocs=","_aLocs_","
    Set:aStaType="" aStaType="E"	// 不是病区就是科室
    
    
	Set (InPatCount,LocPatCount,EPDLocPatCount,EPDLocRepCount,EPDLatePatCount,EPDLateRepCount,EPDLatePatCount,EPDLateRepCount) = 0	
	Set xLocID = ""
	For {
		Set xLocID = $o(^CTLOC(xLocID))	
		Continue:xLocID=0
		Quit:xLocID=""
		// 病区科室过滤
		Continue:($p($g(^CTLOC(+xLocID)),"^",13))'=aStaType
		// 过滤非住院科室
		//Continue:'$d(^PAC("ADMLOC",0,"AdmType","I",xLocID))
		// 获取科室描述
		Set DescStr=$p($g(^CTLOC(+xLocID)),"^",2)
		Set:$p(DescStr,"-",2)'="" DescStr=$p(DescStr,"-",2)
		Continue:((aLocs'="")&&(aLocs'[xLocID))
		// 增加医院过滤
		Set HospID=$p(^CTLOC(xLocID),"^",22)
		Continue:(aHospIDs'="")&(aHospIDs'[HospID)
		if ('$d(^QryLateInfo("Loc","0"))){
			// 获取全院住院人数
			Set InPatCount = ##class(DHCMA.Util.IO.CommonSrv).GetZYRSByLocDate(aDateFrom,aDateTo,"",aHospIDs)
			// 获取全院上报的传染病报告人数
			Set EPDAllLocPatCount = ..GetEPDPatCountByDateLoc(aDateFrom,aDateTo,"",1)
			// 获取全院上报的传染病报告数
			Set EPDAllLocRepCount = ..GetEPDPatCountByDateLoc(aDateFrom,aDateTo,"",2)
			// 获取全院迟报报告人数
			Set EPDAllLatePatCount = ..GetLateRepCountByDateLoc(aDateFrom,aDateTo,"",1)
			// 获取全院迟报报告数
			Set EPDAllLateRepCount = ..GetLateRepCountByDateLoc(aDateFrom,aDateTo,"",2)
			// 获取全院漏报报告人数
			Set EPDAllFailPatCount = ..GetFailRepCountByDateLoc(aDateFrom,aDateTo,"",1)
			
			// 获取全院漏报报告数
			Set EPDAllFailRepCount = ..GetFailRepCountByDateLoc(aDateFrom,aDateTo,"",2)
			Set ^QryLateInfo("Loc","0","全院") = $lb(InPatCount,EPDAllLocPatCount,EPDAllLocRepCount,EPDAllLatePatCount,EPDAllLateRepCount,EPDAllFailPatCount,EPDAllFailRepCount)
			
		}
		// 获取科室住院人数
		Set LocPatCount = ##class(DHCMA.Util.IO.CommonSrv).GetZYRSByLocDate(aDateFrom,aDateTo,xLocID,aHospIDs)
		// 获取科室上报的传染病报告人数
		Set EPDLocPatCount = ..GetEPDPatCountByDateLoc(aDateFrom,aDateTo,xLocID,1)
		// 获取科室上报的传染病报告数
		Set EPDLocRepCount = ..GetEPDPatCountByDateLoc(aDateFrom,aDateTo,xLocID,2)
		// 获取科室迟报报告人数
		Set EPDLatePatCount = ..GetLateRepCountByDateLoc(aDateFrom,aDateTo,xLocID,1)
		// 获取科室迟报报告数
		Set EPDLateRepCount = ..GetLateRepCountByDateLoc(aDateFrom,aDateTo,xLocID,2)
		// 获取科室漏报报告人数
		Set EPDFailPatCount = ..GetFailRepCountByDateLoc(aDateFrom,aDateTo,xLocID,1)
		// 获取科室漏报报告数
		Set EPDFailRepCount = ..GetFailRepCountByDateLoc(aDateFrom,aDateTo,xLocID,2)
		
		Set ^QryLateInfo("Loc",xLocID,DescStr) = $lb(LocPatCount,EPDLocPatCount,EPDLocRepCount,EPDLatePatCount,EPDLateRepCount,EPDFailPatCount,EPDFailRepCount)
	}
	// 输出
	Set tLocID =""
	For{
		Set tLocID = $o(^QryLateInfo("Loc",tLocID))
		Quit:tLocID=""
		Set xDescStr = ""
		For{
			Set xDescStr = $o(^QryLateInfo("Loc",tLocID,xDescStr))
			Quit:xDescStr=""
			Set LateInfo = $g(^QryLateInfo("Loc",tLocID,xDescStr))
			Set LocPatCount 	= $lg(LateInfo,1)	// 住院人数
			Set EPDLocPatCount 	= $lg(LateInfo,2)	// 科室上报的传染病报告人数
			Set EPDLocRepCount 	= $lg(LateInfo,3)	// 科室上报的传染病报告数
			Set EPDLatePatCount = $lg(LateInfo,4)	// 科室迟报报告人数
			Set EPDLateRepCount = $lg(LateInfo,5)	// 科室迟报报告数
			Set EPDFailPatCount = $lg(LateInfo,6)	// 科室漏报报告人数
			Set EPDFailRepCount = $lg(LateInfo,7)	// 科室漏报报告数
			Continue:((aQryCon=1)&&(EPDLocPatCount=0))
			Set EPDRepRatio="0.00%",EPDRepCaseRatio="0.00%"
			Set:LocPatCount>0 EPDRepRatio	  = $fn((EPDLocPatCount/LocPatCount)*100,"",2)_"%" 	// 传染病上报率
			Set:LocPatCount>0 EPDRepCaseRatio = $fn((EPDLocRepCount/LocPatCount)*100,"",2)_"%" 	// 传染病上报例次率
			
			Set EPDLateRepRatio="0.00%",EPDLateRepCaseRatio="0.00%"
			Set:EPDLocPatCount>0 EPDLateRepRatio	  = $fn((EPDLatePatCount/EPDLocPatCount)*100,"",2)_"%" 	// 传染病迟报上报率
			Set:EPDLocRepCount>0 EPDLateRepCaseRatio  = $fn((EPDLateRepCount/EPDLocRepCount)*100,"",2)_"%" 	// 传染病迟报例次率
			
			Set EPDFailRepRatio="0.00%",EPDFailRepCaseRatio="0.00%"
			Set:EPDLocPatCount>0 EPDFailRepRatio	  = $fn((EPDFailPatCount/EPDLocPatCount)*100,"",2)_"%" 	// 传染病漏报上报率
			Set:EPDLocRepCount>0 EPDFailRepCaseRatio  = $fn((EPDFailRepCount/EPDLocRepCount)*100,"",2)_"%" 	// 传染病漏报例次率
			
			Set Data=$lb(tLocID,xDescStr,LocPatCount,EPDLocPatCount,EPDRepRatio,EPDLocRepCount,EPDRepCaseRatio,EPDLatePatCount,EPDLateRepRatio,EPDLateRepCount,EPDLateRepCaseRatio,EPDFailPatCount,EPDFailRepRatio,EPDFailRepCount,EPDFailRepCaseRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	kill ^QryLateInfo("Loc")
	Quit $$$OK
}

ClassMethod QryLateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLateInfoExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenr
/// CreatDate：   2023-02-23
/// Input：   aFlag:是获取人数还是报告数  1：获取报告人数  2： 获取报告例数
/// 通过日期和科室获取该科室上报的传染病报告人数
/// w ##class(DHCMed.EPDService.LateReport).GetEPDPatCountByDateLoc("2023-01-01","2023-03-07","191")
ClassMethod GetEPDPatCountByDateLoc(aDateFrom As %String, aDateTo As %String, aLocID As %String, aFlag As %String = "") As %String
{
	new (aDateFrom,aDateTo,aLocID,aFlag)
	Set retrun = 0
	Quit:(aDateFrom="")||(aDateTo="") -2
	kill ^Temp("GetEPDPatCountByDateLoc")
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	For tmpDate=aDateFrom:1:aDateTo {
		Set tmpLoc=""
		For {
			Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
			Quit:tmpLoc=""
			// 过滤门急住院科室
			Continue:$d(^PAC("ADMLOC",0,"AdmType","O",tmpLoc))
			Continue:$d(^PAC("ADMLOC",0,"AdmType","E",tmpLoc))
			Set RepRowID=""
			For {
				Set RepRowID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,RepRowID))
				Quit:RepRowID=""
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepRowID)
				Continue:'$IsObject(objRep)
				Set EpisodeID	= objRep.MEPDText1                    // EpisodeID
				Set RepLoc		= objRep.MEPDLocDR                    // 报告科室
				Set GroupDr		= $p($g(^CTLOC(+RepLoc)),"^",19) 
				Set GroupDesc	= $p($g(^RBC("DEP",+GroupDr)),"^",2)	// 部门组（行政科室上报的报告算为漏报数据）
				Set AdmLocID 	= ""
				if (GroupDesc["行政科室"){
					Set AdmLocID = +$p($g(^PAADM(+EpisodeID)),"^",4)	// 就诊科室
					Continue:((aLocID'="")&&(aLocID'=AdmLocID)) 	// 针对上报科室是管理科室时，数据统计到临床科室
				}
				Continue:((aLocID'="")&&(AdmLocID="")&&(aLocID'=RepLoc)) 
				
				if (aFlag=1){
					Set PatientID=objRep.MEPDPapmiDR   // 病人ID
					Continue:$d(^Temp("GetEPDPatCountByDateLoc",PatientID)) // 已存在的病人不计入人数
					Set ^Temp("GetEPDPatCountByDateLoc",PatientID) = ""
					Set retrun = retrun+1
				}else{
					Set retrun = retrun+1		// 报告数=有多少ID就有多少份报告
				}
			}
		}
	}
	Quit retrun
}

/// Creator：     chenr
/// CreatDate：   2023-02-23
/// Input：   aFlag:是获取人数还是报告数  1：获取报告人数  2： 获取报告例数
/// 通过日期和科室获取该科室迟报的传染病报告人数或例次数
/// w ##class(DHCMed.EPDService.LateReport).GetLateRepCountByDateLoc("2023-01-01","2023-02-23","198")
ClassMethod GetLateRepCountByDateLoc(aDateFrom As %String, aDateTo As %String, aLocID As %String, aFlag As %String = "") As %String
{
	new (aDateFrom,aDateTo,aLocID,aFlag)
	Set retrun = 0
	Quit:(aDateFrom="")||(aDateTo="") -2
	kill ^Temp("GetLateRepCountByDateLoc")
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	For tmpDate=aDateFrom:1:aDateTo {
		Set tmpLoc=""
		For {
			Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
			Quit:tmpLoc=""
			Set RepRowID=""
			For {
				Set RepRowID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,RepRowID))
				Quit:RepRowID=""
				if (aFlag=1){
					Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepRowID)
					Continue:'$IsObject(objRep)
					Set PatientID=objRep.MEPDPapmiDR   // 病人ID
					Continue:$d(^Temp("GetLateRepCountByDateLoc",PatientID)) // 已存在的病人不计入人数
					Set ^Temp("GetLateRepCountByDateLoc",PatientID) = ""
					Set IsLateRep = ..IsLateReport(RepRowID,aLocID)
					Continue:IsLateRep=0
					Set retrun = retrun+1
				}else{
					Set IsLateRep = ..IsLateReport(RepRowID,aLocID)
					Continue:IsLateRep=0
					Set retrun = retrun+1		// 报告数=有多少ID就有多少份报告
				}
			}
		}
	}
	Quit retrun
}

/// Creator：     chenr
/// CreatDate：   2023-02-23
/// 判断是否是迟报报告
/// w ##class(DHCMed.EPDService.LateReport).IsLateReport()
ClassMethod IsLateReport(aReportID As %String, aLocID As %String = "") As %String
{
	new (aReportID,aLocID)
	Set return = 0
	Quit:aReportID="" return
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep)
	
	Set EpisodeID	= objRep.MEPDText1                    // EpisodeID
	Set RepLoc		= objRep.MEPDLocDR                    // 报告科室
	Set GroupDr		= $p($g(^CTLOC(+RepLoc)),"^",19) 
	Set GroupDesc	= $p($g(^RBC("DEP",+GroupDr)),"^",2)	// 部门组（行政科室上报的报告算为漏报数据）
	Set AdmLocID 	= ""
	if (GroupDesc["行政科室"){
		Set AdmLocID = +$p($g(^PAADM(+EpisodeID)),"^",4)	// 就诊科室
		Quit:((aLocID'="")&&(aLocID'=AdmLocID)) return	// 针对上报科室是管理科室时，数据统计到临床科室
	}
	Quit:((aLocID'="")&&(AdmLocID="")&&(aLocID'=RepLoc)) return
	
	Set RepDate=objRep.MEPDRepDate                  //报告日期
	Set DiagDate=objRep.MEPDDiagDate                //诊断日期
	// 报告日期大于诊断日期24小时即为迟报
	If ((RepDate-DiagDate)>=1){
		Set return =1
	}else{
		Set return =0
	}
	Quit return
}

/// Creator：     chenr
/// CreatDate：   2023-02-23
/// Input：   aFlag:是获取人数还是报告数  1：获取报告人数  2： 获取报告例数
/// 通过日期和科室获取该科室漏报的传染病报告人数或例次数
/// w ##class(DHCMed.EPDService.LateReport).GetFailRepCountByDateLoc("2023-01-07","2023-03-07","191","1")
ClassMethod GetFailRepCountByDateLoc(aDateFrom As %String, aDateTo As %String, aLocID As %String, aFlag As %String = "") As %String
{
	new (aDateFrom,aDateTo,aLocID,aFlag)
	Set retrun = 0
	Quit:(aDateFrom="")||(aDateTo="") -2
	kill ^Temp("GetFailRepCountByDateLoc")
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	For tmpDate=aDateFrom:1:aDateTo {
		Set tmpLoc=""
		For {
			Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
			Quit:tmpLoc=""
			Set RepRowID=""
			For {
				Set RepRowID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,RepRowID))
				Quit:RepRowID=""
				if (aFlag=1){
					Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepRowID)
					Continue:'$IsObject(objRep)
					Set PatientID=objRep.MEPDPapmiDR   // 病人ID
					Continue:$d(^Temp("GetFailRepCountByDateLoc",PatientID)) // 已存在的病人不计入人数
					Set ^Temp("GetFailRepCountByDateLoc",PatientID) = ""
					Set IsLateRep = ..IsFailReport(RepRowID,aLocID)
					Continue:IsLateRep=0
					Set retrun = retrun+1
				}else{
					Set IsLateRep = ..IsFailReport(RepRowID,aLocID)
					Continue:IsLateRep=0
					Set retrun = retrun+1		// 报告数=有多少ID就有多少份报告
				}
			}
		}
	}
	Quit retrun
}

/// Creator：     chenr
/// CreatDate：   2023-02-23
/// 判断是否是漏报报告
/// w ##class(DHCMed.EPDService.LateReport).IsFailReport(123,191)
ClassMethod IsFailReport(aReportID As %String, aLocID As %String = "") As %String
{
	new (aReportID,aLocID)
	Set return = 0
	Quit:aReportID="" return
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep)
	Set RepDate		= objRep.MEPDRepDate                  // 报告日期
	Set RepTime		= objRep.MEPDRepTime                  //报告时间
	Set EpisodeID	= objRep.MEPDText1                    // EpisodeID
	Set RepLoc		= objRep.MEPDLocDR                    // 报告科室
	Set GroupDr		= $p($g(^CTLOC(+RepLoc)),"^",19) 
	Set GroupDesc	= $p($g(^RBC("DEP",+GroupDr)),"^",2)	// 部门组（行政科室上报的报告算为漏报数据）
	Set AdmLocID 	= ""
	if (GroupDesc["行政科室"){
		Set AdmLocID = +$p($g(^PAADM(+EpisodeID)),"^",4)	// 就诊科室
		Quit:((aLocID'="")&&(aLocID'=AdmLocID)) return	// 针对上报科室是管理科室时，数据统计到临床科室
	}
	Quit:((aLocID'="")&&(AdmLocID="")&&(aLocID'=RepLoc)) return
	
	// 出院时间
    Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set FailFlag = 0
	// 报告日期大于出院日期算漏报
	if ((DischDate'="")&&(RepDate>DischDate)){
		Set FailFlag = 1
	}elseif ((DischDate'="")&&(RepDate=DischDate)&&(RepTime>DischTime)){
		// 日期相等时，判断上报时间
		Set FailFlag = 1
	}
	if (GroupDesc["行政科室"){
		Set FailFlag =1
	}
	Set return = FailFlag
	Quit return
}

/// Creator: chenrui
/// CreateDate: 2023-02-20
/// Description:  传染病迟报漏报统计明细
/// 		 	  aQryCon:	 是否仅显示有数据的科室 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.LateReport","QryLateInfoDtl","2","2023-01-07","2023-03-07","191","1","2")
Query QryLateInfoDtl(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aReportTypeCode As %String, aRepType As %String = "1") As %Query(ROWSPEC = "PapmiNo:%String,PatientName:%String,PatientSex:%String,PatientAge:%String,RepDisease:%String,AdmitDate:%String,DishDate:%String,RepDateTime:%String,RepLoc:%String,RepUserName:%String,ReportID:%String,AdmDescStr:%String") [ SqlProc ]
{
}

ClassMethod QryLateInfoDtlExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aReportTypeCode As %String, aRepType As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill ^Temp("QryLateInfoDtl")
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set DateFrom = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set DateTo   = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Quit:(DateFrom>DateTo) $$$OK
 	Set:aRepType="" aRepType =1
 	if (aLocID=0){
		For tmpDate=DateFrom:1:DateTo {
			Set tmpLoc=""
			For {
				Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
				Quit:tmpLoc=""
				// 过滤门急住院科室
				Continue:$d(^PAC("ADMLOC",0,"AdmType","O",tmpLoc))
				Continue:$d(^PAC("ADMLOC",0,"AdmType","E",tmpLoc))
				if aHospID'="" {
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(tmpLoc,aHospID)
					continue:flg<1
				}
				Set RepRowID=""
				For {
					Set RepRowID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,RepRowID))
					Quit:RepRowID=""
					Set objTTRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepRowID)
					Continue:'$IsObject(objTTRep)
					// 1:代表按患者查询
					if (aRepType=1){
						Set PatientID=objTTRep.MEPDPapmiDR   // 病人ID
						Continue:$d(^Temp("QryLateInfoDtl",PatientID)) // 已存在的病人不计入人数
						Set ^Temp("QryLateInfoDtl",PatientID) = ""
						// 1:上报
						If (aReportTypeCode=1){
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=2){
							// 2: 迟报
							Continue:(..IsLateReport(RepRowID))=0
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=3){
							// 3: 漏报
							Continue:(..IsFailReport(RepRowID))=0	
							Set tmpData=..BuildData(RepRowID)
						}
						Set ^CacheTemp(repid,ind)=tmpData
						Set ind=ind+1	
					}else{
						// 1:上报
						If (aReportTypeCode=1){
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=2){
							// 2: 迟报
							Continue:(..IsLateReport(RepRowID))=0
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=3){
							// 3: 漏报
							Continue:(..IsFailReport(RepRowID))=0	
							Set tmpData=..BuildData(RepRowID)
						}
						Set ^CacheTemp(repid,ind)=tmpData
						Set ind=ind+1
					}
				}
			}
		}
	}else{
		For tmpDate=DateFrom:1:DateTo {
			Set tmpLoc=""
			For {
				Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
				Quit:tmpLoc=""
				
				// 过滤门急住院科室
				Continue:$d(^PAC("ADMLOC",0,"AdmType","O",tmpLoc))
				Continue:$d(^PAC("ADMLOC",0,"AdmType","E",tmpLoc))
				if aHospID'="" {
					Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(tmpLoc,aHospID)
					Continue:flg<1
				}
				Set RepRowID=""
				For {
					Set RepRowID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,RepRowID))
					Quit:RepRowID=""
					Set objTTRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepRowID)
					Continue:'$IsObject(objTTRep)
					Set EpisodeID	= objTTRep.MEPDText1                    // EpisodeID
					Set RepLoc		= objTTRep.MEPDLocDR                    // 报告科室
					Set GroupDr		= $p($g(^CTLOC(+RepLoc)),"^",19) 
					Set GroupDesc	= $p($g(^RBC("DEP",+GroupDr)),"^",2)	// 部门组（行政科室上报的报告算为漏报数据）
					Set AdmLocID 	= ""
					// 1:代表按患者查询
					if (aRepType=1){
						Set PatientID=objTTRep.MEPDPapmiDR   // 病人ID
						Continue:$d(^Temp("QryLateInfoDtl",PatientID)) // 已存在的病人不计入人数
						Set ^Temp("QryLateInfoDtl",PatientID) = ""
						// 1:上报
						If (aReportTypeCode=1){
							if (GroupDesc["行政科室"){
								Set AdmLocID = +$p($g(^PAADM(+EpisodeID)),"^",4)	// 就诊科室
								Continue:((aLocID'="")&&(aLocID'=AdmLocID)) 	// 针对上报科室是管理科室时，数据统计到临床科室
							}
							Continue:((aLocID'="")&&(AdmLocID="")&&(aLocID'=RepLoc)) 
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=2){
							// 2: 迟报
							Continue:(..IsLateReport(RepRowID,aLocID))=0
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=3){
							// 3: 漏报
							Continue:(..IsFailReport(RepRowID,aLocID))=0	
							Set tmpData=..BuildData(RepRowID)
						}
						Set ^CacheTemp(repid,ind)=tmpData
						Set ind=ind+1	
					}else{
						// 1:上报
						If (aReportTypeCode=1){
							if (GroupDesc["行政科室"){
								Set AdmLocID = +$p($g(^PAADM(+EpisodeID)),"^",4)	// 就诊科室
								Continue:((aLocID'="")&&(aLocID'=AdmLocID)) 	// 针对上报科室是管理科室时，数据统计到临床科室
							}
							Continue:((aLocID'="")&&(AdmLocID="")&&(aLocID'=RepLoc)) 
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=2){
							// 2: 迟报
							Continue:(..IsLateReport(RepRowID,aLocID))=0
							Set tmpData=..BuildData(RepRowID)
						}elseif(aReportTypeCode=3){
							// 3: 漏报
							Continue:(..IsFailReport(RepRowID,aLocID))=0	
							Set tmpData=..BuildData(RepRowID)
						}
						Set ^CacheTemp(repid,ind)=tmpData
						Set ind=ind+1
					}
				}
			}
		}
	}
    
    Quit $$$OK
}

ClassMethod QryLateInfoDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLateInfoDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLateInfoDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLateInfoDtlExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildData(xReportID As %String) As %List
{
	new (xReportID)
	Set (PapmiNo,PatientName,PatientSex,PatientAge,RepDisease,AdmitDate,DishDate,RepDateTime,RepLoc,RepUserName,AdmDescStr)=""
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xReportID)
	Quit:'$IsObject(objRep)
	Set PatientID=objRep.MEPDPapmiDR                //PatientID
	Set EpisodeID=objRep.MEPDText1                  //EpisodeID
    Set RepDate=objRep.MEPDRepDate                  //报告日期
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatientName=objPatient.PatientName      //姓名
		Set PatientSex=objPatient.Sex               //性别
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		// 根据上报日期给年龄赋值
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,RepDate,RepTime)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		Set:AdmitTime'="" AdmitTime=##Class(DHCMed.SSService.CommonCls).ChangeTimeFormat(AdmitTime)
		Set AdmitDate = AdmDate_" "_AdmitTime
	    Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
		Set DischDate=$p(DischDateTime,"^",1)
		Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
		Set DischTime=$p(DischDateTime,"^",2)
		Set:DischTime'="" DischTime=##Class(DHCMed.SSService.CommonCls).ChangeTimeFormat(DischTime)
		Set DishDate = DischDate_" "_DischTime
	}
	
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set:RepTime'="" RepTime=##Class(DHCMed.SSService.CommonCls).ChangeTimeFormat(RepTime)
	Set RepDateTime = RepDate_" "_RepTime
    Set DiseaseDr = objRep.MEPDICDDR.%Id()
	If $IsObject(objRep.MEPDICDDR){
		Set RepDisease=objRep.MEPDICDDR.MIFDisease	//疾病名称
	}
    Set RepLoc=objRep.MEPDLocDR                     //报告科室
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLoc=objRepLoc.Descs
	}
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserName=objRepUser.Name
	}
	Set AdmLocID = +$p($g(^PAADM(+EpisodeID)),"^",4)	// 就诊科室
	// 获取科室描述
	Set AdmDescStr=$p($g(^CTLOC(+AdmLocID)),"^",2)
	Set:$p(AdmDescStr,"-",2)'="" AdmDescStr=$p(AdmDescStr,"-",2)
	
	Set data=$lb("")
	Set $li(data,1)=PapmiNo 
	Set $li(data,2)=PatientName 
	Set $li(data,3)=PatientSex 
	Set $li(data,4)=PatientAge 
	Set $li(data,5)=RepDisease 
	Set $li(data,6)=AdmitDate 
	Set $li(data,7)=DishDate 
	Set $li(data,8)=RepDateTime 
	Set $li(data,9)=RepLoc 
	Set $li(data,10)=RepUserName 
	Set $li(data,11)=xReportID
	Set $li(data,12)=AdmDescStr
	
	Quit data
}

}
