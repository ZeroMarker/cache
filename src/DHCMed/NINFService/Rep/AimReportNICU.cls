/// 名称: DHCMed.NINFService.Rep.AimReportNICU
/// 描述: 目标性监测报告 NICU相关
/// 编写者：zhufei
/// 编写日期: 2011-05-26
Class DHCMed.NINFService.Rep.AimReportNICU Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  查询目标性监测(NICU相关)记录
/// Table：       DHCMed.NINF.Rep.AimReportUC
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimReportNICU","QryRepInfoByDateLoc","3","2012-06-01","2012-06-17","","Y")
Query QryRepInfoByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Query(ROWSPEC = "AimIndex:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,AdmitDate:%String,DischDate:%String,LocDesc:%String,BornWeight:%String,NUCIntubateDate:%String,NUCExtubateDate:%String,NUCIsInfection:%String,NUCInfDate:%String,NUCInfPyDescs:%String,NPICCIntubateDate:%String,NPICCExtubateDate:%String,NPICCIsInfection:%String,NPICCInfDate:%String,NPICCInfPyDescs:%String,NVNTIntubateDate:%String,NVNTExtubateDate:%String,NVNTIsInfection:%String,NVNTInfDate:%String,NVNTInfPyDescs:%String,NICUInfDate:%String,NIUCDiagnose:%String")
{
}

ClassMethod QryRepInfoByDateLocExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aIsCommit As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
	Set ZIndex=$zn,JIndex=$j,NIndex="QryRepInfoByDateLoc"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set IndexStr="IndexRepDate"
	Set:aDateType=1 IndexNodeStr="IndexIntubateDate"
	Set:aDateType=2 IndexNodeStr="IndexExtubateDate"
	Set:aDateType=3 IndexNodeStr="IndexRepDate"
	
	//NICU-脐静脉
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"NUC",IndexNodeStr,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"NUC",IndexNodeStr,xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			Continue:(aRepLoc'="")&&(aRepLoc'=TransLoc)
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"NUC",IndexNodeStr,xDate,RepID,SubID))
				Quit:SubID=""
				
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNUC).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
					Continue:(aIsCommit="Y")&&(RepStatusCode'="2")  //未提交的报告不显示
				}
				
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,TransLoc,RepID,"NUC"))
				Set ^TMP(ZIndex,JIndex,NIndex,TransLoc,RepID,"NUC",num)=SubID
			}
		}
	}
	
	//NICU-PICC
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"NPICC",IndexNodeStr,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"NPICC",IndexNodeStr,xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			Continue:(aRepLoc'="")&&(aRepLoc'=TransLoc)
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"NPICC",IndexNodeStr,xDate,RepID,SubID))
				Quit:SubID=""
				
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNPICC).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
					Continue:(aIsCommit="Y")&&(RepStatusCode'="2")  //未提交的报告不显示
				}
				
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,TransLoc,RepID,"NPICC"))
				Set ^TMP(ZIndex,JIndex,NIndex,TransLoc,RepID,"NPICC",num)=SubID
			}
		}
	}
	
	//NICU-气管插管
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"NVNT",IndexNodeStr,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"NVNT",IndexNodeStr,xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			Continue:(aRepLoc'="")&&(aRepLoc'=TransLoc)
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"NVNT",IndexNodeStr,xDate,RepID,SubID))
				Quit:SubID=""
				
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
					Continue:(aIsCommit="Y")&&(RepStatusCode'="2")  //未提交的报告不显示
				}
				
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,TransLoc,RepID,"NVNT"))
				Set ^TMP(ZIndex,JIndex,NIndex,TransLoc,RepID,"NVNT",num)=SubID
			}
		}
	}
	
	Set xLocID=0
	For {
		Set xLocID=$o(^TMP(ZIndex,JIndex,NIndex,xLocID))
		Quit:xLocID=""
		Set xRepID=0
		For {
			Set xRepID=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xRepID))
			Quit:xRepID=""
			
			Set (PatName,PatSex,PatMrNo,PatAge,AdmitDate,DischDate,LocDesc,BornWeight)=""
			Set (NICUInfDate,NIUCDiagnose)=""
			
			Set objAimRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(xRepID)
			Continue:'$IsObject(objAimRep)
			Set EpisodeID=objAimRep.EpisodeID
			Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set AdmitDate=objPaadm.AdmitDate
			Set DischDate=objPaadm.DisDate
			Set PatientID=objPaadm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient)
			Set PatName=objPatient.PatientName
			Set PatSex=objPatient.Sex
			Set PatMrNo=objPatient.InPatientMrNo
			Set PatAge=objPatient.Age
			
			Set TransID=objAimRep.TransID
			Set TransLoc=objAimRep.TransLoc
			Set LocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Continue:LocDesc=""
			
			Set BornWeight=objAimRep.BornWeight
			Set:BornWeight'="" BornWeight=BornWeight_"gm"
			
			//取NICU院感报告的感染诊断 NICU感染报告id=8
			Set NICURepId=##class(DHCMed.INFService.InfReportSrv).GetReportID(EpisodeID,"8")
			Set:NICURepId'="" NIUCDiagnose=..GetNICUInfRepDiagDesc(NICURepId)
			Set:NICURepId'="" NICUInfDate=..GetNICUInfRepInfDate(NICURepId)
			
			Set NUCNum=+$g(^TMP(ZIndex,JIndex,NIndex,TransLoc,xRepID,"NUC"))
			Set NPICCNum=+$g(^TMP(ZIndex,JIndex,NIndex,TransLoc,xRepID,"NPICC"))
			Set NVNTNum=+$g(^TMP(ZIndex,JIndex,NIndex,TransLoc,xRepID,"NVNT"))
			
			Set RowNum=NUCNum
			Set:NPICCNum>RowNum RowNum=NPICCNum
			Set:NVNTNum>RowNum RowNum=NVNTNum
			
			For num=1:1:RowNum
			{
				Set (NUCIntubateDate,NUCExtubateDate,NUCIsInfection,NUCInfDate,NUCInfPyDescs)=""
				Set (NPICCIntubateDate,NPICCExtubateDate,NPICCIsInfection,NPICCInfDate,NPICCInfPyDescs)=""
				Set (NVNTIntubateDate,NVNTExtubateDate,NVNTIsInfection,NVNTInfDate,NVNTInfPyDescs)=""
				
				//NICU-脐静脉
				Set xSubID=$g(^TMP(ZIndex,JIndex,NIndex,TransLoc,xRepID,"NUC",num))
				If xSubID'="" {
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNPICC).GetObjById(xRepID_"||"_xSubID)
					If $IsObject(objRepSub) {
						Set NUCIntubateDate=objRepSub.IntubateDate
						Set:NUCIntubateDate'="" NUCIntubateDate=$zd(+NUCIntubateDate,3)
						
						Set NUCExtubateDate=objRepSub.ExtubateDate
						Set:NUCExtubateDate'="" NUCExtubateDate=$zd(+NUCExtubateDate,3)
						
						Set NUCInfDate=objRepSub.InfDate
						Set:NUCInfDate'="" NUCInfDate=$zd(NUCInfDate,3)
						Set:NUCInfDate'="" NUCIsInfection="是"
						Set objInfPyList=objRepSub.InfPathogeny
						If $IsObject(objInfPyList) {
							For indPy=1:1:objInfPyList.Count() {
								Set objInfPy=objInfPyList.GetAt(indPy)
								Continue:'$IsObject(objInfPy)
								Set InfPyDesc=objInfPy.PathogenyDesc
								Set NUCInfPyDescs=NUCInfPyDescs_";"_InfPyDesc
							}
							Set:NUCInfPyDescs'="" NUCInfPyDescs=$e(NUCInfPyDescs,2,$l(NUCInfPyDescs))
						}
					}
				}
				
				//NICU-PICC
				Set xSubID=$g(^TMP(ZIndex,JIndex,NIndex,TransLoc,xRepID,"NPICC",num))
				If xSubID'="" {
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNPICC).GetObjById(xRepID_"||"_xSubID)
					If $IsObject(objRepSub) {
						Set NPICCIntubateDate=objRepSub.IntubateDate
						Set:NPICCIntubateDate'="" NPICCIntubateDate=$zd(+NPICCIntubateDate,3)
						
						Set NPICCExtubateDate=objRepSub.ExtubateDate
						Set:NPICCExtubateDate'="" NPICCExtubateDate=$zd(+NPICCExtubateDate,3)
						
						Set NPICCInfDate=objRepSub.InfDate
						Set:NPICCInfDate'="" NPICCInfDate=$zd(NPICCInfDate,3)
						Set:NPICCInfDate'="" NPICCIsInfection="是"
						Set objInfPyList=objRepSub.InfPathogeny
						If $IsObject(objInfPyList) {
							For indPy=1:1:objInfPyList.Count() {
								Set objInfPy=objInfPyList.GetAt(indPy)
								Continue:'$IsObject(objInfPy)
								Set InfPyDesc=objInfPy.PathogenyDesc
								Set NPICCInfPyDescs=NPICCInfPyDescs_";"_InfPyDesc
							}
							Set:NPICCInfPyDescs'="" NPICCInfPyDescs=$e(NPICCInfPyDescs,2,$l(NPICCInfPyDescs))
						}
					}
				}
				
				//NICU-气管插管
				Set xSubID=$g(^TMP(ZIndex,JIndex,NIndex,TransLoc,xRepID,"NVNT",num))
				If xSubID'="" {
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(xRepID_"||"_xSubID)
					If $IsObject(objRepSub) {
						Set NVNTIntubateDate=objRepSub.IntubateDate
						Set:NVNTIntubateDate'="" NVNTIntubateDate=$zd(+NVNTIntubateDate,3)
						
						Set NVNTExtubateDate=objRepSub.ExtubateDate
						Set:NVNTExtubateDate'="" NVNTExtubateDate=$zd(+NVNTExtubateDate,3)
						
						Set NVNTInfDate=objRepSub.InfDate
						Set:NVNTInfDate'="" NVNTInfDate=$zd(NVNTInfDate,3)
						Set:NVNTInfDate'="" NVNTIsInfection="是"
						Set objInfPyList=objRepSub.InfPathogeny
						If $IsObject(objInfPyList) {
							For indPy=1:1:objInfPyList.Count() {
								Set objInfPy=objInfPyList.GetAt(indPy)
								Continue:'$IsObject(objInfPy)
								Set InfPyDesc=objInfPy.PathogenyDesc
								Set NVNTInfPyDescs=NVNTInfPyDescs_";"_InfPyDesc
							}
							Set:NVNTInfPyDescs'="" NVNTInfPyDescs=$e(NVNTInfPyDescs,2,$l(NVNTInfPyDescs))
						}
					}
				}
				
				If num>1 {
					Set Data=$lb("","","","","","","","","")
				} Else {
					Set Data=$lb(ind,PatName,PatSex,PatMrNo,PatAge,AdmitDate,DischDate,LocDesc,BornWeight)
				}
				Set Data=Data_$lb(NUCIntubateDate,NUCExtubateDate,NUCIsInfection,NUCInfDate,NUCInfPyDescs)
				Set Data=Data_$lb(NPICCIntubateDate,NPICCExtubateDate,NPICCIsInfection,NPICCInfDate,NPICCInfPyDescs)
				Set Data=Data_$lb(NVNTIntubateDate,NVNTExtubateDate,NVNTIsInfection,NVNTInfDate,NVNTInfPyDescs)
				If num>1 {
					Set Data=Data_$lb("","")
				} Else {
					Set Data=Data_$lb(NICUInfDate,NIUCDiagnose)
				}
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
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

/// add by wuqk 2012-01-18
/// 通过报告Id获取NICU院感报告相应诊断的描述
/// w ##class(DHCMed.NINFService.Rep.AimReportNICU).GetNICUInfRepDiagDesc(2011,12,1,1)
ClassMethod GetNICUInfRepDiagDesc(NICURepId As %String) As %String
{
	n (NICURepId)
	
	s ret=""
	q:(NICURepId="") ret
	
	s obj=##class(DHCMed.INF.Report).GetObjById(NICURepId)
	q:'$IsObject(obj) ret
	s StatusDr=obj.StatusDr
	q:StatusDr=0 ret	//删除报告q:'$d(^DHCMed.INF.SummaryI("InfRepDr",rowid))
	s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",NICURepId,""),-1)
	q:SumID="" ret
	s SumObj=##Class(DHCMed.INF.Summary).GetObjById(SumID)
	q:'$IsObject(SumObj) ret
	s PosID=""
	f  s PosID=$o(^DHCMed.INF.RepPosI("InfRepDr",SumID,PosID)) q:PosID=""  d
	.s PosObj=##class(DHCMed.INF.RepPos).GetObjById(PosID)
	.q:'$IsObject(PosObj)
	.s InfDiagCode=PosObj.InfDiagDR
	.s DicDiagId=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfDiagCode,"NICUInfDiag")
	.s objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicDiagId)
	.q:'$IsObject(objDic)
	.s ret=ret_objDic.Description_";"
	
	q ret
}

/// add by zhufei 2012-02-01
/// 通过报告Id获取NICU院感报告相应感染日期
/// w ##class(DHCMed.NINFService.Rep.AimReportNICU).GetNICUInfRepInfDate(1)
ClassMethod GetNICUInfRepInfDate(NICURepId As %String) As %String
{
	n (NICURepId)
	
	s ret=""
	q:(NICURepId="") ret
	
	s obj=##class(DHCMed.INF.Report).GetObjById(NICURepId)
	q:'$IsObject(obj) ret
	s StatusDr=obj.StatusDr
	q:StatusDr=0 ret	//删除报告q:'$d(^DHCMed.INF.SummaryI("InfRepDr",rowid))
	s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",NICURepId,""),-1)
	q:SumID="" ret
	s SumObj=##Class(DHCMed.INF.Summary).GetObjById(SumID)
	q:'$IsObject(SumObj) ret
	s PosID=""
	f  s PosID=$o(^DHCMed.INF.RepPosI("InfRepDr",SumID,PosID)) q:PosID=""  d
	.s PosObj=##class(DHCMed.INF.RepPos).GetObjById(PosID)
	.q:'$IsObject(PosObj)
	.s InfDate=PosObj.InfDate
	.s:(+InfDate)'=0 InfDate=$zd(+InfDate,3)
	.s:(+InfDate)'=0 ret=InfDate
	
	q ret
}

}
