/// 名称: DHCHAI.STAT.S370InfMisRep
/// 描述: 感染漏报统计
/// 编写者：zhugz
/// 编写日期: 2018-10-17
Class DHCHAI.STAT.S370InfMisRep Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2018-10-17
/// Description:  感染漏报统计表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S370InfMisRep","QryInfMisRep","1","2018-09-01","2018-11-29")
Query QryInfMisRep(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocTypeDesc As %String = "", aLocDesc As %String = "", aMissing As %String = "") As %Query(ROWSPEC = "EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,LocDr:%String,LocDesc:%String,LocTypeDesc:%String,WardDr:%String,WardDesc:%String,TansDT:%String,OutLocDT:%String,InfPosDesc:%String,InfDate:%String,InfType:%String,InfEffectDesc:%String,InfXDate:%String,CSActDate:%String") [ SqlProc ]
{
}

ClassMethod QryInfMisRepExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocTypeDesc As %String = "", aLocDesc As %String = "", aMissing As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandle=$lb(0,repidx,0)	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    set ^tmpzgz1018=$lb(aHospIDs,aDateFrom,aDateTo)
    Set Nindex="QryInfMisRep"
    k ^TMP($zn,$j,Nindex)
    //通过感染报告获取一段时间内已报感染信息
    for xInfDate=aDateFrom:1:aDateTo
    {
    	Set RowID="",InfType="医院感染"
    	Set (InfPosDesc,InfDate,InfEffectDesc,InfXDate)=""
    	for {
    		Set RowID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xInfDate,RowID))
    		Quit:RowID=""
    		Set RepList=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",RowID)
			Set objRep=RepList.GetAt(1)
			continue:'$IsObject(objRep)
			Set RepStatus=objRep.IRStatusDr.BTCode
			continue:(RepStatus'=3)&&((RepStatus'=2)) ;审核、提交为有效状态
			Set InfPos=##class(DHCHAI.IR.INFDiagnos).GetObjById(RowID)
			continue:'$IsObject(InfPos)
			Set InfSubDiag=InfPos.IRInfSubDr.BTDesc
			Set InfDate=$zd(xInfDate,3)
			Set InfPosDesc=InfPos.IRInfPosDr.BTDesc
			Set InfEffectDesc=InfPos.IRInfEffectDr.BTDesc
			Set:InfPos.IRInfXDate'="" InfXDate=$zd(InfPos.IRInfXDate,3)
			
			Set EpisodeDr=InfPos.IREpisodeDr.%Id()
			Set LWBMsg=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,xInfDate,"") //获取当天23::59:59时病人所在科室、病区、床信息
			Continue:LWBMsg=""
			Set LocDr  = $p(LWBMsg,"^",1) // 科室
			Set WardDr = $p(LWBMsg,"^",2) // 病区
			Set WardTransID=$p(LWBMsg,"^",6) //转入该病区时TransID，计算入病区时间
			Continue:LocDr=""
			Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(WardTransID)
			Continue:'$IsObject(objTrans)
			Set TansDate=objTrans.PATransDate
			Set TansTime=objTrans.PATransTime
			Set OutLocDate=objTrans.PAOutLocDate
			Set OutLocTime=objTrans.PAOutLocTime
			Set TansDT=$zd(TansDate,3)_" "_$zt(TansTime)
			Set OutLocDT=""
			Set:OutLocDate'="" OutLocDT=$zd(OutLocDate,3)_" "_$zt(OutLocTime)
			// 科室信息
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)			
			// 医院过滤
			Continue:'$IsObject(objLoc.BTHospDr)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
			Continue:'$IsObject(objLoc)
			If ($IsObject(objLoc.BTGroupDr)){
				Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
			}Else {
				Set LocTypeDesc="其他科"
			}
			continue:(aLocTypeDesc'="")&&(aLocTypeDesc'=LocTypeDesc)
			Set LocDesc=objLoc.BTDesc2
			Set:LocDesc="" LocDesc=objLoc.BTDesc
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			// 病区信息
			Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
			Continue:'$isobject(objWard)
			Set WardDesc=objWard.BTDesc2
			Set:WardDesc="" WardDesc=objWard.BTDesc
			Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
			Continue:WardDesc=""	
			continue:(aLocDesc'="")&&(aLocDesc'=LocDesc)&&(aLocDesc'=WardDesc)		
			Set PatData =..BuildPaadmData(EpisodeDr)
	    	Continue:PatData=""
	    	Set AdmDate=$p($lg(PatData,9)," ",1)
	   		Set:AdmDate["-" AdmDate=$zdh(AdmDate,3)
	   		Set:xInfDate-AdmDate<2 InfType="社区感染"
		   	Set ^TMP($zn,$j,Nindex,EpisodeDr)=InfDate  //记录已报感染就诊记录
		   	continue:(aMissing=1)  //如果查漏报的，则不输出感染数据，但是需要前面的感染记录，判断后面的漏报
			Set Data=PatData
		
			Set Data=Data_$lb(LocDr,LocDesc,LocTypeDesc,WardDr,WardDesc,TansDT,OutLocDT)
			Set Data=Data_$lb(InfPosDesc,InfDate,InfType,InfEffectDesc,InfXDate,"")
			Set ^CacheTemp(repidx,indx)=Data
			Set indx=indx+1
    	}
	}
	for xActDate=aDateFrom:1:aDateTo{
		Set RowID=""	
		for {
				Set RowID=$o(^DHCHAI.IR.CCScreeningI("IndexStatusActDate",1,xActDate,RowID))
				Quit:RowID=""
				Set CCSObj=##class(DHCHAI.IR.CCScreening).GetObjById(RowID)
				continue:'$IsObject(CCSObj)
				Set EpisodeDr=CCSObj.CSEpisodeDr.%Id()
				Continue:$d(^TMP($zn,$j,Nindex,EpisodeDr))
				Set LWBMsg=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,xActDate,"") //获取当天23::59:59时病人所在科室、病区、床信息
				Continue:LWBMsg=""
				Set LocDr  = $p(LWBMsg,"^",1) // 科室
				Set WardDr = $p(LWBMsg,"^",2) // 病区
				Set WardTransID=$p(LWBMsg,"^",6) //转入该病区时TransID，计算入病区时间
				Continue:LocDr=""
				Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(WardTransID)
				continue:'$IsObject(objTrans)
				Set TansDate=objTrans.PATransDate
				Set TansTime=objTrans.PATransTime
				Set OutLocDate=objTrans.PAOutLocDate
				Set OutLocTime=objTrans.PAOutLocTime
				Set TansDT=$zd(TansDate,3)_" "_$zt(TansTime)
				Set OutLocDT=""
				Set:OutLocDate'="" OutLocDT=$zd(OutLocDate,3)_" "_$zt(OutLocTime)
				// 科室信息
				Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)			
				// 医院过滤
				Continue:'$IsObject(objLoc.BTHospDr)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
				Continue:'$IsObject(objLoc)
				If ($IsObject(objLoc.BTGroupDr)){
					Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
				}Else {
					Set LocTypeDesc="其他科"
				}
				continue:(aLocTypeDesc'="")&&(aLocTypeDesc'=LocTypeDesc)
				Set LocDesc=objLoc.BTDesc2
				Set:LocDesc="" LocDesc=objLoc.BTDesc
				Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
				// 病区信息
				Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
				Continue:'$isobject(objWard)
				Set WardDesc=objWard.BTDesc2
				Set:WardDesc="" WardDesc=objWard.BTDesc
				Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
				Continue:WardDesc=""
				continue:(aLocDesc'="")&&(aLocDesc'=LocDesc)&&(aLocDesc'=WardDesc)
				Set PatData =..BuildPaadmData(EpisodeDr)
			    Continue:PatData=""
			    Set CSActDate=$zd(CCSObj.CSActDate,3)
			    Set ^TMP($zn,$j,Nindex,EpisodeDr)=CSActDate
			    Set Data=PatData
				Set Data=Data_$lb(LocDr,LocDesc,LocTypeDesc,WardDr,WardDesc,TansDT,OutLocDT)
				Set Data=Data_$lb("","","","","",CSActDate)
				Set ^CacheTemp(repidx,indx)=Data
				Set indx=indx+1
			}
	}
	k ^TMP($zn,$j,Nindex)
	Quit $$$OK
}

ClassMethod QryInfMisRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfMisRepExecute ]
{
	Set repidx=$LIST(qHandle,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryInfMisRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfMisRepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repidx=$LIST(qHandle,2)
 	Set indx=$LIST(qHandle,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repidx,indx)
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
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
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
		Set DischLocDesc2 = objDischLoc.BTDesc2
		Set DischLocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(DischLocDesc2'="":DischLocDesc2,1:DischLocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set DischWardDesc2 = objDischWard.BTDesc2
		Set DischWardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(DischWardDesc2'="":DischWardDesc2,1:DischWardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime

	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

}
