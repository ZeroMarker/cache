/// 名称: DHCMed.NINFService.Rep.ReportExport
/// 描述: 医院感染报告 导出报表
/// 编写者：zhangxing	
/// 编写日期: 2011-11-14
Class DHCMed.NINFService.Rep.ReportExport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangxing
/// CreatDate：   2013-11-14
/// Description:  一切为了导出
/// Table：      
/// Input：       ReportID
/// output:       输出病人基本信息    
/// Return：      
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.ReportExport","QryBaseInf","47","130")
Query QryBaseInf(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,PapmiNo:%String,Name:%String,MrNo:%String,Sex:%String,Age:%String,NowLoc:%String,AdmDate:%String,AdmTime:%String,DisDate:%String,DisTime:%String,ImpDate:%String,BedNo:%String,RelLoc:%String,RepLoc:%String,RepDate:%String,RepMan:%String,RepStatus:%String,DisPro:%String,DeaRel:%String,TransID:%String,TransLoc:%String,TransLocDesc:%String,TransDate:%String,TransTime:%String,PrevTransID:%String,PrevTransWardID:%String,PrevTransWardDesc:%String,NextTransWardID:%String,NextTransWardDesc:%String,NextTransDate:%String,SystemSymptom:%String,LocalSymptom:%String,OutICUStatus:%String,OutICUStatusDesc:%String,OutICU48Status:%String,OutICU48StatusDesc:%String") [ SqlProc ]
{
}

ClassMethod QryBaseInfExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aReportID="") $$$OK
 	
 	Set (PapmiNo,Name,MrNo,Sex,Age,NowLoc,AdmDate,AdmTime,DisDate,DisTime,ImpDate,BedNo,RelLocDesc,ReportLocDesc,RepDate,ReportUserDesc,ReportStatusDesc,DiseasePrognosisDesc,DeathRelationDesc)=""
 	Set (TransID,TransLoc,TransLocDesc,TransDate,TransTime,PrevTransID,PrevTransWardID,PrevTransWardDesc,NextTransWardID,NextTransWardDesc,NextTransDate,SystemSymptom,LocalSymptom,OutICUStatus,OutICUStatusDesc,OutICU48Status,OutICU48StatusDesc)=""
 	
 	Set ReportID=aReportID
 	set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
 	Set EpisodeID=objReport.EpisodeID	
 	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
 	Quit:'$IsObject(objPaadm)
 	Set PatientID=objPaadm.PatientID
 	Quit:PatientID=""
 	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
 	Quit:'$IsObject(objPatient)
 	Set PapmiNo=objPatient.PapmiNo
 	Set Name=objPatient.PatientName
 	Set MrNo=objPaadm.MrNo
 	Set Sex=objPatient.Sex
 	Set Age=objPatient.Age
 	Set NowLoc=objPaadm.Department
 	Set AdmDate=objPaadm.AdmitDate
 	Set AdmTime=objPaadm.AdmitTime
 	Set DisDate=objPaadm.DisDate
 	Set DisTime=objPaadm.DisTime
 	Set ImpDate=objPaadm.Days
 	Set BedNo=objPaadm.Bed
 	
 	Set RepLoc=objReport.ReportLoc
 	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
		If $IsObject(objRepLoc) {
			Set ReportLocID=objRepLoc.Rowid
			Set ReportLocDesc=objRepLoc.Descs
		}
 	Set RepDate=objReport.ReportDate
 	Set RepDate=$zd(RepDate,3)
 	Set RepMan=objReport.ReportUser
 	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepMan)
		If $IsObject(objRepUser) {
			Set ReportUserID=objRepUser.Rowid
			Set ReportUserDesc=objRepUser.Name
		}
	If $IsObject(objReport.ReportStatus) {
		Set ReportStatusID=objReport.ReportStatus.%Id()
		Set ReportStatusDesc=objReport.ReportStatus.Description
	}
 	//Continue:'$IsObject(objSub)
 	Set xsummID=0
 	For {
	 	Set xsummID=$o(^DHCMed.NINF("InfRep",aReportID,"Summ",xsummID))
		Quit:xsummID=""
			
		Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(aReportID_"||"_xsummID)
		Continue:'$IsObject(objSumm)
		
		Set RelLoc=objSumm.TransLoc
		Set objRelLoc=##class(DHCMed.Base.Ctloc).GetObjById(RelLoc)
		If $IsObject(objRelLoc) {
			Set RelLocID=objRelLoc.Rowid
			Set RelLocDesc=objRelLoc.Descs
		}
		If $IsObject(objSumm.DiseasePrognosis) {
		Set DiseasePrognosisID=objSumm.DiseasePrognosis.%Id()
		Set DiseasePrognosisDesc=objSumm.DiseasePrognosis.Description
		}	
		If $IsObject(objSumm.DeathRelation) {
		Set DeathRelationID=objSumm.DeathRelation.%Id()
		Set DeathRelationDesc=objSumm.DeathRelation.Description
		}	
 		Set TranID=objSumm.TransID
 		Set SystemSymptom=objSumm.SystemSymptom
 		Set LocalSymptom=objSumm.LocalSymptom
 		Set TransID=$P(TranID,"||",2)
		Set TranInfo = ##class(DHCMed.NINFService.Srv.CommonCls).GetTransLocByID(TranID)
 		Set:RelLocDesc="" RelLocDesc=$p(TranInfo,"^",3)
 		Set tmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
		Continue:tmpTrans=""
		
		Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
		If TransLoc'="" {
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
			Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
			Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
		
			Set TransDate=$p($g(^PAADM(EpisodeID,"TRANS",TransID)),"^",1)
			Set TransTime=$p($g(^PAADM(EpisodeID,"TRANS",TransID)),"^",2)
			Set:TransDate'="" TransDate=$zd(TransDate,3)
			Set:TransTime'="" TransTime=$zt(TransTime,2)
		
			Set AdmStatus=$p($g(^PAADM(EpisodeID)),"^",20)
			//Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)
			//Set DischTime=$p($g(^PAADM(EpisodeID)),"^",18)
        	//Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)
			Set:DischDate'="" DischDate=$zd(DischDate,3)
			Set:DischTime'="" DischTime=$zt(DischTime,2)
		
			Set PrevTransID=TransID
			Set NextTransID=TransID
			For {
 				Set PrevTransID=$o(^PAADM(EpisodeID,"TRANS",PrevTransID),-1)
 					Quit:(PrevTransID="")
					Set PrevData=$g(^PAADM(EpisodeID,"TRANS",PrevTransID))
					Set PrevTransLocID=$p(PrevData,"^",6)
					Continue:PrevTransLocID=""
					Set PrevTransWard=$g(^CTLOC(PrevTransLocID,"LINK",0))
					Set PrevTransWardID=$g(^CTLOC(PrevTransLocID,"LINK",PrevTransWard))
					Continue:PrevTransWardID=""
					Set PrevTransWardDesc=$p($g(^CTLOC(+PrevTransWardID)),"^",2)
					Set:$p(PrevTransWardDesc,"-",2)'="" PrevTransWardDesc=$p(PrevTransWardDesc,"-",2)
					//Quit:PrevTransWardID=RelLoc PrevTransWardDesc="入院"
					Set:PrevTransID=1 PrevTransWardDesc="入院"
					Quit:PrevTransWardID'=""
			}
			Set xNextTransWardID=$p(TranInfo,"^",8)
			Set xNextTransWardDesc=$p(TranInfo,"^",9)
			Set xNextTransDate=$p(TranInfo,"^",5)
			
			/*
			For {
				Set NextTransID=$o(^PAADM(EpisodeID,"TRANS",NextTransID),+1)
				Quit:(NextTransID="")
				//I NextTransID'="" {

					Set NextData=$g(^PAADM(EpisodeID,"TRANS",NextTransID))
					Set NextTransLocID=$p(NextData,"^",6)
					Continue:NextTransLocID=""
					Set NextTransWard=$g(^CTLOC(NextTransLocID,"LINK",0))
					Set NextTransWardID=$g(^CTLOC(NextTransLocID,"LINK",NextTransWard))
					Continue:NextTransWardID=""
					Set NextTransWardDesc=$p($g(^CTLOC(+NextTransWardID)),"^",2)
					Set:$p(NextTransWardDesc,"-",2)'="" NextTransWardDesc=$p(NextTransWardDesc,"-",2)
					Set NextDate=$p($g(^PAADM(EpisodeID,"TRANS",NextTransID)),"^",1)
					Set NextTime=$p($g(^PAADM(EpisodeID,"TRANS",NextTransID)),"^",2)
					Set:NextDate'="" NextDate=$zd(NextDate,3)
					Set:NextTime'="" NextTime=$zt(NextTime,2)
					Set NextTransDate=NextDate_" "_NextTime
					
					//
					Continue:NextTransWardID=RelLoc
					Set xNextTransWardID=NextTransWardID
					Set xNextTransWardDesc=NextTransWardDesc
					Set xNextTransDate=NextTransDate
					Quit:NextTransWardID'=RelLoc
					// NextTransWardID,NextTransWardDesc,NextTransDate
				//} 
			}	
			*/
			//w c,!
			Set OutICUStatus=objSumm.OutICUStatus
			Set OutICUStatu=""
			For ind1=1:1:OutICUStatus.Count() {
				Set objDic=OutICUStatus.GetAt(ind1)
				continue:'$IsObject(objDic)
				If $IsObject(objDic) {
				Set OutICUStatusID=objDic.%Id()
				Set OutICUStatu=OutICUStatu_" "_objDic.Description
					}
				}
			Set OutICUStatusDesc=OutICUStatu
				
			Set OutICU48Status=objSumm.OutICU48Status
			Set OutICU48Statu=""
			For ind1=1:1:OutICU48Status.Count() {
				Set objDic=OutICU48Status.GetAt(ind1)
				continue:'$IsObject(objDic)
				If $IsObject(objDic) {
				Set OutICU48StatusID=objDic.%Id()
				Set OutICU48Statu=OutICU48Statu_" "_objDic.Description
					}
				}
			Set OutICU48StatusDesc=OutICU48Statu
		} 
 		
 		Set Data=$lb(ReportID,EpisodeID,PapmiNo,Name,MrNo,Sex,Age,NowLoc,AdmDate,AdmTime,DisDate,DisTime,ImpDate,BedNo,RelLocDesc,ReportLocDesc,RepDate,ReportUserDesc,ReportStatusDesc,DiseasePrognosisDesc,DeathRelationDesc,TransID,TransLoc,TransLocDesc,TransDate,TransTime,PrevTransID,PrevTransWardID,PrevTransWardDesc,xNextTransWardID,xNextTransWardDesc,xNextTransDate,SystemSymptom,LocalSymptom,OutICUStatus,OutICUStatusDesc,OutICU48Status,OutICU48StatusDesc)
		//Set Date=$lb(TransID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryBaseInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBaseInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBaseInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBaseInfExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.ReportExport","QryTransLoc","130","W")
Query QryTransLoc(aEpisodeID As %String, aTransType As %String) As %Query(ROWSPEC = "TransRowID:%String,PrevTransLocID:%String,PrevTransLocDesc:%String,TransDate:%String,NextTransDate:%String,NextTransLocID:%String,NextTransLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTransLocExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aTransType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="")&&(aTransType="") $$$OK
 	
 	Set $ZT="GetTransLocListErr"
	
	Set NIndex="GetTransLocList"
	Kill ^TMP($zn,$j,NIndex)
	Set TransID="",PrevTransLoc=""
	For {
		Set TransID=$o(^PAADM(aEpisodeID,"TRANS",TransID))
		Quit:TransID=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",TransID))
		Continue:tmpTrans=""
		
		If aTransType="W" {
			Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			Continue:TransLoc=""
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		} Else {
			Set TransLoc=$p(tmpTrans,"^",6)
			Continue:TransLoc=""
		}
		Continue:PrevTransLoc=TransLoc
		Set PrevTransLoc=TransLoc
		Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
		Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
		Set TransDate=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",1)
		Set TransTime=$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",2)
		Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set:TransTime'="" TransTime=$zt(TransTime,2)
		Set ^TMP($zn,$j,NIndex,TransID)=$lb(aEpisodeID_"||"_TransID,TransLoc,TransLocDesc,TransDate_" "_TransTime)
	}
	
	Set AdmStatus=$p($g(^PAADM(aEpisodeID)),"^",20)
	//Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)
	//Set DischTime=$p($g(^PAADM(aEpisodeID)),"^",18)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
	
	Set JsonStr="",Count=0
	Set TransID=0
	For {
		Set TransID=$o(^TMP($zn,$j,NIndex,TransID))
		Quit:TransID=""
		
		Set (TransRowID,PrevTransLocID,PrevTransLocDesc,TransDate,NextTransDate,NextTransLocID,NextTransLocDesc)=""
		Set PrevTransID=$o(^TMP($zn,$j,NIndex,TransID),-1)
		If PrevTransID'="" {
			Set PrevData=$g(^TMP($zn,$j,NIndex,PrevTransID))
			Set PrevTransLocID=$list(PrevData,2)
			Set PrevTransLocDesc=$list(PrevData,3)
		}
		Set:PrevTransLocDesc="" PrevTransLocDesc="入院"
		
		Set NextTransID=$o(^TMP($zn,$j,NIndex,TransID))
		If NextTransID'="" {
			Set NextData=$g(^TMP($zn,$j,NIndex,NextTransID))
			Set NextTransLocID=$list(NextData,2)
			Set NextTransLocDesc=$list(NextData,3)
			Set NextTransDate=$list(NextData,4)
		} Else {
			If AdmStatus="D" {
				Set NextTransLocDesc="出院"
				Set NextTransDate=DischDate_" "_DischTime
			}
		}
		
		Set tmpData=$g(^TMP($zn,$j,NIndex,TransID))
		Set TransRowID=$list(tmpData,1)
		Set TransLocID=$list(tmpData,2)
		Set TransLocDesc=$list(tmpData,3)
		Set TransDate=$list(tmpData,4)
		
		Set Data=$lb(TransRowID,PrevTransLocID,PrevTransLocDesc,TransDate,NextTransDate,NextTransLocID,NextTransLocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	}
GetTransLocListErr
	Quit $$$OK
}

ClassMethod QryTransLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTransLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTransLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTransLocExecute ]
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

/// Creator：     zhangxing
/// CreatDate：   2013-11-25
/// Description:  导出药敏结果
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.ReportExport","QryAntiRec","45","345")
Query QryAntiRec(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "oePathogenyDesc:%String,oeAntibioticsDesc:%String,oeSenTestRstDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAntiRecExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aReportID="") $$$OK
	
	If aReportID'="" {
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Lab",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(aReportID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			
			
			Set (TestResults,TestResultValues,TestResultDescs,PathogenyDesc,AntibioticsDesc,SenTestRstDesc)=""
			
		
			
			Set oeTestResults=""
			Set DataSource=objSub.DataSource
			If DataSource["OEITEM:" {
				Set OEItemID=$p(DataSource,"OEITEM:",2)
				Set oeTestResults=..getTestResults(OEItemID)
				//w oeTestResults,!
			}
			Set listPathogeny=""
			Set TestResults=objSub.TestResults
			For indTestRst=1:1:TestResults.Count() {
				Set objTestRst=objSub.TestResults.GetAt(indTestRst)
				Continue:'$IsObject(objTestRst)
				Set PathogenyID=objTestRst.PathogenyID
				Set PathogenyDesc=objTestRst.PathogenyDesc
				Continue:PathogenyDesc=""
				Set listPathogeny=listPathogeny_$lb(PathogenyDesc)
				Set DrugSenTest=""
				Set listAntibiotics=""
			If (oeTestResults="") {
				For indSenTest=1:1:objTestRst.DrugSenTest.Count() {
					Set objSenTest=objTestRst.DrugSenTest.GetAt(indSenTest)
					Continue:'$IsObject(objSenTest)
					Set AntibioticsID=objSenTest.AntibioticsID
					Set AntibioticsDesc=objSenTest.AntibioticsDesc
					Continue:AntibioticsDesc=""
					Continue:$listfind(listAntibiotics,AntibioticsDesc)>0
					Set SenTestRstID="",SenTestRstDesc=""
					If $IsObject(objSenTest.SenTestRst) {
						Set SenTestRstID=objSenTest.SenTestRst.%Id()
						Set SenTestRstDesc=objSenTest.SenTestRst.Description
					}
					//Set DrugSenTest=DrugSenTest_"  "_PathogenyDesc_"  "_AntibioticsDesc_"  "_SenTestRstDesc
					//Set Data=$lb(PathogenyDesc,AntibioticsDesc,SenTestRstDesc)
					//Set ^CacheTemp(repid,ind)=Data
					//Set ind=ind+1
				}
			} else {
					//检验报告中药敏试验结果
				For indOeTst=1:1:$l(oeTestResults,$c(1)) {
					Set oeTestResult=$p(oeTestResults,$c(1),indOeTst)
					Continue:oeTestResult=""
					Set oePathogenyID=$p(oeTestResult,$c(2),1)
					Set oePathogenyDesc=$p(oeTestResult,$c(2),2)
					Set oeDrugSenTest=$p(oeTestResult,$c(2),3)
					Continue:oePathogenyDesc=""
					Continue:oePathogenyDesc'=PathogenyDesc
					Continue:oeDrugSenTest=""
						
					For indOeAnti=1:1:$l(oeDrugSenTest,$c(3)) {
						Set oeDrugSenTestStr=$p(oeDrugSenTest,$c(3),indOeAnti)
						Continue:oeDrugSenTestStr=""
						Set oeAntibioticsID=$p(oeDrugSenTestStr,$c(4),1)
						Set oeAntibioticsDesc=$p(oeDrugSenTestStr,$c(4),2)
						Continue:oeAntibioticsDesc=""
						Set listAntibiotics=listAntibiotics_$lb(oeAntibioticsDesc)
						Set oeSenTestRst=$p(oeDrugSenTestStr,$c(4),3)
						Set oeSenTestRstDesc=$p(oeDrugSenTestStr,$c(4),4)
						Continue:oeSenTestRstDesc=""
						Set DrugSenTest=DrugSenTest_"  "_oePathogenyDesc_"  "_oeAntibioticsDesc_"  "_oeSenTestRstDesc
						Set Data=$lb(oePathogenyDesc,oeAntibioticsDesc,oeSenTestRstDesc)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
			/*
			Set Data=$lb(PathogenyDesc,AntibioticsDesc,SenTestRstDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			*/
			}
			/*
			Set:TestResultValues'="" TestResultValues=$e(TestResultValues,2,$l(TestResultValues))
			Set:TestResultDescs'="" TestResultDescs=$e(TestResultDescs,2,$l(TestResultDescs))
			
			Set Data=$lb(PathogenyDesc,AntibioticsDesc,SenTestRstDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			*/
		}
		Quit $$$OK
	}
}

ClassMethod QryAntiRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiRecExecute ]
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

/// 根据医嘱ID取值检验报告中的药敏结果
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).getTestResults("14||6")
ClassMethod getTestResults(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set return=##class(DHCMed.NINFService.Rep.InfReportLab).getTestResults(aOEItemID)
	Quit return
}

}
