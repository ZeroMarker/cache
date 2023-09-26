Class DHCMed.EPDService.MED0101 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:fujingwei
/// CreateDate:2018-10-12
/// Description:  传染病门诊日志
/// Table：       User.PAAdm、User.PAPatMas、DHCMed.EPD.Epidemic
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLoc：	 科室ID  
/// 			  aPapmi:	 登记号
/// 			  aMrNo:	 病案号
/// 			  aName:	 姓名
/// 			  aDiagnos:	 诊断关键字
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.MED0101","QryOPLog","2","2022-02-08","2022-04-08","","","","","")
Query QryOPLog(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLoc As %Text, aPapmi As %String, aMrNo As %String, aName As %String, aDiagnos As %String, aTimeFrom As %String = "0", aTimeTo As %String = "86399", aIsHaveDiag As %String = "") As %Query(ROWSPEC = "ind:%String,xEpisodeID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,Address:%String,PersonID:%String,Tel:%String,DiagList:%String,AdmFirAdm:%String,AdmReAdm:%String,AdmDoc:%String,AdmDate:%String,AdmLoc:%String,LocalFlag:%String,IsRep:%String,EpdList:%String,MrNo:%String,OtherDiagList") [ SqlProc ]
{
}

ClassMethod QryOPLogExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLoc As %Text, aPapmi As %String, aMrNo As %String, aName As %String, aDiagnos As %String, aTimeFrom As %String = "0", aTimeTo As %String = "86399", aIsHaveDiag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aTimeFrom[":" aTimeFrom=$zth(aTimeFrom)
	Set:aTimeTo[":" aTimeTo=$zth(aTimeTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Quit:(aDateFrom=aDateTo)&&(aTimeFrom>aTimeTo) $$$OK
 	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^PAADMi("PAADM_DateTime",xDate))
		Quit:(xDate="")
		Quit:(xDate>aDateTo)
		
		Set xTime=""
		Set:xDate=aDateFrom xTime=aTimeFrom
		For {
			Set xTime=$o(^PAADMi("PAADM_DateTime",xDate,xTime))
			Quit:(xTime="")             //  ||(xTime>86399)
			Quit:(xDate=aDateTo)&&(xTime>aTimeTo)
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^PAADMi("PAADM_DateTime",xDate,xTime,xEpisodeID))
				Quit:xEpisodeID=""
			
				Set AdmInfo=$g(^PAADM(xEpisodeID))
				Set Status=$p(AdmInfo,"^",20)
				Continue:Status'="A"
				Continue:$p(AdmInfo,"^",2)'="O"
				
				//诊断
				Set MRAdm=$p(AdmInfo,"^",61)
				Continue:MRAdm=""
				Set SubID=0,(Diagnos,DiagList)="",EPDFlag=0
				For{
					Set SubID=$o(^MR(MRAdm,"DIA",SubID))
					Quit:SubID=""
					Continue:$d(^MR(MRAdm,"DIA",SubID))="10"
					Set DiagDesc="",DiagDHC="",DiagPrefix="",ICD =""
					Set DiagID=$p($g(^MR(MRAdm,"DIA",SubID)),"^",1)
					Set:DiagID'="" DiagDesc=$p($g(^MRC("ID",DiagID)),"^",2)
					Set:DiagID'="" ICD=$p($g(^MRC("ID",DiagID)),"^",4)			//ICD
					if ((aIsHaveDiag="1")&&(EPDFlag'=1)){   // 有传染病诊断后，不进if判断
						Set IsEPDDiag =  ##class(DHCMed.EPDService.SuspMRDiagnos).GetDiagCheck(ICD,DiagDesc)
						Set:IsEPDDiag'="" EPDFlag=1
					}
					Set DiagDHC=$p($g(^MR(MRAdm,"DIA",SubID,"DES",1)),"^",1)
					Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",SubID,1)),"^",26)    //诊断前缀 add 2020-09-17
					Set:DiagPrefix'="" DiagDesc=DiagPrefix_" "_DiagDesc
					Set:DiagDesc'="" Diagnos=Diagnos_"/"_DiagDesc
					Set:DiagDHC'="" Diagnos=Diagnos_"/"_DiagDHC			
				}
				Continue:((aIsHaveDiag="1")&&(EPDFlag=0))
				Set DiagList=Diagnos
				
				//是否初复诊
				Set AdmReAdm=0,AdmFirAdm=1
				Set AdmReAdm=$p(AdmInfo,"^",56)
				Set:AdmReAdm="R" AdmFirAdm=0,AdmReAdm=1
				Set AdmFirAdm=$s(AdmFirAdm=1:"是",1:"否")
				Set AdmReAdm=$s(AdmReAdm=1:"是",1:"否")
				//就诊信息
				Set AdmDocDr=$p(AdmInfo,"^",9)
				Set AdmDoc=""
				If (AdmDocDr'=""){
					Set AdmDocID=$o(^SSU("SSUSR",0,"CTPCP",AdmDocDr,""))
					Set:AdmDocID'="" AdmDoc=$p(^SSU("SSUSR",AdmDocID),"^",2)
				}
				Set AdmDate=$p(AdmInfo,"^",6)
				Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
				Set AdmLocID=$p(AdmInfo,"^",4)
				Continue:((aLoc'="")&&($LF($LFS(aLoc,","),AdmLocID)=0))
				Set HospID=$p(^CTLOC(AdmLocID),"^",22)
				//Continue:(aHospIDs'="")&(aHospIDs'[HospID)
				Continue:((aHospIDs'="")&&($LF($LFS(aHospIDs,","),HospID)=0))
				Set AdmLoc=$p(^CTLOC(AdmLocID),"^",2)
				Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
				//患者基本信息
				Set PatientID=$p(AdmInfo,"^",1)
				Set objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Set PatName=objPat.PatientName
				Set PapmiNo=objPat.PapmiNo
				Set InMrNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"I","","")
				Set OutMrNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"O","","")
				Continue:(aName'="")&(PatName'[aName)		
				Continue:(aPapmi'="")&(aPapmi'=PapmiNo)
				Continue:(aMrNo'="")&((aMrNo'=InMrNo)&&(aMrNo'=OutMrNo))
				Set MrNo=$s(aMrNo'="":aMrNo,OutMrNo'="":OutMrNo,1:InMrNo)
				Set Sex=objPat.Sex
				Set AgeYear=objPat.Age
				Set:+AgeYear>0 AgeYear=AgeYear_"岁"
				Set AgeMonth=objPat.AgeMonth
				Set:+AgeMonth>0 AgeMonth=AgeMonth_"月"
				Set AgeDay=objPat.AgeDay
				Set:+AgeDay>0 AgeDay=AgeDay_"天"
				If (AgeYear>0)&(AgeMonth'=0){
					Set Age=AgeYear_AgeMonth
				}elseIf (AgeMonth>0)&(AgeDay'=0){
					Set Age=AgeMonth_AgeDay
				}else{
					Set Age=AgeYear
				}
				Set PersonID=objPat.PersonalID
				Set Tel=objPat.Telephone
				Set Address=objPat.Address
				
				Set OtherDiagList=""
				Set:DiagList'="" DiagList=$e(DiagList,2,$l(DiagList))
				Continue:(aDiagnos'="")&(DiagList'[aDiagnos)
				Set TempDiagList = DiagList
				if ($l(TempDiagList)>100){
					Set DiagList = $e(TempDiagList,1,100)
					Set OtherDiagList = $e(TempDiagList,101,$l(TempDiagList))
				}
				//本地或者外地
				Set LocalFlagDr=""
				Set LocalFlagDesc="本市"
				Set DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PatientID,""))
				//"&"改成"&&"，否则DHCPersonDr为空时报错
				Set:(DHCPersonDr'="")&&($d(^DHCPERSON(DHCPersonDr))) LocalFlagDr=$p(^DHCPERSON(DHCPersonDr),"^",12)
				Set:LocalFlagDr=2 LocalFlagDesc="外埠"
				//是否上报传染病、传染病信息
				Set IsRep="N"
				Set EpdInfo=..IsReported(xEpisodeID)
				Set:EpdInfo'="" IsRep="Y"
				Set IsRep=$s(IsRep="Y":"是",1:"否")
				Set EpdCount=$l(EpdInfo,"^")
				Set RepInfo="",EpdList=""
				For EpdInd=1:1:EpdCount{
					Set RepID=$p(EpdInfo,"^",EpdInd)
					Continue:RepID=""
					Set EPDInfo=$g(^DHCMed.EPD("EPD",RepID))
					Continue:EPDInfo=""
					Set:Address="" Address=$p(EPDInfo,"^",26)
					Set Disease=""
					Set MEPDICDDR=$p(EPDInfo,"^",5)
					If (MEPDICDDR'="") {
						Set Infection=$g(^DHCMed.EPDC("IF",MEPDICDDR))
						Set:Infection'="" Disease=$p(Infection,"^",2)
					}
					Set RepDate=$p(EPDInfo,"^",17)
					Set SickDate=$p(EPDInfo,"^",8)
					if (SickDate=""){
						Set RepInfo="诊断："_Disease_" 报告日期："_$zd(RepDate,3)
					}else{
						Set RepInfo="诊断："_Disease_" 发病日期："_$zd(SickDate,3)_" 报告日期："_$zd(RepDate,3)
					}
					Set EpdList=EpdList_"^"_RepInfo
				}
				Set:EpdList'="" EpdList=$e(EpdList,2,$l(EpdList))
			
				Set Data=$lb(ind,xEpisodeID,PapmiNo,PatName,Sex,Age,Address,PersonID,Tel,DiagList,AdmFirAdm,AdmReAdm,AdmDoc,AdmDate,AdmLoc,LocalFlagDesc,IsRep,EpdList,MrNo,OtherDiagList)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryOPLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPLogExecute ]
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

/// 返回值：如果未上报返回空字符串，否则返回已上报的ID列表，以"^"分割
ClassMethod IsReported(EpisodeID)
{
	New (EpisodeID)
	Set return=""
	Quit:(EpisodeID="") return
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objAdm) return
	Set PatientID=objAdm.PatientID
	Quit:PatientID="" return
	
	Set RowID=""
	Set ret=""
	Set InfectionID=""
	For{
		Set InfectionID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionID))
		Quit:InfectionID=""
		
		For {
			Set RowID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionID,RowID))
			Quit:RowID=""
			Set EPDInfo=$g(^DHCMed.EPD("EPD",RowID))
			Continue:EPDInfo=""
			Set EPDStatus=$p(EPDInfo,"^",15)
			Continue:(EPDStatus'=2)&&(EPDStatus'=1)&&(EPDStatus'=3) //必须是 "待审"“已审”"订正""外院已报" 状态
			Set:return'="" return=return_"^"
			Set return=return_RowID
		}
	}
	Quit return
}

}
