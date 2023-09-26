/// 名称: DHCWMR.FPService.PathologRepSrv
/// 描述: 病理编目相关服务
/// 编写者：liyi
/// 编写日期: 2015-11-26
Class DHCWMR.FPService.PathologRepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  查询病理报告编目列表
/// Table：       DHCWMR.FP.PathologRep
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.FPService.PathologRepSrv","QryPathologRep","2","7","2015-11-26","2015-11-26","0","","1")
Query QryPathologRep(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aQryFlag As %String) As %Query(ROWSPEC = "PathRepID:%String,PatientID:%String,PapmiNo:%String,VolID:%String,FrontPageID:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmitDept:%String,AdmitDeptDesc:%String,AdmitDate:%String,EstimDischDate:%String,EpisodeID:%String,Number:%String,ReportID:%String,RepDate:%String,RepTime:%String,RepUser:%String,RepUserDesc:%String,Diagnos:%String,IsCoding:%String,CodDate:%String,CodTime:%String,CodUser:%String,CodUserDesc:%String")
{
}

ClassMethod QryPathologRepExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aQryFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^LIYI=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aLocGrpID,aLocID,aQryFlag)
 	
 	Quit:(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}
	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If (aQryFlag=1) {  //未编目查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		For xDate = aDateFrom:1:aDateTo{
			Set xPathRepID=""
			For {
				Set xPathRepID = $o(^DHCWMR.FP.PathologRepI("IndexOnIsCodeRepDate",0,xDate,xPathRepID))
				Quit:xPathRepID=""
				
				Set Data = ..BuilPathRep(xPathRepID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} ElseIf (aQryFlag=2) {  //已编目
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		For xDate = aDateFrom:1:aDateTo{
			Set xPathRepID=""
			For {
				Set xPathRepID = $o(^DHCWMR.FP.PathologRepI("IndexOnCodDate",xDate,xPathRepID))
				Quit:xPathRepID=""
				
				Set Data = ..BuilPathRep(xPathRepID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} ElseIf (aQryFlag=3) {  //报告查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xCoding = ""
		For {
			Set xCoding =$o(^DHCWMR.FP.PathologRepI("IndexOnIsCodeRepDate",xCoding))
			Quit:xCoding=""
			For xDate = aDateFrom:1:aDateTo{
				Set xPathRepID=""
				For {
					Set xPathRepID = $o(^DHCWMR.FP.PathologRepI("IndexOnIsCodeRepDate",xCoding,xDate,xPathRepID))
					Quit:xPathRepID=""
			
					Set Data = ..BuilPathRep(xPathRepID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	
	}
	
	Quit $$$OK
}

ClassMethod QryPathologRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathologRepExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPathologRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathologRepExecute ]
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

ClassMethod BuilPathRep(aPathRepID As %String) As %String
{
	//New (aPathRep)
	Set return = ""
	Set objPathRep = ##class(DHCWMR.FP.PathologRep).GetObjById(aPathRepID)
	Quit:'$IsObject(objPathRep) return
	
	Set EpisodeID = objPathRep.PREpisodeID
	Set Number 	  = objPathRep.PRNumber
	Set ReportID  = objPathRep.PRReportID
	Set RepDate   = objPathRep.PRRepDate
	Set:RepDate'="" RepDate = $zd(RepDate,3)
	Set RepTime   = objPathRep.PRRepTime
	Set:RepTime'="" RepTime = $zt(RepTime)
	Set RepUser   = objPathRep.PRRepUser
	Set:RepUser'="" RepUserDesc = $p($g(^SSU("SSUSR",RepUser)),"^",2)
	Set Diagnos	  = objPathRep.PRDiagnos
	Set IsCoding  = objPathRep.PRIsCoding
	Set CodDate   = objPathRep.PRCodDate
	Set:CodDate'="" CodDate = $zd(CodDate,3)
	Set CodTime   = objPathRep.PRCodTime
	Set:CodTime'="" CodTime = $zt(CodTime)
	Set CodUser   = objPathRep.PRCodUser
	Set:CodUser'="" CodUserDesc = $p($g(^SSU("SSUSR",CodUser)),"^",2)

	Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	Quit:PatientID="" return
	Set PapmiNo = $p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set objVol = ##Class(DHCWMR.SS.Volume).GetObjByPaadm(EpisodeID)
	Quit:'$IsObject(objVol) return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Set MrTypeID = objVol.SVMainDr.SMMrType.%Id()
	Quit:(aMrTypeID'="")&&(aMrTypeID'=MrTypeID) return
	
	Set MrNo = objVol.SVMainDr.SMMrNo
	Set objPatient=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm(EpisodeID,"","")
	Quit:'$IsObject(objPatient) return
	
	Set PatName = objPatient.VPPatName
	Set Sex = objPatient.VPSex
	Set Age = objPatient.VPAge
	Set AdmitDept = objPatient.VPAdmitDept
	Set:AdmitDept'="" AdmitDeptDesc = $p($g(^CTLOC(+AdmitDept)),"^",2)
	Set AdmitDate = objPatient.VPAdmitDate
	Set:AdmitDate'="" AdmitDate = $zd(AdmitDate,3)
	Set EstimDischDate = objPatient.VPEstimDischDate
	Set:EstimDischDate'="" EstimDischDate = $zd(EstimDischDate,3)
	Set AdmitWard = objPatient.VPAdmitWard
	If aLocID'="" {
    	Quit:(aLocID'[("|"_AdmitDept_"|"))&&(aLocID'[("|"_AdmitWard_"|")) return
    }
	Set AdmitHosp=""
	Set:AdmitDept'="" AdmitHosp = ##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmitDept)
	Quit:(aHospID'="")&&(aHospID'[(","_AdmitHosp_",")) return
	
	//是否编目 卷ID
	Set VolID = objVol.%Id()
	Set objFrontPage = ##class(DHCWMR.FPService.FrontPageSrv).GetFPObjByAdm(EpisodeID)
	Set:$IsObject(objFrontPage) FrontPageID=objFrontPage.%Id()
	
	Set Data = $lb(aPathRepID,PatientID,PapmiNo,VolID,$g(FrontPageID),MrNo,PatName,Sex,Age,AdmitDept,$g(AdmitDeptDesc),AdmitDate,EstimDischDate,EpisodeID,Number,ReportID,RepDate,RepTime,RepUser,$g(RepUserDesc),Diagnos,IsCoding,CodDate,CodTime,CodUser,CodUserDesc)
	Set return = Data
	Quit return
}

}
