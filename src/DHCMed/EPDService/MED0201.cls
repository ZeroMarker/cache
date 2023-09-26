/// 名称: DHCMed.EPDService.MED0201
/// 描述: 传染病住院日志
/// 编写者：liuzhenhe
/// 编写日期: 2020-05-12
Class DHCMed.EPDService.MED0201 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2020-05-12
/// Description:  传染病住院日志: 按照出院日期过滤
/// Table：       User.PAAdm 、 User.PAPatMas 、 DHCMed.EPD.Epidemic
/// Input：       aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLoc：	 科室ID  
/// Return： 
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.MED0201","QryIPLog","2,3","2018-10-12","2019-10-12","","")
Query QryIPLog(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLoc As %String, aDiagnos As %String = "") As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PatName:%String,Sex:%String,Age:%String,Nation:%String,Education:%String,Occupation:%String,Marital:%String,Address:%String,PersonalID:%String,Telephone:%String,AdmDate:%String,AdmLoc:%String,LocalFlagDesc:%String,IsFirAdm,SickDate:%String,IsRep:%String,DiagDate:%String,DiagICD1:%String,Diag1:%String,DiagICD2:%String,Diag2:%String,DiagICD3:%String,Diag3:%String,Dishdate:%String,CateFees:%String,AdmDoc:%String,PapmiNo:%String,MrNo:%String") [ SqlProc ]
{
}

ClassMethod QryIPLogExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLoc As %String, aDiagnos As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^PAADMi("DischDate",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAADMi("DischDate",xDate,xEpisodeID))
			Quit:xEpisodeID=""
			
			Do BuildRowData(xEpisodeID)
		}
	}
	
	Quit $$$OK
	
BuildRowData(EpisodeID)
	Set AdmInfo=$g(^PAADM(EpisodeID))

	Set Status=$p(AdmInfo,"^",20)
	Quit:Status'="D"                   	//A正常C取消D出院
	Quit:$p(AdmInfo,"^",2)'="I"
	               
	Set AdmLocID=$p(AdmInfo,"^",4)
	Quit:(aLoc'="")&(","_aLoc_","'[AdmLocID)
	Set HospID=$p(^CTLOC(AdmLocID),"^",22)
	Quit:(aHospIDs'="")&(aHospIDs'[HospID)
	
	//患者基本信息
	Set PatientID=$p(AdmInfo,"^",1)
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Set PatName=objPat.PatientName
	Set PapmiNo=objPat.PapmiNo
	Set MrNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"I","","")

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

 	Set Nation=objPat.Nation          						//民族
	Set Education=objPat.Education   						//文化程度              			

    Set (OccupationData,Occupation) = ""
    Set PatCareerRowID = $p($g(^PAPER(PatientID,"PER",2)),"^",6)
    Set:PatCareerRowID'="" OccupationData = $g(^CT("OCC",PatCareerRowID))
    Set:OccupationData'="" Occupation = $p(OccupationData,"^",2)   //借助病人号获取职业
    
	Set Marital=objPat.Marital       						//婚姻状况
	Set Address=objPat.Address                              //详细住址
	Set PersonalID=objPat.PersonalID   						//身份证号
	Set Telephone=objPat.Telephone           				//联系电话

	Set AdmDate=$p(AdmInfo,"^",6) 
	Set:AdmDate'="" AdmDate=$zd(AdmDate,3)  	            //入院日期
	Set Admtime=$p($g(^PAADM(EpisodeID,"DHC")),"^",32)   	//入院时间    
	
	Set AdmLoc=$p(^CTLOC(AdmLocID),"^",2)
	Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)                           //就诊科室
	//本地或者外地
	Set LocalFlagDr=""
	Set LocalFlagDesc="本市"
	Set DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PatientID,""))
	//"&"改成"&&"，否则DHCPersonDr为空时报错
	Set:(DHCPersonDr'="")&&($d(^DHCPERSON(DHCPersonDr))) LocalFlagDr=$p(^DHCPERSON(DHCPersonDr),"^",12)
	Set:LocalFlagDr=2 LocalFlagDesc="外埠"
	Set:LocalFlagDr="" LocalFlagDesc=""
	//是否初复诊
	Set AdmReAdm=$p(AdmInfo,"^",56)        	//Admission,Readmission
	Set IsFirAdm=""
	Set:AdmReAdm="A" IsFirAdm="初诊"
	Set:AdmReAdm="R" IsFirAdm="复诊"
	Set Dishdate=$p($g(^PAADM(EpisodeID,"DHC")),"^",29)   
	Set:Dishdate'="" Dishdate=$zd(Dishdate,3)				//出院日期
	Set Dishtime=$p($g(^PAADM(EpisodeID,"DHC")),"^",30)		//出院时间

	//是否上报传染病
	Set IsRep="N"
	Set EpdInfo=..IsReported(EpisodeID)
	Set:EpdInfo'="" IsRep="Y"
	Set IsRep=$s(IsRep="Y":"是",1:"否")
	Set EpdCount=$l(EpdInfo,"^")
	Set SickDate="",DiagDate=""             				 //取本次就诊传染病最早发病日期，诊断日期
	For EpdInd=1:1:EpdCount{
		Set RepID=$p(EpdInfo,"^",EpdInd)
		Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
		Continue:'$IsObject(objRep)
		
		Set MEPDSickDate=objRep.MEPDSickDate
		Set MEPDDiagDate=objRep.MEPDDiagDate
		Set SickDate=$Select(SickDate="":objRep.MEPDSickDate,+SickDate>+(MEPDSickDate):MEPDSickDate,1:SickDate)
		Set DiagDate=$Select(DiagDate="":objRep.MEPDDiagDate,+DiagDate>+(MEPDDiagDate):MEPDDiagDate,1:DiagDate)
	}
	Set:SickDate'="" SickDate=$zd(SickDate,3)	
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)	
	//获取出院诊断		
	Set OutDiaType=$O(^MRC("DTYP",0,"Code","DIS",0))       // DIS:出院诊断
	Set MRAdmId=$p(AdmInfo,"^",61) 
	Set MRDiaSub=0,strDiagnos=""
	For {
	  	Set MRDiaSub=$O(^MR(MRAdmId,"DIA",MRDiaSub)) 
	  	Quit:MRDiaSub=""  
		Set MRDiaICDDR=$p($G(^MR(MRAdmId,"DIA",MRDiaSub)),"^",1)
		continue:MRDiaICDDR=""
		Set MRCDiagType=$p($g(^MR(MRAdmId,"DIA",MRDiaSub,"TYP",1)),"^",1)
		continue:MRCDiagType'=OutDiaType
		Set ICD=$p($G(^MRC("ID",MRDiaICDDR)),"^",1)
		Set ICDDesc=$p($G(^MRC("ID",MRDiaICDDR)),"^",2)
		Set strDiagnos=strDiagnos_","_ICDDesc_"||"_ICD
	}
	Set:strDiagnos'="" strDiagnos=$e(strDiagnos,2,*)
	Quit:(aDiagnos'="")&(strDiagnos'[aDiagnos)
	Set (Diag1,DiagICD1,Diag2,DiagICD2,Diag3,DiagICD3)=""
	If (strDiagnos'=""){
		Set Diagnos1=$p(strDiagnos,",",1)                        //出院诊断1
		Set Diag1=$p(Diagnos1,"||",1)
		Set DiagICD1=$p(Diagnos1,"||",2)
		
		Set Diagnos2=$p(strDiagnos,",",2)                        //出院诊断2
		Set Diag2=$p(Diagnos2,"||",1)
		Set DiagICD2=$p(Diagnos2,"||",2)
		
		Set Diagnos3=$p(strDiagnos,",",3)						//出院诊断3
		Set Diag3=$p(Diagnos3,"||",1)
		Set DiagICD3=$p(Diagnos3,"||",2)
	}
	Set CateFees=..GetAdmCateFees(EpisodeID)       				//住院总费用	
	Set AdmDocDr=$p(AdmInfo,"^",9)
	Set AdmDoc=""
	If (AdmDocDr'=""){
		Set AdmDocID=$o(^SSU("SSUSR",0,"CTPCP",AdmDocDr,""))
		Set:AdmDocID'="" AdmDoc=$p(^SSU("SSUSR",AdmDocID),"^",2)   // 管床医生
	}
	Set Data=$lb(ind,EpisodeID,PatName,Sex,Age,Nation,Education,Occupation,Marital,Address,PersonalID,Telephone,AdmDate,AdmLoc,LocalFlagDesc,IsFirAdm,SickDate,IsRep,DiagDate,DiagICD1,Diag1,DiagICD2,Diag2,DiagICD3,Diag3,Dishdate,CateFees,AdmDoc,PapmiNo,MrNo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryIPLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIPLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIPLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIPLogExecute ]
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
			Set objEpd=##class(DHCMed.EPD.Epidemic).GetObjById(RowID)
			Continue:$IsObject(objEpd)=0
			Do objEpd.%Close()
			Continue:(objEpd.MEPDStatus'=2)&&(objEpd.MEPDStatus'=1)&&(objEpd.MEPDStatus'=3)&&(objEpd.MEPDStatus'=8) //必须是 "待审"“已审”"订正""外院已报" 状态
			Set:return'="" return=return_"^"
			Set return=return_RowID
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-09-27
/// Description:  From计费组接口
///               根据就诊号取本次住院相关费用
/// Table：       
/// Input：       argEpisodeID:    User.PAADM
/// Return：      return=住院总费用
/// w ##class(DHCMed.EPDService.MED0201).GetAdmCateFees(13479887)
ClassMethod GetAdmCateFees(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=""
	Quit:argEpisodeID="" return
	
	Set $ZT="GetAdmCateFeesErr"	
	//取东华HIS费用数据                  ##Class(web.UDHCJFBaseCommon).GetAdmDepositAndFee(574)
	Set strCateFee=##Class(web.UDHCJFBaseCommon).GetAdmCateFee(argEpisodeID)
	Set CountCost=0
	For Index=1:1:$l(strCateFee,"&")
	{
		Set Fee=$p(strCateFee,"&",Index)
		Set CountCost=CountCost+$p(Fee,"^",2)
	}
	Set:CountCost'=0 return=CountCost
	Quit return
	
GetAdmCateFeesErr
	Quit return
}

}
