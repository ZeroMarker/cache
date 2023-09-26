/// 名称: DHCHAI.STAT.S270AIncAntDay
/// 描述: Ⅰ类切口手术预防使用抗菌药物天数统计表
/// 编写者：zhoubo
/// 编写日期: 2018-07-12
Class DHCHAI.STAT.S270AIncAntDay Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-07-12
/// Description:  获取一段时间内使用预防抗菌药物天数
/// Return：      使用抗菌药物天数
/// w ##class(DHCHAI.STAT.S270AIncAntDay).GetUesAntiDays(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod GetUesAntiDays(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=0
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	Set MinDate=+$h
	Set MaxDate=0
	Set UseAntiFlag=0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:(xSCode="")
		
		For xSttDate=aFromDate:1:aToDate {
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:(xID="")
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive=0
				Set AntUsePurpose = objOrdItem.OEAntUsePurpose
				Continue:AntUsePurpose'["预防"
				Set OESttDate = objOrdItem.OESttDate   // 执行医嘱日期
				Set OESttTime = objOrdItem.OESttTime   // 执行医嘱时间
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(OESttTime<aFromTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(OESttTime>aToTime))
				}
				Set OEXDate = objOrdItem.OEXDate       // 停止医嘱日期
				Set OEXTime = objOrdItem.OEXTime       // 停止医嘱时间
				Set:OESttDate<MinDate MinDate=OESttDate
				Set:OEXDate>MaxDate MaxDate=OEXDate
				Set UseAntiFlag=1
			}
		}
	}
	Quit:UseAntiFlag'=1 return     // 无预防抗菌药物
	Set:MaxDate=0 MaxDate=+$h      // 使用了预防抗菌药物,但都没有停止医嘱
	Set return=(MaxDate-MinDate)+1 // 如果无预防抗菌药物,加1也不影响两者之差
	Set:return<0 return=0
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-07-12
/// Description:  Ⅰ类切口手术预防使用抗菌药物天数
/// Table：       DHCHAI.DP.OROperAnaes,DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S270AIncAntDay","QryAIncAntDay","","2017-07-12","2017-12-21")
Query QryAIncAntDay(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,EpisodeDr:%String,OperICD:%String,OperDesc:%String,OperHour:%Integer,OperLocID:%String,OperLocDesc:%String,OperWardDr:%String,OperWardDesc:%String,LocTypeDesc:%String,MapIncDicDesc:%String,MapASADicDesc:%String,MapNNISDicDesc:%String,MapHealDicDesc:%String,InfPosDesc:%String,IRIsOperInf:%String,OperType:%String,UesAntiDays:%Integer") [ SqlProc ]
{
}

ClassMethod QryAIncAntDayExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xOperLocDr)
				Set HospID=$p(HospInfo,"^",1)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 	Continue:'$IsObject(obj.OREpisodeDr)
				 	
				 	Do BuildDataAIncAntDay
				}
			}
		}
	}
	Quit $$$OK
	
BuildDataAIncAntDay
 	Set EpisodeDr   = obj.OREpisodeDr.%Id()
	Set EpisodeID   = obj.OREpisodeDr.PAEpisodeIDx
	Set PatientID   = obj.OREpisodeDr.PAPatientIDx
	Set PapmiNo     = obj.OREpisodeDr.PAPapmiNo
	
	// 手术信息
	Set OperICD     = obj.OROperICD          // 手术ICD
	Set OperDesc    = obj.OROperDesc         // 手术名称
	Set OperHour    = +obj.OROperHour        // 手术时长
	Set OperLocID="",OperLocDesc=""
	If $IsObject(obj.OROperLocDr) {
		Set OperLocID   = obj.OROperLocDr.%Id()     // 手术科室ID
		Set OperLocDesc = obj.OROperLocDr.BTDesc    // 手术科室
		Set OperLocDesc2 = obj.OROperLocDr.BTDesc2  // 手术科室2
		Set:OperLocDesc'="" OperLocDesc=OperLocDesc2
		Set:$p(OperLocDesc,"-",2)'="" OperLocDesc=$p(OperLocDesc,"-",2)
	}
	Quit:OperLocDesc=""
	Set OperDate  = obj.OROperDate
	Set ORSttTime = obj.ORSttTime
	
	// 判断是否使用抗菌药物,术前2小时术后24小时使用预防抗菌药物
	Set ChangeDateInfo1 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,"-2",1)
	Set Date1 = $p(ChangeDateInfo1," ",1)
	Set Time1 = $p(ChangeDateInfo1," ",2)
	Set ChangeDateInfo2 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,"24",1)
	Set Date2 = $p(ChangeDateInfo2," ",1)
	Set Time2 = $p(ChangeDateInfo2," ",2)
	// 获取本例手术预防用药天数,一天内（00:00:01 24:00:00）使用多种抗生素计算为1天
	Set UesAntiDays=..GetUesAntiDays(EpisodeDr,Date1,Time1,Date2,Time2)
	Quit:UesAntiDays<1   // 无预防抗菌药物
	// 患者手术时所在的科室病区
	Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
	Quit:OperLocWard=""
	Set OperLocDr  = $p(OperLocWard,"^",1) // 科室
	Set OperWardDr = $p(OperLocWard,"^",2) // 病区
	// 手术科室
	Set objOperLoc = ##class(DHCHAI.BT.Location).GetObjById(OperLocDr)
	Quit:'$IsObject(objOperLoc)
	If ($IsObject(objOperLoc.BTGroupDr)){
		Set LocTypeDesc = objOperLoc.BTGroupDr.BTDesc  // 科室分类
	}Else {
		Set LocTypeDesc="其他科"
	}
	Set OperLocDesc=objOperLoc.BTDesc2
	Set:OperLocDesc="" OperLocDesc=objOperLoc.BTDesc
	Set:OperLocDesc["-" OperLocDesc=$p(OperLocDesc,"-",2)
	// 手术病区
	Set objOperWard = ##class(DHCHAI.BT.Location).GetObjById(OperWardDr)
	Quit:'$isobject(objOperWard)
	Set OperWardDesc=objOperWard.BTDesc2
	Set:OperWardDesc="" OperWardDesc=objOperWard.BTDesc
	Set:OperWardDesc["-" OperWardDesc=$p(OperWardDesc,"-",2)
	Quit:OperWardDesc=""
	
	Set Incision = obj.ORIncision         // 切口等级
	Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
	If (IncisionInfo'="") {
		Set MapIncDicDR   = $p(IncisionInfo,"^",1)
		Set MapIncDicCode = $p(IncisionInfo,"^",2)
		Set MapIncDicDesc = $p(IncisionInfo,"^",3)
	}Else {
		Set MapIncDicDR   = ""
		Set MapIncDicCode = ""
		Set MapIncDicDesc = Incision
	}
	Set ASAScore = obj.ORASAScore   // ASA评分
	Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
	If (ASAScoreInfo'="") {
		Set MapASADicDR   = $p(ASAScoreInfo,"^",1)
		Set MapASADicCode = $p(ASAScoreInfo,"^",2)
		Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
	}Else {
		Set MapASADicDR   = ""
		Set MapASADicCode = ""
		Set MapASADicDesc = ASAScore
	}
	Set NNISGrade   = obj.ORNNISGrade        // NNIS分级
	Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
	If (NNISGradeInfo'="") {
		Set MapNNISDicDR   = $p(NNISGradeInfo,"^",1)
		Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
		Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
	}Else {
		Set MapNNISDicDR   = ""
		Set MapNNISDicCode = ""
		Set MapNNISDicDesc = NNISGrade
	}
	Set ORHealing = obj.ORHealing        // 愈合情况
	Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",ORHealing)  
	If (HealingInfo'="") {
		Set MapHealDicDR   = $p(HealingInfo,"^",1)
		Set MapHealDicCode = $p(HealingInfo,"^",2)
		Set MapHealDicDesc = $p(HealingInfo,"^",3)
	}Else {
		Set MapHealDicDR   = ""
		Set MapHealDicCode = ""
		Set MapHealDicDesc = ORHealing
	}
	Set IsImplants = obj.ORIsImplants   // 是否植入物
	Set OperType   = obj.OROperType     // 手术类型  
	// 手术切口调查表
	Set (ReportID,InfPosDesc,IROperName,IRImplantFlag,IROperHours,IRIsOperInf)=""
	Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjByEpOperDr(EpisodeDr,xID)
	If ($IsObject(objINFOPS)) {
		Set ReportID      = objINFOPS.%Id()
		Set IROperName    = objINFOPS.IROperName       // 标准手术名称
		Set IRIsOperInf   = objINFOPS.IRIsOperInf      // 是否切口感染
		Set IRImplantFlag = objINFOPS.IRImplantFlag    // 是否有植入物
		Set IROperHours   = objINFOPS.IROperHours      // 手术时长
		Set IRNNISLevelDr = objINFOPS.IRNNISLevelDr
		If $IsObject(objINFOPS.IRNNISLevelDr){
			Set IRNNISLevelDesc = objINFOPS.IRNNISLevelDr.BTDesc
			Set:IRNNISLevelDesc'="" MapNNISDicDesc=IRNNISLevelDesc
		}
		If $IsObject(objINFOPS.IROperTypeDr){
			Set OperTypeDesc = objINFOPS.IROperTypeDr.BTDesc
			Set:OperTypeDesc'="" OperType=OperTypeDesc
		}
		If $IsObject(objINFOPS.IRASAScore){
			Set IRASAScoreDesc = objINFOPS.IRASAScore.BTDesc
			Set:IRASAScoreDesc'="" MapASADicDesc=IRASAScoreDesc
		}
		If $IsObject(objINFOPS.IRCuteTypeDr){
			Set IRCuteTypeDesc = objINFOPS.IRCuteTypeDr.BTDesc
			Set:IRCuteTypeDesc'="" MapIncDicDesc=IRCuteTypeDesc
		}
		If $IsObject(objINFOPS.IRCuteHealingDr){
			Set HealingDesc = objINFOPS.IRCuteHealingDr.BTDesc
			Set:HealingDesc'="" MapHealDicDesc=HealingDesc
		}
		If $IsObject(objINFOPS.IRInfTypeDr){
			Set InfPosDesc = objINFOPS.IRInfTypeDr.BTDesc  // 感染部位
		}
	}
	Quit:(MapIncDicDesc="")||(MapIncDicDesc'="Ⅰ类")  // Ⅰ类切口过滤
	Set:IROperName'="" OperDesc=IROperName
	// 计算NNIS分级
	If (MapNNISDicDesc="") {
		Set:OperHour>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1
	}
	Set MapNNISDicDesc=+MapNNISDicDesc
	
	Set Data=$lb(xID,EpisodeDr,OperICD,OperDesc,OperHour,OperLocID,OperLocDesc,OperWardDr,OperWardDesc,LocTypeDesc,MapIncDicDesc,MapASADicDesc,MapNNISDicDesc,MapHealDicDesc,InfPosDesc,IRIsOperInf,OperType,UesAntiDays)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryAIncAntDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAntDayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAntDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAntDayExecute ]
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
/// CreatDate：   2018-07-12
/// Description:  Ⅰ类切口手术预防使用抗菌药物天数明细
/// Table：       DHCHAI.DP.OROperAnaes,DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs  : 多个医院用"|"连接
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocType  : 科室类型
///               aLocDesc  : 科室名称
///               aWardDesc : 病区名称
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S270AIncAntDay","QryAIncAntDayDtl","","2017-07-12","2017-12-21","","","")
Query QryAIncAntDayDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocDesc As %String, aWardDesc As %String) As %Query(ROWSPEC = "ID:%String,EpisodeDr:%String,MrNo:%String,PapmiNo:%String,PatName:%String,AdmDate:%String,AdmLocDesc:%String,DischDate:%String,DischLocDesc:%String,OperICD:%String,OperDesc:%String,OperHour:%Integer,OperLocID:%String,OperLocDesc:%String,OperWardDr:%String,OperWardDesc:%String,LocTypeDesc:%String,MapIncDicDesc:%String,MapASADicDesc:%String,MapNNISDicDesc:%String,MapHealDicDesc:%String,InfPosDesc:%String,IRIsOperInf:%String,OperType:%String,UesAntiDays:%Integer,OperDateTime:%String,OREndDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAIncAntDayDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocDesc As %String, aWardDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xOperLocDr)
				Set HospID=$p(HospInfo,"^",1)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 	Continue:'$IsObject(obj.OREpisodeDr)
				 	
				 	Do BuildDataAIncAntDayDtl
				}
			}
		}
	}
	Quit $$$OK
	
BuildDataAIncAntDayDtl
 	Set EpisodeDr   = obj.OREpisodeDr.%Id()
	Set EpisodeID   = obj.OREpisodeDr.PAEpisodeIDx
	Set PatientID   = obj.OREpisodeDr.PAPatientIDx
	Set PapmiNo     = obj.OREpisodeDr.PAPapmiNo
	// 患者信息
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objPaadm)
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo    = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set AdmDate = objPaadm.PAAdmDate  // 入院日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""                 // 入院科室
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc  = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set DischDate = objPaadm.PADischDate  // 出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set objDischLoc = objPaadm.PADischLocDr  //出院科室
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	// 手术信息
	Set OperICD     = obj.OROperICD          // 手术ICD
	Set OperDesc    = obj.OROperDesc         // 手术名称
	Set OperHour    = +obj.OROperHour        // 手术时长
	Set OperLocID="",OperLocDesc=""
	If $IsObject(obj.OROperLocDr) {
		Set OperLocID   = obj.OROperLocDr.%Id()     // 手术科室ID
		Set OperLocDesc = obj.OROperLocDr.BTDesc    // 手术科室
		Set OperLocDesc2 = obj.OROperLocDr.BTDesc2  // 手术科室2
		Set:OperLocDesc'="" OperLocDesc=OperLocDesc2
		Set:$p(OperLocDesc,"-",2)'="" OperLocDesc=$p(OperLocDesc,"-",2)
	}
	Quit:OperLocDesc=""
	Set OperDate  = obj.OROperDate
	Set ORSttTime = obj.ORSttTime
	
	// 获取预防应用抗菌药物医嘱ID,术前2小时术后24小时使用预防抗菌药物
	Set ChangeDateInfo1 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,"-2",1)
	Set Date1 = $p(ChangeDateInfo1," ",1)
	Set Time1 = $p(ChangeDateInfo1," ",2)
	Set ChangeDateInfo2 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,"24",1)
	Set Date2 = $p(ChangeDateInfo2," ",1)
	Set Time2 = $p(ChangeDateInfo2," ",2)
	// 获取本例手术预防用药天数,一天内（00:00:01 24:00:00）使用多种抗生素计算为1天
	Set UesAntiDays =..GetUesAntiDays(EpisodeDr,Date1,Time1,Date2,Time2)
	Quit:UesAntiDays<1  // 无预防使用抗菌药物
	// 患者手术时所在的科室病区
	Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
	Quit:OperLocWard=""
	Set OperLocDr  = $p(OperLocWard,"^",1) // 科室
	Set OperWardDr = $p(OperLocWard,"^",2) // 病区
	// 手术科室
	Set objOperLoc = ##class(DHCHAI.BT.Location).GetObjById(OperLocDr)
	Quit:'$IsObject(objOperLoc)
	If ($IsObject(objOperLoc.BTGroupDr)){
		Set LocTypeDesc = objOperLoc.BTGroupDr.BTDesc  // 科室分类
	}Else {
		Set LocTypeDesc="其他科"
	}
	Quit:(aLocType'="")&&(aLocType'=LocTypeDesc) // 科室类型过滤
	Set OperLocDesc=objOperLoc.BTDesc2
	Set:OperLocDesc="" OperLocDesc=objOperLoc.BTDesc
	Set:OperLocDesc["-" OperLocDesc=$p(OperLocDesc,"-",2)
	Quit:(aLocDesc'="")&&(aLocDesc'=OperLocDesc) // 科室过滤
	// 手术病区
	Set objOperWard = ##class(DHCHAI.BT.Location).GetObjById(OperWardDr)
	Quit:'$isobject(objOperWard)
	Set OperWardDesc=objOperWard.BTDesc2
	Set:OperWardDesc="" OperWardDesc=objOperWard.BTDesc
	Set:OperWardDesc["-" OperWardDesc=$p(OperWardDesc,"-",2)
	Quit:OperWardDesc=""
	Quit:(aWardDesc'="")&&(aWardDesc'=OperWardDesc) // 病区过滤
	Set Incision = obj.ORIncision         // 切口等级
	Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
	If (IncisionInfo'="") {
		Set MapIncDicDR   = $p(IncisionInfo,"^",1)
		Set MapIncDicCode = $p(IncisionInfo,"^",2)
		Set MapIncDicDesc = $p(IncisionInfo,"^",3)
	}Else {
		Set MapIncDicDR   = ""
		Set MapIncDicCode = ""
		Set MapIncDicDesc = Incision
	}
	Set ASAScore = obj.ORASAScore   // ASA评分
	Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
	If (ASAScoreInfo'="") {
		Set MapASADicDR   = $p(ASAScoreInfo,"^",1)
		Set MapASADicCode = $p(ASAScoreInfo,"^",2)
		Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
	}Else {
		Set MapASADicDR   = ""
		Set MapASADicCode = ""
		Set MapASADicDesc = ASAScore
	}
	Set NNISGrade   = obj.ORNNISGrade        // NNIS分级
	Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
	If (NNISGradeInfo'="") {
		Set MapNNISDicDR   = $p(NNISGradeInfo,"^",1)
		Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
		Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
	}Else {
		Set MapNNISDicDR   = ""
		Set MapNNISDicCode = ""
		Set MapNNISDicDesc = NNISGrade
	}
	Set ORHealing = obj.ORHealing        // 愈合情况
	Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",ORHealing)  
	If (HealingInfo'="") {
		Set MapHealDicDR   = $p(HealingInfo,"^",1)
		Set MapHealDicCode = $p(HealingInfo,"^",2)
		Set MapHealDicDesc = $p(HealingInfo,"^",3)
	}Else {
		Set MapHealDicDR   = ""
		Set MapHealDicCode = ""
		Set MapHealDicDesc = ORHealing
	}
	Set IsImplants = obj.ORIsImplants   // 是否植入物
	Set OperType   = obj.OROperType     // 手术类型 
	Set OREndDate  = obj.OREndDate
	Set OREndTime  = obj.OREndTime
	Set:OperDate'="" OperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
	Set:ORSttTime'="" ORSttTime = $zt(ORSttTime,1)
	Set OperDateTime=OperDate_" "_ORSttTime
	Set:OREndDate'="" OREndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OREndDate)
	Set:OREndTime'="" OREndTime = $zt(OREndTime,1)
	Set OREndDateTime=OREndDate_" "_OREndTime  
	// 手术切口调查表
	Set (ReportID,InfPosDesc,IROperName,IRImplantFlag,IROperHours,IRIsOperInf)=""
	Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjByEpOperDr(EpisodeDr,xID)
	If ($IsObject(objINFOPS)) {
		Set ReportID      = objINFOPS.%Id()
		Set IROperName    = objINFOPS.IROperName       // 标准手术名称
		Set IRIsOperInf   = +objINFOPS.IRIsOperInf     // 是否切口感染
		Set IRImplantFlag = objINFOPS.IRImplantFlag    // 是否有植入物
		Set IROperHours   = objINFOPS.IROperHours      // 手术时长
		Set OperDate = objINFOPS.IROperDate
		Set ORSttTime = objINFOPS.IRSttTime
		Set OREndDate = objINFOPS.IREndDate
		Set OREndTime = objINFOPS.IREndTime
		
		Set:OperDate'="" OperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
		Set:ORSttTime'="" ORSttTime = $zt(ORSttTime,1)
		Set OperDateTime=OperDate_" "_ORSttTime
		Set:OREndDate'="" OREndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OREndDate)
		Set:OREndTime'="" OREndTime = $zt(OREndTime,1)
		Set OREndDateTime=OREndDate_" "_OREndTime 
		Set IRNNISLevelDr = objINFOPS.IRNNISLevelDr
		If $IsObject(objINFOPS.IRNNISLevelDr){
			Set IRNNISLevelDesc = objINFOPS.IRNNISLevelDr.BTDesc
			Set:IRNNISLevelDesc'="" MapNNISDicDesc=IRNNISLevelDesc
		}
		If $IsObject(objINFOPS.IROperTypeDr){
			Set OperTypeDesc = objINFOPS.IROperTypeDr.BTDesc
			Set:OperTypeDesc'="" OperType=OperTypeDesc
		}
		If $IsObject(objINFOPS.IRASAScore){
			Set IRASAScoreDesc = objINFOPS.IRASAScore.BTDesc
			Set:IRASAScoreDesc'="" MapASADicDesc=IRASAScoreDesc
		}
		If $IsObject(objINFOPS.IRCuteTypeDr){
			Set IRCuteTypeDesc = objINFOPS.IRCuteTypeDr.BTDesc
			Set:IRCuteTypeDesc'="" MapIncDicDesc=IRCuteTypeDesc
		}
		If $IsObject(objINFOPS.IRCuteHealingDr){
			Set HealingDesc = objINFOPS.IRCuteHealingDr.BTDesc
			Set:HealingDesc'="" MapHealDicDesc=HealingDesc
		}
		If $IsObject(objINFOPS.IRInfTypeDr){
			Set InfPosDesc = objINFOPS.IRInfTypeDr.BTDesc  // 感染部位
		}
	}
	Quit:(MapIncDicDesc="")||(MapIncDicDesc'="Ⅰ类")  // Ⅰ类切口过滤
	Set:IROperName'="" OperDesc=IROperName
	// 计算NNIS分级
	If (MapNNISDicDesc="") {
		Set:OperHour>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1
	}
	Set MapNNISDicDesc=+MapNNISDicDesc
	
	Set Data=$lb(xID,EpisodeDr,MrNo,PapmiNo,PatName,AdmDate,AdmLocDesc,DischDate,DischLocDesc,OperICD,OperDesc,OperHour,OperLocID,OperLocDesc,OperWardDr,OperWardDesc,LocTypeDesc,MapIncDicDesc,MapASADicDesc,MapNNISDicDesc,MapHealDicDesc,InfPosDesc,IRIsOperInf,OperType,UesAntiDays,OperDateTime,OREndDateTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryAIncAntDayDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAntDayDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAntDayDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAntDayDtlExecute ]
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
/// CreatDate：   2018-07-12
/// Description:  获取某例手术预防使用抗菌药物明细
/// Table：       DHCHAI.DP.OROperAnaes,DHCHAI.DP.OEOrdItem
/// Input:        aOperDr : 手术ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S270AIncAntDay","QryAntDtl","2345")
Query QryAntDtl(aOperDr As %String) As %Query(ROWSPEC = "OEItemDr:%String,OEOrdDesc:%String,OESttDateTime:%String,OEXDateTime:%String,OEAntPoison:%String,OEAntPurpose:%String,OEInstruc:%String,OEDoctor:%String") [ SqlProc ]
{
}

ClassMethod QryAntDtlExecute(ByRef qHandle As %Binary, aOperDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(aOperDr)
 	Quit:'$IsObject(obj) $$$OK
 	Quit:obj.ORIsActive'=1 $$$OK
 	Quit:'$IsObject(obj.OREpisodeDr) $$$OK
	Set EpisodeDr = obj.OREpisodeDr.%Id()
	Set OperDate  = obj.OROperDate
	Set ORSttTime = obj.ORSttTime
	
	// 获取预防应用抗菌药物医嘱ID,术前2小时术后24小时使用预防抗菌药物
	Set ChangeDateInfo1 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,"-2",1)
	Set Date1 = $p(ChangeDateInfo1," ",1)
	Set Time1 = $p(ChangeDateInfo1," ",2)
	Set ChangeDateInfo2 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,"24",1)
	Set Date2 = $p(ChangeDateInfo2," ",1)
	Set Time2 = $p(ChangeDateInfo2," ",2)
	Set AntiOEDrList=##class(DHCHAI.STAT.S260AIncAntUse).GetAntiOEDrList(EpisodeDr,Date1,Time1,Date2,Time2)
	
	// 预防使用抗菌药物信息
	For xList=1:1:$l(AntiOEDrList,","){
		Set OEItemDr =$p(AntiOEDrList,",",xList)
		Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(OEItemDr)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive=0
		Set OEOrdDesc    = objOrdItem.OEOrdDesc       // 医嘱名称
		Set OESttDate    = objOrdItem.OESttDate       // 医嘱开始日期
		Set OESttTime    = objOrdItem.OESttTime       // 医嘱开始时间
		Set:OESttDate'="" OESttDate=$zd(OESttDate,3)
		Set:OESttTime'="" OESttTime=$zt(OESttTime,1)
		Set OESttDateTime=OESttDate_" "_OESttTime
		Set OEXDate      = objOrdItem.OEXDate         // 医嘱结束日期
		Set OEXTime      = objOrdItem.OEXTime         // 医嘱结束时间
		Set:OEXDate'="" OEXDate=$zd(OEXDate,3)
		Set:OEXTime'="" OEXTime=$zt(OEXTime,1)
		Set OEXDateTime  = OEXDate_" "_OEXTime
		Set OEAntPoison  = objOrdItem.OEAntDrgPoison  // 医嘱管制分类
		Set OEAntPurpose = objOrdItem.OEAntUsePurpose // 医嘱使用目的
		Set OEInstruc    = objOrdItem.OEInstruc       // 医嘱给药途径
		Set OEDoctor     = objOrdItem.OEDoctor        // 开医嘱医生
		Set:OEDoctor["|" OEDoctor=$p(OEDoctor,"|",3)
		
		Set Data=$lb(OEItemDr,OEOrdDesc,OESttDateTime,OEXDateTime,OEAntPoison,OEAntPurpose,OEInstruc,OEDoctor)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAntDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntDtlExecute ]
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
