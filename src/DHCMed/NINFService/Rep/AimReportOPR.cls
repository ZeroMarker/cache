/// 名称: DHCMed.NINFService.Rep.AimReportOPR
/// 描述: 目标性监测报告 手术部位
/// 编写者：zhufei
/// 编写日期: 2011-06-07
Class DHCMed.NINFService.Rep.AimReportOPR Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Rep.AimReportOPR).SaveReport("2^^1641^心脏泵植入术^2012-06-09^^200^3198^3^3417^4354^542^702^702^69781||104``1.5g`,69781||238``1g`^69781||238``1g`1,69781||104``1.5g`1^2012-06-09^1,^3453^aaa^117^9","^")
ClassMethod SaveReport(aInput As %String, aSeparase As %String)
{
	New (aInput,aSeparase)
	Set return=0
	Set $ZT="SaveReportErr"
	
	Set RepID=$p(aInput,aSeparase,1)
	Set SubID=$p(aInput,aSeparase,2)
	
	Set OperationID=$p(aInput,aSeparase,3)
	Set OperationDesc=$p(aInput,aSeparase,4)
	
	Set OperStartDateTime=$p(aInput,aSeparase,5)
	Set OperStartDate=$p(OperStartDateTime," ",1)
	Set:OperStartDate["-" OperStartDate=$zdh(OperStartDate,3)
	Set OperStartTime=$p(OperStartDateTime," ",2)
	Set:OperStartTime[":" OperStartTime=$zth(OperStartTime,1)
	
	Set OperEndDateTime=$p(aInput,aSeparase,6)
	Set OperEndDate=$p(OperEndDateTime," ",1)
	Set:OperEndDate["-" OperEndDate=$zdh(OperEndDate,3)
	Set OperEndTime=$p(OperEndDateTime," ",2)
	Set:OperEndTime[":" OperEndTime=$zth(OperEndTime,1)
	
	Set OperTimes=$p(aInput,aSeparase,7)
	
	Set OperCutType=$p(aInput,aSeparase,8)
	Set OperASAScore=$p(aInput,aSeparase,9)
	Set OperNarcosisType=$p(aInput,aSeparase,10)
	Set OperationType=$p(aInput,aSeparase,11)
	Set OperationType1=$p(aInput,aSeparase,12)
	Set OperationType2=$p(aInput,aSeparase,13)
	Set OperDoctor=$p(aInput,aSeparase,14)
	Set Assistant1=$p(aInput,aSeparase,15)
	Set Assistant2=$p(aInput,aSeparase,16)
	Set NarcosisAnti=$p(aInput,aSeparase,17)
	Set PostoperAnti=$p(aInput,aSeparase,18)
	
	Set InfDate=$p(aInput,aSeparase,19)
	Set:InfDate["-" InfDate=$zdh(InfDate,3)
	Set InfPyStr=$p(aInput,aSeparase,20)
	Set OperInfType=$p(aInput,aSeparase,21)
	Set ResumeText=$p(aInput,aSeparase,22)
	
	Set RepLoc=$p(aInput,aSeparase,23)
	Set RepUser=$p(aInput,aSeparase,24)
	Set RepDate=+$h
	Set RepTime=$p($h,",",2)
	Set RepStatus=""
	Set RepStatusCode=$p(aInput,aSeparase,25)
	Set objRepStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportStatus",RepStatusCode,"")
	If $IsObject(objRepStatus){
		Set RepStatus=objRepStatus.%Id()
	}
	Set InputReportOPR=RepID
	Set InputReportOPR=InputReportOPR_aSeparase_SubID
	If (RepID'="")&&(SubID'="") {
		Set objReportOPR=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(RepID_"||"_SubID)
		If $IsObject(objReportOPR) {
			Set RepLoc=objReportOPR.RepLoc
			Set RepUser=objReportOPR.RepUser
			Set RepDate=objReportOPR.RepDate
			Set RepTime=objReportOPR.RepTime
		}
	}
	Set InputReportOPR=InputReportOPR_aSeparase_OperationID
	Set InputReportOPR=InputReportOPR_aSeparase_OperationDesc
	Set InputReportOPR=InputReportOPR_aSeparase_OperStartDate
	Set InputReportOPR=InputReportOPR_aSeparase_OperStartTime
	Set InputReportOPR=InputReportOPR_aSeparase_OperEndDate
	Set InputReportOPR=InputReportOPR_aSeparase_OperEndTime
	Set InputReportOPR=InputReportOPR_aSeparase_OperTimes
	Set InputReportOPR=InputReportOPR_aSeparase_OperCutType
	Set InputReportOPR=InputReportOPR_aSeparase_OperASAScore
	Set InputReportOPR=InputReportOPR_aSeparase_OperNarcosisType
	Set InputReportOPR=InputReportOPR_aSeparase_OperationType
	Set InputReportOPR=InputReportOPR_aSeparase_OperationType1
	Set InputReportOPR=InputReportOPR_aSeparase_OperationType2
	Set InputReportOPR=InputReportOPR_aSeparase_OperDoctor
	Set InputReportOPR=InputReportOPR_aSeparase_Assistant1
	Set InputReportOPR=InputReportOPR_aSeparase_Assistant2
	Set InputReportOPR=InputReportOPR_aSeparase_NarcosisAnti
	Set InputReportOPR=InputReportOPR_aSeparase_PostoperAnti
	Set InputReportOPR=InputReportOPR_aSeparase_InfDate
	Set InputReportOPR=InputReportOPR_aSeparase_InfPyStr
	Set InputReportOPR=InputReportOPR_aSeparase_OperInfType
	Set InputReportOPR=InputReportOPR_aSeparase_ResumeText
	Set InputReportOPR=InputReportOPR_aSeparase_RepLoc
	Set InputReportOPR=InputReportOPR_aSeparase_RepUser
	Set InputReportOPR=InputReportOPR_aSeparase_RepDate
	Set InputReportOPR=InputReportOPR_aSeparase_RepTime
	Set InputReportOPR=InputReportOPR_aSeparase_RepStatus
	Set UpdateLog=RepLoc_","_RepUser_","_RepStatus
	Set InputReportOPR=InputReportOPR_aSeparase_UpdateLog
	Set return=##Class(DHCMed.NINF.Rep.AimReportOPR).Update(InputReportOPR,aSeparase)
	Quit return
	
SaveReportErr
	Quit -999
}

/// w ##Class(DHCMed.NINFService.Rep.AimReportOPR).UpdateStatus("1||1^117^9^3","^")
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
	Set return=##Class(DHCMed.NINF.Rep.AimReportOPR).UpdateStatus(InputStr,aSeparase)
	Quit return
	
UpdateStatusErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询目标性监测(手术部位)记录
/// Table：       DHCMed.NINF.Rep.AimReportOPR
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportOPR","QryReportByID",1)
Query QryReportByID(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,ReportID:%String,OperationID:%String,OperationDesc:%String,OperStartDate:%String,OperStartTime:%String,OperStartDateTime:%String,OperEndDate:%String,OperEndTime:%String,OperEndDateTime:%String,OperTimes:%String,OperCutTypeID:%String,OperCutTypeDesc:%String,OperASAScore:%String,OperNarcosisTypeID:%String,OperNarcosisTypeDesc:%String,OperationTypeID:%String,OperationTypeDesc:%String,OperationType1ID:%String,OperationType1Desc:%String,OperationType2ID:%String,OperationType2Desc:%String,OperDoctorID:%String,OperDoctorDesc:%String,Assistant1ID:%String,Assistant1Desc:%String,Assistant2ID:%String,Assistant2Desc:%String,NarcosisAntiIDs:%String,NarcosisAntiDescs:%String,NarcosisAntiValues:%String,PostoperAntiIDs:%String,PostoperAntiDescs:%String,PostoperAntiValues:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,OperInfTypeID:%String,OperInfTypeDesc:%String,ResumeText:%String,RepStatusID:%String,RepStatusDesc:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
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
		Set SubID=$o(^DHCMed.NINF("AimRep",aRepID,"OPR",SubID))
		Quit:SubID=""
		
		Set ReportID=aRepID_"||"_SubID
		Set objRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(ReportID)
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
/// Description:  查询目标性监测(手术部位)记录
/// Table：       DHCMed.NINF.Rep.AimReportOPR
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportOPR","QryRepByDateLoc","3","2012-06-01","2012-06-12","117")
Query QryRepByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "EpisodeID:%String,AdmitDate:%String,DischDate:%String,PatientID:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,TransLocID:%String,TransLocDesc:%String,TransFromLocID:%String,TransFromLocDesc:%String,TransToLocID:%String,TransToLocDesc:%String,TransStartDate:%String,TransStartTime:%String,TransEndDate:%String,TransEndTime:%String,TransDays:%String,TransDiagnose:%String,ReportID:%String,OperationID:%String,OperationDesc:%String,OperStartDate:%String,OperStartTime:%String,OperStartDateTime:%String,OperEndDate:%String,OperEndTime:%String,OperEndDateTime:%String,OperTimes:%String,OperCutTypeID:%String,OperCutTypeDesc:%String,OperASAScore:%String,OperNarcosisTypeID:%String,OperNarcosisTypeDesc:%String,OperationTypeID:%String,OperationTypeDesc:%String,OperationType1ID:%String,OperationType1Desc:%String,OperationType2ID:%String,OperationType2Desc:%String,OperDoctorID:%String,OperDoctorDesc:%String,Assistant1ID:%String,Assistant1Desc:%String,Assistant2ID:%String,Assistant2Desc:%String,NarcosisAntiIDs:%String,NarcosisAntiDescs:%String,NarcosisAntiValues:%String,PostoperAntiIDs:%String,PostoperAntiDescs:%String,PostoperAntiValues:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,OperInfTypeID:%String,OperInfTypeDesc:%String,ResumeText:%String,RepStatusID:%String,RepStatusDesc:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
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
			Set xRepStatus=$o(^DHCMed.NINFi("AimRep",0,"OPR","IndexRepStatusDate",xRepStatus))
			Quit:xRepStatus=""
			
			Set objRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(xRepStatus)
			Continue:'$IsObject(objRepStatus)
			Set RepStatusCode=objRepStatus.Code
			Continue:RepStatusCode="0"  //删除报告不显示
			Continue:RepStatusCode="2"  //提交报告不显示
			
			Set xRepDate=""
			For {
				Set xRepDate=$o(^DHCMed.NINFi("AimRep",0,"OPR","IndexRepStatusDate",xRepStatus,xRepDate))
				Quit:xRepDate=""
				Set xRepTime=""
				For {
					Set xRepTime=$o(^DHCMed.NINFi("AimRep",0,"OPR","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime))
					Quit:xRepTime=""
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"OPR","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID))
						Quit:xRepID=""
						
						Set RepData=..BuildRepData(xRepID)
						Continue:RepData=""
						Set TransLocID=$List(RepData,9)              
						Continue:(aRepLoc'="")&&(aRepLoc'=TransLocID)
						//Set TransEndDate=$list(RepData,17)  //转科或出院时间
						//Continue:TransEndDate=""
						
						Set xSubID=0
						For {
							Set xSubID=$o(^DHCMed.NINFi("AimRep",0,"OPR","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID,xSubID))
							Quit:xSubID=""
							
							Set ReportID=xRepID_"||"_xSubID
							Set objRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(ReportID)
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
		Set:aDateType=1 IndexNodeStr="IndexOperationDate"
		Set:aDateType=3 IndexNodeStr="IndexRepDate"
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("AimRep",0,"OPR",IndexNodeStr,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			Set RepID=0
			For {
				Set RepID=$o(^DHCMed.NINFi("AimRep",0,"OPR",IndexNodeStr,xDate,RepID))
				Quit:RepID=""
				
				Set RepData=..BuildRepData(RepID)
				Continue:RepData=""
				Set TransLocID=$List(RepData,9)              
				Continue:(aRepLoc'="")&&(aRepLoc'=TransLocID)
				
				Set SubID=0
				For {
					Set SubID=$o(^DHCMed.NINFi("AimRep",0,"OPR",IndexNodeStr,xDate,RepID,SubID))
					Quit:SubID=""
					
					Set ReportID=RepID_"||"_SubID
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(ReportID)
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

/// Creator：     zhufei
/// CreatDate：   2012-06-11
/// Description:  查询目标性监测(手术部位)记录
/// Table：       DHCMed.NINF.Rep.AimReportOPR
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportOPR","QryRepInfoByDateLoc","3","2012-06-01","2012-06-12","117")
Query QryRepInfoByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "EpisodeID:%String,AdmitDate:%String,DischDate:%String,PatientID:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,TransLocID:%String,TransLocDesc:%String,TransFromLocID:%String,TransFromLocDesc:%String,TransToLocID:%String,TransToLocDesc:%String,TransStartDate:%String,TransStartTime:%String,TransEndDate:%String,TransEndTime:%String,TransDays:%String,TransDiagnose:%String,ReportID:%String,OperationID:%String,OperationDesc:%String,OperStartDate:%String,OperStartTime:%String,OperStartDateTime:%String,OperEndDate:%String,OperEndTime:%String,OperEndDateTime:%String,OperTimes:%String,OperCutTypeID:%String,OperCutTypeDesc:%String,OperASAScore:%String,OperNarcosisTypeID:%String,OperNarcosisTypeDesc:%String,OperationTypeID:%String,OperationTypeDesc:%String,OperationType1ID:%String,OperationType1Desc:%String,OperationType2ID:%String,OperationType2Desc:%String,OperDoctorID:%String,OperDoctorDesc:%String,Assistant1ID:%String,Assistant1Desc:%String,Assistant2ID:%String,Assistant2Desc:%String,NarcosisAntiIDs:%String,NarcosisAntiDescs:%String,NarcosisAntiValues:%String,PostoperAntiIDs:%String,PostoperAntiDescs:%String,PostoperAntiValues:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,OperInfTypeID:%String,OperInfTypeDesc:%String,ResumeText:%String,RepStatusID:%String,RepStatusDesc:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
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
	Set:aDateType=1 IndexNodeStr="IndexOperationDate"
	Set:aDateType=3 IndexNodeStr="IndexRepDate"
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"OPR",IndexNodeStr,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"OPR",IndexNodeStr,xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			Continue:(aRepLoc'="")&&(aRepLoc'=TransLoc)
			
			Set RepData=..BuildRepData(RepID)
			Continue:RepData=""
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"OPR",IndexNodeStr,xDate,RepID,SubID))
				Quit:SubID=""
				
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(ReportID)
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
	
	Set (OperationID,OperationDesc)=""
	Set (OperStartDate,OperStartTime,OperStartDateTime,OperEndDate,OperEndTime,OperEndDateTime,OperTimes)=""
	Set (OperCutTypeID,OperCutTypeDesc,OperASAScore)=""
	Set (OperNarcosisTypeID,OperNarcosisTypeDesc,OperationTypeID,OperationTypeDesc)=""
	Set (OperationType1ID,OperationType1Desc,OperationType2ID,OperationType2Desc)=""
	Set (OperDoctorID,OperDoctorDesc,Assistant1ID,Assistant1Desc,Assistant2ID,Assistant2Desc)=""
	Set (NarcosisAntiIDs,NarcosisAntiDescs,NarcosisAntiValues,PostoperAntiIDs,PostoperAntiDescs,PostoperAntiValues)=""
	Set (IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues,OperInfTypeID,OperInfTypeDesc,ResumeText)=""
	Set (RepStatusID,RepStatusDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc)=""
	Set (RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc)=""
	
	Set objRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(aReportID)
	Quit:'$IsObject(objRepSub) return
	
	Set objRepStatus=objRepSub.RepStatus
	If $IsObject(objRepStatus) {
		Set RepStatusID=objRepStatus.%Id()
		Set RepStatusDesc=objRepStatus.Description
	}
	
	Set OperationID=objRepSub.OperationID
	Set OperationDesc=objRepSub.OperationDesc
	Set OperStartDate=objRepSub.OperStartDate
	Set OperStartTime=objRepSub.OperStartTime
	If OperStartDate'="" {
		Set OperStartDate=$zd(+OperStartDate,3)
		Set OperStartTime=$zt(+OperStartTime,2)
		Set OperStartDateTime=OperStartDate_" "_OperStartTime
	}
	Set OperEndDate=objRepSub.OperEndDate
	Set OperEndTime=objRepSub.OperEndTime
	If OperEndDate'="" {
		Set OperEndDate=$zd(+OperEndDate,3)
		Set OperEndTime=$zt(+OperEndTime,2)
		Set OperEndDateTime=OperEndDate_" "_OperEndTime
	}
	Set OperTimes=objRepSub.OperTimes
	Set objOperCutType=objRepSub.OperCutType
	If $IsObject(objOperCutType) {
		Set OperCutTypeID=objOperCutType.%Id()
		Set OperCutTypeDesc=objOperCutType.Description
	}
	Set OperASAScore=objRepSub.OperASAScore
	Set objOperNarcosisType=objRepSub.OperNarcosisType
	If $IsObject(objOperNarcosisType) {
		Set OperNarcosisTypeID=objOperNarcosisType.%Id()
		Set OperNarcosisTypeDesc=objOperNarcosisType.Description
	}
	Set objOperationType=objRepSub.OperationType
	If $IsObject(objOperationType) {
		Set OperationTypeID=objOperationType.%Id()
		Set OperationTypeDesc=objOperationType.Description
	}
	Set objOperationType1=objRepSub.OperationType1
	If $IsObject(objOperationType1) {
		Set OperationType1ID=objOperationType1.%Id()
		Set OperationType1Desc=objOperationType1.Description
	}
	Set objOperationType2=objRepSub.OperationType2
	If $IsObject(objOperationType2) {
		Set OperationType2ID=objOperationType2.%Id()
		Set OperationType2Desc=objOperationType2.Description
	}
	Set OperDoctor=objRepSub.OperDoctor
	Set objOperDoctor=##class(DHCMed.Base.SSUser).GetObjById(OperDoctor)
	If $IsObject(objOperDoctor) {
		Set OperDoctorID=objOperDoctor.Rowid
		Set OperDoctorDesc=objOperDoctor.Name
	}
	Set Assistant1=objRepSub.Assistant1
	Set objAssistant1=##class(DHCMed.Base.SSUser).GetObjById(Assistant1)
	If $IsObject(objAssistant1) {
		Set Assistant1ID=objAssistant1.Rowid
		Set Assistant1Desc=objAssistant1.Name
	}
	Set Assistant2=objRepSub.Assistant2
	Set objAssistant2=##class(DHCMed.Base.SSUser).GetObjById(Assistant2)
	If $IsObject(objAssistant2) {
		Set Assistant2ID=objAssistant2.Rowid
		Set Assistant2Desc=objAssistant2.Name
	}
	Set objNarcosisAntiList=objRepSub.NarcosisAnti
	If $IsObject(objNarcosisAntiList) {
		For indAnti=1:1:objNarcosisAntiList.Count()
		{
			Set objAnti=objNarcosisAntiList.GetAt(indAnti)
			Continue:'$IsObject(objAnti)
			Set AntiOEOrdItem=objAnti.OEOrdItem
			Set AntiArcimID=objAnti.ArcimID
			Set AntiArcimDesc=""
			If (AntiArcimID="")&&(AntiOEOrdItem'="")
			{
				Set AntiArcimID=$p($g(^OEORD(+AntiOEOrdItem,"I",$p(AntiOEOrdItem,"||",2),1)),"^",2)
			}
			If AntiArcimID'=""
			{
				Set AntiArcimDesc=$p(^ARCIM(+AntiArcimID,$p(AntiArcimID,"||",2),1),"^",2)
			}
			Continue:AntiArcimDesc=""
			Set AntiDrugQty=objAnti.DrugQty
			Set AntiDrugUom=objAnti.DrugUom
			Set AntiDrugDays=objAnti.DrugDays
			
			Set NarcosisAntiID=indAnti
			Set NarcosisAntiDesc=AntiArcimDesc_"("_AntiDrugQty_AntiDrugUom_" "_AntiDrugDays_")"
			Set AntiArcimDesc=$tr(AntiArcimDesc,"`","")
			Set AntiDrugUom=$tr(AntiDrugUom,"`","")
			Set NarcosisAntiValue=AntiOEOrdItem_"`"_AntiArcimDesc_"`"_AntiDrugQty_"`"_AntiDrugUom_"`"_AntiDrugDays
			
			Set NarcosisAntiIDs=NarcosisAntiIDs_$c(1)_NarcosisAntiID
			Set NarcosisAntiDescs=NarcosisAntiDescs_";"_NarcosisAntiDesc
			Set NarcosisAntiValue=$tr(NarcosisAntiValue,$c(1),"")
			Set NarcosisAntiValues=NarcosisAntiValues_$c(1)_NarcosisAntiValue
		}
		Set:NarcosisAntiIDs'="" NarcosisAntiIDs=$e(NarcosisAntiIDs,2,$l(NarcosisAntiIDs))
		Set:NarcosisAntiDescs'="" NarcosisAntiDescs=$e(NarcosisAntiDescs,2,$l(NarcosisAntiDescs))
		Set:NarcosisAntiValues'="" NarcosisAntiValues=$e(NarcosisAntiValues,2,$l(NarcosisAntiValues))
	}
	Set objPostoperAntiList=objRepSub.PostoperAnti
	If $IsObject(objPostoperAntiList) {
		For indAnti=1:1:objPostoperAntiList.Count()
		{
			Set objAnti=objPostoperAntiList.GetAt(indAnti)
			Continue:'$IsObject(objAnti)
			Set AntiOEOrdItem=objAnti.OEOrdItem
			Set AntiArcimID=objAnti.ArcimID
			Set AntiArcimDesc=""
			If (AntiArcimID="")&&(AntiOEOrdItem'="")
			{
				Set AntiArcimID=$p($g(^OEORD(+AntiOEOrdItem,"I",$p(AntiOEOrdItem,"||",2),1)),"^",2)
			}
			If AntiArcimID'=""
			{
				Set AntiArcimDesc=$p(^ARCIM(+AntiArcimID,$p(AntiArcimID,"||",2),1),"^",2)
			}
			Continue:AntiArcimDesc=""
			Set AntiDrugQty=objAnti.DrugQty
			Set AntiDrugUom=objAnti.DrugUom
			Set AntiDrugDays=objAnti.DrugDays
			
			Set PostoperAntiID=indAnti
			Set PostoperAntiDesc=AntiArcimDesc_"("_AntiDrugQty_AntiDrugUom_" "_AntiDrugDays_")"
			Set AntiArcimDesc=$tr(AntiArcimDesc,"`","")
			Set AntiDrugUom=$tr(AntiDrugUom,"`","")
			Set PostoperAntiValue=AntiOEOrdItem_"`"_AntiArcimDesc_"`"_AntiDrugQty_"`"_AntiDrugUom_"`"_AntiDrugDays
			
			Set PostoperAntiValue=$tr(PostoperAntiValue,$c(1),"")
			Set PostoperAntiIDs=PostoperAntiIDs_$c(1)_PostoperAntiID
			Set PostoperAntiDescs=PostoperAntiDescs_";"_PostoperAntiDesc
			Set PostoperAntiValues=PostoperAntiValues_$c(1)_PostoperAntiValue
		}
		Set:PostoperAntiIDs'="" PostoperAntiIDs=$e(PostoperAntiIDs,2,$l(PostoperAntiIDs))
		Set:PostoperAntiDescs'="" PostoperAntiDescs=$e(PostoperAntiDescs,2,$l(PostoperAntiDescs))
		Set:PostoperAntiValues'="" PostoperAntiValues=$e(PostoperAntiValues,2,$l(PostoperAntiValues))
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
			Set InfPyID=objInfPy.%Id()
			Set InfPyDesc=objInfPy.PYDesc
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
	Set objOperInfType=objRepSub.OperInfType
	If $IsObject(objOperInfType) {
		Set OperInfTypeID=objOperInfType.%Id()
		Set OperInfTypeDesc=objOperInfType.Description
	}
	Set ResumeText=objRepSub.ResumeText
	
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
	
	Set return=$lb(aReportID,OperationID,OperationDesc)
	Set return=return_$lb(OperStartDate,OperStartTime,OperStartDateTime,OperEndDate,OperEndTime,OperEndDateTime,OperTimes)
	Set return=return_$lb(OperCutTypeID,OperCutTypeDesc,OperASAScore)
	Set return=return_$lb(OperNarcosisTypeID,OperNarcosisTypeDesc,OperationTypeID,OperationTypeDesc)
	Set return=return_$lb(OperationType1ID,OperationType1Desc,OperationType2ID,OperationType2Desc)
	Set return=return_$lb(OperDoctorID,OperDoctorDesc,Assistant1ID,Assistant1Desc,Assistant2ID,Assistant2Desc)
	Set return=return_$lb(NarcosisAntiIDs,NarcosisAntiDescs,NarcosisAntiValues,PostoperAntiIDs,PostoperAntiDescs,PostoperAntiValues)
	Set return=return_$lb(IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues,OperInfTypeID,OperInfTypeDesc,ResumeText)
	Set return=return_$lb(RepStatusID,RepStatusDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc)
	Set return=return_$lb(RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc)
	
	Quit return
	
BuildSubDataErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-02-01
/// Description:  查询病人抗生素的信息
/// Table：       
/// Input：       Paadm ： 就诊
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportOPR","QryAdmAnti","69738","Y")
Query QryAdmAnti(Paadm As %String = "", DrugFlag As %String = "Yes") As %Query(ROWSPEC = "OEORIID:%String,OEORIPriority:%String,OEORIItmMast:%String,OEOrdStartDate:%String,OEOrdEndDate:%String,OEORIInstr:%String,OEORIPHFreq:%String,OEORIQty:%String,OEORIPackUom:%String,OEORIDoseQty:%String,OEORIUnit:%String,OEORIDays:%String,OEORIIDStr:%String,OEORIDescStr:%String")
{
}

ClassMethod QryAdmAntiExecute(ByRef qHandle As %Binary, Paadm As %String = "", DrugFlag As %String = "Yes") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:Paadm="" $$$OK
 	
 	Set ZIndex=$zn,JIndex=$j
 	Kill ^TMP(ZIndex,JIndex,"QryAdmAnti")
 	
 	//抗菌用药药学分类
	Set AntiPhcDrugType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfAntiPhcDrugType","")
 	
 	Set OrderID=$o(^OEORD(0,"Adm",Paadm,""))
 	Set ArcimID=""
 	For {
	 	Set ArcimID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID))
	 	Quit:ArcimID=""
	 	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ARCICOrderType=objArcim.ARCICOrderType
	 	Continue:ARCICOrderType'="R"
	 	Set ARCIMPHCDFDR=objArcim.ARCIMPHCDFDR
	 	Set objPhc=##class(DHCMed.Base.PHC).GetObjById(ARCIMPHCDFDR)
	 	Continue:(objPhc.PHCCDesc="")||(objPhc.PHCSCDesc="")
	 	Set PHCCDesc=objPhc.PHCCDesc
	 	Set PHCSCDesc=objPhc.PHCSCDesc
		//抗生素,抗感染,抗微生物
	 	//w AntiPhcDrugType_"///"_objPhc.PHCCDesc_"///"_objPhc.PHCSCDesc,!
	 	Continue:(AntiPhcDrugType'="")&&(AntiPhcDrugType'[PHCSCDesc)&&(AntiPhcDrugType'[PHCCDesc)
	 	
		Set StartDate=0
		For {
			Set StartDate=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate))
			Quit:StartDate=""
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate,SubID))
				Quit:SubID=""
				
				Set FillerNo=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",12)
				If FillerNo'="" {
					Set OEOrdID=$p(FillerNo,"!!",1)
				}Else{
					Set OEOrdID=OrderID_"||"_SubID
				}
				Continue:OEOrdID=""
				
				Set xDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",34)
				Continue:(+xDate)'=0  //停止的医嘱过滤掉
				
				Set OEStartDate=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),1)),"^",9)
				Continue:OEStartDate=""
				If '$d(^TMP(ZIndex,JIndex,"QryAdmAnti",OEOrdID,OEStartDate))
				{
					Set ^TMP(ZIndex,JIndex,"QryAdmAnti",OEOrdID,OEStartDate)=""
					Set num=$i(^TMP(ZIndex,JIndex,"QryAdmAnti",OEOrdID))
				}
				
				Set ^TMP(ZIndex,JIndex,"QryAdmAnti",OEOrdID,SubID)=FillerNo
				//w OEOrdID_"///"_OrderID_"||"_SubID,!
			}
		}
	}
	
	Set OEOrdID=""
	For {
		Set OEOrdID=$o(^TMP(ZIndex,JIndex,"QryAdmAnti",OEOrdID))
		Quit:OEOrdID=""
		
		Set FstSubID=$o(^TMP(ZIndex,JIndex,"QryAdmAnti",OEOrdID,0))
		Set FstOEOrdID=(+OEOrdID)_"||"_FstSubID
		Set LstSubID=$o(^TMP(ZIndex,JIndex,"QryAdmAnti",OEOrdID,""),-1)
		Set LstOEOrdID=(+OEOrdID)_"||"_LstSubID
		
		Set objOEOrd=##class(DHCMed.Base.OrdItem).GetObjById(FstOEOrdID)
		Continue:'$IsObject(objOEOrd)
		Set OEORIItmMastDR=objOEOrd.OEORIItmMastDR
		Set OEORIItmMast=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),1)),"^",2)
		Continue:OEORIItmMast=""
		Set OEOrdStartDate=objOEOrd.OEORISttDat
		Set:(+OEOrdStartDate)'=0 OEOrdStartDate=$zd(+OEOrdStartDate,3)
		Set OEOrdEndDate=""
		Set OEORIPriorityDR=objOEOrd.OEORIPriorityDR  //OEC_Priority  类型
		Set OEORIPriority=$p($g(^OECPR(+OEORIPriorityDR)),"^",2)
		Set OEORIInstrDR=objOEOrd.OEORIInstrDR  //PHC_Instruc  用法
		Set OEORIInstr=$p($g(^PHCIN(+OEORIInstrDR)),"^",2)
		Set:$p(OEORIInstr,"-",2)'="" OEORIInstr=$p(OEORIInstr,"-",2)
		Set OEORIPHFreqDR=objOEOrd.OEORIPHFreqDR  //PHC_Freq  频次
		Set OEORIPHFreq=$p($g(^PHCFR(+OEORIPHFreqDR)),"^",3)
		
		Set (OEORIQty,OEORIPackUom,OEORIDoseQty,OEORIUnit)=""
		Set OEORIQty=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),1)),"^",18)     //数量
		Set ItmPackUomID=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),8)),"^",14)
		Set:ItmPackUomID'="" OEORIPackUom=$p($g(^CT("UOM",ItmPackUomID)),"^",2)    //基本单位
		
		Set OEORIDoseQty=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),2)),"^",1)  //剂量
		Set ItmUnitID=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),2)),"^",3)   //剂量单位
		Set:ItmUnitID'="" OEORIUnit=$p($g(^CT("UOM",ItmUnitID)),"^",2)
		
		Set objOEOrd=##class(DHCMed.Base.OrdItem).GetObjById(LstOEOrdID)
		If $IsObject(objOEOrd) {
			Set OEOrdEndDate=objOEOrd.OEORISttDat
			Set:(+OEOrdEndDate)'=0 OEOrdEndDate=$zd(+OEOrdEndDate,3)
		}
		
		Set OEORIDays=+$g(^TMP(ZIndex,JIndex,"QryAdmAnti",FstOEOrdID))
		
		Set OEORIIDStr=OEOrdID_","_FstOEOrdID_","_LstOEOrdID
		Set OEORIDescStr=OEORIItmMast_"("_OEORIPriority_" "_OEOrdStartDate_" "_OEOrdEndDate_" "_OEORIInstr_" "_OEORIPHFreq_")"
		Set Data=$lb(OEOrdID,OEORIPriority,OEORIItmMast,OEOrdStartDate,OEOrdEndDate,OEORIInstr,OEORIPHFreq,OEORIQty,OEORIPackUom,OEORIDoseQty,OEORIUnit,OEORIDays,OEORIIDStr,OEORIDescStr)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,"QryAdmAnti")
	
	Quit $$$OK
}

ClassMethod QryAdmAntiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmAntiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmAntiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmAntiExecute ]
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
/// CreatDate：   2014-07-12
/// Description:  查询手术信息
/// Table：       DHCMed.NINFService.Rep.AimReportOPR
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportOPR","QryOperations","3528677")
Query QryOperations(aEpisodeID As %String) As %Query(ROWSPEC = "RecordID:%String,OperDesc:%String,OperDate:%String,OperTimes:%String,CutGradeID:%String,CutGrade:%String,AnesthesiaID:%String,Anesthesia:%String,DocID:%String,DocName:%String,Assistant1ID:%String,Assistant1:%String,OperType1:%String,OperType2:%String,OperType3:%String,ASAScore:%String") [ SqlProc ]
{
}

ClassMethod QryOperationsExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	Set arrRec=##Class(DHCMed.DPCustom.Data.Operation).GetDataByAdm(aEpisodeID,"","")
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set RecordID=objRec.RecordID
		Set OperDesc=objRec.OperDesc
		Set SttDate=objRec.SttDate
		Set SttTime=objRec.SttTime
		Set EndDate=objRec.EndDate
		Set EndTime=objRec.EndTime
		Set OperDate=SttDate
		Set OperTimes=""
		If (EndDate'="")&&(EndTime'="") {
			Set OperTimes=(($zdh(EndDate,3)-$zdh(SttDate,3))*24*60)+(($zth(EndTime)-$zth(SttTime))/60)
		}
		Set CutGrade=objRec.CutGrade
		Set:CutGrade="无" CutGrade=""
		Set CutGradeID=""
		If CutGrade'="" {
			Set CutGrade=##class(DHCMed.NINFService.Srv.CommonCls).GetMapping("XHAIMDicCutType",CutGrade,"","*"_CutGrade)
			Set:CutGrade'="" CutGradeID=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFAimOPRCutType",CutGrade)
		}
		Set Anesthesia=objRec.Anesthesia
		Set AnesthesiaID=""
		If Anesthesia'="" {
			Set Anesthesia=##class(DHCMed.NINFService.Srv.CommonCls).GetMapping("XHAIMDicAnesthesia",Anesthesia,"","*"_Anesthesia)
			Set:Anesthesia'="" AnesthesiaID=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFAimOPRNarcosisType",Anesthesia)
		}
		Set DocID=objRec.DocCode
		Set DocName=objRec.DocName
		Set Assistant1ID=""
		Set Assistant1=""
		Set OperType1="",OperType2="",OperType3=""
		Set OperType=objRec.OperType
		Set OperType1=$s(OperType["急诊":"是",1:"否")
		Set ASAScore=objRec.ASAScore
		Set:ASAScore'="" ASAScore=+$e(ASAScore,2,$l(ASAScore))
		Set:ASAScore<1 ASAScore=""
		
		Set Data=$lb(RecordID,OperDesc,OperDate,OperTimes,CutGradeID,CutGrade,AnesthesiaID,Anesthesia,DocID,DocName,Assistant1ID,Assistant1,OperType1,OperType2,OperType3,ASAScore)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOperationsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperationsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperationsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperationsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="")||($isvalidnum(ind)=0) {				// if there are no more rows, finish fetching
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

/// w ##Class(DHCMed.NINFService.Rep.AimReportOPR).GetDataBySummID("291")
ClassMethod GetDataBySummID(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set (DiseasePrognosisDesc,DeathRelationDesc)=""
	Set xsummID=0
 	For {
	 	Set xsummID=$o(^DHCMed.NINF("InfRep",aReportID,"Summ",xsummID))
		Quit:xsummID=""
		
		Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(aReportID_"||"_xsummID)
		Continue:'$IsObject(objSumm)
		
		If $IsObject(objSumm.DiseasePrognosis) {
		Set DiseasePrognosisID=objSumm.DiseasePrognosis.%Id()
		Set DiseasePrognosisDesc=objSumm.DiseasePrognosis.Description
		}	
		If $IsObject(objSumm.DeathRelation) {
		Set DeathRelationID=objSumm.DeathRelation.%Id()
		Set DeathRelationDesc=objSumm.DeathRelation.Description
		}	
		
		Set return=DiseasePrognosisDesc_"^"_DeathRelationDesc
 	}
 	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-07-08
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportOPR","QryOprRepByID")
Query QryOprRepByID(aReportID As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,ObjectID:%String,ReportTypeID:%String,ReportTypeDesc:%String,ReportLocID:%String,ReportLocDesc:%String,ReportUserID:%String,ReportUserDesc:%String,ReportDate:%String,ReportTime:%String,ReportStatusID:%String,ReportStatusCode:%String,ReportStatusDesc:%String,AdmitDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,AdmBed:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,EncryptLevel:%String,PatLevel:%String,RecordID:%String,OperationID:%String,OperationDesc:%String,OperDocID:%String,OperDocDesc:%String,OperStartDate:%String,OperStartTime:%String,OperStartDateTime:%String,OperEndDate:%String,OperEndTime:%String,OperEndDateTime:%String,OperationTypeID:%String,OperationTypeDesc:%String,AnesthesiaID:%String,AnesthesiaDesc:%String,CuteTypeID:%String,CuteTypeDesc:%String,CuteHealingID:%String,CuteHealingDesc:%String,CuteInfFlagID:%String,CuteInfFlagDesc:%String,OperInfTypeID:%String,OperInfTypeDesc:%String,InHospInfFlagID:%String,InHospInfFlagDesc:%String,ASAScoreID:%String,ASAScoreDesc:%String,DataSource:%String,PreoperWBC:%String,CuteNumberID:%String,CuteNumberDesc:%String,EndoscopeFlagID:%String,EndoscopeFlagDesc:%String,ImplantFlagID:%String,ImplantFlagDesc:%String,PreoperAntiFlagID:%String,PreoperAntiFlagDesc:%String,BloodLossFlagID:%String,BloodLossFlagDesc:%String,BloodLoss:%String,BloodTransFlagID:%String,BloodTransFlagDesc:%String,BloodTrans:%String,PostoperComps:%String,PostoperCompsDesc:%String,OperTimes:%String,NNISScore:%String")
{
}

ClassMethod QryOprRepByIDExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aReportID="" $$$OK
	
	Set RepData= ##Class(DHCMed.NINFService.Rep.InfReport).BuildRepData(aReportID)
	Quit:RepData="" $$$OK
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Opr",xSubID))
		Quit:xSubID=""
		Set SubData=##Class(DHCMed.NINFService.Rep.InfReport).BuildOprData(aReportID,xSubID)
		Continue:SubData=""
		Set ^CacheTemp(repid,ind)=RepData_SubData
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryOprRepByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOprRepByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOprRepByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOprRepByIDExecute ]
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
