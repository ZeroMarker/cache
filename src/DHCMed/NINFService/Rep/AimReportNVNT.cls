/// 名称: DHCMed.NINFService.Rep.AimReportNVNT
/// 描述: 目标性监测报告 NICU-气管插管(VNT)
/// 编写者：zhufei
/// 编写日期: 2011-06-05
Class DHCMed.NINFService.Rep.AimReportNVNT Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Rep.AimReportNVNT).SaveReport("1^^2012-06-06 10:00^2012-06-06 19:00^3187^268^2012-06-06^1^117^9","^")
ClassMethod SaveReport(aInput As %String, aSeparase As %String)
{
	New (aInput,aSeparase)
	Set return=0
	Set $ZT="SaveReportErr"
	
	Set RepID=$p(aInput,aSeparase,1)
	Set SubID=$p(aInput,aSeparase,2)
	
	Set IntubateDateTime=$p(aInput,aSeparase,3)
	Set IntubateDate=$p(IntubateDateTime," ",1)
	Set:IntubateDate["-" IntubateDate=$zdh(IntubateDate,3)
	Set IntubateTime=$p(IntubateDateTime," ",2)
	Set:IntubateTime[":" IntubateTime=$zth(IntubateTime,1)
	
	Set ExtubateDateTime=$p(aInput,aSeparase,4)
	Set ExtubateDate=$p(ExtubateDateTime," ",1)
	Set:ExtubateDate["-" ExtubateDate=$zdh(ExtubateDate,3)
	Set ExtubateTime=$p(ExtubateDateTime," ",2)
	Set:ExtubateTime[":" ExtubateTime=$zth(ExtubateTime,1)
	
	Set InfDate=$p(aInput,aSeparase,5)
	Set:InfDate["-" InfDate=$zdh(InfDate,3)
	Set InfPyStr=$p(aInput,aSeparase,6)
	Set RepLoc=$p(aInput,aSeparase,7)
	Set RepUser=$p(aInput,aSeparase,8)
	Set RepDate=+$h
	Set RepTime=$p($h,",",2)
	Set RepStatus=""
	Set RepStatusCode=$p(aInput,aSeparase,9)
	Set objRepStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportStatus",RepStatusCode,"")
	If $IsObject(objRepStatus){
		Set RepStatus=objRepStatus.%Id()
	}
	Set InputReportNVNT=RepID
	Set InputReportNVNT=InputReportNVNT_aSeparase_SubID
	If (RepID'="")&&(SubID'="") {
		Set objReportNVNT=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(RepID_"||"_SubID)
		If $IsObject(objReportNVNT) {
			Set RepLoc=objReportNVNT.RepLoc
			Set RepUser=objReportNVNT.RepUser
			Set RepDate=objReportNVNT.RepDate
			Set RepTime=objReportNVNT.RepTime
		}
	}
	Set InputReportNVNT=InputReportNVNT_aSeparase_IntubateDate
	Set InputReportNVNT=InputReportNVNT_aSeparase_IntubateTime
	Set InputReportNVNT=InputReportNVNT_aSeparase_ExtubateDate
	Set InputReportNVNT=InputReportNVNT_aSeparase_ExtubateTime
	Set InputReportNVNT=InputReportNVNT_aSeparase_InfDate
	Set InputReportNVNT=InputReportNVNT_aSeparase_InfPyStr
	Set InputReportNVNT=InputReportNVNT_aSeparase_RepLoc
	Set InputReportNVNT=InputReportNVNT_aSeparase_RepUser
	Set InputReportNVNT=InputReportNVNT_aSeparase_RepDate
	Set InputReportNVNT=InputReportNVNT_aSeparase_RepTime
	Set InputReportNVNT=InputReportNVNT_aSeparase_RepStatus
	Set UpdateLog=RepLoc_","_RepUser_","_RepStatus
	Set InputReportNVNT=InputReportNVNT_aSeparase_UpdateLog
	Set return=##Class(DHCMed.NINF.Rep.AimReportNVNT).Update(InputReportNVNT,aSeparase)
	Quit return
	
SaveReportErr
	Quit -999
}

/// w ##Class(DHCMed.NINFService.Rep.AimReportNVNT).UpdateStatus("1||1^117^9^3","^")
ClassMethod UpdateStatus(aInput As %String, aSeparase As %String)
{
	New (aInput,aSeparase)
	Set return=0
	Set $ZT="UpdateStatusErr"
	
	Set StatusCode=$p(aInput,aSeparase,4)
	Set objStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportStatus",StatusCode,"")
	Quit:'$IsObject(objStatus) return
	Set StatusID=objStatus.%Id()
	
	Set InputStr=aInput
	Set $p(InputStr,aSeparase,4)=StatusID
	Set return=##Class(DHCMed.NINF.Rep.AimReportNVNT).UpdateStatus(InputStr,aSeparase)
	Quit return
	
UpdateStatusErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询目标性监测(NICU-气管插管(VNT))记录
/// Table：       DHCMed.NINF.Rep.AimReportNVNT
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportNVNT","QryReportByID",1)
Query QryReportByID(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,ReportID:%String,IntubateDate:%String,IntubateTime:%String,IntubateDateTime:%String,ExtubateDate:%String,ExtubateTime:%String,ExtubateDateTime:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
{
}

ClassMethod QryReportByIDExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("AimRep",aRepID,"NVNT",SubID))
		Quit:SubID=""
		
		Set ReportID=aRepID_"||"_SubID
		Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(ReportID)
		Continue:'$IsObject(objRepSub)
		
		Set objRepStatus=objRepSub.RepStatus
		If $IsObject(objRepStatus) {
			Set RepStatusCode=objRepStatus.Code
			Continue:RepStatusCode="0"  //删除的报告不再显示
		}
		
		Set SubData=..BuildSubData(ReportID)
		Continue:SubData=""
		
		Set ^CacheTemp(repid,ind)=$lb(aRepID,SubID)_SubData
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryReportByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByIDExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-06-11
/// Description:  查询目标性监测(NICU-气管插管(VNT))记录
/// Table：       DHCMed.NINF.Rep.AimReportNVNT
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportNVNT","QryRepByDateLoc","3","2012-06-01","2012-06-12","117")
Query QryRepByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "EpisodeID:%String,AdmitDate:%String,DischDate:%String,PatientID:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,TransLocID:%String,TransLocDesc:%String,TransFromLocID:%String,TransFromLocDesc:%String,TransToLocID:%String,TransToLocDesc:%String,TransStartDate:%String,TransStartTime:%String,TransEndDate:%String,TransEndTime:%String,TransDays:%String,TransDiagnose:%String,ReportID:%String,IntubateDate:%String,IntubateTime:%String,IntubateDateTime:%String,ExtubateDate:%String,ExtubateTime:%String,ExtubateDateTime:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
{
}

ClassMethod QryRepByDateLocExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If aIsCommit="Y"
	{
		Set xRepStatus=0
		For {
			Set xRepStatus=$o(^DHCMed.NINFi("AimRep",0,"NVNT","IndexRepStatusDate",xRepStatus))
			Quit:xRepStatus=""
			
			Set objRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(xRepStatus)
			Continue:'$IsObject(objRepStatus)
			Set RepStatusCode=objRepStatus.Code
			Continue:RepStatusCode="0"  //删除报告不显示
			Continue:RepStatusCode="2"  //提交报告不显示
			
			Set xRepDate=0
			For {
				Set xRepDate=$o(^DHCMed.NINFi("AimRep",0,"NVNT","IndexRepStatusDate",xRepStatus,xRepDate))
				Quit:xRepDate=""
				Set xRepTime=0
				For {
					Set xRepTime=$o(^DHCMed.NINFi("AimRep",0,"NVNT","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime))
					Quit:xRepTime=""
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"NVNT","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID))
						Quit:xRepID=""
						
						Set RepData=..BuildRepData(xRepID)
						Continue:RepData=""
						//Set TransEndDate=$list(RepData,17)  //转科或出院时间
						//Continue:TransEndDate=""
						
						Set xSubID=0
						For {
							Set xSubID=$o(^DHCMed.NINFi("AimRep",0,"NVNT","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID,xSubID))
							Quit:xSubID=""
							
							Set ReportID=xRepID_"||"_xSubID
							Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(ReportID)
							Continue:'$IsObject(objRepSub)
							
							Set RepLocID=objRepSub.RepLoc
							Continue:(aRepLoc'="")&&(aRepLoc'=RepLocID)
							
							Set SubData=..BuildSubData(ReportID)
							Continue:SubData=""
							Set Data=RepData_SubData
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
	} Else {
		Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
		
		Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
		Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
		
		Set IndexStr="IndexRepDate"
		Set:aDateType=1 IndexNodeStr="IndexIntubateDate"
		Set:aDateType=2 IndexNodeStr="IndexExtubateDate"
		Set:aDateType=3 IndexNodeStr="IndexRepDate"
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("AimRep",0,"NVNT",IndexNodeStr,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			Set RepID=0
			For {
				Set RepID=$o(^DHCMed.NINFi("AimRep",0,"NVNT",IndexNodeStr,xDate,RepID))
				Quit:RepID=""
				
				Set RepData=..BuildRepData(RepID)
				Continue:RepData=""
				
				Set SubID=0
				For {
					Set SubID=$o(^DHCMed.NINFi("AimRep",0,"NVNT",IndexNodeStr,xDate,RepID,SubID))
					Quit:SubID=""
					
					Set ReportID=RepID_"||"_SubID
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(ReportID)
					Continue:'$IsObject(objRepSub)
					
					Set RepLocID=objRepSub.RepLoc
					Continue:(aRepLoc'="")&&(aRepLoc'=RepLocID)
					
					Set objRepStatus=objRepSub.RepStatus
					If $IsObject(objRepStatus) {
						Set RepStatusCode=objRepStatus.Code
						Continue:RepStatusCode="0"  //删除的报告不再显示
					}
					
					Set SubData=..BuildSubData(ReportID)
					Continue:SubData=""
					Set Data=RepData_SubData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryRepByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByDateLocExecute ]
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

ClassMethod BuildRepData(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	
	Set $ZT="BuildRepDataErr"
	
	Set (EpisodeID,AdmitDate,DischDate)=""
	Set (PatientID,PatName,PatSex,PatMrNo,PatAge)=""
	Set (TransLocID,TransLocDesc)=""
	Set (TransFromLocID,TransFromLocDesc,TransToLocID,TransToLocDesc)=""
	Set (TransStartDate,TransStartTime,TransEndDate,TransEndTime)=""
	
	Set objAimRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(aRepID)
	Quit:'$IsObject(objAimRep) return
	Set EpisodeID=objAimRep.EpisodeID
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm) return
	Set AdmitDate=objPaadm.AdmitDate
	Set DischDate=objPaadm.DisDate
	
	Set PatientID=objPaadm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return
	Set PatName=objPatient.PatientName
	Set PatSex=objPatient.Sex
	Set PatMrNo=objPatient.InPatientMrNo
	Set PatAge=objPatient.Age
	
	Set TransID=objAimRep.TransID
	Set TransLoc=objAimRep.TransLoc
	Set AdmTransStr=##Class(DHCMed.NINFService.Srv.CommonCls).GetAdmTrans(TransID,TransLoc)
	Quit:AdmTransStr="" return
	Set TransLocID=$p(AdmTransStr,$c(1),1)
	Set TransLocDesc=$p(AdmTransStr,$c(1),2)
	Set TransFromLocID=$p(AdmTransStr,$c(1),3)
	Set TransFromLocDesc=$p(AdmTransStr,$c(1),4)
	Set TransToLocID=$p(AdmTransStr,$c(1),5)
	Set TransToLocDesc=$p(AdmTransStr,$c(1),6)
	Set TransStartDate=$p(AdmTransStr,$c(1),7)
	Set TransStartTime=$p(AdmTransStr,$c(1),8)
	Set TransEndDate=$p(AdmTransStr,$c(1),9)
	Set TransEndTime=$p(AdmTransStr,$c(1),10)
	Set TransDays=$p(AdmTransStr,$c(1),11)
	Set TransDiagnose=$p(AdmTransStr,$c(1),12)
	
	Set return=$lb(EpisodeID,AdmitDate,DischDate)
	Set return=return_$lb(PatientID,PatName,PatSex,PatMrNo,PatAge)
	Set return=return_$lb(TransLocID,TransLocDesc,TransFromLocID,TransFromLocDesc,TransToLocID,TransToLocDesc,TransStartDate,TransStartTime,TransEndDate,TransEndTime,TransDays,TransDiagnose)
	
	Quit return
	
BuildRepDataErr
	Quit ""
}

ClassMethod BuildSubData(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	
	Set $ZT="BuildSubDataErr"
	
	Set (IntubateDate,IntubateTime,IntubateDateTime,ExtubateDate,ExtubateTime,ExtubateDateTime)=""
	Set (IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues)=""
	Set (RepStatusID,RepStatusDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc)=""
	
	Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(aReportID)
	Quit:'$IsObject(objRepSub) return
	
	Set objRepStatus=objRepSub.RepStatus
	If $IsObject(objRepStatus) {
		Set RepStatusID=objRepStatus.%Id()
		Set RepStatusDesc=objRepStatus.Description
	}
	
	Set IntubateDate=objRepSub.IntubateDate
	Set IntubateTime=objRepSub.IntubateTime
	If IntubateDate'="" {
		Set IntubateDate=$zd(+IntubateDate,3)
		Set IntubateTime=$zt(+IntubateTime,2)
		Set IntubateDateTime=IntubateDate_" "_IntubateTime
	}
	Set ExtubateDate=objRepSub.ExtubateDate
	Set ExtubateTime=objRepSub.ExtubateTime
	If ExtubateDate'="" {
		Set ExtubateDate=$zd(+ExtubateDate,3)
		Set ExtubateTime=$zt(+ExtubateTime,2)
		Set ExtubateDateTime=ExtubateDate_" "_ExtubateTime
	}
	
	Set InfDate=objRepSub.InfDate
	Set:InfDate'="" InfDate=$zd(InfDate,3)
	Set:InfDate'="" IsInfection="是"
	Set InfPyIDs="",InfPyDescs=""
	Set objInfPyList=objRepSub.InfPathogeny
	If $IsObject(objInfPyList) {
		For indPy=1:1:objInfPyList.Count() {
			Set objInfPy=objInfPyList.GetAt(indPy)
			Continue:'$IsObject(objInfPy)
			Set InfPyID=objInfPy.PathogenyID
			Set InfPyDesc=objInfPy.PathogenyDesc
			Set InfPyDesc=$tr(InfPyDesc,$c(1),"")
			Set InfPyDesc=$tr(InfPyDesc,"`","")
			Set InfPyIDs=InfPyIDs_$c(1)_InfPyID
			Set InfPyDescs=InfPyDescs_$c(1)_InfPyDesc
			Set InfPyValues=InfPyValues_$c(1)_InfPyID_"`"_InfPyDesc
		}
		Set:InfPyIDs'="" InfPyIDs=$e(InfPyIDs,2,$l(InfPyIDs))
		Set:InfPyDescs'="" InfPyDescs=$e(InfPyDescs,2,$l(InfPyDescs))
		Set:InfPyValues'="" InfPyValues=$e(InfPyValues,2,$l(InfPyValues))
	}
	Set RepLoc=objRepSub.RepLoc
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc) {
		Set RepLocID=objRepLoc.Rowid
		Set RepLocDesc=objRepLoc.Descs
	}
	Set RepUser=objRepSub.RepUser
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser) {
		Set RepUserID=objRepUser.Rowid
		Set RepUserDesc=objRepUser.Name
	}
	Set RepDate=objRepSub.RepDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepTime=objRepSub.RepTime
	Set:RepTime'="" RepTime=$zt(RepTime,2)
	Set RepDateTime=RepDate_" "_RepTime
	
	Set return=$lb(aReportID,IntubateDate,IntubateTime,IntubateDateTime,ExtubateDate,ExtubateTime,ExtubateDateTime)
	Set return=return_$lb(IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues)
	Set return=return_$lb(RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc)
	
	Quit return
	
BuildSubDataErr
	Quit ""
}

}
