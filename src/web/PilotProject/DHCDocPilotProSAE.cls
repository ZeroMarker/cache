Import SQLUser

Class web.PilotProject.DHCDocPilotProSAE Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod AddSAE(PPRowId As %String, PPSAERowId As %String, PPSAEDocumentRegNo As %String, PPSAEPatNameab As %String, PPSAEReportTypeDr As %String, PPSAEDate As %String, PPSAEICDCode As %String, PPSAESituationDr As %String, PPSAERelateDr As %String, PPSAEStepDr As %String, PPSAELapseDr As %String, DeathDate As %String, Remark As %String = "") As %String
{
    ;w ##class(web.PilotProject.DHCDocPilotProSAE).AddSAE(28,1534,"zzy",62949,"",1,2,2,1,2,"备注")
	q:(PPRowId=""&&PPSAERowId="") ""
	s myrtn=0
	s:PPSAEDate'="" PPSAEDate=$zdh(PPSAEDate,4)
	s:DeathDate'="" DeathDate=$zdh(DeathDate,4)
	TS
	if PPSAERowId=""{
	&sql(insert into DHC_DocPilotProSAE (PPSAE_PP_ParRef,PPSAE_DocumentRegNo,PPSAE_PatNameab,PPSAE_Date,PPSAE_ICDCode,PPSAE_Situation_Dr,PPSAE_Relate_Dr,PPSAE_Step_Dr,PPSAE_Lapse_Dr,PPSAE_ReportType_Dr,PPSAE_DeathDate,PPSAE_Remark)values(:PPRowId,:PPSAEDocumentRegNo,:PPSAEPatNameab,:PPSAEDate,:PPSAEICDCode,:PPSAESituationDr,:PPSAERelateDr,:PPSAEStepDr,:PPSAELapseDr,:PPSAEReportTypeDr,:DeathDate,:Remark))
  s myrtn=SQLCODE
  if myrtn=0{
	 s SAECaseNum=$p($g(^DHCDocPP(PPRowId)),"^",65)
	 if (SAECaseNum="") s SAECaseNum=0
	 s SAECaseNum=SAECaseNum+1
	  &sql(Update dhc_docpilotproject set PP_SAECaseNum=:SAECaseNum where PP_RowId=:PPRowId)
	   s myrtn=SQLCODE
  }
  } else{
	  &sql(update DHC_DocPilotProSAE set PPSAE_DocumentRegNo=:PPSAEDocumentRegNo,PPSAE_PatNameab=:PPSAEPatNameab,PPSAE_Date=:PPSAEDate,PPSAE_ICDCode=:PPSAEICDCode,PPSAE_Situation_Dr=:PPSAESituationDr,PPSAE_Relate_Dr=:PPSAERelateDr,PPSAE_Step_Dr=:PPSAEStepDr,PPSAE_Lapse_Dr=:PPSAELapseDr,PPSAE_ReportType_Dr=:PPSAEReportTypeDr,PPSAE_DeathDate=:DeathDate,PPSAE_Remark=:Remark where PPSAE_RowId=:PPSAERowId)
  s myrtn=SQLCODE
	  
  }
  if +myrtn=0{
		TC
	}else{
		TRO
	}
   q myrtn
}

ClassMethod DeleteSAE(PPSAERowId As %String) As %String
{
    ;w ##class(web.PilotProject.DHCDocPilotProSAE).PPSAERowId("28||1")
	q:PPSAERowId="" ""
	&sql(delete from  DHC_DocPilotProSAE where PPSAE_RowId=:PPSAERowId)
   q SQLCODE
}

ClassMethod FindProSAEClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProSAEExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindProSAEExecute(ByRef QHandle As %Binary, PPRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProSAE","FindProSAE")
	Set repid=$I(^CacheTemp)
	s ind=1
	i PPRowId="" Set QHandle=$lb(0,repid,0)  Quit $$$OK
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	s childsub=0
	f  s childsub=$o(^DHCDocPPSAE(PPRowId,childsub)) q:childsub=""  d
	.s PPSAEICDCode="",PPSAESituation="",PPSAERelate="",PPSAEStep="",PPSAELapse="",PPSAEReportType=""
	.s PPSAEDocumentRegNo=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",1)
	.s PPSAEPatNameab=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",2)
	.s PPSAEDate=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",3)
	.s:PPSAEDate'="" PPSAEDate=$zd(PPSAEDate,4)
	.s PPSAEICDCode=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",4)
	.s PPSAESituationDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",5)
	.s:PPSAESituationDr'="" PPSAESituation=$p($g(^DHCDocCT("DefineData",+PPSAESituationDr,"D",$p(PPSAESituationDr,"||",2))),"^",2)
    .s PPSAERelateDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",6)
	.s:PPSAERelateDr'="" PPSAERelate=$p($g(^DHCDocCT("DefineData",+PPSAERelateDr,"D",$p(PPSAERelateDr,"||",2))),"^",2)
	.s PPSAEStepDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",7)
	.s:PPSAEStepDr'="" PPSAEStep=$p($g(^DHCDocCT("DefineData",+PPSAEStepDr,"D",$p(PPSAEStepDr,"||",2))),"^",2)
	.s PPSAELapseDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",8)
	.s:PPSAELapseDr'="" PPSAELapse=$p($g(^DHCDocCT("DefineData",+PPSAELapseDr,"D",$p(PPSAELapseDr,"||",2))),"^",2)
    .s PPSAEReportTypeDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",9)
	.s:PPSAEReportTypeDr'="" PPSAEReportType=$p($g(^DHCDocCT("DefineData",+PPSAEReportTypeDr,"D",$p(PPSAEReportTypeDr,"||",2))),"^",2)
	.s PPSAERowId=PPRowId_"||"_childsub
	.Do OutputRow6
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(PPSAERowId,PPSAEDocumentRegNo,PPSAEPatNameab,PPSAEDate,PPSAEICDCode,PPSAESituation,PPSAERelate,PPSAEStep,PPSAELapse,PPSAEReportType)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindProSAEFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProSAEExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProSAE","FindProSAE","29")

Query FindProSAE(PPRowId As %String) As %Query(ROWSPEC = "PPSAERowId,PPSAEDocumentRegNo:%String,PPSAEPatNameab:%String,PPSAEDate:%String,PPSAEICDCode:%String,PPSAESituation:%String,PPSAERelate:%String,PPSAEStep:%String,PPSAELapse:%String,PPSAEReportType:%String") [ SqlProc ]
{
}

//得到SAE信息

//d ##class(web.PilotProject.DHCDocPilotProSAE).GetSAEInfoByRowId("36||2")

ClassMethod GetSAEInfoByRowId(PPSAERowId)
{
	q:PPSAERowId="" ""
	s PPRowId=+PPSAERowId
	s childsub=$p(PPSAERowId,"||",2)
	s PPSAEICDCode="",PPSAESituation="",PPSAERelate="",PPSAEStep="",PPSAELapse="",PPSAEReportType=""
	s PPSAEDocumentRegNo=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",1)
	s PPSAEPatNameab=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",2)
	s PPSAEDate=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",3)
	s PPSAEDate1=""
	s:PPSAEDate'="" PPSAEDate1=$zd(PPSAEDate,4)
	i PPSAEDate1'=""{
		s y=$p(PPSAEDate1,"/",3)
		s m=$p(PPSAEDate1,"/",2)
		S d=$p(PPSAEDate1,"/",1)
		s PPSAEDate=y_"年"_m_"月"_d_"日"
	}
	s PPSAEICDCode=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",4)
	s PPSAESituationDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",5)
	s:PPSAESituationDr'="" PPSAESituation=$p($g(^DHCDocCT("DefineData",+PPSAESituationDr,"D",$p(PPSAESituationDr,"||",2))),"^",2)
    s PPSAERelateDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",6)
	s:PPSAERelateDr'="" PPSAERelate=$p($g(^DHCDocCT("DefineData",+PPSAERelateDr,"D",$p(PPSAERelateDr,"||",2))),"^",2)
	s PPSAEStepDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",7)
	s:PPSAEStepDr'="" PPSAEStep=$p($g(^DHCDocCT("DefineData",+PPSAEStepDr,"D",$p(PPSAEStepDr,"||",2))),"^",2)
	s PPSAELapseDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",8)
	s:PPSAELapseDr'="" PPSAELapse=$p($g(^DHCDocCT("DefineData",+PPSAELapseDr,"D",$p(PPSAELapseDr,"||",2))),"^",2)
    s PPSAEReportTypeDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",9)
	s:PPSAEReportTypeDr'="" PPSAEReportType=$p($g(^DHCDocCT("DefineData",+PPSAEReportTypeDr,"D",$p(PPSAEReportTypeDr,"||",2))),"^",2)
	s PPSAEDeathDate=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",10)
	s PPSAEDeathDate1=""
	s:PPSAEDeathDate'="" PPSAEDeathDate1=$zd(PPSAEDeathDate,4)
	i PPSAEDeathDate1'=""{
		s y=$p(PPSAEDeathDate1,"/",3)
		s m=$p(PPSAEDeathDate1,"/",2)
		S d=$p(PPSAEDeathDate1,"/",1)
		s PPSAEDeathDate=y_"年"_m_"月"_d_"日"
	}
	s ret=PPSAEDocumentRegNo_"^"_PPSAEPatNameab_"^"_PPSAEDate_"^"_PPSAEICDCode_"^"_PPSAESituation_"^"_PPSAERelate_"^"_PPSAEStep_"^"_PPSAELapse_"^"_PPSAEReportType_"^"_PPSAEDeathDate_"^"_PPSAEReportTypeDr_"^"_PPSAESituationDr_"^"_PPSAEDate1_"^"_PPSAEDeathDate1_"^"_PPSAERelateDr_"^"_PPSAEStepDr_"^"_PPSAELapseDr
	q ret
}

Query FindSAE(SttDate, EndDate) As %Query(ROWSPEC = "PPSAERowId,Job,ProDesc,ProPlanName,ProCreateDepartment,ProStartUser,PPSAEDocumentRegNo,PPSAEPatNameab,PPSAEDate,PPSAEICDCode,PPSAESituation,PPSAERelate,PPSAEStep,PPSAELapse,PPSAEReportType,ProCode,ArchivesFilesNo") [ SqlProc ]
{
}

ClassMethod FindSAEClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindSAEExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSAEFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSAEExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获得SAE详细信息
/// 入参：
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProSAE","FindSAE","01/01/2013","23/08/2013")
ClassMethod FindSAEExecute(ByRef QHandle As %Binary, SttDate, EndDate) As %Status
{
	//w ##class(web.PilotProject.DHCDocPilotProSAE).FindSAEExecute("30/1/2014","30/12/2014") 
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^zzy("FindSAE")=SttDate_"^"_EndDate
	
	s USERID=%session.Get("LOGON.USERID")
	k ^TMPDHCDocSAEReport(USERID)
	s Job=$j
     if SttDate="" s FindSAE=+$h
     e  i $l(SttDate,"/")=3  s SttDate=$zdh(SttDate,4)
     if EndDate="" s EndDate=+$h
      e  i $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,4)
      if SttDate>EndDate d
      .s mDate=SttDate
      .s SttDate=EndDate
      .s EndDate=mDate
      s i=0
      f date=SttDate:1:EndDate d
      .s PPRowId=0
      .f  s PPRowId=$o(^DHCDocPPSAE("Date",0,date,PPRowId)) q:PPRowId=""  d
      ..s childsub=""
      ..s ProDesc=$P(^DHCDocPP(PPRowId),"^",2)
      ..s ProCode=$P(^DHCDocPP(PPRowId),"^",1)
      ..s ProPlanName=$p($g(^DHCDocPP(PPRowId)),"^",27)
      ..;s ArchivesFilesNo=$p($g(^DHCDocPP(PPRowId)),"^",34)
      ..s ArchivesFilesNo=$p(^DHCDocPP(PPRowId),"^",34)
      ..S ProCreateDepartment=""
	  ..s ProCreateDepartmenDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	  ..if ProCreateDepartmenDr'="" s ProCreateDepartment=$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	  ..i ProCreateDepartment["免疫" s ProCreateDepartment="风湿免疫科"
	  ..s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	  ..S ProStartUser=""
	  ..if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	  ..s child=0
	  ..f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	  ...s User=""
	  ...s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	  ...s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	  ...s Dep=""
	  ...if DepDr'="" s Dep=$p($P(^CTLOC(DepDr),"^",2),"-",2)
	  ...i Dep["免疫" s Dep="风湿免疫科"
	  ...s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	  ...s:User'="" ProStartUser=ProStartUser_","_User
	  ...s:Dep'="" ProCreateDepartment=ProCreateDepartment_","_Dep
      ..f  s childsub=$o(^DHCDocPPSAE("Date",0,date,PPRowId,childsub)) q:childsub=""  d
      ...s PPSAEICDCode="",PPSAESituation="",PPSAERelate="",PPSAEStep="",PPSAELapse="",PPSAEReportType=""
	  ...s PPSAEDocumentRegNo=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",1)
	  ...s PPSAEPatNameab=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",2)
	  ...s PPSAEDate=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",3)
	  ...s:PPSAEDate'="" PPSAEDate=$tr($zd(PPSAEDate,3),"-","/")
	  ...s PPSAEICDCode=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",4)
	  ...s PPSAESituationDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",5)
	  ...s:PPSAESituationDr'="" PPSAESituation=$p($g(^DHCDocCT("DefineData",+PPSAESituationDr,"D",$p(PPSAESituationDr,"||",2))),"^",2)
      ...s PPSAERelateDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",6)
	  ...s:PPSAERelateDr'="" PPSAERelate=$p($g(^DHCDocCT("DefineData",+PPSAERelateDr,"D",$p(PPSAERelateDr,"||",2))),"^",2)
	  ...s PPSAEStepDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",7)
	  ...s:PPSAEStepDr'="" PPSAEStep=$p($g(^DHCDocCT("DefineData",+PPSAEStepDr,"D",$p(PPSAEStepDr,"||",2))),"^",2)
	  ...s PPSAELapseDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",8)
	  ...s:PPSAELapseDr'="" PPSAELapse=$p($g(^DHCDocCT("DefineData",+PPSAELapseDr,"D",$p(PPSAELapseDr,"||",2))),"^",2)
      ...s PPSAEReportTypeDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",9)
	  ...s:PPSAEReportTypeDr'="" PPSAEReportType=$p($g(^DHCDocCT("DefineData",+PPSAEReportTypeDr,"D",$p(PPSAEReportTypeDr,"||",2))),"^",2)
	  ...q:PPSAEReportType'="首次报告"
	  ...s PPSAERowId=PPRowId_"||"_childsub
	  ...s i=i+1
	  ...s ^TMPDHCDocSAEReport(USERID,Job)=i
	  ...s ^TMPDHCDocSAEReport(USERID,Job,i)=ProDesc_"^"_ProPlanName_"^"_ProCreateDepartment_"^"_ProStartUser_"^"_PPSAEDocumentRegNo_"^"_PPSAEPatNameab_"^"_PPSAEDate_"^"_PPSAEICDCode_"^"_PPSAESituation_"^"_PPSAERelate_"^"_PPSAEStep_"^"_PPSAELapse_"^"_PPSAEReportType_"^"_ProCode_"^"_ArchivesFilesNo
	...Do OutputRow7
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(PPSAERowId,Job,ProDesc,ProPlanName,ProCreateDepartment,ProStartUser,PPSAEDocumentRegNo,PPSAEPatNameab,PPSAEDate,PPSAEICDCode,PPSAESituation,PPSAERelate,PPSAEStep,PPSAELapse,PPSAEReportType,ProCode,ArchivesFilesNo)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod GetSAENum(ProcessNo As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	s num=^TMPDHCDocSAEReport(USERID,ProcessNo)
	q num
}

ClassMethod GetSAE(ProcessNo As %String, Num As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q $g(^TMPDHCDocSAEReport(USERID,ProcessNo,Num))
}

}
