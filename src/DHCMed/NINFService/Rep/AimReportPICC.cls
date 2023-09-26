/// 名称: DHCMed.NINFService.Rep.AimReportPICC
/// 描述: 目标性监测报告 中央导管
/// 编写者：zhufei
/// 编写日期: 2011-05-26
Class DHCMed.NINFService.Rep.AimReportPICC Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Rep.AimReportPICC).SaveReport("1^^2012-06-09 00:00^2012-06-09 00:00^3538^3548^3551^3525^3541^3530^3507^286^2012-06-09^1,^117^9^1","^")
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
	
	Set IntubatePos=$p(aInput,aSeparase,5)
	Set IntubateSize=$p(aInput,aSeparase,6)
	Set IntubateType=$p(aInput,aSeparase,7)
	Set IntubateNum=$p(aInput,aSeparase,8)
	Set IntubateRegion=$p(aInput,aSeparase,9)
	Set IntubatePlace=$p(aInput,aSeparase,10)
	Set ExtubateReason=$p(aInput,aSeparase,11)
	
	Set IntubateUserTpye=$p(aInput,aSeparase,12)
	Set IntubateUser=$p(aInput,aSeparase,13)
	Set InfDate=$p(aInput,aSeparase,14)
	Set:InfDate["-" InfDate=$zdh(InfDate,3)
	Set InfPyStr=$p(aInput,aSeparase,15)
	Set RepLoc=$p(aInput,aSeparase,16)
	Set RepUser=$p(aInput,aSeparase,17)
	Set RepDate=+$h
	Set RepTime=$p($h,",",2)
	Set RepStatus=""
	Set RepStatusCode=$p(aInput,aSeparase,18)
	Set objRepStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportStatus",RepStatusCode,"")
	If $IsObject(objRepStatus){
		Set RepStatus=objRepStatus.%Id()
	}
	
	Set InputReportPICC=RepID
	Set InputReportPICC=InputReportPICC_aSeparase_SubID
	If (RepID'="")&&(SubID'="") {
		Set objReportPICC=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(RepID_"||"_SubID)
		If $IsObject(objReportPICC) {
			Set RepLoc=objReportPICC.RepLoc
			Set RepUser=objReportPICC.RepUser
			Set RepDate=objReportPICC.RepDate
			Set RepTime=objReportPICC.RepTime
		}
	}
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateDate
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateTime
	Set InputReportPICC=InputReportPICC_aSeparase_ExtubateDate
	Set InputReportPICC=InputReportPICC_aSeparase_ExtubateTime
	Set InputReportPICC=InputReportPICC_aSeparase_IntubatePos
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateSize
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateType
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateNum
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateRegion
	Set InputReportPICC=InputReportPICC_aSeparase_IntubatePlace
	Set InputReportPICC=InputReportPICC_aSeparase_ExtubateReason
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateUserTpye
	Set InputReportPICC=InputReportPICC_aSeparase_IntubateUser
	Set InputReportPICC=InputReportPICC_aSeparase_InfDate
	Set InputReportPICC=InputReportPICC_aSeparase_InfPyStr
	Set InputReportPICC=InputReportPICC_aSeparase_RepLoc
	Set InputReportPICC=InputReportPICC_aSeparase_RepUser
	Set InputReportPICC=InputReportPICC_aSeparase_RepDate
	Set InputReportPICC=InputReportPICC_aSeparase_RepTime
	Set InputReportPICC=InputReportPICC_aSeparase_RepStatus
	Set UpdateLog=RepLoc_","_RepUser_","_RepStatus
	Set InputReportPICC=InputReportPICC_aSeparase_UpdateLog
	Set return=##Class(DHCMed.NINF.Rep.AimReportPICC).Update(InputReportPICC,aSeparase)
	Quit return
	
SaveReportErr
	Quit -999
}

/// w ##Class(DHCMed.NINFService.Rep.AimReportPICC).UpdateStatus("1||1^117^9^3","^")
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
	Set return=##Class(DHCMed.NINF.Rep.AimReportPICC).UpdateStatus(InputStr,aSeparase)
	Quit return
	
UpdateStatusErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询目标性监测(中央导管)记录
/// Table：       DHCMed.NINF.Rep.AimReportPICC
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportPICC","QryReportByID",1)
Query QryReportByID(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,ReportID:%String,IntubateDate:%String,IntubateTime:%String,IntubateDateTime:%String,ExtubateDate:%String,ExtubateTime:%String,ExtubateDateTime:%String,IntubatePosID:%String,IntubatePosDesc:%String,IntubateSizeID:%String,IntubateSizeDesc:%String,IntubateTypeID:%String,IntubateTypeDesc:%String,IntubateNumID:%String,IntubateNumDesc,IntubateRegionID:%String,IntubateRegionDesc:%String,IntubatePlaceID:%String,IntubatePlaceDesc:%String,ExtubateReasonID:%String,ExtubateReasonDesc:%String,IntubateUserTypeID:%String,IntubateUserTypeDesc:%String,IntubateUserID:%String,IntubateUserDesc:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
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
		Set SubID=$o(^DHCMed.NINF("AimRep",aRepID,"PICC",SubID))
		Quit:SubID=""
		
		Set ReportID=aRepID_"||"_SubID
		Set objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(ReportID)
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
/// Description:  查询目标性监测(中央导管)记录
/// Table：       DHCMed.NINF.Rep.AimReportPICC
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportPICC","QryRepByDateLoc","3","2012-06-01","2012-06-14","")
Query QryRepByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "EpisodeID:%String,AdmitDate:%String,DischDate:%String,PatientID:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,TransLocID:%String,TransLocDesc:%String,TransFromLocID:%String,TransFromLocDesc:%String,TransToLocID:%String,TransToLocDesc:%String,TransStartDate:%String,TransStartTime:%String,TransEndDate:%String,TransEndTime:%String,TransDays:%String,TransDiagnose:%String,ReportID:%String,IntubateDate:%String,IntubateTime:%String,IntubateDateTime:%String,ExtubateDate:%String,ExtubateTime:%String,ExtubateDateTime:%String,IntubatePosID:%String,IntubatePosDesc:%String,IntubateSizeID:%String,IntubateSizeDesc:%String,IntubateTypeID:%String,IntubateTypeDesc:%String,IntubateNumID:%String,IntubateNumDesc,IntubateRegionID:%String,IntubateRegionDesc:%String,IntubatePlaceID:%String,IntubatePlaceDesc:%String,ExtubateReasonID:%String,ExtubateReasonDesc:%String,IntubateUserTypeID:%String,IntubateUserTypeDesc:%String,IntubateUserID:%String,IntubateUserDesc:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
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
			Set xRepStatus=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepStatusDate",xRepStatus))
			Quit:xRepStatus=""
			
			Set objRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(xRepStatus)
			Continue:'$IsObject(objRepStatus)
			Set RepStatusCode=objRepStatus.Code
			Continue:RepStatusCode="0"  //删除报告不显示
			Continue:RepStatusCode="2"  //提交报告不显示
			
			Set xRepDate=""
			For {
				Set xRepDate=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepStatusDate",xRepStatus,xRepDate))
				Quit:xRepDate=""
				Set xRepTime=""
				For {
					Set xRepTime=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime))
					Quit:xRepTime=""
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID))
						Quit:xRepID=""
						
						Set RepData=..BuildRepData(xRepID)
						Continue:RepData=""
						Set TransLocID=$List(RepData,9)              
						Continue:(aRepLoc'="")&&(aRepLoc'=TransLocID)
						//Set TransEndDate=$list(RepData,17)  //转科或出院时间
						//Continue:TransEndDate=""
						
						Set xSubID=0
						For {
							Set xSubID=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID,xSubID))
							Quit:xSubID=""
							
							Set ReportID=xRepID_"||"_xSubID
							Set objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(ReportID)
							Continue:'$IsObject(objRepSub)
							
							//Set RepLocID=objRepSub.RepLoc
							//Continue:(aRepLoc'="")&&(aRepLoc'=RepLocID)
							
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
			Set xDate=$o(^DHCMed.NINFi("AimRep",0,"PICC",IndexNodeStr,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			Set RepID=0
			For {
				Set RepID=$o(^DHCMed.NINFi("AimRep",0,"PICC",IndexNodeStr,xDate,RepID))
				Quit:RepID=""
				
				Set RepData=..BuildRepData(RepID)
				Continue:RepData=""
				Set TransLocID=$List(RepData,9)              
				Continue:(aRepLoc'="")&&(aRepLoc'=TransLocID)
				
				Set SubID=0
				For {
					Set SubID=$o(^DHCMed.NINFi("AimRep",0,"PICC",IndexNodeStr,xDate,RepID,SubID))
					Quit:SubID=""
					
					Set ReportID=RepID_"||"_SubID
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(ReportID)
					Continue:'$IsObject(objRepSub)
					
					//Set RepLocID=objRepSub.RepLoc
					//Continue:(aRepLoc'="")&&(aRepLoc'=RepLocID)
					
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

ClassMethod GetMRDiagByPaadm(paadm As %String) As %String
{
	New (paadm)
	Set return=""
	
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(paadm)
	Quit:MRAdm="" return
	
	Set DiagnosID=0
	For {
		Set DiagnosID=$o(^MR(MRAdm,"DIA",DiagnosID))
		Quit:DiagnosID=""
		Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
		Set ICDDxID=$p(tmpDiagnos,"^",1)
		Continue:ICDDxID=""
		Set ICDDesc=$p($g(^MRC("ID",ICDDxID)),"^",2)
		Set:return'="" return=return_","_ICDDesc
		Set:return="" return=ICDDesc
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-11
/// Description:  查询目标性监测(中央导管)记录
/// Table：       DHCMed.NINF.Rep.AimReportPICC
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportPICC","QryRepInfoByDateLoc","3","2012-06-01","2012-06-14","")
Query QryRepInfoByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "EpisodeID:%String,AdmitDate:%String,DischDate:%String,PatientID:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,TransLocID:%String,TransLocDesc:%String,TransFromLocID:%String,TransFromLocDesc:%String,TransToLocID:%String,TransToLocDesc:%String,TransStartDate:%String,TransStartTime:%String,TransEndDate:%String,TransEndTime:%String,TransDays:%String,TransDiagnose:%String,ReportID:%String,IntubateDate:%String,IntubateTime:%String,IntubateDateTime:%String,ExtubateDate:%String,ExtubateTime:%String,ExtubateDateTime:%String,IntubatePosID:%String,IntubatePosDesc:%String,IntubateSizeID:%String,IntubateSizeDesc:%String,IntubateTypeID:%String,IntubateTypeDesc:%String,IntubateNumID:%String,IntubateNumDesc,IntubateRegionID:%String,IntubateRegionDesc:%String,IntubatePlaceID:%String,IntubatePlaceDesc:%String,ExtubateReasonID:%String,ExtubateReasonDesc:%String,IntubateUserTypeID:%String,IntubateUserTypeDesc:%String,IntubateUserID:%String,IntubateUserDesc:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String,MrDiag:%String")
{
}

ClassMethod QryRepInfoByDateLocExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set IndexStr="IndexRepDate"
	Set:aDateType=1 IndexNodeStr="IndexIntubateDate"
	Set:aDateType=2 IndexNodeStr="IndexExtubateDate"
	Set:aDateType=3 IndexNodeStr="IndexRepDate"
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"PICC",IndexNodeStr,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"PICC",IndexNodeStr,xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			Continue:(aRepLoc'="")&&(aRepLoc'=TransLoc)
			
			Set Paadm=objRep.EpisodeID
			
			Set MrDiag=..GetMRDiagByPaadm(Paadm)
			
			Set RepData=..BuildRepData(RepID)
			Continue:RepData=""
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"PICC",IndexNodeStr,xDate,RepID,SubID))
				Quit:SubID=""
				
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
					Continue:(aIsCommit="Y")&&(RepStatusCode'="2")  //未提交的报告不显示
				}
				
				Set SubData=..BuildSubData(ReportID)
				Continue:SubData=""
				Set Data=RepData_SubData
				Set Data=Data_$lb(MrDiag)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryRepInfoByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
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
	Set:TransFromLocDesc="" TransFromLocDesc="入院" 
	Set TransToLocID=$p(AdmTransStr,$c(1),5)
	Set TransToLocDesc=$p(AdmTransStr,$c(1),6)
	Set:TransToLocDesc="" TransToLocDesc="出院" 
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
	Set (IntubatePosID,IntubatePosDesc,IntubateSizeID,IntubateSizeDesc,IntubateTypeID,IntubateTypeDesc,IntubateNumID,IntubateNumDesc)=""
	Set (IntubateRegionID,IntubateRegionDesc,IntubatePlaceID,IntubatePlaceDesc,ExtubateReasonID,ExtubateReasonDesc)=""
	Set (IntubateUserTypeID,IntubateUserTypeDesc,IntubateUserID,IntubateUserDesc,IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues)=""
	Set (RepStatusID,RepStatusDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc)=""
	
	Set objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(aReportID)
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
	
	Set objIntubatePos=objRepSub.IntubatePos
	If $IsObject(objIntubatePos) {
		Set IntubatePosID=objIntubatePos.%Id()
		Set IntubatePosDesc=objIntubatePos.Description
	}
	Set objIntubateSize=objRepSub.IntubateSize
	If $IsObject(objIntubateSize) {
		Set IntubateSizeID=objIntubateSize.%Id()
		Set IntubateSizeDesc=objIntubateSize.Description
	}
	Set objIntubateType=objRepSub.IntubateType
	If $IsObject(objIntubateType) {
		Set IntubateTypeID=objIntubateType.%Id()
		Set IntubateTypeDesc=objIntubateType.Description
	}
	Set objIntubateNum=objRepSub.IntubateNum
	If $IsObject(objIntubateNum) {
		Set IntubateNumID=objIntubateNum.%Id()
		Set IntubateNumDesc=objIntubateNum.Description
	}
	Set objIntubateRegion=objRepSub.IntubateRegion
	If $IsObject(objIntubateRegion) {
		Set IntubateRegionID=objIntubateRegion.%Id()
		Set IntubateRegionDesc=objIntubateRegion.Description
	}
	Set objIntubatePlace=objRepSub.IntubatePlace
	If $IsObject(objIntubatePlace) {
		Set IntubatePlaceID=objIntubatePlace.%Id()
		Set IntubatePlaceDesc=objIntubatePlace.Description
	}
	Set objExtubateReason=objRepSub.ExtubateReason
	If $IsObject(objExtubateReason) {
		Set ExtubateReasonID=objExtubateReason.%Id()
		Set ExtubateReasonDesc=objExtubateReason.Description
	}
	Set objIntubateUserType=objRepSub.IntubateUserType
	If $IsObject(objIntubateUserType) {
		Set IntubateUserTypeID=objIntubateUserType.%Id()
		Set IntubateUserTypeDesc=objIntubateUserType.Description
	}
	Set IntubateUser=objRepSub.IntubateUser
	Set objIntubateUser=##class(DHCMed.Base.SSUser).GetObjById(IntubateUser)
	If $IsObject(objIntubateUser) {
		Set IntubateUserID=objIntubateUser.Rowid
		Set IntubateUserDesc=objIntubateUser.Name
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
	Set return=return_$lb(IntubatePosID,IntubatePosDesc,IntubateSizeID,IntubateSizeDesc,IntubateTypeID,IntubateTypeDesc,IntubateNumID,IntubateNumDesc)
	Set return=return_$lb(IntubateRegionID,IntubateRegionDesc,IntubatePlaceID,IntubatePlaceDesc,ExtubateReasonID,ExtubateReasonDesc)
	Set return=return_$lb(IntubateUserTypeID,IntubateUserTypeDesc,IntubateUserID,IntubateUserDesc,IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues)
	Set return=return_$lb(RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc)
	
	Quit return
	
BuildSubDataErr
	Quit ""
}

}
