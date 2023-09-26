Import SQLUser

Class web.PilotProject.UDHCDocPilotProECApprove Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod UpdateEMDate(PPRowId As %String, EMDate As %String) As %String
{
	q:PPRowId="" ""
	q:EMDate="" ""
	s EMDate=$zdh(EMDate,4)
	s NowDate=+$h
	s rowid=""
	s myrtn=0
	s EthicsMeetDate=$p($g(^DHCDocPP(PPRowId)),"^",32)
	TS
	if EthicsMeetDate=""{
	&sql(update DHC_DocPilotProject set PP_EthicsMeetDate=:EMDate where PP_RowId=:PPRowId) 
	s myrtn=SQLCODE
	}
	if +myrtn=0{
	s InstrucNo=..GetInstrucNo("C")
	&sql(insert into DHC_DocPilotProECRecord (PPE_PProject_Dr,PPE_EthicsMeetDate,PPE_CreateDate,PPE_InstrucNo,PPE_Type)values (:PPRowId,:EMDate,:NowDate,:InstrucNo,"C")) 
	s rowid=%ROWID
	}
	s myrtn=SQLCODE
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn_"^"_%ROWID
}

ClassMethod CreateKSPJ(PPRowId As %String, EMADate As %String) As %String
{
	q:PPRowId="" ""
	s NowDate=+$h
	s EthicsMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	;q:((EthicsMeetAduitDate="")&&(EMADate="")) "-301"
	s:EMADate'="" EMADate=$zdh(EMADate,4)
	i EMADate="" s EMADate=NowDate
	TS
	s InstrucNo=..GetInstrucNo("F")
	&sql(insert into DHC_DocPilotProECRecord (PPE_PProject_Dr,PPE_CreateDate,PPE_InstrucNo,PPE_Type)values (:PPRowId,:NowDate,:InstrucNo,"F")) 
	s myrtn=SQLCODE
	if +myrtn=0{
		if EthicsMeetAduitDate=""{
		 ;&sql(update DHC_DocPilotProject set PP_EthicsMeetAduitDate=:EMADate where PP_RowId=:PPRowId) 
		 ;s myrtn=SQLCODE
		}
	}
	if +myrtn=0{
					;插入子表状态
					s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
					s ProjectStateObj.PPSPPParRef=PPRowId
					s ProjectStateObj.PPSCurState="I"
					s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
					s ProjectStateObj.PPSUpdateDate=+$H
					s ProjectStateObj.PPSUpdateTime=$p($h,",",2)
					s ProjectStateObj.PPSUpdateReason="伦理委员会审查通过"
					s myrtn=##class(web.PilotProject.DHCDocPilotProject).InsertProjectState(ProjectStateObj)
				}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

ClassMethod CreateBCPJ(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s NowDate=+$H
	TS
	s InstrucNo=..GetInstrucNo("A")
	&sql(insert into DHC_DocPilotProECRecord (PPE_PProject_Dr,PPE_CreateDate,PPE_InstrucNo,PPE_Type)values (:PPRowId,:NowDate,:InstrucNo,"A")) 
	s myrtn=SQLCODE
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

ClassMethod GetEMDate(PPRowId As %String) As %String
{
	q:PPRowId="" "" 
	s EMDate=$p($g(^DHCDocPP(PPRowId)),"^",32)
	s:EMDate'="" EMDate=$zd(EMDate,4)
	q EMDate
}

ClassMethod GetEMADate(PPRowId As %String) As %String
{
	q:PPRowId="" "" 
	s EMDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	s:EMDate'="" EMDate=$zd(EMDate,4)
	q EMDate
}

ClassMethod InsertEcRecord(PPRowId As %String, PPERowId As %String, PRResultDr As %String, CheckFreqDr As %String, Attendance As %String, UndecideNum As %String, MainAppraisal As %String, DesignAppraisal As %String, FormAppraisal As %String, ComPenAppraisal As %String, OtherRemark As %String, Attachment As %String, AvoidNum As %String, OtherPara As %String) As %String
{
	s ^zzy("InsertEcRecord")=PPRowId_"^"_PPERowId_"^"_PRResultDr_"^"_CheckFreqDr_"^"_Attendance_"^"_UndecideNum_"^"_MainAppraisal_"^"_DesignAppraisal_"^"_FormAppraisal_"^"_ComPenAppraisal_"^"_OtherRemark_"^"_Attachment_"^"_AvoidNum_"^"_OtherPara
	q:PPERowId="" ""
	q:PPRowId="" ""
	s Result=""
	s EMDate=$p($g(^DHCDocPP(PPRowId)),"^",32)
	s EthicsMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	s myrtn=""
	s TaskFrom=$p(OtherPara,"^",1)
	s DrugPJNo=$p(OtherPara,"^",2)
	s PlanVersion=$p(OtherPara,"^",3)
	s PlanVersionDate=$p(OtherPara,"^",4)
	s:PlanVersionDate'="" PlanVersionDate=$zdh(PlanVersionDate,4)
	s FormVersion=$p(OtherPara,"^",5)
	s FormVersionDate=$p(OtherPara,"^",6)
	s:FormVersionDate'="" FormVersionDate=$zdh(FormVersionDate,4)
	s AgreeNum=$p(OtherPara,"^",7)
	s ZBYXZHTY=$p(OtherPara,"^",8)
	s BBYXZHCS=$p(OtherPara,"^",9)
	s UAgreeNum=$p(OtherPara,"^",10)
	s ZZHZT=$p(OtherPara,"^",11)
	s RecordName=$p(OtherPara,"^",12)
	s WyName=$p(OtherPara,"^",13)
	
	s:PRResultDr'="" Result=$p($g(^DHCDocCT("DefineData",+PRResultDr,"D",$p(PRResultDr,"||",2))),"^",2)
	TS
	
	
	&sql(update DHC_DocPilotProECRecord set PPE_Result_Dr=:PRResultDr,PPE_CheckFreq_Dr=:CheckFreqDr,PPE_Attendance=:Attendance,PPE_UndecideNum=:UndecideNum,PPE_MainAppraisal=:MainAppraisal,PPE_DesignAppraisal=:DesignAppraisal,PPE_FormAppraisal=:FormAppraisal,PPE_ComPenAppraisal=:ComPenAppraisal,PPE_OtherRemark=:OtherRemark,PPE_Attachment=:Attachment,PPE_AvoidNum=:AvoidNum,PPE_TaskFrom=:TaskFrom,PPE_DrugPJNo=:DrugPJNo,PPE_PlanVersion=:PlanVersion,PPE_PlanVersionDate=:PlanVersionDate,PPE_FormVersion=:FormVersion,PPE_FormVersionDate=:FormVersionDate,PPE_AgreeNum=:AgreeNum,PPE_ZBYXZHTY=:ZBYXZHTY,PPE_BBYXZHCS=:BBYXZHCS,PPE_UAgreeNum=:UAgreeNum,PPE_ZZHZT=:ZZHZT,PPE_RecordName=:RecordName,PPE_WyName=:WyName where PPE_RowId=:PPERowId )
	s myrtn=SQLCODE
	if +myrtn=0{
		&sql(update DHC_DocPilotProject set PP_EcResultDr_Dr=:PRResultDr,PP_CheckFreq_Dr=:CheckFreqDr where PP_RowId=:PPRowId) 
		s myrtn=SQLCODE
	}
	if Result'="同意" s EMDate=""
	if +myrtn=0{
		if Result="同意"{
			if EthicsMeetAduitDate=""{
			&sql(update DHC_DocPilotProject set PP_EthicsMeetAduitDate=:EMDate where PP_RowId=:PPRowId) 
			s myrtn=SQLCODE
			}
			if +myrtn=0{
					;插入子表状态
					s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
					s ProjectStateObj.PPSPPParRef=PPRowId
					s ProjectStateObj.PPSCurState="I"
					s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
					s ProjectStateObj.PPSUpdateDate=+$H
					s ProjectStateObj.PPSUpdateTime=$p($h,",",2)
					s ProjectStateObj.PPSUpdateReason="伦理委员会审查通过"
					s myrtn=##class(web.PilotProject.DHCDocPilotProject).InsertProjectState(ProjectStateObj)
				}
			if +myrtn=0{
			;if ($p($g(^DHCDocPP(PPRowId)),"^",34)=""){
				;s ArchivesFilesNo=..GetMaxArchivesFilesNo()
				;&sql(update DHC_DocPilotProject set PP_ArchivesFilesNo=:ArchivesFilesNo where PP_RowId=:PPRowId) 
				;s myrtn=SQLCODE	
				;}
			}
		}elseif Result="不同意"{
				&sql(update DHC_DocPilotProject set PP_State="U" where PP_RowId=:PPRowId) 
				s myrtn=SQLCODE
				if +myrtn=0{
					;插入子表状态
					s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
					s ProjectStateObj.PPSPPParRef=PPRowId
					s ProjectStateObj.PPSCurState="U"
					s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
					s ProjectStateObj.PPSUpdateDate=+$H
					s ProjectStateObj.PPSUpdateTime=$p($h,",",2)
					s ProjectStateObj.PPSUpdateReason="伦理委员会审查不通过"
					s myrtn=##class(web.PilotProject.DHCDocPilotProject).InsertProjectState(ProjectStateObj)
				}
			}	
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q myrtn
}

//录入快审批件内容

ClassMethod UpdateFastPJ(PPRowId As %String, PPERowId As %String, PRResultDr As %String, CheckFreqDr As %String, Attachment As %String, Date As %String, Hospital As %String, Opinion As %String, PJNo As %String, DrugPJNo As %String) As %String
{
	s ^zzy("UpdateFastPJ")=PPRowId_"^"_PPERowId
	q:PPERowId="" ""
	q:PPRowId="" ""
	s Result=""
	s EthicsMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	s EthicsMeetDate=$p($g(^DHCDocPP(PPRowId)),"^",32)
	s myrtn=""
	s:Date'="" Date=$zdh(Date,4)
	s:PRResultDr'="" Result=$p($g(^DHCDocCT("DefineData",+PRResultDr,"D",$p(PRResultDr,"||",2))),"^",2)
	TS
	&sql(update DHC_DocPilotProECRecord set PPE_Result_Dr=:PRResultDr,PPE_CheckFreq_Dr=:CheckFreqDr,PPE_Attachment=:Attachment,PPE_CheckDate=:Date,PPE_Hospital=:Hospital,PPE_Opinion=:Opinion,PPE_PJNo=:PJNo ,PPE_DrugPJNo=:DrugPJNo where PPE_RowId=:PPERowId )
	s myrtn=SQLCODE
	if +myrtn=0{
	    if ((Date'="")&&(EthicsMeetDate="")){
			&sql(update DHC_DocPilotProject set PP_EthicsMeetDate=:Date where PP_RowId=:PPRowId) 
			s myrtn=SQLCODE
			}
	}
	if +myrtn=0{
		&sql(update DHC_DocPilotProject set PP_EcResultDr_Dr=:PRResultDr,PP_CheckFreq_Dr=:CheckFreqDr where PP_RowId=:PPRowId) 
		s myrtn=SQLCODE
	}
	if +myrtn=0{
		if Result="同意"{
			
			if +myrtn=0{
					;插入子表状态
					s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
					s ProjectStateObj.PPSPPParRef=PPRowId
					s ProjectStateObj.PPSCurState="I"
					s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
					s ProjectStateObj.PPSUpdateDate=+$H
					s ProjectStateObj.PPSUpdateTime=$p($h,",",2)
					s ProjectStateObj.PPSUpdateReason="伦理委员会审查通过"
					s myrtn=##class(web.PilotProject.DHCDocPilotProject).InsertProjectState(ProjectStateObj)
				}
			if +myrtn=0{
			;if ($p($g(^DHCDocPP(PPRowId)),"^",34)=""){
				;s ArchivesFilesNo=..GetMaxArchivesFilesNo()
				;&sql(update DHC_DocPilotProject set PP_ArchivesFilesNo=:ArchivesFilesNo where PP_RowId=:PPRowId) 
				;s myrtn=SQLCODE	
				;}
			}
		}elseif Result="不同意"{
				&sql(update DHC_DocPilotProject set PP_State="U" where PP_RowId=:PPRowId) 
				s myrtn=SQLCODE
				if +myrtn=0{
					;插入子表状态
					s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
					s ProjectStateObj.PPSPPParRef=PPRowId
					s ProjectStateObj.PPSCurState="U"
					s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
					s ProjectStateObj.PPSUpdateDate=+$H
					s ProjectStateObj.PPSUpdateTime=$p($h,",",2)
					s ProjectStateObj.PPSUpdateReason="伦理委员会审查不通过"
					s myrtn=##class(web.PilotProject.DHCDocPilotProject).InsertProjectState(ProjectStateObj)
				}
			}	
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q myrtn
}

//录入补充批件内容

ClassMethod UpdateAdditionPJ(PPRowId As %String, PPERowId As %String, Date As %String, Opinion As %String, PJNo As %String, FileData As %String, PassFlag As %String, DrugPJNo As %String, SFDADate, SFDANo, ApproveDate) As %String
{
	s ^zzy("UpdateAdditionPJ")=PPRowId_"^"_PPERowId_"^"_Date
	q:PPERowId="" ""
	q:PPRowId="" ""
	s EthicsMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	s myrtn=""
	s:Date'="" Date=$zdh(Date,4)
	s:SFDADate'="" SFDADate=$zdh(SFDADate,4)
	s:ApproveDate'="" ApproveDate=$zdh(ApproveDate,4)
	s OpinionDesc=""
	s:Opinion'="" OpinionDesc=$p($g(^DHCDocCT("DefineData",+Opinion,"D",$p(Opinion,"||",2))),"^",2)
	TS
	&sql(update DHC_DocPilotProECRecord set PPE_FileData=:FileData,PPE_CheckDate=:Date,PPE_Pass=:PassFlag,PPE_Opinion=:Opinion,PPE_PJNo=:PJNo,PPE_DrugPJNo=:DrugPJNo ,PPE_SFDADate=:SFDADate, PPE_SFDANo=:SFDANo, PPE_ApproveDate=:ApproveDate where PPE_RowId=:PPERowId )
	s myrtn=SQLCODE
	if +myrtn=0{
	s EthicsMeetDate=$p($g(^DHCDocPP(PPRowId)),"^",32)
	if EthicsMeetDate=""{
	&sql(update DHC_DocPilotProject set PP_EthicsMeetDate=:EMDate where PP_RowId=:PPRowId) 
	s myrtn=SQLCODE
	}
	}
	if +myrtn=0{
		if ((PassFlag="Y")||(OpinionDesc="同意")){
			if EthicsMeetAduitDate=""{
			&sql(update DHC_DocPilotProject set PP_EthicsMeetAduitDate=:Date where PP_RowId=:PPRowId) 
			s myrtn=SQLCODE
			}
			if +myrtn=0{
					;插入子表状态
					s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
					s ProjectStateObj.PPSPPParRef=PPRowId
					s ProjectStateObj.PPSCurState="I"
					s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
					s ProjectStateObj.PPSUpdateDate=+$H
					s ProjectStateObj.PPSUpdateTime=$p($h,",",2)
					s ProjectStateObj.PPSUpdateReason="伦理委员会审查通过"
					s myrtn=##class(web.PilotProject.DHCDocPilotProject).InsertProjectState(ProjectStateObj)
				}
			if +myrtn=0{
			;if ($p($g(^DHCDocPP(PPRowId)),"^",34)=""){
				;s ArchivesFilesNo=..GetMaxArchivesFilesNo()
				;&sql(update DHC_DocPilotProject set PP_ArchivesFilesNo=:ArchivesFilesNo where PP_RowId=:PPRowId) 
				;s myrtn=SQLCODE	
				;}
			}
		}elseif PassFlag="N"{
				&sql(update DHC_DocPilotProject set PP_State="U" where PP_RowId=:PPRowId) 
				s myrtn=SQLCODE
				if +myrtn=0{
					;插入子表状态
					s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
					s ProjectStateObj.PPSPPParRef=PPRowId
					s ProjectStateObj.PPSCurState="U"
					s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
					s ProjectStateObj.PPSUpdateDate=+$H
					s ProjectStateObj.PPSUpdateTime=$p($h,",",2)
					s ProjectStateObj.PPSUpdateReason="伦理委员会审查不通过"
					s myrtn=##class(web.PilotProject.DHCDocPilotProject).InsertProjectState(ProjectStateObj)
				}
			}	
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q myrtn
}

ClassMethod GetMaxArchivesFilesNo() As %String
{
	s myMAXNo=0
	Lock ^DHCDocPilotConfig("ArchivesFilesNo")
    s myMAXNo=$i(^DHCDocPilotConfig("ArchivesFilesNo"))
	Lock -^DHCDocPilotConfig("ArchivesFilesNo")
	;s myPatLen=6
	;s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
	q myMAXNo
}

ClassMethod FindEcRecordClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindEcRecordExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindEcRecordExecute(ByRef QHandle As %Binary, PPRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProRem")
	Set repid=$I(^CacheTemp)
	s ind=1
	i PPRowId="" Set QHandle=$lb(0,repid,0)  Quit $$$OK
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	s EMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	s:EMeetAduitDate'="" EMeetAduitDate=$zd(EMeetAduitDate,3)
	s PPERowId=0
	f  s PPERowId=$o(^DHCDocPPE(0,"ProjectDr",PPRowId,PPERowId)) q:PPERowId=""  d
	.s EthicsMeetDate=$p($g(^DHCDocPPE(PPERowId)),"^",9)
	.s InstrucNo=$p($g(^DHCDocPPE(PPERowId)),"^",13)
	.s:EthicsMeetDate'="" EthicsMeetDate=$zd(EthicsMeetDate,3)
	.s PPEType=$p($g(^DHCDocPPE(PPERowId)),"^",14)
	.s CreateDate=$p($g(^DHCDocPPE(PPERowId)),"^",12)
	.s:CreateDate'="" CreateDate=$zd(CreateDate,4)
	.i PPEType="C" s Type="伦理委员会批件"
	.i PPEType="A" s Type="补充批件"
	.i PPEType="F" s Type="快审批件"
	.Do OutputRow6
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(PPERowId,PPDesc,InstrucNo,CreateDate,Type,EthicsMeetDate,EMeetAduitDate)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindEcRecordFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEcRecordExecute ]
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

//d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotProECApprove","FindEcRecord","37")

Query FindEcRecord(PPRowId As %String) As %Query(ROWSPEC = "PPERowId:%String,PPDesc:%String,InstrucNo:%String,CreateDate:%String,Type:%String,EthicsMeetDate:%String,EMeetAduitDate:%String") [ SqlProc ]
{
}

//产生批件号

/*ClassMethod GetInstrucNo(Type As %String) As %String
{
	s myMAXNo=0
	s Year=$p($zd(+$h),"/",3)
	i Type="C" set config="CommonInstrucNo"
	i Type="A" set config="AdditionInstrucNo"
	i Type="F" set config="FastInstrucNo"
	Lock ^DHCDocPilotConfig(config)
    s myMAXNo=$i(^DHCDocPilotConfig(config))
	Lock -^DHCDocPilotConfig(config)
	s myPatLen=3
	s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
	i Type="C" set myMAXNo="HS"_Year_""_myMAXNo
	i Type="A" set myMAXNo="BC"_Year_""_myMAXNo
	i Type="F" set myMAXNo="KS"_Year_""_myMAXNo
	
	q myMAXNo
}*/

//产生批件号

//w ##class(web.PilotProject.UDHCDocPilotProECApprove).GetInstrucNo("C")

ClassMethod GetInstrucNo(Type As %String) As %String
{
	s myMAXNo=0
	s Year=$p($zd(+$h),"/",3)
	i Type="C" set config="CommonInstrucNo"
	i Type="A" set config="AdditionInstrucNo"
	i Type="F" set config="FastInstrucNo"
	if '$d(^DHCDocPilotConfig(config,Year)) s ^DHCDocPilotConfig(config,Year)=1
	s large=$g(^DHCDocPilotConfig(config,Year))
	s myMAXNo=""
	f i=1:1:large q:myMAXNo'=""  d
	.s flag=0
	.s ProRowId=""
	.f  s ProRowId=$o(^DHCDocPPE(0,"ProjectDr",ProRowId)) q:ProRowId=""  d
	..s PPERowId=""
	..f  s PPERowId=$o(^DHCDocPPE(0,"ProjectDr",ProRowId,PPERowId)) q:PPERowId=""  d
	...s InstrucNo=$p(^DHCDocPPE(PPERowId),"^",13)
	...s PPEType=$p(^DHCDocPPE(PPERowId),"^",14)
	...q:PPEType'=Type
	...s PJYear=$e(InstrucNo,3,6)
	...q:PJYear'=Year
	...s InstrucNo=+$e(InstrucNo,7,9)
	...i i=InstrucNo s flag=1
	.i flag=0 s myMAXNo=i
	if myMAXNo="" d
	.Lock ^DHCDocPilotConfig(config,Year)
    .s myMAXNo=$i(^DHCDocPilotConfig(config,Year))
	.Lock -^DHCDocPilotConfig(config,Year)
	s myPatLen=3
	s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
	i Type="C" set myMAXNo="HS"_Year_""_myMAXNo
	i Type="A" set myMAXNo="BC"_Year_""_myMAXNo
	i Type="F" set myMAXNo="KS"_Year_""_myMAXNo
	
	q myMAXNo
}

ClassMethod GetEcRecord(PPERowId As %String) As %String
{
	q:PPERowId=""
	s PRResult="",CheckFreq=""
	s PRResultDr=$p($g(^DHCDocPPE(PPERowId)),"^",1)
	s:PRResultDr'="" PRResult=$p($g(^DHCDocCT("DefineData",+PRResultDr,"D",$p(PRResultDr,"||",2))),"^",2)
	s CheckFreqDr=$p($g(^DHCDocPPE(PPERowId)),"^",2)
	s:CheckFreqDr'="" CheckFreq=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",2)
	s MainAppraisal=$p($g(^DHCDocPPE(PPERowId)),"^",4)
	s DesignAppraisal=$p($g(^DHCDocPPE(PPERowId)),"^",5)
	s FormAppraisal=$p($g(^DHCDocPPE(PPERowId)),"^",6)
	s ComPenAppraisal=$p($g(^DHCDocPPE(PPERowId)),"^",7)
	s OtherRemark=$p($g(^DHCDocPPE(PPERowId)),"^",8)
	s MeetDate=$p($g(^DHCDocPPE(PPERowId)),"^",9)
	s:MeetDate'="" MeetDate=$zd(MeetDate,3)
	s Attendance=$p($g(^DHCDocPPE(PPERowId)),"^",10)
	s UndecideNum=$p($g(^DHCDocPPE(PPERowId)),"^",11)
	s Hospital=$p($g(^DHCDocPPE(PPERowId)),"^",15)
	s Opinion=""
	s OpinionDr=$p($g(^DHCDocPPE(PPERowId)),"^",16)
	s:OpinionDr'="" Opinion=$p($g(^DHCDocCT("DefineData",+OpinionDr,"D",$p(OpinionDr,"||",2))),"^",2)
	s Attachment=$p($g(^DHCDocPPE(PPERowId)),"^",17)
	s CheckDate=$p($g(^DHCDocPPE(PPERowId)),"^",18)
	s:CheckDate'="" CheckDate=$zd(CheckDate,4)
	s PJNo=$p($g(^DHCDocPPE(PPERowId)),"^",19)
	s FileData=$p($g(^DHCDocPPE(PPERowId)),"^",20)
	s Pass=$p($g(^DHCDocPPE(PPERowId)),"^",21)
	s AvoidNum=$p($g(^DHCDocPPE(PPERowId)),"^",22)
	s InstrucNo=$p($g(^DHCDocPPE(PPERowId)),"^",13)
	s TaskFrom=$p($g(^DHCDocPPE(PPERowId)),"^",23)
	s DrugPJNo=$p($g(^DHCDocPPE(PPERowId)),"^",24)
	s PlanVersion=$p($g(^DHCDocPPE(PPERowId)),"^",25)
	s PlanVersionDate=$p($g(^DHCDocPPE(PPERowId)),"^",26)
	s:PlanVersionDate'="" PlanVersionDate=$zd(PlanVersionDate,4)
	s FormVersion=$p($g(^DHCDocPPE(PPERowId)),"^",27)
	s FormVersionDate=$p($g(^DHCDocPPE(PPERowId)),"^",28)
	s:FormVersionDate'="" FormVersionDate=$zd(FormVersionDate,4)
	s AgreeNum=$p($g(^DHCDocPPE(PPERowId)),"^",29)
	s ZBYXZHTY=$p($g(^DHCDocPPE(PPERowId)),"^",30)
	s BBYXZHCS=$p($g(^DHCDocPPE(PPERowId)),"^",31)
	s UAgreeNum=$p($g(^DHCDocPPE(PPERowId)),"^",32)
	s ZZHZT	=$p($g(^DHCDocPPE(PPERowId)),"^",33)
	s RecordName=$p($g(^DHCDocPPE(PPERowId)),"^",34)
	s WyName=$p($g(^DHCDocPPE(PPERowId)),"^",35)
	s SFDADate=$p($g(^DHCDocPPE(PPERowId)),"^",36)
	s:SFDADate'="" SFDADate=$zd(SFDADate,4)
	s SFDANo=$p($g(^DHCDocPPE(PPERowId)),"^",37)
	s ApproveDate=$p($g(^DHCDocPPE(PPERowId)),"^",38)
	s:ApproveDate'="" ApproveDate=$zd(ApproveDate,4)
		
	s ret=Attendance_"^"_UndecideNum_"^"_PRResultDr_"^"_PRResult_"^"_CheckFreqDr_"^"_CheckFreq_"^"_MainAppraisal_"^"_DesignAppraisal_"^"_FormAppraisal_"^"_ComPenAppraisal_"^"_OtherRemark_"^"_MeetDate_"^"_Hospital_"^"_Opinion_"^"_CheckDate_"^"_PJNo_"^"_Attachment_"^"_FileData_"^"_Pass_"^"_AvoidNum_"^"_OpinionDr_"^"_InstrucNo_"^"_TaskFrom_"^"_DrugPJNo_"^"_PlanVersion_"^"_PlanVersionDate_"^"_FormVersion_"^"_FormVersionDate_"^"_AgreeNum_"^"_ZBYXZHTY_"^"_BBYXZHCS_"^"_UAgreeNum_"^"_ZZHZT_"^"_RecordName_"^"_WyName_"^"_SFDADate_"^"_SFDANo_"^"_ApproveDate
	q ret
}

ClassMethod DeletePJ(PPERowId As %String) As %String
{
	q:PPERowId="" ""
	&sql(Delete from DHC_DocPilotProECRecord where PPE_RowId=:PPERowId)
	q SQLCODE
}

ClassMethod UpdateProMeetDate(PPRowId As %String, MeetDate As %String, MeetDateRemark As %String = "") As %String
{
	s ^zzy("UpdateProPIInfo")=PPRowId_"^"_MeetDate_"^"_MeetDateRemark
	if (MeetDate'="") s MeetDate=$zdh(MeetDate,4)
	if PPRowId=""  q "-1"
	 &SQL(Update SQLUser.DHC_DocPilotProject set PP_EthicsMeetDate=:MeetDate, PP_EthicsMeetDateRemark=:MeetDateRemark where PP_RowId=:PPRowId)
    Q SQLCODE
}

ClassMethod GetProMeetDate(PPRowId As %String)
{
	s ^zzy("GetProMeetDate")=PPRowId
	if PPRowId=""  q "^"
	s MeetDate=$p($g(^DHCDocPP(PPRowId)),"^",32)
	s:MeetDate'="" MeetDate=$zd(MeetDate,4)
	s MeetDateRemark=$p($g(^DHCDocPP(PPRowId)),"^",113)
	q MeetDate_"^"_MeetDateRemark
}

}
