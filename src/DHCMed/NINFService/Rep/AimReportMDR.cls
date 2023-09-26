/// 名称: DHCMed.NINFService.Rep.AimReportMDR
/// 描述: 目标性监测报告 多重耐药
/// 编写者：zhufei
/// 编写日期: 2011-05-26
Class DHCMed.NINFService.Rep.AimReportMDR Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Rep.AimReportMDR).SaveReport("3^^2012-06-11^4358^4362^4370^4372^4376^117^9^1","^")
ClassMethod SaveReport(aInput As %String, aSeparase As %String)
{
	New (aInput,aSeparase)
	Set return=0
	Set $ZT="SaveReportErr"
	
	Set RepID=$p(aInput,aSeparase,1)
	Set SubID=$p(aInput,aSeparase,2)
	
	Set PathDate=$p(aInput,aSeparase,3)
	Set:PathDate["-" PathDate=$zdh(PathDate,3)
	Set SampleType=$p(aInput,aSeparase,4)
	Set Pathogeny=$p(aInput,aSeparase,5)
	Set IsolateType=$p(aInput,aSeparase,6)
	Set HandHygiene=$p(aInput,aSeparase,7)
	Set SecondaryCases=$p(aInput,aSeparase,8)
	
	Set RepLoc=$p(aInput,aSeparase,9)
	Set RepUser=$p(aInput,aSeparase,10)
	Set RepDate=+$h
	Set RepTime=$p($h,",",2)
	Set RepStatus=""
	Set RepStatusCode=$p(aInput,aSeparase,11)
	
	//update by lyh 2013-3-5 增加感染情况
	Set NINFStation=$p(aInput,aSeparase,12)
	Set objRepStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportStatus",RepStatusCode,"")
	If $IsObject(objRepStatus){
		Set RepStatus=objRepStatus.%Id()
	}
	
	Set InputReportMDR=RepID
	Set InputReportMDR=InputReportMDR_aSeparase_SubID
	If (RepID'="")&&(SubID'="") {
		Set objReportMDR=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(RepID_"||"_SubID)
		If $IsObject(objReportMDR) {
			Set RepLoc=objReportMDR.RepLoc
			Set RepUser=objReportMDR.RepUser
			Set RepDate=objReportMDR.RepDate
			Set RepTime=objReportMDR.RepTime
		}
	}
	
	Set DataSource=$p(aInput,aSeparase,13)
	
	Set InputReportMDR=InputReportMDR_aSeparase_PathDate
	Set InputReportMDR=InputReportMDR_aSeparase_SampleType
	Set InputReportMDR=InputReportMDR_aSeparase_Pathogeny
	Set InputReportMDR=InputReportMDR_aSeparase_IsolateType
	Set InputReportMDR=InputReportMDR_aSeparase_HandHygiene
	Set InputReportMDR=InputReportMDR_aSeparase_SecondaryCases
	Set InputReportMDR=InputReportMDR_aSeparase_RepLoc
	Set InputReportMDR=InputReportMDR_aSeparase_RepUser
	Set InputReportMDR=InputReportMDR_aSeparase_RepDate
	Set InputReportMDR=InputReportMDR_aSeparase_RepTime
	Set InputReportMDR=InputReportMDR_aSeparase_RepStatus
	Set UpdateLog=RepLoc_","_RepUser_","_RepStatus
	Set InputReportMDR=InputReportMDR_aSeparase_UpdateLog
	Set InputReportMDR=InputReportMDR_aSeparase_NINFStation
	Set InputReportMDR=InputReportMDR_aSeparase_DataSource
	Set return=##Class(DHCMed.NINF.Rep.AimReportMDR).Update(InputReportMDR,aSeparase)
	Quit return
	
SaveReportErr
	Quit -999
}

/// w ##Class(DHCMed.NINFService.Rep.AimReportMDR).UpdateStatus("3||5^117^9^0","^")
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
	Set return=##Class(DHCMed.NINF.Rep.AimReportMDR).UpdateStatus(InputStr,aSeparase)
	Quit return
	
UpdateStatusErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询目标性监测(多重耐药)记录
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportMDR","QryReportByID",1)
Query QryReportByID(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,ReportID:%String,PathDate:%String,SampleTypeID:%String,SampleTypeDesc:%String,PathogenyID:%String,PathogenyDesc:%String,IsolateTypeID:%String,IsolateTypeDesc:%String,HandHygieneID:%String,HandHygieneDesc:%String,SecondaryCasesID:%String,SecondaryCasesDesc:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String,NINFStationID:%String,NINFStationDesc:%String")
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
		Set SubID=$o(^DHCMed.NINF("AimRep",aRepID,"MDR",SubID))
		Quit:SubID=""
		
		Set ReportID=aRepID_"||"_SubID
		Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
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
/// Description:  查询目标性监测(多重耐药)记录
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportMDR","QryRepByDateLoc","3","2012-06-01","2012-06-14","")
Query QryRepByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "EpisodeID:%String,AdmitDate:%String,DischDate:%String,PatientID:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,TransLocID:%String,TransLocDesc:%String,TransFromLocID:%String,TransFromLocDesc:%String,TransToLocID:%String,TransToLocDesc:%String,TransStartDate:%String,TransStartTime:%String,TransEndDate:%String,TransEndTime:%String,TransDays:%String,TransDiagnose:%String,ReportID:%String,PathDate:%String,SampleTypeID:%String,SampleTypeDesc:%String,PathogenyID:%String,PathogenyDesc:%String,IsolateTypeID:%String,IsolateTypeDesc:%String,HandHygieneID:%String,HandHygieneDesc:%String,SecondaryCasesID:%String,SecondaryCasesDesc:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String")
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
			Set xRepStatus=$o(^DHCMed.NINFi("AimRep",0,"MDR","IndexRepStatusDate",xRepStatus))
			Quit:xRepStatus=""
			
			Set objRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(xRepStatus)
			Continue:'$IsObject(objRepStatus)
			Set RepStatusCode=objRepStatus.Code
			Continue:RepStatusCode="0"  //删除报告不显示
			Continue:RepStatusCode="2"  //提交报告不显示
			
			Set xRepDate=""
			For {
				Set xRepDate=$o(^DHCMed.NINFi("AimRep",0,"MDR","IndexRepStatusDate",xRepStatus,xRepDate))
				Quit:xRepDate=""
				Set xRepTime=""
				For {
					Set xRepTime=$o(^DHCMed.NINFi("AimRep",0,"MDR","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime))
					Quit:xRepTime=""
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"MDR","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID))
						Quit:xRepID=""
						
						Set RepData=..BuildRepData(xRepID)
						Continue:RepData=""
						Set TransLocID=$List(RepData,9)              
						Continue:(aRepLoc'="")&&(aRepLoc'=TransLocID)
						//Set TransEndDate=$list(RepData,17)  //转科或出院时间
						//Continue:TransEndDate=""
						
						Set xSubID=0
						For {
							Set xSubID=$o(^DHCMed.NINFi("AimRep",0,"MDR","IndexRepStatusDate",xRepStatus,xRepDate,xRepTime,xRepID,xSubID))
							Quit:xSubID=""
							
							Set ReportID=xRepID_"||"_xSubID
							Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
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
		Set:aDateType=1 IndexNodeStr="IndexPathDate"
		Set:aDateType=3 IndexNodeStr="IndexRepDate"
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("AimRep",0,"MDR",IndexNodeStr,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			Set RepID=0
			For {
				Set RepID=$o(^DHCMed.NINFi("AimRep",0,"MDR",IndexNodeStr,xDate,RepID))
				Quit:RepID=""
				
				Set RepData=..BuildRepData(RepID)
				Continue:RepData=""
				Set TransLocID=$List(RepData,9)              
				Continue:(aRepLoc'="")&&(aRepLoc'=TransLocID)
				
				Set SubID=0
				For {
					Set SubID=$o(^DHCMed.NINFi("AimRep",0,"MDR",IndexNodeStr,xDate,RepID,SubID))
					Quit:SubID=""
					
					Set ReportID=RepID_"||"_SubID
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
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
/// Description:  查询目标性监测(多重耐药)记录
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportMDR","QryRepInfoByDateLoc","3","2012-06-01","2012-06-14","")
Query QryRepInfoByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "EpisodeID:%String,AdmitDate:%String,DischDate:%String,PatientID:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,TransLocID:%String,TransLocDesc:%String,TransFromLocID:%String,TransFromLocDesc:%String,TransToLocID:%String,TransToLocDesc:%String,TransStartDate:%String,TransStartTime:%String,TransEndDate:%String,TransEndTime:%String,TransDays:%String,TransDiagnose:%String,ReportID:%String,PathDate:%String,SampleTypeID:%String,SampleTypeDesc:%String,PathogenyID:%String,PathogenyDesc:%String,IsolateTypeID:%String,IsolateTypeDesc:%String,HandHygieneID:%String,HandHygieneDesc:%String,SecondaryCasesID:%String,SecondaryCasesDesc:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String,NINFStationID:%String,NINFStationDesc:%String")
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
	Set:aDateType=1 IndexNodeStr="IndexPathDate"
	Set:aDateType=3 IndexNodeStr="IndexRepDate"
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"MDR",IndexNodeStr,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"MDR",IndexNodeStr,xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			Continue:(aRepLoc'="")&&(aRepLoc'=TransLoc)
			
			Set RepData=..BuildRepData(RepID)
			Continue:RepData=""
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"MDR",IndexNodeStr,xDate,RepID,SubID))
				Quit:SubID=""
				
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
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
	
	Set (PathDate,SampleTypeID,SampleTypeDesc,PathogenyID,PathogenyDesc)=""
	Set (IsolateTypeID,IsolateTypeDesc,HandHygieneID,HandHygieneDesc,SecondaryCasesID,SecondaryCasesDesc)=""
	Set (RepStatusID,RepStatusDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc,NINFStationID,NINFStationDesc)=""
	
	Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(aReportID)
	Quit:'$IsObject(objRepSub) return
	
	Set objRepStatus=objRepSub.RepStatus
	If $IsObject(objRepStatus) {
		Set RepStatusID=objRepStatus.%Id()
		Set RepStatusDesc=objRepStatus.Description
	}
	
	Set PathDate=objRepSub.PathDate
	Set:PathDate'="" PathDate=$zd(+PathDate,3)
	Set objSampleType=objRepSub.SampleType
	If $IsObject(objSampleType) {
		Set SampleTypeID=objSampleType.%Id()
		Set SampleTypeDesc=objSampleType.Description
	}
	Set objPathogeny=objRepSub.Pathogeny
	If $IsObject(objPathogeny) {
		Set PathogenyID=objPathogeny.%Id()
		Set PathogenyDesc=objPathogeny.Description
	}
	Set objIsolateType=objRepSub.IsolateType
	If $IsObject(objIsolateType) {
		Set IsolateTypeID=objIsolateType.%Id()
		Set IsolateTypeDesc=objIsolateType.Description
	}
	Set objHandHygiene=objRepSub.HandHygiene
	If $IsObject(objHandHygiene) {
		Set HandHygieneID=objHandHygiene.%Id()
		Set HandHygieneDesc=objHandHygiene.Description
	}
	Set objSecondaryCases=objRepSub.SecondaryCases
	If $IsObject(objSecondaryCases) {
		Set SecondaryCasesID=objSecondaryCases.%Id()
		Set SecondaryCasesDesc=objSecondaryCases.Description
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
	
	Set objNINFStation=objRepSub.NINFStation
	
	If $IsObject(objNINFStation) {
		Set NINFStationID=objNINFStation.%Id()
		Set NINFStationDesc=objNINFStation.Description
	}
	
	Set return=$lb(aReportID,PathDate,SampleTypeID,SampleTypeDesc,PathogenyID,PathogenyDesc)
	Set return=return_$lb(IsolateTypeID,IsolateTypeDesc,HandHygieneID,HandHygieneDesc,SecondaryCasesID,SecondaryCasesDesc)
	Set return=return_$lb(RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc,NINFStationID,NINFStationDesc)
	
	Quit return
	
BuildSubDataErr
	Quit ""
}

}
