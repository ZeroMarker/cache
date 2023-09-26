/// 名称: DHCHAI.IRS.INFRepExportSrv
/// 描述: 院感报告全部信息导出服务
/// 编写者：mayanpeng
/// 编写日期: 2018-05-16
Class DHCHAI.IRS.INFRepExportSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2018-05-17
/// Description:  查询院感报告易感因素
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFPreFactor
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryPreFactorExport","4","2018-02-01","2018-02-02","","","1","","","","","")
Query QryPreFactorExport(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,IsInfPreFactor:%String,BTIsNewborn:%String") [ SqlProc ]
{
}

ClassMethod QryPreFactorExportExecute(ByRef qHandlex As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
 	
	Set flag=..BuildPreFactor(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set NIndex="PreFactor"
	Set Count=""
	For {
		Set Count=$o(^TMP(NIndex,Count))
		Quit:Count=""
		Continue:$g(^TMP(NIndex,Count))=""
		
		Set Data=$g(^TMP(NIndex,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP(NIndex)
	Quit $$$OK
}

ClassMethod QryPreFactorExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryPreFactorExportExnmecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryPreFactorExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPreFactorExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildPreFactor(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %String
{
	New (aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") return
 	//默认查询感染报告
	Set:aRepType="" aRepType = "1"
	
	Set NIndex="PreFactor"
	Kill ^TMP(NIndex)
	Set Count=1
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.INFDiagnosSrv:QryRepInfoByDateLoc")
	Set sc=rs.Execute(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	While (rs.Next()){
		Set ReportID=rs.Data("ReportID")
		Set EpisodeID=rs.Data("EpisodeID")
		
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFPreFactorSrv:QryPreFactorOfConfig")
		Set se=res.Execute(ReportID,EpisodeID,"1","1")
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set BTCode=res.Data("BTCode")
		  	Set BTDesc=res.Data("BTDesc")
		  	Set BTIndNo=res.Data("BTIndNo")
		  	Set IsInfPreFactor=res.Data("IsInfPreFactor")
		  	Set BTIsNewborn=res.Data("BTIsNewborn")
		  	Set ^TMP(NIndex,Count)=$lb(ReportID,EpisodeID,BTCode,BTDesc,BTIndNo,IsInfPreFactor,BTIsNewborn)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2018-06-05
/// Description:  查询院感报告侵害性操作
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFInvOper
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryInvOperExport","4","2018-02-01","2018-02-02","","","1","","","","","")
Query QryInvOperExport(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,IsInfInvOper:%String") [ SqlProc ]
{
}

ClassMethod QryInvOperExportExecute(ByRef qHandlex As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
 	
 	Set flag=..BuildInvOper(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set NIndex="InvOper"
	Set Count=""
	For {
		Set Count=$o(^TMP(NIndex,Count))
		Quit:Count=""
		Continue:$g(^TMP(NIndex,Count))=""
		
		Set Data=$g(^TMP(NIndex,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP(NIndex)
	Quit $$$OK
}

ClassMethod QryInvOperExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryInvOperExportExnmecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryInvOperExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInvOperExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildInvOper(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %String
{
	New (aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") return
 	//默认查询感染报告
	Set:aRepType="" aRepType = "1"
	
	Set NIndex="InvOper"
	Kill ^TMP(NIndex)
	Set Count=1
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.INFDiagnosSrv:QryRepInfoByDateLoc")
	Set sc=rs.Execute(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set ReportID=rs.Data("ReportID")
		Set EpisodeID=rs.Data("EpisodeID")
		
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFInvOperSrv:QryInvOperOfConfig")
		Set se=res.Execute(ReportID,EpisodeID,"1")
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set BTCode=res.Data("BTCode")
		  	Set BTDesc=res.Data("BTDesc")
		  	Set BTIndNo=res.Data("BTIndNo")
		  	Set IsInfInvOper=res.Data("IsInfInvOper")
			Set ^TMP(NIndex,Count)=$lb(ReportID,EpisodeID,BTCode,BTDesc,BTIndNo,IsInfInvOper)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2018-06-05
/// Description:  查询院感报告诊断
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFDiagnos
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryINFDiagExport","4","2018-02-01","2018-02-02","","","1","","","","","")
Query QryINFDiagExport(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,InfPosID:%String,InfPos:%String,InfSubID:%String,InfSub:%String,InfDate:%String,InfLocID:%String,InfLoc:%String,InfDiagnosisBasis:%String,InfDiseaseCourse:%String,InfXDate:%String,InfEffectID:%String,InfEffect:%String,DeathRelationID:%String,DeathRelation:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String,IsReportDiag:%String") [ SqlProc ]
{
}

ClassMethod QryINFDiagExportExecute(ByRef qHandlex As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
 	
	Set flag=..BuildINFDiag(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set NIndex="INFDiag"
	Set Count=""
	For {
		Set Count=$o(^TMP(NIndex,Count))
		Quit:Count=""
		Continue:$g(^TMP(NIndex,Count))=""
		
		Set Data=$g(^TMP(NIndex,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP(NIndex)
	
	Quit $$$OK
}

ClassMethod QryINFDiagExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryINFDiagExportExnmecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryINFDiagExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFDiagExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildINFDiag(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %String
{
	New (aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") return
 	//默认查询感染报告
	Set:aRepType="" aRepType = "1"
	
	Set NIndex="INFDiag"
	Kill ^TMP(NIndex)
	Set Count=1
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.INFDiagnosSrv:QryRepInfoByDateLoc")
	Set sc=rs.Execute(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set ReportID=rs.Data("ReportID")
		Set EpisodeID=rs.Data("EpisodeID")
		
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFDiagnosSrv:QryINFDiagByRep")
		Set se=res.Execute(ReportID,EpisodeID,"")
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set InfPosID=res.Data("InfPosID")
		  	Set InfPos=res.Data("InfPos")
		  	Set InfSubID=res.Data("InfSubID")
		  	Set InfSub=res.Data("InfSub")
		  	Set InfDate=res.Data("InfDate")
		  	Set InfLocID=res.Data("InfLocID")
		  	Set InfDiagnosisBasis=res.Data("InfDiagnosisBasis")
		  	Set InfDiseaseCourse=res.Data("InfDiseaseCourse")
		  	Set InfXDate=res.Data("InfXDate")
		  	Set InfEffectID=res.Data("InfEffectID")
		  	Set InfEffect=res.Data("InfEffect")
		  	Set DeathRelationID=res.Data("DeathRelationID")
		  	Set DeathRelation=res.Data("DeathRelation")
		  	Set UpdateDate=res.Data("UpdateDate")
		  	Set UpdateTime=res.Data("UpdateTime")
		  	Set UpdateUserID=res.Data("UpdateUserID")
		  	Set UpdateUser=res.Data("UpdateUser")
		  	Set IsReportDiag=res.Data("IsReportDiag")
		  	
		  	Set ^TMP(NIndex,Count)=$lb(ReportID,EpisodeID,InfPosID,InfPos,InfSubID,InfSub,InfDate,InfLocID,InfLoc,InfDiagnosisBasis,InfDiseaseCourse,InfXDate,InfEffectID,InfEffect,DeathRelationID,DeathRelation,UpdateDate,UpdateTime,UpdateUserID,UpdateUser,IsReportDiag)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2018-06-05
/// Description:  查询院感报告手术
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFDiagnos
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryINFOPSExport","4","2018-02-01","2018-02-02","","","1","","","","","")
Query QryINFOPSExport(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,OperAnaesID:%String,OperName:%String,OperName2:%String,OperLocID:%String,OperLoc:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDoc:%String,OperType:%String,Anesthesia:%String,NNISLevel:%String,CuteType:%String,CuteHealing:%String,IsOperInf:%String,InfType:%String,IsInHospInf:%String,ASAScore:%String,PreoperWBC:%String,CuteNumber:%String,EndoscopeFlag:%String,ImplantFlag:%String,PreoperAntiFlag:%String,BloodLoss:%String,BloodTrans:%String,PostoperComps:%String") [ SqlProc ]
{
}

ClassMethod QryINFOPSExportExecute(ByRef qHandlex As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
 	Set flag=..BuildINFOPS(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set NIndex="INFOPS"
	Set Count=""
	For {
		Set Count=$o(^TMP(NIndex,Count))
		Quit:Count=""
		Continue:$g(^TMP(NIndex,Count))=""
		
		Set Data=$g(^TMP(NIndex,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP(NIndex)
	
	Quit $$$OK
}

ClassMethod QryINFOPSExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryINFOPSExportExnmecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryINFOPSExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFOPSExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildINFOPS(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %String
{
	New (aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") return
 	//默认查询感染报告
	Set:aRepType="" aRepType = "1"
	
	Set NIndex="INFOPS"
	Kill ^TMP(NIndex)
	Set Count=1
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.INFDiagnosSrv:QryRepInfoByDateLoc")
	Set sc=rs.Execute(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set ReportID=rs.Data("ReportID")
		Set EpisodeID=rs.Data("EpisodeID")
		
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFOPSSrv:QryINFOPSByRep")
		Set se=res.Execute(ReportID,EpisodeID)
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set OperAnaesID=res.Data("OperAnaesID")
		  	Set OperName=res.Data("OperName")
		  	Set OperName2=res.Data("OperName2")
		  	Set OperLocID=res.Data("OperLocID")
		  	Set OperLoc=res.Data("OperLoc")
		  	Set OperDate=res.Data("OperDate")
		  	Set EndDate=res.Data("EndDate")
		  	Set SttTime=res.Data("SttTime")
		  	Set EndTime=res.Data("EndTime")
		  	Set OperHours=res.Data("OperHours")
		  	Set OperDocTxt=res.Data("OperDocTxt")
		  	Set OperDoc=res.Data("OperDoc")
		  	Set OperType=res.Data("OperType")
		  	Set Anesthesia=res.Data("Anesthesia")
		  	Set NNISLevel=res.Data("NNISLevel")
		  	Set CuteType=res.Data("CuteType")
		  	Set CuteHealing=res.Data("CuteHealing")
		  	Set IsOperInf=res.Data("IsOperInf")
		  	Set InfType=res.Data("InfType")
		  	Set IsInHospInf=res.Data("IsInHospInf")
		  	Set ASAScore=res.Data("ASAScore")
		  	Set PreoperWBC=res.Data("PreoperWBC")
		  	Set CuteNumber=res.Data("CuteNumber")
		  	Set EndoscopeFlag=res.Data("EndoscopeFlag")
		  	Set ImplantFlag=res.Data("ImplantFlag")
		  	Set PreoperAntiFlag=res.Data("PreoperAntiFlag")
		  	Set BloodLoss=res.Data("BloodLoss")
		  	Set BloodTrans=res.Data("BloodTrans")
		  	Set PostoperComps=res.Data("PostoperComps")
		  	
		  	Set ^TMP(NIndex,Count)=$lb(ReportID,EpisodeID,OperAnaesID,OperName,OperName2,OperLocID,OperLoc,OperDate,EndDate,SttTime,EndTime,OperHours,OperDocTxt,OperDoc,OperType,Anesthesia,NNISLevel,CuteType,CuteHealing,IsOperInf,InfType,IsInHospInf,ASAScore,PreoperWBC,CuteNumber,EndoscopeFlag,ImplantFlag,PreoperAntiFlag,BloodLoss,BloodTrans,PostoperComps)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2018-06-12
/// Description:  查询院感报告病原学
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFLab
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryINFLabExport","4","2018-02-01","2018-02-02","","","1","","","","","")
Query QryINFLabExport(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,LabRepID:%String,TSDesc:%String,TSDesc2:%String,SpecimenID:%String,Specimen:%String,SubmissDate:%String,SubmissLocID:%String,SubmissLoc:%String,AssayMethodID:%String,AssayMethod:%String,PathogenTestID:%String,PathogenTest:%String,BacteriaIDs:%String,Bacterias:%String,RuleMRBs:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String") [ SqlProc ]
{
}

ClassMethod QryINFLabExportExecute(ByRef qHandlex As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
 	Set flag=..BuildINFLab(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set NIndex="INFLab"
	Set Count=""
	For {
		Set Count=$o(^TMP(NIndex,Count))
		Quit:Count=""
		Continue:$g(^TMP(NIndex,Count))=""
		
		Set Data=$g(^TMP(NIndex,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP(NIndex)
	
	Quit $$$OK
}

ClassMethod QryINFLabExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryINFLabExportExnmecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryINFLabExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFLabExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildINFLab(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %String
{
	New (aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") return
 	//默认查询感染报告
	Set:aRepType="" aRepType = "1"
	
	Set NIndex="INFLab"
	Kill ^TMP(NIndex)
	Set Count=1
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.INFDiagnosSrv:QryRepInfoByDateLoc")
	Set sc=rs.Execute(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set ReportID=rs.Data("ReportID")
		Set EpisodeID=rs.Data("EpisodeID")
		
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFLabSrv:QryINFLabByRep")
		Set se=res.Execute(ReportID,EpisodeID)
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set LabRepID=res.Data("LabRepID")
		  	Set TSDesc=res.Data("TSDesc")
		  	Set TSDesc2=res.Data("TSDesc2")
		  	Set SpecimenID=res.Data("SpecimenID")
		  	Set Specimen=res.Data("Specimen")
		  	Set SubmissDate=res.Data("SubmissDate")
		  	Set SubmissLocID=res.Data("SubmissLocID")
		  	Set SubmissLoc=res.Data("SubmissLoc")
		  	Set AssayMethodID=res.Data("AssayMethodID")
		  	Set AssayMethod=res.Data("AssayMethod")
		  	Set PathogenTestID=res.Data("PathogenTestID")
		  	Set PathogenTest=res.Data("PathogenTest")
		  	Set BacteriaIDs=res.Data("BacteriaIDs")
		  	Set Bacterias=res.Data("Bacterias")
		  	Set RuleMRBs=res.Data("RuleMRBs")
		  	Set UpdateDate=res.Data("UpdateDate")
		  	Set UpdateTime=res.Data("UpdateTime")
		  	Set UpdateUserID=res.Data("UpdateUserID")
		  	Set UpdateUser=res.Data("UpdateUser")
		  	
		  	Set ^TMP(NIndex,Count)=$lb(ReportID,EpisodeID,LabRepID,TSDesc,TSDesc2,SpecimenID,Specimen,SubmissDate,SubmissLocID,SubmissLoc,AssayMethodID,AssayMethod,PathogenTestID,PathogenTest,BacteriaIDs,Bacterias,RuleMRBs,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2018-06-13
/// Description:  查询院感报告抗菌药物
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFAnti
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryINFAntiExport","4","2018-02-01","2018-02-02","","","1","","","","","")
Query QryINFAntiExport(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,AntiUseID:%String,AntiDesc:%String,AntiDesc2:%String,SttDate:%String,EndDate:%String,DoseQty:%String,DoseUnitID:%String,DoseUnit:%String,PhcFreqID:%String,PhcFreq:%String,MedUsePurposeID:%String,MedUsePurpose:%String,AdminRouteID:%String,AdminRoute:%String,MedPurposeID:%String,MedPurpose:%String,TreatmentModeID:%String,TreatmentMode:%String,PreMedEffectID:%String,PreMedEffect:%String,PreMedIndicatID:%String,PreMedIndicat:%String,CombinedMedID:%String,CombinedMed:%String,PreMedTime:%String,PostMedDays:%String,SenAnaID:%String,SenAna:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String") [ SqlProc ]
{
}

ClassMethod QryINFAntiExportExecute(ByRef qHandlex As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
 	Set flag=..BuildINFAnti(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set NIndex="INFAnti"
	Set Count=""
	For {
		Set Count=$o(^TMP(NIndex,Count))
		Quit:Count=""
		Continue:$g(^TMP(NIndex,Count))=""
		
		Set Data=$g(^TMP(NIndex,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP(NIndex)
	
	Quit $$$OK
}

ClassMethod QryINFAntiExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryINFAntiExportExnmecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryINFAntiExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFAntiExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildINFAnti(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "") As %String
{
	New (aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") return
 	//默认查询感染报告
	Set:aRepType="" aRepType = "1"
	
	Set NIndex="INFAnti"
	Kill ^TMP(NIndex)
	Set Count=1
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.INFDiagnosSrv:QryRepInfoByDateLoc")
	Set sc=rs.Execute(aDateType,aDateFrom,aDateTo,aRepLoc,aRepStatus,aRepType,aRegNo,aMrNo,aPatName,aHospIDs,aInfLoc)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set ReportID=rs.Data("ReportID")
		Set EpisodeID=rs.Data("EpisodeID")
		
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFAntiSrv:QryINFAntiByRep")
		Set se=res.Execute(ReportID,EpisodeID)
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set AntiUseID=res.Data("AntiUseID")
		  	Set AntiDesc=res.Data("AntiDesc")
		  	Set AntiDesc2=res.Data("AntiDesc2")
		  	Set SttDate=res.Data("SttDate")
		  	Set EndDate=res.Data("EndDate")
		  	Set DoseQty=res.Data("DoseQty")
		  	Set DoseUnitID=res.Data("DoseUnitID")
		  	Set DoseUnit=res.Data("DoseUnit")
		  	Set PhcFreqID=res.Data("PhcFreqID")
		  	Set PhcFreq=res.Data("PhcFreq")
		  	Set MedUsePurposeID=res.Data("MedUsePurposeID")
		  	Set MedUsePurpose=res.Data("MedUsePurpose")
		  	Set AdminRouteID=res.Data("AdminRouteID")
		  	Set AdminRoute=res.Data("AdminRoute")
		  	Set MedPurposeID=res.Data("MedPurposeID")
		  	Set MedPurpose=res.Data("MedPurpose")
		  	Set TreatmentModeID=res.Data("TreatmentModeID")
		  	Set TreatmentMode=res.Data("TreatmentMode")
		  	Set PreMedEffectID=res.Data("PreMedEffectID")
		  	Set PreMedEffect=res.Data("PreMedEffect")
		  	Set PreMedIndicatID=res.Data("PreMedIndicatID")
		  	Set PreMedIndicat=res.Data("PreMedIndicat")
		  	Set CombinedMedID=res.Data("CombinedMedID")
		  	Set CombinedMed=res.Data("CombinedMed")
		  	Set PreMedTime=res.Data("PreMedTime")
		  	Set PostMedDays=res.Data("PostMedDays")
		  	Set SenAnaID=res.Data("SenAnaID")
		  	Set SenAna=res.Data("SenAna")
		  	Set UpdateDate=res.Data("UpdateDate")
		  	Set UpdateTime=res.Data("UpdateTime")
		  	Set UpdateUserID=res.Data("UpdateUserID")
		  	Set UpdateUser=res.Data("UpdateUser")
		  	
		  	Set ^TMP(NIndex,Count)=$lb(ReportID,EpisodeID,AntiUseID,AntiDesc,AntiDesc2,SttDate,EndDate,DoseQty,DoseUnitID,DoseUnit,PhcFreqID,PhcFreq,MedUsePurposeID,MedUsePurpose,AdminRouteID,AdminRoute,MedPurposeID,MedPurpose,TreatmentModeID,TreatmentMode,PreMedEffectID,PreMedEffect,PreMedIndicatID,PreMedIndicat,CombinedMedID,CombinedMed,PreMedTime,PostMedDays,SenAnaID,SenAna,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     chenjb
/// CreatDate：   2018-06-05
/// Description:  查询患者手术信息
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFDiagnos
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryPatAdmOPSExport","","E","","2018-10-01","2018-10-15")
Query QryPatAdmOPSExport(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,OperAnaesID:%String,OperName:%String,OperName2:%String,OperLocID:%String,OperLoc:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDoc:%String,OperType:%String,Anesthesia:%String,NNISLevel:%String,CuteType:%String,CuteHealing:%String,IsOperInf:%String,InfType:%String,IsInHospInf:%String,ASAScore:%String,PreoperWBC:%String,CuteNumber:%String,EndoscopeFlag:%String,ImplantFlag:%String,PreoperAntiFlag:%String,BloodLoss:%String,BloodTrans:%String,PostoperComps:%String") [ SqlProc ]
{
}

ClassMethod QryPatAdmOPSExportExecute(ByRef qHandlex As %Binary, aHospIDs As %String, aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set flag=..BuildPatAdmOPS(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set PatAdmOPSExportIdx="PatAdmOPS"
	Set Count=""
	For {
		Set Count=$o(^TMP($zn,$j,PatAdmOPSExportIdx,Count))
		Quit:Count=""
		Continue:$g(^TMP($zn,$j,PatAdmOPSExportIdx,Count))=""
		
		Set Data=$g(^TMP($zn,$j,PatAdmOPSExportIdx,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP($zn,$j,PatAdmOPSExportIdx)
	
	Quit $$$OK
}

ClassMethod QryPatAdmOPSExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryPatAdmOPSExportExecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryPatAdmOPSExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatAdmOPSExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildPatAdmOPS(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %String
{
	New (aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set PatAdmOPSExportIdx="PatAdmOPS"
	Kill ^TMP($zn,$j,PatAdmOPSExportIdx)
	Set Count=1
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
  
    Set rs=##Class(%ResultSet).%New("DHCHAI.STAS.StaService:QryInLocAdm")
  	Set sc=rs.Execute(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}  	    
    While (rs.Next()) {
	    Set EpisodeID=rs.Data("Paadm")	 
		Set ReportID=""
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFOPSSrv:QryINFOPSByRep")
		Set se=res.Execute(ReportID,EpisodeID)
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set OperAnaesID=res.Data("OperAnaesID")
		  	Set OperName=res.Data("OperName")
		  	Set OperName2=res.Data("OperName2")
		  	Set OperLocID=res.Data("OperLocID")
		  	Set OperLoc=res.Data("OperLoc")
		  	Set OperDate=res.Data("OperDate")
		  	Set EndDate=res.Data("EndDate")
		  	Set SttTime=res.Data("SttTime")
		  	Set EndTime=res.Data("EndTime")
		  	Set OperHours=res.Data("OperHours")
		  	Set OperDocTxt=res.Data("OperDocTxt")
		  	Set OperDoc=res.Data("OperDoc")
		  	Set OperType=res.Data("OperType")
		  	Set Anesthesia=res.Data("Anesthesia")
		  	Set NNISLevel=res.Data("NNISLevel")
		  	Set CuteType=res.Data("CuteType")
		  	Set CuteHealing=res.Data("CuteHealing")
		  	Set IsOperInf=res.Data("IsOperInf")
		  	Set InfType=res.Data("InfType")
		  	Set IsInHospInf=res.Data("IsInHospInf")
		  	Set ASAScore=res.Data("ASAScore")
		  	Set PreoperWBC=res.Data("PreoperWBC")
		  	Set CuteNumber=res.Data("CuteNumber")
		  	Set EndoscopeFlag=res.Data("EndoscopeFlag")
		  	Set ImplantFlag=res.Data("ImplantFlag")
		  	Set PreoperAntiFlag=res.Data("PreoperAntiFlag")
		  	Set BloodLoss=res.Data("BloodLoss")
		  	Set BloodTrans=res.Data("BloodTrans")
		  	Set PostoperComps=res.Data("PostoperComps")
		  	
		  	Set ^TMP($zn,$j,PatAdmOPSExportIdx,Count)=$lb(ReportID,EpisodeID,OperAnaesID,OperName,OperName2,OperLocID,OperLoc,OperDate,EndDate,SttTime,EndTime,OperHours,OperDocTxt,OperDoc,OperType,Anesthesia,NNISLevel,CuteType,CuteHealing,IsOperInf,InfType,IsInHospInf,ASAScore,PreoperWBC,CuteNumber,EndoscopeFlag,ImplantFlag,PreoperAntiFlag,BloodLoss,BloodTrans,PostoperComps)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     chenjb
/// CreatDate：   2018-10-18
/// Description:  查询病原学
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFLab
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryPatAdmLabExport","","E","","2018-10-01","2018-10-15")
Query QryPatAdmLabExport(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,LabRepID:%String,TSDesc:%String,TSDesc2:%String,SpecimenID:%String,Specimen:%String,SubmissDate:%String,SubmissLocID:%String,SubmissLoc:%String,AssayMethodID:%String,AssayMethod:%String,PathogenTestID:%String,PathogenTest:%String,BacteriaIDs:%String,Bacterias:%String,RuleMRBs:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String") [ SqlProc ]
{
}

ClassMethod QryPatAdmLabExportExecute(ByRef qHandlex As %Binary, aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set flag=..BuildPatAdmLab(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set PatAdmLabExportIdx="PatAdmLab"
	Set Count=""
	For {
		Set Count=$o(^TMP($zn,$j,PatAdmLabExportIdx,Count))
		Quit:Count=""
		Continue:$g(^TMP($zn,$j,PatAdmLabExportIdx,Count))=""
		
		Set Data=$g(^TMP($zn,$j,PatAdmLabExportIdx,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP($zn,$j,PatAdmLabExportIdx)
	
	Quit $$$OK
}

ClassMethod QryPatAdmLabExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryPatAdmLabExportExecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryPatAdmLabExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatAdmLabExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildPatAdmLab(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %String
{
	New (aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") return
	
	Set PatAdmLabExportIdx="PatAdmLab"
	Kill ^TMP($zn,$j,PatAdmLabExportIdx)
	Set Count=1
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
  
    Set rs=##Class(%ResultSet).%New("DHCHAI.STAS.StaService:QryInLocAdm")
  	Set sc=rs.Execute(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set ReportID=""
		Set EpisodeID=rs.Data("Paadm")
		
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFLabSrv:QryINFLabByRep")
		Set se=res.Execute(ReportID,EpisodeID)
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set LabRepID=res.Data("LabRepID")
		  	Set TSDesc=res.Data("TSDesc")
		  	Set TSDesc2=res.Data("TSDesc2")
		  	Set SpecimenID=res.Data("SpecimenID")
		  	Set Specimen=res.Data("Specimen")
		  	Set SubmissDate=res.Data("SubmissDate")
		  	Set SubmissLocID=res.Data("SubmissLocID")
		  	Set SubmissLoc=res.Data("SubmissLoc")
		  	Set AssayMethodID=res.Data("AssayMethodID")
		  	Set AssayMethod=res.Data("AssayMethod")
		  	Set PathogenTestID=res.Data("PathogenTestID")
		  	Set PathogenTest=res.Data("PathogenTest")
		  	Set BacteriaIDs=res.Data("BacteriaIDs")
		  	Set Bacterias=res.Data("Bacterias")
		  	Set RuleMRBs=res.Data("RuleMRBs")
		  	Set UpdateDate=res.Data("UpdateDate")
		  	Set UpdateTime=res.Data("UpdateTime")
		  	Set UpdateUserID=res.Data("UpdateUserID")
		  	Set UpdateUser=res.Data("UpdateUser")
		  	
		  	Set ^TMP($zn,$j,PatAdmLabExportIdx,Count)=$lb(ReportID,EpisodeID,LabRepID,TSDesc,TSDesc2,SpecimenID,Specimen,SubmissDate,SubmissLocID,SubmissLoc,AssayMethodID,AssayMethod,PathogenTestID,PathogenTest,BacteriaIDs,Bacterias,RuleMRBs,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     chenjb
/// CreatDate：   2018-10-18
/// Description:  查询抗菌药物
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFAnti
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryPatAdmAntiExport","","E","","2018-10-01","2018-10-15")
Query QryPatAdmAntiExport(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,AntiUseID:%String,AntiDesc:%String,AntiDesc2:%String,SttDate:%String,EndDate:%String,DoseQty:%String,DoseUnitID:%String,DoseUnit:%String,PhcFreqID:%String,PhcFreq:%String,MedUsePurposeID:%String,MedUsePurpose:%String,AdminRouteID:%String,AdminRoute:%String,MedPurposeID:%String,MedPurpose:%String,TreatmentModeID:%String,TreatmentMode:%String,PreMedEffectID:%String,PreMedEffect:%String,PreMedIndicatID:%String,PreMedIndicat:%String,CombinedMedID:%String,CombinedMed:%String,PreMedTime:%String,PostMedDays:%String,SenAnaID:%String,SenAna:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String") [ SqlProc ]
{
}

ClassMethod QryPatAdmAntiExportExecute(ByRef qHandlex As %Binary, aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") $$$OK
 	Set flag=..BuildPatAdmAnti(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set PatAdmAntiExportIdx="PatAdmAnti"
	Set Count=""
	For {
		Set Count=$o(^TMP($zn,$j,PatAdmAntiExportIdx,Count))
		Quit:Count=""
		Continue:$g(^TMP($zn,$j,PatAdmAntiExportIdx,Count))=""
		
		Set Data=$g(^TMP($zn,$j,PatAdmAntiExportIdx,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP($zn,$j,PatAdmAntiExportIdx)
	
	Quit $$$OK
}

ClassMethod QryPatAdmAntiExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryPatAdmAntiExportExnmecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryPatAdmAntiExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatAdmAntiExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildPatAdmAnti(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %String
{
	New (aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") return
	
	Set PatAdmAntiExportIdx="PatAdmAnti"
	Kill ^TMP($zn,$j,PatAdmAntiExportIdx)
	Set Count=1
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
    
    Set rs=##Class(%ResultSet).%New("DHCHAI.STAS.StaService:QryInLocAdm")
  	Set sc=rs.Execute(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set ReportID=""
		Set EpisodeID=rs.Data("Paadm")
		Set res=##class(%ResultSet).%New("DHCHAI.IRS.INFAntiSrv:QryINFAntiByRep")
		Set se=res.Execute(ReportID,EpisodeID)
		If $$$ISERR(se) {
		  	Do $System.Status.DisplayError(se)
		  	Continue
	  	}
	  	While (res.Next()){
		  	Set AntiUseID=res.Data("AntiUseID")
		  	Set AntiDesc=res.Data("AntiDesc")
		  	Set AntiDesc2=res.Data("AntiDesc2")
		  	Set SttDate=res.Data("SttDate")
		  	Set EndDate=res.Data("EndDate")
		  	Set DoseQty=res.Data("DoseQty")
		  	Set DoseUnitID=res.Data("DoseUnitID")
		  	Set DoseUnit=res.Data("DoseUnit")
		  	Set PhcFreqID=res.Data("PhcFreqID")
		  	Set PhcFreq=res.Data("PhcFreq")
		  	Set MedUsePurposeID=res.Data("MedUsePurposeID")
		  	Set MedUsePurpose=res.Data("MedUsePurpose")
		  	Set AdminRouteID=res.Data("AdminRouteID")
		  	Set AdminRoute=res.Data("AdminRoute")
		  	Set MedPurposeID=res.Data("MedPurposeID")
		  	Set MedPurpose=res.Data("MedPurpose")
		  	Set TreatmentModeID=res.Data("TreatmentModeID")
		  	Set TreatmentMode=res.Data("TreatmentMode")
		  	Set PreMedEffectID=res.Data("PreMedEffectID")
		  	Set PreMedEffect=res.Data("PreMedEffect")
		  	Set PreMedIndicatID=res.Data("PreMedIndicatID")
		  	Set PreMedIndicat=res.Data("PreMedIndicat")
		  	Set CombinedMedID=res.Data("CombinedMedID")
		  	Set CombinedMed=res.Data("CombinedMed")
		  	Set PreMedTime=res.Data("PreMedTime")
		  	Set PostMedDays=res.Data("PostMedDays")
		  	Set SenAnaID=res.Data("SenAnaID")
		  	Set SenAna=res.Data("SenAna")
		  	Set UpdateDate=res.Data("UpdateDate")
		  	Set UpdateTime=res.Data("UpdateTime")
		  	Set UpdateUserID=res.Data("UpdateUserID")
		  	Set UpdateUser=res.Data("UpdateUser")
		  	Set ^TMP($zn,$j,PatAdmAntiExportIdx,Count)=$lb(ReportID,EpisodeID,AntiUseID,AntiDesc,AntiDesc2,SttDate,EndDate,DoseQty,DoseUnitID,DoseUnit,PhcFreqID,PhcFreq,MedUsePurposeID,MedUsePurpose,AdminRouteID,AdminRoute,MedPurposeID,MedPurpose,TreatmentModeID,TreatmentMode,PreMedEffectID,PreMedEffect,PreMedIndicatID,PreMedIndicat,CombinedMedID,CombinedMed,PreMedTime,PostMedDays,SenAnaID,SenAna,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
			Set Count=Count+1
		}
		Do res.Close()
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     chenjb
/// CreatDate：   2018-10-18
/// Description:  查询抗菌药物
/// Table：       DHCHAI.IR.INFReport,DHCHAI.IR.INFAnti
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFRepExportSrv","QryPatAdmTransExport","","E","","2018-10-01","2018-10-15")
Query QryPatAdmTransExport(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,TransID:%String,PATransTypeDesc:%String,RstStDt:%String,RstEndDt:%String,PosDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPatAdmTransExportExecute(ByRef qHandlex As %Binary, aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") $$$OK
 	Set flag=..BuildPatAdmTrans(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set PatAdmTransExportIdx="PatAdmTrans"
	Set Count=""
	For {
		Set Count=$o(^TMP($zn,$j,PatAdmTransExportIdx,Count))
		Quit:Count=""
		Continue:$g(^TMP($zn,$j,PatAdmTransExportIdx,Count))=""
		
		Set Data=$g(^TMP($zn,$j,PatAdmTransExportIdx,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1 
	}
	Kill ^TMP($zn,$j,PatAdmTransExportIdx)
	
	Quit $$$OK
}

ClassMethod QryPatAdmTransExportClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryPatAdmTransExportExecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryPatAdmTransExportFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatAdmTransExportExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildPatAdmTrans(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %String
{
	New (aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") return
	
	Set PatAdmTransExportIdx="PatAdmTrans"
	Kill ^TMP($zn,$j,PatAdmTransExportIdx)
	Set Count=1
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
    
    Set rs=##Class(%ResultSet).%New("DHCHAI.STAS.StaService:QryInLocAdm")
  	Set sc=rs.Execute(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
	While (rs.Next()){
		Set EpisodeID=rs.Data("Paadm")
		Set ReportID =""
		
		Set xTransID = ""
		For {
			Set xTransID = $o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",EpisodeID,xTransID))
			Quit:xTransID=""
			Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$Isobject(objTrans)
			Set PATransType =objTrans.PATransType
			Set PosDesc = ""
			if (PATransType="B")
			{
				Set:$Isobject(objTrans.PATransBedDr) PosDesc =objTrans.PATransBedDr.BTDesc
			}
			else
			{
				Set:$Isobject(objTrans.PATransLocDr) PosDesc =objTrans.PATransLocDr.BTDesc
			}
			Set PATransTypeDesc = ""
			if (PATransType="B")
			{
				Set PATransTypeDesc = "转入床"
			}
			Elseif (PATransType="E")
			{
				Set PATransTypeDesc = "转入科"	
			}
			else
			{
				Set PATransTypeDesc = "转入病区"	
			}
			Set StartDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objTrans.PATransDate)
			Set StartTime = objTrans.PATransTime
			Set EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objTrans.PAOutLocDate)
			Set EndTime =objTrans.PAOutLocTime
			Set RstStDt = StartDate_" "_$zt(+StartTime,1)
			Set:EndDate'="" RstEndDt = EndDate
			Set:EndTime'="" RstEndDt =" "_$zt(+EndTime,1)
			Set ^TMP($zn,$j,PatAdmTransExportIdx,Count)=$lb(ReportID,EpisodeID,xTransID,PATransTypeDesc,RstStDt,RstEndDt,PosDesc)
			Set Count=Count+1
		}
	  	
		  	
		  	
	}
	Do rs.Close()
	Quit 1
}

}
