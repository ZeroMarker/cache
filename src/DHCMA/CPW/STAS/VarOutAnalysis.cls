/// 名称: DHCMA.CPW.STAS.VarOutAnalysis
/// 描述: 临床路径变异-出径报表服务类
/// 编写者：zqy
/// 编写日期: 2022-11-16
Class DHCMA.CPW.STAS.VarOutAnalysis Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2022-11-16
/// Description:  按出院日期统计出径变异数据
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.VarOutAnalysis","QryCPWVarAndOutDateOfDay","2012-05-01","2019-11-01","","2","","Adm")
Query QryCPWVarAndOutDateOfDay(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,ExecReasonList:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%Integer,PatCost:%Integer,PAAdmType:%String,ForCPCount:%Integer,InCPCount:%Integer,OutCPCount:%Integer,ClsCPCount:%Integer,VarCPCount:%Integer,HasHAICount:%Integer,PathMastID:%String,PathMastDesc:%String,InLocID:%String,AdmLocID:%String,AdmLocDesc:%String,PathwayVarTime:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWVarAndOutDateOfDayExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	Set ^zqy("QryCPWVarAndOutDateOfDay")=$lb(aDateFrom,aDateTo,aLocID,aHospID,aSDID,aLocType)
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
	 		Continue:(aLocID'="")&&(aLocID'=InLocID)&&(aLocType="InP")
	 		Set AdmLocID = $p(AdmLocID,"!!",1) 
	 		
	 		If aLocType="InP"{
		 		Set AdmLocDesc = ""
		 		Set AdmLocID = ""
		 		Set:InLocID'="" AdmLocID = $p(InLocID,"!!",1)
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
				Set CPVarTypeDesc = objVar.CPVariatDr.BTTypeDr.BTDesc    //变异原因类型
				Continue:CPVarTypeDesc'["变异"
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
	 		Set DischDate=$lg(PatData,9)
	 		Continue:InCPCount=0  //add by zqy 2022-5-18过滤没有入经的数据
			Set Data=$lb(ind)_CPWData_PatData_$lb(ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,PathMastID,PathMastDesc,InLocID,AdmLocID,AdmLocDesc,PathwayVarTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
    	}
    }
 	
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarAndOutDateOfDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarAndOutDateOfDayExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarAndOutDateOfDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarAndOutDateOfDayExecute ]
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

/// Description:  查询病人出入径及变异情况
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.VarOutAnalysis","QryCPWPathWayVar","2013-10-28","2019-10-30","2!!1","","","Adm")
Query QryCPWPathWayVar(aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String, aSDID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,CPVarID:%String,CPVariatDesc:%String,CPVarTypeDesc:%String,CPStatus:%String,xCPInLocId:%String,CPVarPathEpsiDesc:%String,CPVarUserDesc:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,ExecReasonList:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%String,PatCost:%String,PAAdmType:%String") [ SqlProc ]
{
}

ClassMethod QryCPWPathWayVarExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String, aSDID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^zqy("QryCPWPathWayVar")=$lb(aDateFrom,aDateTo,aHospID,aLocID,aSDID,aLocType)
 	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	Set:aLocID["所有" aLocID=""
	Set:aSDID["所有" aSDID=""
	
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
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))&&(aLocType="Adm")
    		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'[$p(AdmHospID,"!!",1))
    		
    		//出院患者
    		//Set HospStatus=objEpisode.PAVisitStatus
    		//Continue:HospStatus'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
    		
    		Set AdmDays=objEpisode.PAAdmDays	//住院天数
    		Set EpisodeID=objEpisode.OID
		 	
	 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
	 		Continue:xCPWID=""
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
			Continue:'$IsObject(objPathway)
			Set EpisodeID = objPathway.CPEpisodeID    
			Set CPStatus = objPathway.CPStatus 	     //路径状态
			Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
			Set PatData = ##class(DHCMA.CPW.STAS.OutPutData).GetPatData(EpisodeID)
			Set InLocID = objPathway.CPInLocID
			Continue:(aLocID'="")&&(aLocID'=$p(InLocID,"!!",1))&&(aLocType="InP")
			
			Set:aLocType="InP" AdmLocID=$p(InLocID,"!!",1)
			
			Set objMast = objPathway.CPFormDr.FormPathDr
			Continue:'$IsObject(objMast)
			Set PathMastID = objPathway.CPFormDr.FormPathDr.%Id()
			Set PathMastDesc = objPathway.CPFormDr.FormPathDr.BTDesc
	 		Continue:(aSDID'="")&&(aSDID'=PathMastID)
			
			//过滤门诊
	 		Set PAAdmType=$lg(PatData,12)
	 		Continue:PAAdmType'["I"
	 		//过滤未出院信息
	 		Set DischDate=$lg(PatData,9)
	 		//Continue:DischDate=""
			
			Set xPathWayVarId=""
			for {
				Set xPathWayVarId=$o(^DHCMA.CPW.CP.PathwayD(xCPWID,"VAR",xPathWayVarId))
				Quit:xPathWayVarId=""
				Set objPathWayVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xCPWID_"||"_xPathWayVarId)
				Continue:'$IsObject(objPathWayVar)
				Set CPVariatDesc=objPathWayVar.CPVariatDr.BTDesc          //变异原因
				Set CPVarID = objPathWayVar.%Id()
				Set CPVarTypeDesc = objPathWayVar.CPVariatDr.BTTypeDr.BTDesc    //变异原因类型
				Continue:CPVarTypeDesc'["变异"
				Continue:objPathWayVar.CPIsActive'=1
				//Continue:CPStatus="O"
				Set CPStatus="Var"
				Set CPVarCatDesc = objPathWayVar.CPVariatDr.BTCatDr.BTDesc      //变异原因分类
				Set CPVarPathEpsiDesc = objPathWayVar.CPEpisDr.CPFormEpDr.EpDesc  //变异阶段
				Set CPVarUserId = objPathWayVar.CPActUserID
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(CPVarUserId)
				Set:$IsObject(objUser) CPVarUserDesc=objUser.BTDesc
				
				Set Data=$lb(ind,EpisodeID,CPVarID,CPVariatDesc,CPVarTypeDesc,CPStatus,xCPInLocId,CPVarPathEpsiDesc,CPVarUserDesc)_CPWData_PatData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
			Set xPathwayApplyId=""
			for{
				Set xPathwayApplyId=$o(^DHCMA.CPW.CP.PathwayD(xCPWID,"APPLY",xPathwayApplyId))
				Quit:xPathwayApplyId=""
				Set objPathwayApply = ##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xPathwayApplyId)
				Continue:'$IsObject(objPathwayApply)
				Set PathwayApplyID = objPathwayApply.%Id()
				Set ApplyTypeDesc = objPathwayApply.CPTypeDr.BTDesc  //申请类型
				Continue:objPathway.CPStatus'="O"					 //出径申请判断
				Set CPStatus="O"
				Set ApplyReasonDesc = objPathwayApply.CPReasonDr.BTDesc  //申请原因
				Set ApplyUserId = objPathwayApply.CPActUserID
				Set ApplyUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ApplyUserId)
				Set:$IsObject(ApplyUser) ApplyUserDesc=ApplyUser.BTDesc
				
				Set Data=$lb(ind,EpisodeID,PathwayApplyID,ApplyReasonDesc,ApplyTypeDesc,CPStatus,xCPInLocId,"",ApplyUserDesc)_CPWData_PatData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}	
		}
	}
	
 	Quit $$$OK
}

ClassMethod QryCPWPathWayVarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPathWayVarExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPathWayVarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPathWayVarExecute ]
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
