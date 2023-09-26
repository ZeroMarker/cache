/// 名称: DHCHAI.STAT.S040MRBInf
/// 描述: 多重耐药菌感染发现率统计
/// 编写者: zhoubo
/// 编写日期: 2018-07-24
Class DHCHAI.STAT.S040MRBInf Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:      zhoubo
/// CreatDate:    2018-07-24
/// Description:  查询同期在科人数(科室/病区)
///               同一个病人一次就诊多次入住同一科室/病区记为一人
///               一天内多次转科(转入同一科)记为最初所在科室
/// Input:        aHospIDs:  多个医院用"|"连接
/// 			  aDateFrom: 开始日期
/// 			  aDateTo:   结束日期       
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S040MRBInf","QryInLocAdm","","2017-08-01","2017-08-03")
Query QryInLocAdm(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,LocID:%String,LocDesc:%String,LocTypeDesc:%String,PatAdmSum:%Integer,InDaysSum:%Integer,WardID:%String,WardDesc:%String,WardPaadmSum:%Integer,WardDaysSum:%Integer,LocGroupSum:%Integer,HospInSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryInLocAdmExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

    Set NIndex="QryInLocAdm"
	Kill ^TMP($zn,$j,NIndex)

    // 同期在科天数
    Set ListArray=..GetTransEpisByDate("",aDateFrom,aDateTo,"I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""
		Set LocType = $LIST(TransInfo,1)	
		Set Date    = $LIST(TransInfo,2)
		Set Paadm   = $LIST(TransInfo,3)
		Set Status  = $LIST(TransInfo,4)			
		Set LocID   = $LIST(TransInfo,5)	
		Set TansID  = $LIST(TransInfo,6)
		Set num=$i(^TMP($zn,$j,NIndex,Date,Paadm,LocID))
		Continue:num>1                        //当天转出不算在内
		Continue:(Status="I")                 //当天转入不算在内
        
        Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(LocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$isobject(objLoc)
		// 全院同期在院人数
		If '$d(^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm)) {
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm)=""
			Set num=$i(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))
		}
		
        If (LocType="E") {
			If ($IsObject(objLoc.BTGroupDr)){
				Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
			}Else {
				Set LocTypeDesc="其他科"
			}
			// 科室分组同期在科人数
			If '$d(^TMP($zn,$j,NIndex,"LocGroup",LocTypeDesc,"PatAdm",Paadm)) {
				Set ^TMP($zn,$j,NIndex,"LocGroup",LocTypeDesc,"PatAdm",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"LocGroup",LocTypeDesc,"PatAdm"))
			}
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm",Paadm)) {
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm"))   // 同期在科人数
			}
		}
		If (LocType="W") {
	        If '$d(^TMP($zn,$j,NIndex,"Ward",LocID,"PatAdm",Paadm)) {
				Set ^TMP($zn,$j,NIndex,"Ward",LocID,"PatAdm",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"Ward",LocID,"PatAdm"))  // 同期在病区人数
			}
		}
		Set InDays=$i(^TMP($zn,$j,NIndex,LocID,"InDays")) // 同期在科天数		
    }
    
	Set HospInSum=+$g(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Loc",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		If ($IsObject(objLoc.BTGroupDr)){
			Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
		}Else {
			Set LocTypeDesc="其他科"
		}
		Set LocGroupSum =+$g(^TMP($zn,$j,NIndex,"LocGroup",LocTypeDesc,"PatAdm"))
		Set PatAdmSum   =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"PatAdm"))   // 同期在科人数
		Set InDaysSum   =+$g(^TMP($zn,$j,NIndex,xLocID,"InDays"))         // 同期在科天数
		Set xWardID = ""
	 	For {
			Set xWardID = $o(^DHCHAI.BT.LocationD(xLocID,"Link",xWardID))
			Quit:xWardID=""
			
			Set xID = xLocID_"||"_xWardID
			Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xID)
			Continue:'$IsObject(objLocLink)
			Continue:'$IsObject(objLocLink.BTLinkLocDr)
			Continue:(+objLocLink.BTIsActive)'=1
			
			Set WardID = objLocLink.BTLinkLocDr.%Id()
			Set WardDesc = objLocLink.BTLinkLocDr.BTDesc2
			Set:WardDesc="" WardDesc = objLocLink.BTLinkLocDr.BTDesc
		    Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)	
		        
		    Set WardPaadmSum =+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm")) // 同期在病区人数
			Set WardDaysSum  =+$g(^TMP($zn,$j,NIndex,WardID,"InDays"))        // 同期在病区天数
			
			Set Data=$lb(ind,xLocID,LocDesc,LocTypeDesc,PatAdmSum,InDaysSum,WardID,WardDesc,WardPaadmSum,WardDaysSum,LocGroupSum,HospInSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}	
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInLocAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInLocAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInLocAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInLocAdmExecute ]
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

/// Creator:      zhoubo
/// CreatDate:    2018-07-31
/// Description:  查询同期在科患者明细
///               同一个病人一次就诊多次入住同一科室/病区记为一人
///               一天内多次转科(转入同一科)记为最初所在科室
/// Input:        aHospIDs  : 多个医院用"|"连接
/// 			  aDateFrom : 开始日期
/// 			  aDateTo   : 结束日期
///               aLocType  : 科室类型(E/W)
///               aLocGroup : 科室分组
///               aLocDesc  : 科室名称
///               aWardDesc : 病区名称  
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S040MRBInf","QryInLocAdmDtl","1","2018-08-01","2018-08-08","W","妇产科","","妇科二病区")
Query QryInLocAdmDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aWardDesc As %String) As %Query(ROWSPEC = "EpisodeDr:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,InDays:%Integer,TransID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryInLocAdmDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aWardDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    // 科室和病区不能同时存在
	Quit:(aLocDesc'="")&&(aWardDesc'="") $$$OK
    Set NIndex="QryInLocAdmDtl"
	Kill ^TMP($zn,$j,NIndex)

    // 同期在科天数
    Set ListArray=..GetTransEpisByDate(aLocType,aDateFrom,aDateTo,"I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""
		Set LocType = $LIST(TransInfo,1)	
		Set Date    = $LIST(TransInfo,2)
		Set Paadm   = $LIST(TransInfo,3)
		Set Status  = $LIST(TransInfo,4)			
		Set LocID   = $LIST(TransInfo,5)	
		Set TansID  = $LIST(TransInfo,6)
		Set num=$i(^TMP($zn,$j,NIndex,Date,Paadm,LocID))
		Continue:num>1                        //当天转出不算在内
		Continue:(Status="I")                 //当天转入不算在内
        
        Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(LocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		// 科室病区过滤,科室病区名称不能同时存在
		Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc)    
		Continue:(aWardDesc'="")&&(aWardDesc'=LocDesc)
		If ($IsObject(objLoc.BTGroupDr)){
			Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
		}Else {
			Set LocTypeDesc="其他科"
		}
		Continue:(aLocGroup'="")&&(aLocGroup'=LocTypeDesc)  // 科室分组过滤	
		If '$d(^TMP($zn,$j,NIndex,"PatAdm",Paadm)) {
			Set ^TMP($zn,$j,NIndex,"PatAdm",Paadm)=""
		}
		// 记录患者转科记录ID
		If ('$d(^TMP($zn,$j,NIndex,"PatTransIDList",Paadm,TansID))) {
			Set ^TMP($zn,$j,NIndex,"PatTransIDList",Paadm)=$g(^TMP($zn,$j,NIndex,"PatTransIDList",Paadm))_$lb(TansID)
			Set ^TMP($zn,$j,NIndex,"PatTransIDList",Paadm,TansID)=""
		}
		Set InDays=$i(^TMP($zn,$j,NIndex,Paadm,"InDays")) // 同期在科天数	
    }	
	Set xPaadm=""
	For {
		Set xPaadm=$o(^TMP($zn,$j,NIndex,"PatAdm",xPaadm))
		Quit:xPaadm=""
		Set EpisodeDr=xPaadm
		Set PatData =..BuildPaadmData(EpisodeDr)
		Continue:PatData=""
		Set InDays=+$g(^TMP($zn,$j,NIndex,EpisodeDr,"InDays"))
		//重新计算在院天数  出院日期减入院日期 同一天算一天
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
		Set AdmDate = +objPaadm.PAAdmDate
		Set DischDate = +objPaadm.PADischDate
		Set:DischDate'=0 InDays = DischDate-AdmDate
		Set:DischDate=0 InDays = (+$h)-AdmDate
		Set:InDays=0 InDays=1
		 
		Set PatTransIDList=$g(^TMP($zn,$j,NIndex,"PatTransIDList",EpisodeDr))
		
		For xIndex=1:1:$LL(PatTransIDList) {
			Set TransID = $LG(PatTransIDList,xIndex)
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(TransID)
			
			Set TransLocDr=objTrans.PATransLocDr.%Id()
			Set TransLocDesc=objTrans.PATransLocDr.BTDesc2
			Set:TransLocDesc="" TransLocDesc=objTrans.PATransLocDr.BTDesc
			Set:TransLocDesc["-" TransLocDesc=$p(TransLocDesc,"-",2)
			
			Set TransDate=objTrans.PATransDate
			Set TransTime=objTrans.PATransTime
			Set TransTime=+TransTime
			Set:TransTime=0 TransTime=1
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:TransTime'="" TransTime=$zt(TransTime)
			Set OutLocDate=objTrans.PAOutLocDate
			Set OutLocTime=objTrans.PAOutLocTime
			If OutLocDate="" {
				Set TransXDate=+$h
			} Else {
				Set OutLocTime=+OutLocTime
				Set:OutLocTime=0 OutLocTime=1
				Set TransXDate=OutLocDate
			}
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			Set (TransDateTime,OutLocDateTime)=""
			Set:TransDate'="" TransDateTime=TransDate_" "_TransTime
			Set:OutLocDate'="" OutLocDateTime=OutLocDate_" "_OutLocTime
			
			Set ^CacheTemp(repid,ind)=PatData_$lb(InDays,TransID,TransLocDesc,TransDateTime,OutLocDateTime)
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInLocAdmDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInLocAdmDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInLocAdmDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInLocAdmDtlExecute ]
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

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime

	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// Creator：		zhoubo
/// CreateDate：	2018-07-25
/// Description:	多重耐药菌感染发现率
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:          aHospIDs： 多个医院用"|"连接
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S040MRBInf","QryMRBInf","1","2018-07-01","2018-08-08")
Query QryMRBInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeDr:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocTypeDesc:%String,LocDr:%String,LocDesc:%String,WardDr:%String,WardDesc:%String,ResultID:%String,Specimen:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDate:%String,ActTime:%String,MRB2ID:%String,MRB2Code:%String,MRB2Desc:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	// 获取一段日期内在院及出院患者
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set EpisodeDr=ListArray.GetAt(index)	
		Continue:EpisodeDr=""
		Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",EpisodeDr)) // 无院感报告	
		
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
		
	   	Set ResultList=""
	    Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode
			Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
			
			For xDate=aDateFrom:1:aDateTo {
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID,xDate,xID))
					Quit:xID=""
				
					Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
					Continue:'$Isobject(objResult)
					Continue:objResult.CCIsActive'=1
					Continue:'$Isobject(objResult.CCMRBTpDr)
				
					Set ActDate=objResult.CCActDate
					Set ActTime=objResult.CCActTime
					Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  //排除CA入院小于48小时
					Continue:IPHour<48
				    
					// 采集病区
				    Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
				   	Set LocDr  = $p(LocWardInfo,"^",1) // 科室
					Set WardDr = $p(LocWardInfo,"^",2) // 病区
					Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
					Continue:'$IsObject(objLoc)
					If ($IsObject(objLoc.BTGroupDr)){
						Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
					}Else {
						Set LocTypeDesc="其他科"
					}
					Set LocDesc=objLoc.BTDesc2
					Set:LocDesc="" LocDesc=objLoc.BTDesc
					Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
					Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
					Continue:'$isobject(objWard)
					Set WardDesc=objWard.BTDesc2
					Set:WardDesc="" WardDesc=objWard.BTDesc
					Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
					Continue:WardDesc=""
					
					Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
					Set:ActTime'="" ActTime=$zt(ActTime)
					
					Set MRBID    = objResult.CCMRBTpDr.%Id()
					Set MRBDesc  = objResult.CCMRBTpDr.BTDesc
					Set MRBCode  = objResult.CCMRBTpDr.BTCode
					If ($IsObject(objResult.CCMRBTp2Dr)) {
						Set MRB2ID    = objResult.CCMRBTp2Dr.%Id()
						Set MRB2Desc  = objResult.CCMRBTp2Dr.BTDesc
						Set MRB2Code  = objResult.CCMRBTp2Dr.BTCode
					}Else {
						Set MRB2ID    = ""
						Set MRB2Desc  = ""
						Set MRB2Code  = ""
					}
					Continue:($listfind(ResultList,MRBDesc)>0)  // 多重耐药菌重复
					Set ResultList=ResultList_$lb(MRBDesc)
					
					Set SCode    = objResult.CCSCode             //子系统代码
			        Set Specimen = objResult.CCSpecimen          //原始标本名称
			        Set SpeID="",SpeCode="",SpeDesc=""
			        Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			        If $IsObject(objSpe) {
				        If $IsObject(objSpe.BTMapItemDr){
							Set SpeID=objSpe.BTMapItemDr.%Id()
							Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
							Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
						}
			        }
			        Set Bacteria = objResult.CCBacteria   //原始细菌名称
			        Continue:Bacteria=""
		            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
		            Continue:'$IsObject(objBactMap)
					Continue:'$IsObject(objBactMap.BTMapItemDr)
					Set BacID=objBactMap.BTMapItemDr.%Id()
					Set BacCode=objBactMap.BTMapItemDr.BTBacCode
					Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
					// 判断HA
					Set ResultID = $p(objResult.CCParams,"=",2)  // 检验结果ID
					// 获取院感报告病原学检验病原体信息
					Set xLabRepDr="",IsInfMRBFlag=0,RepRstIDList=""
					For {
						Set xLabRepDr=$o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",EpisodeDr,xLabRepDr))
						Quit:(xLabRepDr="")||(IsInfMRBFlag=1)
						Set objLabRep= ##class(DHCHAI.DP.LabVisitReport).GetObjById(xLabRepDr)
						Continue:'$IsObject(objLabRep)
						Continue:'$IsObject(objLabRep.LabVisitNumberDr)
						Set RepRstIDList="",BacCount=0
						Set xRepRstDr=""
						For {
							Set xRepRstDr=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xLabRepDr,xRepRstDr))
							Quit:xRepRstDr=""
							Set objLabRepRst = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRepRstDr)
							Continue:'$IsObject(objLabRepRst)
							Set BacCount=BacCount+1
							Set RepRstIDList=RepRstIDList_","_xRepRstDr
						}
						Continue:BacCount>3 // 同一份报告检出3种以上的病原体为污染
						Set RepRstIDList=RepRstIDList_","
						If (RepRstIDList[","_ResultID_",") {
							Set IsInfMRBFlag=1
						}
					}
					Continue:IsInfMRBFlag=0   // 病原学信息中无多重耐药菌
					
				   	Set Data=$lb(EpisodeDr,PapmiNo,MrNo,PatName,Sex,Age,LocTypeDesc,LocDr,LocDesc,WardDr,WardDesc,ResultID,Specimen,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ActDate,ActTime,MRB2ID,MRB2Code,MRB2Desc)
					Set ^CacheTemp(repid,ind)=$lb(ind)_Data
					Set ind=ind+1
				}
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryMRBInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfExecute ]
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

/// Creator：		zhoubo
/// CreateDate：	2018-07-31
/// Description:	多重耐药菌感染明细
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:          aHospIDs  : 多个医院用"|"连接
/// 				aDateFrom : 开始日期
/// 				aDateTo   : 结束日期
///                 aLocGroup : 科室分组
///                 aLocDesc  : 科室名称
///                 aWardDesc : 病区名称 
///                 aMRBDesc  : 多耐名称
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S040MRBInf","QryMRBInfDtl","","2018-07-01","2018-08-24","","","")
Query QryMRBInfDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocGroup As %String, aLocDesc As %String, aWardDesc As %String, aMRBDesc As %String) As %Query(ROWSPEC = "EpisodeDr:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,ResultID:%String,LabEpisodeNo:%String,Specimen:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDateTime:%String,CCRepDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocGroup As %String, aLocDesc As %String, aWardDesc As %String, aMRBDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	// 获取一段日期内在院及出院患者
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set EpisodeDr=ListArray.GetAt(index)	
		Continue:EpisodeDr=""
		Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",EpisodeDr)) // 无院感报告	
		
	   	Set ResultList=""
	    Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode
			Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
			
			For xDate=aDateFrom:1:aDateTo {
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID,xDate,xID))
					Quit:xID=""
				
					Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
					Continue:'$Isobject(objResult)
					Continue:objResult.CCIsActive'=1
					Continue:'$Isobject(objResult.CCMRBTpDr)
				
					Set ActDate=objResult.CCActDate
					Set ActTime=objResult.CCActTime
					Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  //排除CA入院小于48小时
					Continue:IPHour<48
				    Set CCRepDate=objResult.CCRepDate
				    Set CCRepTime=objResult.CCRepTime
					// 采集病区
				    Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
				   	Set LocDr  = $p(LocWardInfo,"^",1) // 科室
					Set WardDr = $p(LocWardInfo,"^",2) // 病区
					Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
					Continue:'$IsObject(objLoc)
					If ($IsObject(objLoc.BTGroupDr)){
						Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
					}Else {
						Set LocTypeDesc="其他科"
					}
					Continue:(aLocGroup'="")&&(aLocGroup'=LocTypeDesc) // 科室类型过滤
					Set LocDesc=objLoc.BTDesc2
					Set:LocDesc="" LocDesc=objLoc.BTDesc
					Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
					Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤
					Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
					Continue:'$isobject(objWard)
					Set WardDesc=objWard.BTDesc2
					Set:WardDesc="" WardDesc=objWard.BTDesc
					Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
					Continue:WardDesc=""
					Continue:(aWardDesc'="")&&(aWardDesc'=WardDesc) // 病区过滤
					Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
					Set:ActTime'="" ActTime=$zt(ActTime)
					Set:CCRepDate'="" CCRepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CCRepDate)
					Set:CCRepTime'="" CCRepTime=$zt(CCRepTime)
					Set ActDateTime=ActDate_" "_ActTime
					Set CCRepDateTime=CCRepDate_" "_CCRepTime
					Set MRBID    = objResult.CCMRBTpDr.%Id()
					Set MRBDesc  = objResult.CCMRBTpDr.BTDesc
					Set MRBCode  = objResult.CCMRBTpDr.BTCode
					If ($IsObject(objResult.CCMRBTp2Dr)) {
						Set MRB2ID    = objResult.CCMRBTp2Dr.%Id()
						Set MRB2Desc  = objResult.CCMRBTp2Dr.BTDesc
						Set MRB2Code  = objResult.CCMRBTp2Dr.BTCode
					}Else {
						Set MRB2ID    = ""
						Set MRB2Desc  = ""
						Set MRB2Code  = ""
					}
					Continue:($listfind(ResultList,MRBDesc)>0)  // 多重耐药菌重复
					Set ResultList=ResultList_$lb(MRBDesc)
					Continue:(aMRBDesc'="")&&(aMRBDesc'=MRBDesc)&&(aMRBDesc'=MRB2Desc)
					Set SCode    = objResult.CCSCode             // 子系统代码
			        Set Specimen = objResult.CCSpecimen          // 原始标本名称
			        Set SpeID="",SpeCode="",SpeDesc=""
			        Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			        If $IsObject(objSpe) {
				        If $IsObject(objSpe.BTMapItemDr){
							Set SpeID=objSpe.BTMapItemDr.%Id()
							Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
							Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
						}
			        }
			        Set Bacteria = objResult.CCBacteria   // 原始细菌名称
			        Continue:Bacteria=""
		            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
		            Continue:'$IsObject(objBactMap)
					Continue:'$IsObject(objBactMap.BTMapItemDr)
					Set BacID=objBactMap.BTMapItemDr.%Id()
					Set BacCode=objBactMap.BTMapItemDr.BTBacCode
					Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
					// 判断HA
					Set ResultID = $p(objResult.CCParams,"=",2)  // 检验结果ID
					// 获取院感报告病原学检验病原体信息
					Set LabEpisodeNo=""  // 标本号
					Set xLabRepDr="",IsInfMRBFlag=0,RepRstIDList=""
					For {
						Set xLabRepDr=$o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",EpisodeDr,xLabRepDr))
						Quit:(xLabRepDr="")||(IsInfMRBFlag=1)
						Set objLabRep= ##class(DHCHAI.DP.LabVisitReport).GetObjById(xLabRepDr)
						Continue:'$IsObject(objLabRep)
						Continue:'$IsObject(objLabRep.LabVisitNumberDr)
						Set tmpLabNo=objLabRep.LabVisitNumberDr.LabEpisodeNo
						Set RepRstIDList="",BacCount=0
						Set xRepRstDr=""
						For {
							Set xRepRstDr=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xLabRepDr,xRepRstDr))
							Quit:xRepRstDr=""
							Set objLabRepRst = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRepRstDr)
							Continue:'$IsObject(objLabRepRst)
							Set BacCount=BacCount+1
							Set RepRstIDList=RepRstIDList_","_xRepRstDr
						}
						Continue:BacCount>3 // 同一份报告检出3种以上的病原体为污染
						Set RepRstIDList=RepRstIDList_","
						If (RepRstIDList[","_ResultID_",") {
							Set IsInfMRBFlag=1
							Set LabEpisodeNo=tmpLabNo
						}
					}
					Continue:IsInfMRBFlag=0   // 病原学信息中无多重耐药菌
					// 患者基本信息
	   				Set PatData =..BuildPaadmData(EpisodeDr)
					Continue:PatData=""
					
				   	Set Data=PatData_$lb(ResultID,LabEpisodeNo,Specimen,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ActDateTime,CCRepDateTime)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryMRBInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfDtlExecute ]
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
/// CreatDate：   2017-07-24
/// Description:  取每日新入、在院、出院就诊接口(报表统计使用计算同期在科人数和天数)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aLocType  : 科室类型
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aAdmType  : 就诊类型
/// Return：      返回%List
/// w ##class(DHCHAI.STAT.S040MRBInf).GetTransEpisByDate("E","2017-08-01","2017-08-02","I")
ClassMethod GetTransEpisByDate(aLocType As %String, aDateFrom As %String, aDateTo As %String, aAdmType As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aLocType,aDateFrom,aDateTo,aAdmType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Quit:(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetTransEpisByDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Set $ZT="GetTransEpisByDateErr"
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:xTransType="B"   // 转床信息
		Set LocType = xTransType  // 转科E、转病区W
		Continue:(aLocType'="")&&(aLocType'=LocType)
		Set xTransDays=""
		For {
			Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays))
			Quit:xTransDays=""
			
			//xTransDays<0 表示在科病人
			Set xTransDate=""
			//xTransDays>0 表示出科病人
			Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
			For {
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate))
				Quit:xTransDate=""
				Quit:xTransDate>aDateTo  //转入日期大于截止日期
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate,xTransID))
					Quit:xTransID=""
					
					Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					Continue:'$isobject(objTrans)
					Continue:'$isobject(objTrans.PAEpisodeDr)
					Set AdmType=objTrans.PAEpisodeDr.PAAdmType
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					Continue:'$isobject(objTrans.PATransLocDr)
					Continue:'$isobject(objTrans.PATransLocDr.BTTypeDr)
					Set TransLocDr=objTrans.PATransLocDr.%Id()
					
					Set EpisodeDr=objTrans.PAEpisodeDr.%Id()
					Set TransDate=objTrans.PATransDate
					Set TransTime=objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=objTrans.PAOutLocDate
					Set OutLocTime=objTrans.PAOutLocTime
					If OutLocDate="" {
						Set TransXDate=+$h
					} Else {
						Set OutLocTime=+OutLocTime
						Set:OutLocTime=0 OutLocTime=1
						Set TransXDate=OutLocDate
					}
					
					For xDate=TransDate:1:TransXDate {
						Continue:xDate<aDateFrom
						Quit:xDate>aDateTo
						
						If (xDate'=TransDate)&&(xDate'=OutLocDate) {      //在科A
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",LocType,xDate,EpisodeDr,TransLocDr,"A",TransTime,xTransID)=""
						} ElseIf (xDate=TransDate)&&(xDate=OutLocDate) {  //在科A2
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",LocType,xDate,EpisodeDr,TransLocDr,"A2",TransTime,xTransID)=""
						} Else {
							If xDate=TransDate {   //入科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",LocType,xDate,EpisodeDr,TransLocDr,"I"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",LocType,xDate,EpisodeDr,TransLocDr,"I",TransTime,xTransID)=""
							}
							If xDate=OutLocDate {  //出科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",LocType,xDate,EpisodeDr,TransLocDr,"O"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",LocType,xDate,EpisodeDr,TransLocDr,"O",OutLocTime,xTransID)=""
							}
						}
					}
				}
			}
		}
	}
	
	Set Count=0
	Set xType=""
	For {
		Set xType=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType))
		Quit:xType=""
		
		Set xDate=""
		For {
			Set xDate=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate))
			Quit:xDate=""
			
			Set xEpisodeDr=0
			For {
				Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr))
				Quit:xEpisodeDr=""
				
				Set xLocDr=""
				For {
					Set xLocDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr))
					Quit:xLocDr=""
					
					Set TransID=""
					Set ICnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,"I"))
					Set OCnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,"O"))
					If ICnt>OCnt {
						Set xStatus="I"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
					} ElseIf ICnt<OCnt {
						Set xStatus="O"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,""),-1)
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,xTime,""),-1)
					} ElseIf (ICnt=OCnt)&(ICnt>0) {
						//说明：先出再入，并且"转入次数=转出次数"，这种算在院A
						//      先入再出，并且"转入次数=转出次数"，这种算在院A2
						Set tStatus="O",xStatus="A"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,tStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,tStatus,xTime,""))
					} Else {
						Set xStatus="A"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
						If TransID="" {
							Set xStatus="A2"
							Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,""))
							Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xType,xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
						}
					}
					Continue:TransID=""
					
					Set TransInfo=$lb(xType,xDate,xEpisodeDr,xStatus,xLocDr,TransID)
					Set Count=Count+1
					Do return.SetAt(TransInfo,Count)
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetTransEpisByDateErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

}
