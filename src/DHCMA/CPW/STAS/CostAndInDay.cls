/// 名称: DHCMA.CPW.STAS.VarOutAnalysis
/// 描述: 临床路径费用住院日报表服务类
/// 编写者：zqy
/// 编写日期: 2022-11-16
Class DHCMA.CPW.STAS.CostAndInDay Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2022-11-16
/// Description:  按出院日期统计费用住院日数据
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.CostAndInDay","QryCPWCostAndDaysDateOfDay","2019-01-01","2020-03-01","","2","")
Query QryCPWCostAndDaysDateOfDay(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,ExecReasonList:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%Integer,PatCost:%Integer,PAAdmType:%String,ForCPCount:%Integer,InCPCount:%Integer,OutCPCount:%Integer,ClsCPCount:%Integer,VarCPCount:%Integer,HasHAICount:%Integer,PathMastID:%String,PathMastDesc:%String,InLocID:%String,AdmLocID:%String,AdmLocDesc:%String,PathwayVarTime:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWCostAndDaysDateOfDayExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
    Set xDate=aDateFrom-1
    For {
    	Set xDate=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate))
    	Quit:xDate=""
    	Quit:xDate>aDateTo
    	
 		Set xEpisodeID=""
    	For {
    		Set xEpisodeID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate,xEpisodeID))
    		Quit:xEpisodeID=""
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objEpisode.PAAdmLocID
    		Set AdmLocDesc = objEpisode.PAAdmLocDesc
    		
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))&&(aLocType="Adm")
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		//出院患者
    		//Set HospStatus=objEpisode.PAVisitStatus
    		//Continue:HospStatus'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
    		
    		Set EpisodeID=objEpisode.OID
    		
			Set ForCPCount=0
			Set InCPCount=0
			Set OutCPCount=0
			Set ClsCPCount=0
			Set VarCPCount=0
			Set HasHAICount=0
			
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
			Continue:xPathwayID=""
			
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			
			Continue:'$IsObject(objPathway)
	 	
	 		Set objMast = objPathway.CPFormDr.FormPathDr
			Continue:'$IsObject(objMast)
			Set PathMastID = objPathway.CPFormDr.FormPathDr.%Id()
			Set PathMastDesc = objPathway.CPFormDr.FormPathDr.BTDesc
	 		Continue:(aSDID'="")&&(aSDID'=PathMastID)
	 	
	 		Set InLocID =  objPathway.CPInLocID //$p(AdmLocID,"!!",1) 
	 		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(InLocID,"!!",1))&&(aLocType="InP")
	 		Set AdmLocID = $p(AdmLocID,"!!",1) 
	 		
	 		If aLocType="InP"{
		 		Set AdmLocDesc = ""
		 		Set AdmLocID = $p(InLocID,"!!",1)
		 		Set objAdmLoc=##class(DHCMA.Util.EP.Location).xGetByOID(InLocID)
		 		Set:$IsObject(objAdmLoc) AdmLocDesc=objAdmLoc.BTDesc	
		 	}
	 		
	 		Set Status=objPathway.CPStatus
	 		Set:Status'="" ForCPCount =ForCPCount+1
	 		Set:Status'="T" InCPCount =InCPCount+1
	 		Set:Status="O" OutCPCount =OutCPCount+1
	 		Set:Status="C" ClsCPCount =ClsCPCount+1
	 		
	 		Set PathwayVarflg=0
	 		Set PathwayVarTime=0 //每个路径的变异例次
	 		Set xPathwayVarId=""
	 		For{
		 		Set xPathwayVarId = $O(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xPathwayVarId))
		 		Quit:xPathwayVarId=""
		 		//Quit:PathwayVarflg=1
		 		Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xPathwayVarId)
		 		Continue:'$IsObject(objVar)
		 		Set:objVar.CPIsActive=1 PathwayVarflg=1,PathwayVarTime = PathwayVarTime+1
		 		}
	 		Set:PathwayVarflg=1 VarCPCount = VarCPCount+1
	 		Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
	 		
	 		Set EpisodeID=objPathway.CPEpisodeID
	 		
	 		Set PatData =  ##class(DHCMA.CPW.STAS.OutPutData).GetPatData(EpisodeID)
	 		Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)
	 		Set:IsHAI=1 HasHAICount=HasHAICount+1
	 		
	 		Set caps=1
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,10,caps:0)  //住院天数清零
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,11,caps:0)  //费用清空
	 		
	 		//过滤门诊
	 		Set PAAdmType=$lg(PatData,12)
	 		Continue:PAAdmType'["I"
	 		//过滤未出院信息
	 		Set DischDate=$lg(PatData,9)
	 		Continue:DischDate=""
	 		//Set OrdData = ..GetOrdData(objPathway)
	 		
			Set Data=$lb(ind)_CPWData_PatData_$lb(ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,PathMastID,PathMastDesc,InLocID,AdmLocID,AdmLocDesc,PathwayVarTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
    	  	}
    }
 	
 	
 	Quit $$$OK
}

ClassMethod QryCPWCostAndDaysDateOfDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWCostAndDaysDateOfDayExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWCostAndDaysDateOfDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWCostAndDaysDateOfDayExecute ]
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

}
