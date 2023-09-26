Import SQLUser

Class web.PilotProject.DHCDocPilotProject Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod InsertProjectInfo(myProjecctInfo As %String, myExpStr As %String = "", OtherDepStr As %String, InHosp = "", CROInfo = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).InsertProjectInfo($List(^gry("InsertProjectInfo"),1),"")
	s ^tmpgry("InsertProjectInfo")=$lb(myProjecctInfo,myExpStr)
	n (myProjecctInfo,myExpStr,OtherDepStr,InHosp,CROInfo)
	s CFAutoProCode=$g(^DHCDocPilotSeting(InHosp,"AutoProCode"))
	
	s myrtn=0,errDesc=""
	s myProObj=##class(web.PilotProject.PPA.DHCDocPilotProject).%New()
	d myProObj.XMLNodeDeserialize(.myProObj, "DHCDocPilotProject", myProjecctInfo)
	
	s myrtn=..CheckSaveData(myProObj,myExpStr)
	Q:+myrtn'=0 myrtn
	;if $l(myProObj.PPEndDate,"/")=3 s myProObj.PPEndDate=$zdh(myProObj.PPEndDate,4)
	;if $l(myProObj.FileSubmitDate,"/")=3 s myProObj.FileSubmitDate=$zdh(myProObj.FileSubmitDate,4)
    ;if $l(myProObj.EthicsMeetDate,"/")=3 s myProObj.EthicsMeetDate=$zdh(myProObj.EthicsMeetDate,4)
    ;if $l(myProObj.EthicsMeetAduitDate,"/")=3 s myProObj.EthicsMeetAduitDate=$zdh(myProObj.EthicsMeetAduitDate,4)
    ;if $l(myProObj.EthicsFilesOffDate,"/")=3 s myProObj.EthicsFilesOffDate=$zdh(myProObj.EthicsFilesOffDate,4)
    ;if $l(myProObj.SignProtocolDate,"/")=3 s myProObj.SignProtocolDate=$zdh(myProObj.SignProtocolDate,4)
		
	TS
	s UObj=##class(User.DHCDocPilotProject).%New()
	i CFAutoProCode=1 {
		s PPCode=..GetMaxCodeNo(InHosp)
	}else{
		s PPCode=myProObj.PPCode
	}
	;设置了自动起始编号则自动增加
	s ArchivesFilesStNo=+$G(^DHCDocPilotSeting(InHosp,"ArchivesFilesNoStart"))
	if (ArchivesFilesStNo=0)
	{
		s ArchivesFilesNo=myProObj.ArchivesFilesNo
	}
	else{
		s ArchivesFilesNo=..GetMaxArchivesFilesNo(InHosp)
	}
	s UObj.PPCode=PPCode
	s UObj.PPDesc=myProObj.PPDesc
	s UObj.PPOrder=myProObj.PPOrder
	;s UObj.PPResult=myProObj.PPResult
	s UObj.PPRemark=myProObj.PPRemark
	d UObj.PPCreateDepartmentDrSetObjectId(myProObj.PPCreateDepartmentDr)
	d UObj.PPCreateUserDrSetObjectId(myProObj.PPCreateUserDr)
	s UObj.PPCreateDate=..%SysDate()
	s UObj.PPCreateTime=..%SysTime()
	d UObj.PPStartUserDrSetObjectId(myProObj.PPStartUserDr)  ;项目批准人
	;s UObj.PPStartDate=myProObj.PPStartDate
	;d UObj.PPEndUserDrSetObjectId(myProObj.PPEndUserDr)
	;s UObj.PPEndDate=myProObj.PPEndDate
	;s UObj.PPEndTime=myProObj.PPEndTime
	;s UObj.PPBudget=myProObj.PPBudget
	s UObj.PPState="N"
	s UObj.Indication=myProObj.Indication
		d UObj.PilotCategoryDrSetObjectId(myProObj.PilotCategoryDr)
		;d UObj.EthicsFilesNextStateDrSetObjectId(myProObj.EthicsFilesNextStateDr)
		;d UObj.EthicsFilesStateDrSetObjectId(myProObj.EthicsFilesStateDr)
		;d UObj.ProjectFilesStateDrSetObjectId(myProObj.ProjectFilesStateDr)
		d UObj.IsHeadmanDrSetObjectId(myProObj.IsHeadmanDr)
	
		d UObj.ApplyStageDrSetObjectId(myProObj.ApplyStageDr)
		s UObj.ApplicationUnit=myProObj.ApplicationUnit
	    s UObj.PlanNo=myProObj.PlanNo
	    s UObj.PlanName=myProObj.PlanName
	    s UObj.ApprovalNo=myProObj.ApprovalNo
	    ;s UObj.Role=myProObj.Role
	    ;s UObj.ExamReportNum=myProObj.ExamReportNum
		;s UObj.FileSubmitDate=myProObj.FileSubmitDate
		;s UObj.EthicsMeetDate=myProObj.EthicsMeetDate
		;s UObj.EthicsMeetAduitDate=myProObj.EthicsMeetAduitDate
		s UObj.ArchivesFilesNo=ArchivesFilesNo ;myProObj.ArchivesFilesNo
		;s UObj.CollectCompany=myProObj.CollectCompany
		;s UObj.EthicsFilesOffDate=myProObj.EthicsFilesOffDate
		;s UObj.SignProtocolDate=myProObj.SignProtocolDate
		s UObj.LeaderCompany=myProObj.LeaderCompany
		s UObj.LeaderCompanyPI=myProObj.LeaderCompanyPI
		s UObj.CROCompany=myProObj.CROCompany
		;d UObj.PPEndUserDrSetObjectId(myProObj.PPEndUserDr)
		s UObj.PPEndDate=##class(websys.Conversions).DateHtmlToLogical(myProObj.PPEndDate)
		s UObj.PPStartDate=##class(websys.Conversions).DateHtmlToLogical(myProObj.PPStartDate)
		d UObj.ApplyMatterDrSetObjectId(myProObj.ApplyMatterDr)
		d UObj.SubPilotCategoryDrSetObjectId(myProObj.SubPilotCategoryDr)
		s UObj.ApplyContact=myProObj.ApplyContact
		s UObj.ApplyContactTel=myProObj.ApplyContactTel
		s UObj.CROContact=myProObj.CROContact
		s UObj.CROContactTel=myProObj.CROContactTel
		s UObj.OpenOrdEntryLimit=myProObj.OpenOrdEntryLimit
		s UObj.PPNum=myProObj.PPNum
		s UObj.PPInterFlag=myProObj.PPInterFlag
		d UObj.StudyTypeSetObjectId(myProObj.StudyType)
	Set sc = UObj.%Save()
	s PPSPPParRef=UObj.%Id()
	b ;ProjectSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
  if +myrtn=0{
	s SamePPCRowId=..FindSameUser(PPSPPParRef,myProObj.PPStartUserDr)
			if SamePPCRowId="" {
				s myrtn=..InsertProjectCare("",PPSPPParRef,myProObj.PPStartUserDr,"",myProObj.PPStartUserDr)
			}
	}
	if +myrtn=0{
		if OtherDepStr'=""{
		s length=$l(OtherDepStr,"^")
		f i=1:1:length {
			s PPCreateDepartmentDr=$p($p(OtherDepStr,"^",i),"-",1)
			s PPStartUserDr=$p($p(OtherDepStr,"^",i),"-",2)
			q:PPCreateDepartmentDr=""
			s DepObj=##class(User.DHCDocPilotProDept).%New(PPSPPParRef)
			d DepObj.PPDPPParRefSetObjectId(PPSPPParRef)
			d DepObj.PPDCreateDepartmentDrSetObjectId(PPCreateDepartmentDr)
			d DepObj.PPDStartUserDrSetObjectId(PPStartUserDr)
			if +myrtn=0{
			s SamePPCRowId=..FindSameUser(PPSPPParRef,PPStartUserDr)
			if SamePPCRowId="" {
				s myrtn=..InsertProjectCare("",PPSPPParRef,PPStartUserDr,"",PPStartUserDr)
			}
	}
			Set sc = DepObj.%Save()
			If ($System.Status.IsError(sc))
			{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-106"
			}
			d DepObj.%Close()
		}	
		}
	}
	if +myrtn=0 {
		;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPSPPParRef
		s ProjectStateObj.PPSCurState="N"
		s ProjectStateObj.PPSUpdateUserDr=myProObj.PPCreateUserDr
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		s ProjectStateObj.PPSUpdateReason="立项"
		s ProjectStateObj.PPSAuthUserDr=myProObj.PPStartUserDr    ;批准人
		s myrtn=..InsertProjectState(ProjectStateObj)
	}
	;保存CRO
	if (CROInfo'="") d ##class(DHCDoc.GCP.BS.CRO).Save(PPSPPParRef,CROInfo)
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	if myrtn="-104" s errDesc="插入项目数据失败."
	if myrtn="-105" s errDesc="插入项目状态数据失败."
	if (+myrtn=0) q +myrtn_"^"_PPSPPParRef
    Q +myrtn_"^"_errDesc
}

ClassMethod UpdateMethod(myProjecctInfo As %String, PPRowId As %String, CROInfo As %String) As %String
{
	n (myProjecctInfo,PPRowId,CROInfo,%session)
	;w ##class(web.PilotProject.DHCDocPilotProject).InsertProjectInfo($List(^gry("InsertProjectInfo"),1),"")
	s ^tmpgry("UpdateMethod")=$lb(myProjecctInfo,PPRowId)
	;n (myProjecctInfo,PPRowId)
	s myrtn=0,errDesc="",EthicsMeetAduitDate=""
	s UpdateStr=""
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocPilotProject"_$c(2)_PPRowId)
	TS
	s UObj=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
	if ($IsObject(UObj)) {
		s PPStartUserDr=UObj.PPStartUserDr
		s myrtn=0,errDesc=""
		s myProObj=##class(web.PilotProject.PPA.DHCDocPilotProject).%New()
		d myProObj.XMLNodeDeserialize(.myProObj, "DHCDocPilotProject", myProjecctInfo)
	
	;s myrtn=..CheckSaveData(myProObj,myExpStr)
	;Q:+myrtn'=0 myrtn
	;if $l(myProObj.PPEndDate,"/")=3 s myProObj.PPEndDate=$zdh(myProObj.PPEndDate,4)
	;if $l(myProObj.FileSubmitDate,"/")=3 s myProObj.FileSubmitDate=$zdh(myProObj.FileSubmitDate,4)
    ;if $l(myProObj.EthicsMeetDate,"/")=3 s myProObj.EthicsMeetDate=$zdh(myProObj.EthicsMeetDate,4)
    ;if $l(myProObj.EthicsMeetAduitDate,"/")=3 s myProObj.EthicsMeetAduitDate=$zdh(myProObj.EthicsMeetAduitDate,4)
    ;if $l(myProObj.EthicsFilesOffDate,"/")=3 s myProObj.EthicsFilesOffDate=$zdh(myProObj.EthicsFilesOffDate,4)
    ;if $l(myProObj.SignProtocolDate,"/")=3 s myProObj.SignProtocolDate=$zdh(myProObj.SignProtocolDate,4)
		
	
	;s UObj.PPCode=myProObj.PPCode
	i UObj.PPDesc'=myProObj.PPDesc s UpdateStr=UpdateStr_" "_"把项目名称从"_UObj.PPDesc_"修改为"_myProObj.PPDesc_"。"
	s UObj.PPCode=myProObj.PPCode
	s UObj.PPDesc=myProObj.PPDesc
	s UObj.PPOrder=myProObj.PPOrder
	;s UObj.PPResult=myProObj.PPResult
	s UObj.PPRemark=myProObj.PPRemark
	d UObj.PPCreateDepartmentDrSetObjectId(myProObj.PPCreateDepartmentDr)
	;d UObj.PPCreateUserDrSetObjectId(myProObj.PPCreateUserDr)
	d UObj.PPStartUserDrSetObjectId(myProObj.PPStartUserDr)  ;项目批准人
	s UObj.PPStartDate=##class(websys.Conversions).DateHtmlToLogical(myProObj.PPStartDate)
	;d UObj.PPEndUserDrSetObjectId(myProObj.PPEndUserDr)
	;s UObj.PPEndDate=myProObj.PPEndDate
	;s UObj.PPEndTime=myProObj.PPEndTime
	;s UObj.PPBudget=myProObj.PPBudget
	s UObj.Indication=myProObj.Indication
		d UObj.PilotCategoryDrSetObjectId(myProObj.PilotCategoryDr)
		;d UObj.EthicsFilesNextStateDrSetObjectId(myProObj.EthicsFilesNextStateDr)
		;d UObj.EthicsFilesStateDrSetObjectId(myProObj.EthicsFilesStateDr)
		;d UObj.ProjectFilesStateDrSetObjectId(myProObj.ProjectFilesStateDr)
		d UObj.IsHeadmanDrSetObjectId(myProObj.IsHeadmanDr)
	
		d UObj.ApplyStageDrSetObjectId(myProObj.ApplyStageDr)
		s UObj.ApplicationUnit=myProObj.ApplicationUnit
	    s UObj.PlanNo=myProObj.PlanNo
	    s UObj.PlanName=myProObj.PlanName
	    s UObj.ApprovalNo=myProObj.ApprovalNo
	    ;s UObj.Role=myProObj.Role
	    ;s UObj.ExamReportNum=myProObj.ExamReportNum
		;s UObj.FileSubmitDate=myProObj.FileSubmitDate
		;s UObj.EthicsMeetDate=myProObj.EthicsMeetDate
		;s UObj.EthicsMeetAduitDate=myProObj.EthicsMeetAduitDate
		s UObj.ArchivesFilesNo=myProObj.ArchivesFilesNo
		;s UObj.CollectCompany=myProObj.CollectCompany
		;s UObj.EthicsFilesOffDate=myProObj.EthicsFilesOffDate
		;s UObj.SignProtocolDate=myProObj.SignProtocolDate
		s UObj.LeaderCompany=myProObj.LeaderCompany
		s UObj.LeaderCompanyPI=myProObj.LeaderCompanyPI
		s UObj.CROCompany=myProObj.CROCompany
		;d UObj.PPEndUserDrSetObjectId(myProObj.PPEndUserDr)
		s UObj.PPEndDate=##class(websys.Conversions).DateHtmlToLogical(myProObj.PPEndDate)
		d UObj.ApplyMatterDrSetObjectId(myProObj.ApplyMatterDr)
		d UObj.SubPilotCategoryDrSetObjectId(myProObj.SubPilotCategoryDr)
		s UObj.ApplyContact=myProObj.ApplyContact
		s UObj.ApplyContactTel=myProObj.ApplyContactTel
		s UObj.CROContact=myProObj.CROContact
		s UObj.CROContactTel=myProObj.CROContactTel
		s UObj.OpenOrdEntryLimit=myProObj.OpenOrdEntryLimit
		s UObj.PPNum=myProObj.PPNum
		s UObj.PPInterFlag=myProObj.PPInterFlag
		d UObj.StudyTypeSetObjectId(myProObj.StudyType)
	
	Set sc = UObj.%Save()
	Set changeId = UObj.%Id()
	set changeDesc=myProObj.PPDesc
	s PPSPPParRef=PPRowId
	
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	;保存CRO
	d ##class(DHCDoc.GCP.BS.CRO).Save(PPRowId,CROInfo)
		s OperateType="A"
		i PPRowId'="" s OperateType="U"
    	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocPilotProject"_$c(2)_PPRowId)
    	set flag=##class(web.DHCDocDataChangeLog).SaveLog("DHC_DocPilotProject","User.DHCDocPilotProject","药理实验项目基本信息表","User.DHCDocPilotProject_"_changeId,changeDesc,OperateType,NewDataJson,OldDataJson)
	i myrtn=0{
	s SamePPCRowId=..FindSameUser(PPRowId,myProObj.PPStartUserDr)
			if SamePPCRowId="" {
				s myrtn=..InsertProjectCare("",PPRowId,myProObj.PPStartUserDr,"",myProObj.PPStartUserDr)
	
				 i myrtn=0 s myrtn=..DeleteProjectCare(PPRowId,PPStartUserDr)	
			}
	}
		s OtherDepStr=myProObj.OtherDepStr
	s NeedDelUserStr=""
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.q:UserDr=""
	.s NeedDelFlag=0
	.s length=$l(OtherDepStr,"^")
		.f i=1:1:length d
			..s PPCreateDepartmentDr=$p($p(OtherDepStr,"^",i),"-",1)
			..s StartUserDr=$p($p(OtherDepStr,"^",i),"-",2)
			..;q:StartUserDr=""
			..q:StartUserDr'=UserDr
			..s NeedDelFlag=1
	.i NeedDelFlag=0 d
	..i NeedDelUserStr="" s NeedDelUserStr=UserDr
	..e  s NeedDelUserStr=NeedDelUserStr_"^"_UserDr
	s NeedAddUserStr=""
	s length=$l(OtherDepStr,"^")
	f i=1:1:length d
	.s PPCreateDepartmentDr=$p($p(OtherDepStr,"^",i),"-",1)
	.s StartUserDr=$p($p(OtherDepStr,"^",i),"-",2)
	.//s ^zzy(10)=StartUserDr
	.q:StartUserDr=""
	.s NeedAddFlag=0
	.s chil=0
	.f  s chil=$o(^DHCDocPPD(PPRowId,chil)) q:chil=""  d
	..s UserID=$p($g(^DHCDocPPD(PPRowId,chil)),"^",2)
	..q:StartUserDr'=UserID
	..//s ^zzy("ss")=UserID
	..s NeedAddFlag=1
	.i NeedAddFlag=0 d
	..i NeedAddUserStr="" s NeedAddUserStr=StartUserDr
	..e  s NeedAddUserStr=NeedAddUserStr_"^"_StartUserDr
	i myrtn=0 d
	.f k=1:1:$l(NeedDelUserStr,"^")
	.s User=$p(NeedDelUserStr,"^",k)
	.q:User=""
	.s myrtn=..DeleteProjectCare(PPRowId,User)
	//s ^zzy("m")=myrtn
	//s ^zzy("N")=NeedAddUserStr
	//s ^zzy("Y")=NeedDelUserStr
	i myrtn=0 d
	.f k=1:1:$l(NeedAddUserStr,"^")
	.s User=$p(NeedAddUserStr,"^",k)
	.q:User=""
	.s SamePPCRowId=..FindSameUser(PPRowId,User)
	.s:SamePPCRowId="" myrtn=..InsertProjectCare("",PPRowId,User,"",User)
		//s ^zzy("OtherDepStr")=OtherDepStr
	if +myrtn=0{
		if OtherDepStr'=""{
			s number=0
			&sql(select count(*) into :number from DHC_DocPilotProDept where PPD_PP_ParRef=:PPRowId)
			if number>0{
		&sql(delete from DHC_DocPilotProDept where PPD_PP_ParRef=:PPRowId)
		s myrtn=SQLCODE
			}
		if +myrtn=0{
		s length=$l(OtherDepStr,"^")
		f i=1:1:length {
			s PPCreateDepartmentDr=$p($p(OtherDepStr,"^",i),"-",1)
			s PPStartUserDr=$p($p(OtherDepStr,"^",i),"-",2)
			q:PPStartUserDr=""
			s DepObj=##class(User.DHCDocPilotProDept).%New(PPSPPParRef)
			d DepObj.PPDPPParRefSetObjectId(PPSPPParRef)
			d DepObj.PPDCreateDepartmentDrSetObjectId(PPCreateDepartmentDr)
			d DepObj.PPDStartUserDrSetObjectId(PPStartUserDr)
			Set sc = DepObj.%Save()
			If ($System.Status.IsError(sc))
			{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-106"
			}
			d DepObj.%Close()
		}	
		}
		}
	}
	
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	}
	if myrtn="-104" s errDesc="插入项目数据失败."
	if myrtn="-105" s errDesc="插入项目状态数据失败."
	if (+myrtn=0) q +myrtn_"^"_PPSPPParRef
    Q +myrtn_"^"_errDesc
}

ClassMethod InsertProjectState(ProjectStateObj As web.PilotProject.PPA.DHCDocPilotProState) As %String
{
	n (ProjectStateObj)
	s myrtn=0
	TS
	s UObj=##class(User.DHCDocPilotProState).%New(ProjectStateObj.PPSPPParRef)
	d UObj.PPSPPParRefSetObjectId(ProjectStateObj.PPSPPParRef)
	s UObj.PPSCurState=ProjectStateObj.PPSCurState
	d UObj.PPSUpdateUserDrSetObjectId(ProjectStateObj.PPSUpdateUserDr)
	s UObj.PPSUpdateDate=ProjectStateObj.PPSUpdateDate
	s UObj.PPSUpdateTime=ProjectStateObj.PPSUpdateTime
	;s UObj.PPSRemark=ProjectStateObj.PPSRemark
	s UObj.PPSUpdateReason=ProjectStateObj.PPSUpdateReason
	d UObj.PPSAuthUserDrSetObjectId(ProjectStateObj.PPSAuthUserDr)
	Set sc = UObj.%Save()
	b ;ProjectStateSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d UObj.%Close()
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q +myrtn
}

ClassMethod InsertProjectRem(ProjectRemInfo As %String, PPRowId As %String) As %String
{
	//s ^gry("InsertProjectRem")=ProjectRemInfo_"^"_PPRowId
	n (ProjectRemInfo,PPRowId)
	s myrtn=0,errDesc=""
	s ProjectRemObj=##class(web.PilotProject.PPA.DHCDocPilotProRem).%New()
	d ProjectRemObj.XMLNodeDeserialize(.ProjectRemObj, "DHCDocPilotProRem", ProjectRemInfo)
	

	TS
	s UObj=##class(User.DHCDocPilotProRem).%New(PPRowId)
	d UObj.PPRPPParRefSetObjectId(PPRowId)
	s UObj.PPRRemAmount=ProjectRemObj.PPRRemAmount
	d UObj.PPRRemUserDrSetObjectId(ProjectRemObj.PPRRemUserDr)
	s UObj.PPRDateAdd=..%SysDate()
	s UObj.PPRTimeAdd=..%SysTime()
	s UObj.PPRRemitter=ProjectRemObj.PPRRemitter
	d UObj.PPRReceiverSetObjectId(ProjectRemObj.PPRReceiver)
	;s UObj.PPRReceiver=ProjectRemObj.PPRReceiver
	if (ProjectRemObj.PPRDate'="") s ProjectRemObj.PPRDate=..%ZDH(ProjectRemObj.PPRDate)
	//if $l(ProjectRemObj.PPRDate,"/")=3 s ProjectRemObj.PPRDate=$zdh(ProjectRemObj.PPRDate,4)
	s UObj.PPRDate=ProjectRemObj.PPRDate
	s UObj.PPRRemark=ProjectRemObj.PPRRemark
	s UObj.PPRState="A"
	Set sc = UObj.%Save()
	b ;ProjectStateSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d UObj.%Close()
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	if +myrtn'=0 s errDesc="插入数据失败."
	
    Q +myrtn_"^"_errDesc
}

ClassMethod SaveMethod(CurGroupDr As %String, ListStr As %String, ExpStr As %String = "", UserID) As %String
{
	n (CurGroupDr,ListStr,ExpStr,UserID)
	;w ##class(web.PilotProject.DHCDocPilotProject).SaveMethod(1,$p(^gry("SaveMethod"),",",2),"809^Y^")
	//s ^gry("SaveMethod")=CurGroupDr_","_ListStr_","_ExpStr
	s myrtn=0
	for i=1:1:$l(ListStr,"^") {
		s ListStrTemp=$p(ListStr,"^",i)
		s PPRowId=$p(ListStrTemp,"!",1)
		s UserListStr=$p(ListStrTemp,"!",2)
		for j=1:1:$l(UserListStr,$c(1)) {
			s UserListStrTemp=$p(UserListStr,$c(1),j)
			s UserRowId=$p(UserListStrTemp,$c(2),1)
			s UserName=$p(UserListStrTemp,$c(2),2)
			s SamePPCRowId=..FindSameUser(PPRowId,UserRowId)
			if SamePPCRowId="" {
				s myrtn=..InsertProjectCare(CurGroupDr,PPRowId,UserRowId,ExpStr,UserID)
			}else{
				s myrtn=..UpdateProjectCare(SamePPCRowId,ExpStr)
			}
			Q:+myrtn'=0
		}
		Q:+myrtn'=0
	}
	
	Q myrtn
}

ClassMethod FindSameUser(PPRowId As %String, UserRowId As %String) As %String
{
	n (PPRowId,UserRowId)
	s FindPPCRowId=""
	s PPCRowId=0
	for {
		s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) Q:(PPCRowId="")||(FindPPCRowId'="")
		s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
		if JoinUserDr=UserRowId s FindPPCRowId=PPRowId_"||"_PPCRowId
	}
	
	Q FindPPCRowId
}

ClassMethod InsertProjectCare(CurGroupDr As %String, PPRowId As %String, UserRowId As %String, ExpStr As %String = "", UserID) As %String
{
	n (CurGroupDr,PPRowId,UserRowId,ExpStr,UserID)
	s myrtn=0
	TS
	s UObj=##class(User.DHCDocPilotProCare).%New(PPRowId)
	d UObj.PPCPPPParRefSetObjectId(PPRowId)
	d UObj.PPCCurGroupDrSetObjectId(CurGroupDr)
	s UObj.PPCState="N"
	s UObj.PPCStartDate=..%SysDate()
	d UObj.PPCJoinUserDrSetObjectId(UserRowId)
	d UObj.PPCUserDrSetObjectId(UserID)
	Set sc = UObj.%Save()
	b ;ProjectCareSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-106"
	}
	d UObj.%Close()
	i myrtn=0 {
		s myrtn=..UpdateProjectCare(UObj.%Id(),ExpStr)
	}
	if myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q +myrtn
}

ClassMethod UpdateProjectCare(SamePPCRowId As %String, ExpStr As %String = "") As %String
{
	n (SamePPCRowId,ExpStr)
	s SeledUserListStr=$p(ExpStr,"^",1)
	s ContactFlag=$p(ExpStr,"^",2)
	s ContactTel=$p(ExpStr,"^",3)
	
	s myrtn=0
	i SeledUserListStr'="" s SeledUserListStr=$C(1)_SeledUserListStr_$C(1)
	s UObj=##class(User.DHCDocPilotProCare).%OpenId(SamePPCRowId)
	if $IsObject(UObj){
		s JoinUserDr=UObj.PPCJoinUserDrGetObjectId()
		i SeledUserListStr[($C(1)_JoinUserDr_$C(1)) {
			s UObj.PPCContactFlag=ContactFlag
			s UObj.PPCContactTel=ContactTel
		}
		
		Set sc = UObj.%Save()
		b ;ProjectCareUpdate
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-1061"
		}
		d UObj.%Close()
	}
	
	Q myrtn
}

ClassMethod GetProCareInfo(PPRowId As %String, UserRowId As %String) As %String
{
	n (PPRowId,UserRowId)
	s myStr=""
	s PPCRowId=..FindSameUser(PPRowId,UserRowId)
	i PPCRowId'="" {
		s myStr=PPCRowId_"^"_$g(^DHCDocPPC($p(PPCRowId,"||",1),$p(PPCRowId,"||",2)))
	}
	Q myStr
}

ClassMethod DeleteProjectCare(PPRowId As %String, UserRowId As %String) As %String
{
	n (PPRowId,UserRowId)
	s myrtn=0
	s PPCRowId=0
	Ts
	for {
		s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) Q:(PPCRowId="")
		s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
		s PPCUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",12)
		if JoinUserDr=UserRowId {
			
			s RowId=PPRowId_"||"_PPCRowId
			s sc=##class(User.DHCDocPilotProCare).%DeleteId(RowId)
			b ;ProjectCareDelete
			If ($System.Status.IsError(sc))
			{
				
				Set myrtn = "-107"
			}
		}
		if ((myrtn=0)&&(UserRowId=PPCUserDr)&&(JoinUserDr'=UserRowId)){
			s RowId=PPRowId_"||"_PPCRowId
			s sc=##class(User.DHCDocPilotProCare).%DeleteId(RowId)
			b ;ProjectCareDelete
			If ($System.Status.IsError(sc))
			{
				Set myrtn = "-108"
			}
		}
	}
	if myrtn=0 {
			Tc
		}
	else {
		TRO
	}
	
	Q +myrtn
}

ClassMethod CheckPPCodeRlue(PPCodeDesc As %String, paraPPRowId As %String = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).CheckPPCodeRlue(PPCodeDesc)
	//s ^gry("CheckPPCodeRlue")=PPCodeDesc
	n (PPCodeDesc,paraPPRowId)
	s myrtn=0,errDesc=""
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPP(PPRowId)) q:(PPRowId="")||(myrtn'=0)
		if (PPRowId=paraPPRowId) {continue}
		s PPCode=$P(^DHCDocPP(PPRowId),"^",1)
		if PPCode=PPCodeDesc {
			s myrtn="-101"
			continue
		}
		
	}
	if myrtn="-101" s errDesc="项目编码重复"
	
	Q myrtn_"^"_errDesc
}

ClassMethod CheckSaveData(myProObj As web.PilotProject.PPA.DHCDocPilotProject, myExpStr As %String) As %String
{
	n (myProObj,myExpStr)
	s myrtn=0
	;if myProObj.PPCode="" {
		;s myrtn="-200"
	;}
	if myProObj.PPDesc="" {
		s myrtn="-201"
	}
	
	Q myrtn
}

ClassMethod GetUserRowIdBySession() As %String
{
	s UserRowId=##class(User.SSUser).%OpenId(%session.Get("LOGON.USERID")).%Id()
	
	Q UserRowId
}

ClassMethod GetProjectInfoByID(PPRowId As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetProjectInfoByID(16)
	//s ^gry("GetProjectInfoByID")=PPRowId
	s ProObj=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
	if '$IsObject(ProObj) Q ""
	s WebProObj=##class(web.PilotProject.PPA.DHCDocPilotProject).%New()
	s WebProObj.PPCode=ProObj.PPCode
	s WebProObj.PPDesc=ProObj.PPDesc
	s WebProObj.PPOrder=ProObj.PPOrder
	s WebProObj.PPResult=ProObj.PPResult
	s WebProObj.PPRemark=ProObj.PPRemark
	s WebProObj.PPCreateDepartment="",WebProObj.PPCreateDepartmentDr=""
	if $IsObject(ProObj.PPCreateDepartmentDr) {
		s WebProObj.PPCreateDepartmentDr=ProObj.PPCreateDepartmentDr.%Id()
		s WebProObj.PPCreateDepartment=ProObj.PPCreateDepartmentDr.%Id()	//##class(web.DHCOPAdmReg).LocDescFormate($p(^CTLOC(WebProObj.PPCreateDepartmentDr),"^",2)) //$p($p(^CTLOC(WebProObj.PPCreateDepartmentDr),"^",2),"-",2)
		//i WebProObj.PPCreateDepartment="临床药理实验室" s WebProObj.PPCreateDepartment="I期临床试验研究室"
		//i WebProObj.PPCreateDepartment["免疫" s WebProObj.PPCreateDepartment="风湿免疫科"
	}
	if $IsObject(ProObj.PPCreateUserDr) s WebProObj.PPCreateUserDr=ProObj.PPCreateUserDr.%Id()
	s WebProObj.PPCreateDate=ProObj.PPCreateDate
	//if WebProObj.PPCreateDate'="" s WebProObj.PPCreateDate=$zd(WebProObj.PPCreateDate,4)
	s WebProObj.PPCreateDate=##class(websys.Conversions).DateLogicalToHtml(WebProObj.PPCreateDate)
	s WebProObj.PPCreateTime=ProObj.PPCreateTime
	if WebProObj.PPCreateTime'="" s WebProObj.PPCreateTime=..%ZT(WebProObj.PPCreateTime,1)
	s WebProObj.PPStartUser="",WebProObj.PPStartUserDr=""
	if $IsObject(ProObj.PPStartUserDr) {
		s WebProObj.PPStartUserDr=ProObj.PPStartUserDr.%Id()
		s WebProObj.PPStartUser=ProObj.PPStartUserDr.%Id()	//$p(^SSU("SSUSR",WebProObj.PPStartUserDr),"^",2)
	}
	s WebProObj.PPStartDate=ProObj.PPStartDate
	//if WebProObj.PPStartDate'="" s WebProObj.PPStartDate=$zd(WebProObj.PPStartDate,4)
	s WebProObj.PPStartDate=##class(websys.Conversions).DateLogicalToHtml(WebProObj.PPStartDate)
	s WebProObj.PPEndUserDr=ProObj.PPEndUserDr
	s WebProObj.PPEndDate=ProObj.PPEndDate
	//if WebProObj.PPEndDate'="" s WebProObj.PPEndDate=$zd(WebProObj.PPEndDate,4)
	s WebProObj.PPEndDate=##class(websys.Conversions).DateLogicalToHtml(WebProObj.PPEndDate)
	s WebProObj.PPEndTime=ProObj.PPEndTime
	if WebProObj.PPEndTime'="" s WebProObj.PPEndTime=..%ZT(WebProObj.PPEndTime,1)
	s WebProObj.PPBudget=ProObj.PPBudget
	s WebProObj.PPState=ProObj.PPState
	s WebProObj.ApplicationUnit=ProObj.ApplicationUnit
	s WebProObj.PlanNo=ProObj.PlanNo
	s WebProObj.PlanName=ProObj.PlanName
	s WebProObj.ApprovalNo=ProObj.ApprovalNo
	s WebProObj.Role=ProObj.Role
	s WebProObj.ExamReportNum=ProObj.ExamReportNum
	s WebProObj.FileSubmitDate=ProObj.FileSubmitDate
	if WebProObj.FileSubmitDate'="" s WebProObj.FileSubmitDate=$zd(WebProObj.FileSubmitDate,4)
	s WebProObj.EthicsMeetDate=ProObj.EthicsMeetDate
	if WebProObj.EthicsMeetDate'="" s WebProObj.EthicsMeetDate=$zd(WebProObj.EthicsMeetDate,4)
	s WebProObj.EthicsMeetAduitDate=ProObj.EthicsMeetAduitDate
	if WebProObj.EthicsMeetAduitDate'="" s WebProObj.EthicsMeetAduitDate=$zd(WebProObj.EthicsMeetAduitDate,4)
	s WebProObj.ArchivesFilesNo=ProObj.ArchivesFilesNo
	s WebProObj.CollectCompany=ProObj.CollectCompany
	
	s WebProObj.SignProtocolDate=ProObj.SignProtocolDate
	if WebProObj.SignProtocolDate'="" s WebProObj.SignProtocolDate=$zd(WebProObj.SignProtocolDate,4)
	s WebProObj.LeaderCompany=ProObj.LeaderCompany
	s WebProObj.LeaderCompanyPI=ProObj.LeaderCompanyPI
	s WebProObj.CROCompany=ProObj.CROCompany
	;s WebProObj.ApplyMatter=ProObj.ApplyMatter
	s WebProObj.JoinedUser=$$getJoinedUserByParId(PPRowId)
	s WebProObj.Indication=ProObj.Indication
	
	s WebProObj.PilotCategory="",WebProObj.PilotCategoryDr=""
	if $IsObject(ProObj.PilotCategoryDr) {
		s WebProObj.PilotCategoryDr=ProObj.PilotCategoryDr.%Id()
		s WebProObj.PilotCategory=$p($g(^DHCDocCT("DefineData",+ProObj.PilotCategoryDr.%Id(),"D",$p(ProObj.PilotCategoryDr.%Id(),"||",2))),"^",2)
	}
	s WebProObj.SubPilotCategory="",WebProObj.SubPilotCategoryDr=""
	if $IsObject(ProObj.SubPilotCategoryDr) {
		s WebProObj.SubPilotCategoryDr=ProObj.SubPilotCategoryDr.%Id()
		s WebProObj.SubPilotCategory=$p($g(^DHCDocCT("DefineData",+ProObj.SubPilotCategoryDr.%Id(),"D",$p(ProObj.SubPilotCategoryDr.%Id(),"||",2))),"^",2)
	}
	s WebProObj.EthicsFilesNextState="",WebProObj.EthicsFilesNextStateDr=""
	if $IsObject(ProObj.EthicsFilesNextStateDr) {
		s WebProObj.EthicsFilesNextStateDr=ProObj.EthicsFilesNextStateDr.%Id()
		s WebProObj.EthicsFilesNextState=$p($g(^DHCDocCT("DefineData",+ProObj.EthicsFilesNextStateDr.%Id(),"D",$p(ProObj.EthicsFilesNextStateDr.%Id(),"||",2))),"^",2)
	}
	s WebProObj.EthicsFilesState="",WebProObj.EthicsFilesStateDr=""
	if $IsObject(ProObj.EthicsFilesStateDr) {
		s WebProObj.EthicsFilesStateDr=ProObj.EthicsFilesStateDr.%Id()
		s WebProObj.EthicsFilesState=$p($g(^DHCDocCT("DefineData",+ProObj.EthicsFilesStateDr.%Id(),"D",$p(ProObj.EthicsFilesStateDr.%Id(),"||",2))),"^",2)
	}
	s WebProObj.ProjectFilesState="",WebProObj.ProjectFilesStateDr=""
	if $IsObject(ProObj.ProjectFilesStateDr) {
		s WebProObj.ProjectFilesStateDr=ProObj.ProjectFilesStateDr.%Id()
		s WebProObj.ProjectFilesState=$p($g(^DHCDocCT("DefineData",+ProObj.ProjectFilesStateDr.%Id(),"D",$p(ProObj.ProjectFilesStateDr.%Id(),"||",2))),"^",2)
	}
	s WebProObj.IsHeadman="",WebProObj.IsHeadmanDr=""
	if $IsObject(ProObj.IsHeadmanDr) {
		s WebProObj.IsHeadmanDr=ProObj.IsHeadmanDr.%Id()
		s WebProObj.IsHeadman=$p($g(^DHCDocCT("DefineData",+ProObj.IsHeadmanDr.%Id(),"D",$p(ProObj.IsHeadmanDr.%Id(),"||",2))),"^",2)
	}
	
	s WebProObj.ApplyStage="",WebProObj.ApplyStageDr=""
	if $IsObject(ProObj.ApplyStageDr) {
		s WebProObj.ApplyStageDr=ProObj.ApplyStageDr.%Id()
		s WebProObj.ApplyStage=$p($g(^DHCDocCT("DefineData",+ProObj.ApplyStageDr.%Id(),"D",$p(ProObj.ApplyStageDr.%Id(),"||",2))),"^",2)
	}
	s WebProObj.ApplyMatter="",WebProObj.ApplyMatterDr=""
	if $IsObject(ProObj.ApplyMatterDr) {
		s WebProObj.ApplyMatterDr=ProObj.ApplyMatterDr.%Id()
		s WebProObj.ApplyMatter=$p($g(^DHCDocCT("DefineData",+ProObj.ApplyMatterDr.%Id(),"D",$p(ProObj.ApplyMatterDr.%Id(),"||",2))),"^",2)
	}
	if $IsObject(ProObj.StudyType) {
		s WebProObj.StudyType=ProObj.StudyType.%Id()
		//s WebProObj.StudyType=$p($g(^DHCDocCT("DefineData",+ProObj.StudyType.%Id(),"D",$p(ProObj.ApplyMatterDr.%Id(),"||",2))),"^",2)
	}
	s WebProObj.EndYear=ProObj.EndYear
	s WebProObj.DeptCode=ProObj.DeptCode
	s WebProObj.ProjectNo=ProObj.ProjectNo
	s WebProObj.FileCaseNo=ProObj.FileCaseNo
	s WebProObj.ApplyContact=ProObj.ApplyContact
	s WebProObj.ApplyContactTel=ProObj.ApplyContactTel
	s WebProObj.CROContact=ProObj.CROContact
	s WebProObj.CROContactTel=ProObj.CROContactTel
	s WebProObj.CountUnitContact=ProObj.CountUnitContact
	s WebProObj.CountUnitContactTel=ProObj.CountUnitContactTel
	s WebProObj.DesignCaseNum=ProObj.DesignCaseNum
	s WebProObj.LocalGroupPlanCaseNum=ProObj.LocalGroupPlanCaseNum
	s WebProObj.LocalGroupFactCaseNum=ProObj.LocalGroupFactCaseNum
	s WebProObj.LastCaseDate=ProObj.LastCaseDate
	if WebProObj.LastCaseDate'="" s WebProObj.LastCaseDate=$zd(WebProObj.LastCaseDate,4)
	s WebProObj.FilterCaseNum=ProObj.FilterCaseNum
	s WebProObj.RejectCaseNum=ProObj.RejectCaseNum
	s WebProObj.DropCaseNum=ProObj.DropCaseNum
	s WebProObj.SAECaseNum=ProObj.SAECaseNum
	s WebProObj.BriefDate=ProObj.BriefDate
	if WebProObj.BriefDate'="" s WebProObj.BriefDate=$zd(WebProObj.BriefDate,4)
	s WebProObj.CenterDate=ProObj.CenterDate
	if WebProObj.CenterDate'="" s WebProObj.CenterDate=$zd(WebProObj.CenterDate,4)
	s WebProObj.SumDate=ProObj.SumDate
	if WebProObj.SumDate'="" s WebProObj.SumDate=$zd(WebProObj.SumDate,4)
	s WebProObj.FilingDate=ProObj.FilingDate
	if WebProObj.FilingDate'="" s WebProObj.FilingDate=$zd(WebProObj.FilingDate,4)
	s WebProObj.SaveLastDate=ProObj.SaveLastDate
	s WebProObj.GroupTransferUser=ProObj.GroupTransferUser
	s WebProObj.recipient=ProObj.recipient
	;s WebProObj.EthicsFilesOffStatusDr=ProObj.EthicsFilesOffStatusDr
	s WebProObj.EthicsFilesOffDate=ProObj.EthicsFilesOffDate
	if WebProObj.EthicsFilesOffDate'="" s WebProObj.EthicsFilesOffDate=$zd(WebProObj.EthicsFilesOffDate,4)
	s WebProObj.EthicsFilesOffOperator=ProObj.EthicsFilesOffOperator
	s WebProObj.EthicsFilesOffCompany=ProObj.EthicsFilesOffCompany
	s WebProObj.EthicsFilesOffTel=ProObj.EthicsFilesOffTel
	s WebProObj.ImageDataLocation=ProObj.ImageDataLocation
	s WebProObj.ImageDataNum=ProObj.ImageDataNum
	s WebProObj.FileNum=ProObj.FileNum
	s WebProObj.FormConsentNum=ProObj.FormConsentNum
	s WebProObj.CaseReportNum=ProObj.CaseReportNum
	s WebProObj.EthicsFilesNum=ProObj.EthicsFilesNum
	s WebProObj.OrigRecordNum=ProObj.OrigRecordNum
	s WebProObj.TotalFileNum=ProObj.TotalFileNum
	s WebProObj.RegNo=ProObj.RegNo
	s WebProObj.Filingstatus="",WebProObj.FilingstatusDr=""
	if $IsObject(ProObj.FilingstatusDr) {
		s WebProObj.FilingstatusDr=ProObj.FilingstatusDr.%Id()
		s WebProObj.Filingstatus=$p($g(^DHCDocCT("DefineData",+ProObj.FilingstatusDr.%Id(),"D",$p(ProObj.FilingstatusDr.%Id(),"||",2))),"^",2)
	}	
	s WebProObj.EthicsFilesOffStatus="",WebProObj.EthicsFilesOffStatusDr=""
	if $IsObject(ProObj.EthicsFilesOffStatusDr) {
		s WebProObj.EthicsFilesOffStatusDr=ProObj.EthicsFilesOffStatusDr.%Id()
		s WebProObj.EthicsFilesOffStatus=$p($g(^DHCDocCT("DefineData",+ProObj.EthicsFilesOffStatusDr.%Id(),"D",$p(ProObj.EthicsFilesOffStatusDr.%Id(),"||",2))),"^",2)
	}	
	s OtherDepStr=$$getOtherDept(PPRowId,"RowId")
	s OtherDepartment=$$getOtherDept(PPRowId,"Desc")
	s WebProObj.OtherDepStr=OtherDepStr
	s WebProObj.OtherDepartment=OtherDepartment
	s WebProObj.PPFileRemark=ProObj.PPFileRemark
	s WebProObj.FirstPatDate=ProObj.FirstPatDate
	if WebProObj.FirstPatDate'="" s WebProObj.FirstPatDate=$zd(WebProObj.FirstPatDate,4)
	s WebProObj.BriefRemark=ProObj.BriefRemark
	s WebProObj.CenterRemark=ProObj.CenterRemark
	s WebProObj.ConclusionRemark=ProObj.ConclusionRemark
	if $IsObject(ProObj.Brief) {
		s WebProObj.BriefDr=ProObj.Brief.%Id()
		s WebProObj.Brief=$p($g(^DHCDocCT("DefineData",+ProObj.Brief.%Id(),"D",$p(ProObj.Brief.%Id(),"||",2))),"^",2)
	}
	if $IsObject(ProObj.Center) {
		s WebProObj.CenterDr=ProObj.Center.%Id()
		s WebProObj.Center=$p($g(^DHCDocCT("DefineData",+ProObj.Center.%Id(),"D",$p(ProObj.Center.%Id(),"||",2))),"^",2)
	}
	if $IsObject(ProObj.Conclusion) {
		s WebProObj.ConclusionDr=ProObj.Conclusion.%Id()
		s WebProObj.Conclusion=$p($g(^DHCDocCT("DefineData",+ProObj.Conclusion.%Id(),"D",$p(ProObj.Conclusion.%Id(),"||",2))),"^",2)
	}
	s WebProObj.EndQualityCtrlFlag=ProObj.EndQualityCtrlFlag
	s WebProObj.OpenOrdEntryLimit=ProObj.OpenOrdEntryLimit
	s WebProObj.PPNum=ProObj.PPNum
	s WebProObj.PPInterFlag=ProObj.PPInterFlag
	d WebProObj.XMLExportToString(.rtnStr)
	    
	Q rtnStr
getJoinedUserByParId(ParId)
    s myStr=""
    s PPCRowId=0
    for {
	    s PPCRowId=$O(^DHCDocPPC(ParId,PPCRowId)) Q:PPCRowId=""
	    s PPCJoinUserDr=$p(^DHCDocPPC(ParId,PPCRowId),"^",1)
	    s PPCJoinUser=""
	    if PPCJoinUserDr'="" s PPCJoinUser=$p(^SSU("SSUSR",PPCJoinUserDr),"^",2)
	    if myStr="" s myStr=PPCJoinUser
	    else  s myStr=myStr_","_PPCJoinUser
    }
    
    Q myStr
getOtherDept(ParId,flag)
  s strID=""
  s str=""
  s sub=0
  s OtherDepartment=""
  s OtherDepStr=""
  for {
	    s sub=$O(^DHCDocPPD(ParId,sub)) Q:sub=""
	    s DepDr=$p(^DHCDocPPD(ParId,sub),"^",1)
	    s UserDr=$p(^DHCDocPPD(ParId,sub),"^",2)
	    s Dep=""
	    if DepDr'="" s Dep=$p(^CTLOC(DepDr),"^",2)
	   // i Dep="临床药理实验室" s Dep="I期临床试验研究室"
		//i Dep["免疫" s Dep="风湿免疫科"
	    if Dep["-" s Dep=$p(Dep,"-",2)
	    s User=""
	    if UserDr'="" s User=$p(^SSU("SSUSR",UserDr),"^",2)
	   	if OtherDepStr="" s OtherDepStr=DepDr_"-"_UserDr
		else  s OtherDepStr=OtherDepStr_"^"_DepDr_"-"_UserDr
		if OtherDepartment="" s OtherDepartment=Dep_"-"_User
	   else  s OtherDepartment=OtherDepartment_";"_Dep_"-"_User
    }
  i flag="RowId" q OtherDepStr
  else  q OtherDepartment
}

ClassMethod GetJoinUserStrByProID(PPRowId As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetJoinUserStrByProID(16)
	//s ^gry("GetJoinUserStrByProID")=PPRowId
	Q:PPRowId="" ""
	s langid=..%LanguageID()
	s rtnStr=""
	s PPCRowId=0
	for {
	    s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) Q:PPCRowId=""
	    s PPCJoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
	    s PPCJoinUserDesc=""
		if PPCJoinUserDr'="" {
			s PPCJoinUserDesc=$p($g(^SSU("SSUSR",PPCJoinUserDr)),"^",2)
			s PPCJoinUserDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PPCJoinUserDesc,langid)
			if rtnStr="" s rtnStr=PPCJoinUserDr_$C(1)_PPCJoinUserDesc
			else  s rtnStr=rtnStr_"^"_PPCJoinUserDr_$C(1)_PPCJoinUserDesc
		}
    }
	
	Q rtnStr
}

ClassMethod GetProjectStr() As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetProjectStr()
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:LookUpProject")
	do rset.Execute()
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		set ret=rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(3)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

// 获得主要研究者项目

/// w ##class(web.PilotProject.DHCDocPilotProject).GetProjectStrSelf(InHosp,UserID)
ClassMethod GetProjectStrSelf(InHosp = "", UserID = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetProjectStr()
	s ret1=""
	s langid=..%LanguageID()
    s PPRowId=0
    i UserID="" s UserID=%session.Get("LOGON.USERID")
    i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
    .s PPState=$p(^DHCDocPP(PPRowId),"^",16)
    .q:(PPState'="N")&&(PPState'="V")&&(PPState'="C") //非立项  在研 发布后研 状态退出
    .s flag=0
    .s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
    .s PPDesc=$p(^DHCDocPP(PPRowId),"^",2)
    .s PPDesc= ##class(User.DHCDocPilotProject).GetTranByDesc("PPDesc",PPDesc,langid)
    .s PPStartDate=$p(^DHCDocPP(PPRowId),"^",11)
    .s PPEndDate=$p(^DHCDocPP(PPRowId),"^",13)
    .q:(PPStartDate'="")&&(PPStartDate>+$h)
    .q:(PPEndDate'="")&&(PPEndDate<+$h)
    .s PPCreateLoc=$p(^DHCDocPP(PPRowId),"^",6)
    .s Hosp=$P($g(^CTLOC(PPCreateLoc)),"^",22)
    .q:(InHosp'="")&&(InHosp'=Hosp)
	.s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
    .i ((UserID=ProStartUserDr)||(UserID=UserUserDr)) s flag=1
    .i flag'=1 d
    ..s child=""
    ..f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	...s ProStartUserDr=""
	...s UserUserDr=""
	...s ProStartUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	...s UserUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	...i ((UserID=ProStartUserDr)||(UserID=UserUserDr))  s flag=1
	.i flag=1 d
	..set ret=PPRowId_$C(1)_PPDesc_"-"_PPCode
	..i ret1="" s ret1=ret
	..e  s ret1=ret_"^"_ret1
	Q ret1
}

// 获得主要研究者，医生项目

ClassMethod GetProjectStrDocSelf(UserID As %String = "", InHosp = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetProjectStrDocSelf(12175)
	s langid=..%LanguageID()
	s ret1=""
    s PPRowId=0
    i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    s:UserID="" UserID=%session.Get("LOGON.USERID")
    f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
    .s flag=0
    .s dflag=""
    .s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
    .s PPDesc=$p(^DHCDocPP(PPRowId),"^",2)
    .s PPDesc= ##class(User.DHCDocPilotProject).GetTranByDesc("PPDesc",PPDesc,langid)
    .s PlanName=$p(^DHCDocPP(PPRowId),"^",27)
    .s CreateLoc=$p(^DHCDocPP(PPRowId),"^",6)
    .s Hosp=$P($g(^CTLOC(CreateLoc)),"^",22)
    .q:(InHosp'="")&&(Hosp'=InHosp)
	.s ProState=""
    .s State=$p($g(^DHCDocPP(PPRowId)),"^",16)
	.i State="I" s ProState="审批中"
	.i State="U" s ProState="未批准"
	.i State="N" s ProState="立项"
	.i State="A" s ProState="暂停"
	.i State="S" s ProState="终止"
	.i State="V" s ProState="在研"
	.i State="F" s ProState="已完成"
	.i State="B" s ProState="中止"
	.i State="H" s ProState="未进行"
	.i State="E" s ProState="非大表项目，财务专用"
	.i State="D" s ProState="上会未通过"
	.i State="P" s ProState="发补后在研"
    .Q:(State'="V")&&(State'="N")
	.s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
    .i ((UserID=ProStartUserDr)||(UserID=UserUserDr)) s flag=1
    .i flag'=1 d
    ..s child=""
    ..f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	...s ProStartUserDr=""
	...s UserUserDr=""
	...s ProStartUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	...s UserUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	...i ((UserID=ProStartUserDr)||(UserID=UserUserDr))  s flag=1
	.s PPCRowId=0,FindPPC=""
	.for  s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) q:PPCRowId=""  d
	..s JionUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
	..s State=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",5)
	..q:State'="N"
	..s StartDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",6)
	..s EndDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",7)
	..q:((StartDate>+$h)&&(StartDate'=""))||((EndDate<+$h)&&(EndDate'=""))
	..if (JionUserDr=UserID) s dflag=1
	.i ((flag=1)||(dflag=1)) d
	..set ret=PPRowId_$C(1)_PPDesc_"-"_PPCode_$C(1)_PlanName
	..i ret1="" s ret1=ret
	..e  s ret1=ret_"^"_ret1
	Q ret1
}

ClassMethod GetProjectStrByUser(UserID As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetProjectStrByUser()
	n (UserID)
	Q:UserID="" ""
	s UserProStr=""
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPPC("JoinUserDr",0,UserID,PPRowId))
		Q:PPRowId=""
		s ProCode=$p(^DHCDocPP(PPRowId),"^",1)
		s ProDesc=$p(^DHCDocPP(PPRowId),"^",2)
		s ProStartDate=$p(^DHCDocPP(PPRowId),"^",11)
		s ProEndDate=$p(^DHCDocPP(PPRowId),"^",13)
		s ProState=$p(^DHCDocPP(PPRowId),"^",16)
		if (ProState'="N")||((ProStartDate>+$h)&&(ProStartDate'=""))||((ProEndDate<+$h)&&(ProEndDate'="")) continue
		s PPCRowId=0,FindPPC=""
		for {
			s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId))
			Q:PPCRowId=""
			s JionUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
			s State=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",5)
			if State'="N" continue
			s StartDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",6)
			s EndDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",7)
			
			if ((StartDate>+$h)&&(StartDate'=""))||((EndDate<+$h)&&(EndDate'="")) continue
			if JionUserDr=UserID s FindPPC=PPRowId_$c(1)_ProCode_"-"_ProDesc
			Q:FindPPC'=""
		}
		if (UserProStr="") s UserProStr=FindPPC
		else  if (FindPPC'="") s UserProStr=UserProStr_"^"_FindPPC
	}
	Q UserProStr
}

ClassMethod GetStartUserStr(StartLocID As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetStartUserStr(484)
	//s ^gry("GetStartUserStr")=StartLocID
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindStartUser")
	do rset.Execute(StartLocID,"")
	Set columns = rset.GetColumnCount()
	set row=0
	While ((rset.Next())) {
		s row=row+1
		set ret=rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(3)_"-"_rset.GetData(1)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

ClassMethod GetStartUserStrMethod(StartLocID As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetStartUserStr()
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindStartUser")
	do rset.Execute(StartLocID,"")
	Set columns = rset.GetColumnCount()
	set row=0
	While ((rset.Next())) {
		s row=row+1
		set ret=rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(3)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

ClassMethod GetOPDeptStr() As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetOPDeptStr()
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindLoc")
	do rset.Execute("")
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set ret=rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(4)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

ClassMethod GetOPDeptStr1() As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetOPDeptStr1()
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:LookUpAllLoc")
	do rset.Execute("")
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set ret=rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(4)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

ClassMethod getCreateDepartment(ProRowId As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).getCreateDepartment(16)
	s ret=""
	Q:ProRowId="" ""
	s ret=$p(^DHCDocPP(ProRowId),"^",6)
	
	Q ret
}

/*ClassMethod StatusChangeMethod(Para As %String, Status As %String) As %String
{
	n (Para,Status)
	s PPRowId=$p(Para,"^",1)
	s AuthUserRowId=$p(Para,"^",2)
	s UpdateReason=$p(Para,"^",3)
	s UserRowId=$p(Para,"^",4)
	;改变主变的状态
	s myrtn=0
	s ProObj=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
	if '$IsObject(ProObj) quit "-100"
	if " A N S "'[" "_Status_" " quit "-101"
	TS
	i ((ProObj.EthicsMeetAduitDate'="")&&(Status="N")) s Status="V"
	s ProObj.PPState=Status
	s sc=ProObj.%Save()
	s PPSPPParRef=ProObj.%Id()
	b ;ProjectSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-102"
	}
	d ProObj.%Close()
	if +myrtn=0 {
		;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPSPPParRef
		s ProjectStateObj.PPSCurState=Status
		s ProjectStateObj.PPSUpdateUserDr=UserRowId
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		s ProjectStateObj.PPSUpdateReason=UpdateReason
		s ProjectStateObj.PPSAuthUserDr=AuthUserRowId    ;批准人
		s myrtn=..InsertProjectState(ProjectStateObj)
	}
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q myrtn
}*/
ClassMethod StatusChangeMethod(PPRowId As %String, Status As %String) As %String
{
	
	;改变主变的状态
	s myrtn=0
	s ProObj=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
	if '$IsObject(ProObj) quit "-100"
	TS
	s ProObj.PPState=Status
	s sc=ProObj.%Save()
	s PPSPPParRef=ProObj.%Id()
	b ;ProjectSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-102"
	}
	d ProObj.%Close()
	if +myrtn=0 {
		;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPSPPParRef
		s ProjectStateObj.PPSCurState=Status
		;s ProjectStateObj.PPSUpdateUserDr=UserRowId
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		;s ProjectStateObj.PPSUpdateReason="手工修改"
		;s ProjectStateObj.PPSAuthUserDr=AuthUserRowId    ;批准人
		s myrtn=..InsertProjectState(ProjectStateObj)
	}
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q myrtn
}

ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocExecute(ByRef QHandle As %Binary, Loc As %String = "", User As %String = "", InHosp = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindLoc","",6,2)
	Set repid=$I(^CacheTemp)
	s ind=1
	s temFlag=0
	s ^TEMP("QP","FindLocExecute")=$LB(Loc,User,InHosp)
	i (User'="") d
	.s InUser=$p(^SSU("SSUSR",User),"^",14)
	.q:InUser=""
	.s beLoc=""
	.f  s beLoc=$o(^RB("RES",0,"CTPCP",InUser,beLoc)) q:beLoc=""  d
	..s mData(beLoc)=beLoc
	..s temFlag=1
	
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.q:$g(^UDHCDocPilotProConfig("DeptApprove",rowid))'=1
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.//i $l(CTDesc,"-")=2 s CTDesc=$p(CTDesc,"-",2)
	.//i CTDesc="临床药理实验室" s CTDesc="I期临床试验研究室"
	.//i CTDesc["免疫" s CTDesc="风湿免疫科"
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.s Hosp=$p($g(^CTLOC(rowid)),"^",22)
	.q:(InHosp'="")&&(InHosp'=Hosp)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)   ;现在维护科室别名的地方
	.//s CTContactName=$P($p($g(^CTLOC(rowid)),"^",2),"-",1)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.;w CTDesc_","_CTContactName_","_(CTContactName'[(Loc))_","_(CTDesc'[(Loc)),!
	.//Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.Q:##class(web.DHCOPAdmReg).CheckLocDesc(rowid,Loc)'=1
	.;Q:(User'="")&&(temFlag=0)&&('$d(mData(rowid)))
	.Q:(User'="")&&('$d(mData(rowid)))
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CTDesc,CTCode,rowid,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
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

Query FindLoc(Loc As %String, User As %String = "", InHosp = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,RowId:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod FindStartUserClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindStartUserExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindStartUserExecute(ByRef QHandle As %Binary, PPStartUser As %String, InHosp = "", ShowCode = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindStartUser","")
	Set repid=$I(^CacheTemp)
	s ind=1
    s PPStartUserD=$ZCVT(PPStartUser,"U")
	s langid=..%LanguageID()
		/*s CTPCPRowId=0
		for  s CTPCPRowId=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId)) Q:CTPCPRowId=""  d
		.s StartLocID=$O(^RB("RES",0,"CTPCP",CTPCPRowId,0))
		.;Q:StartLocID=""   ;此医生没有加入过任何科室资源
		.s DocCode=$p(^CTPCP(CTPCPRowId,1),"^",1)
		.s DocDesc=$p(^CTPCP(CTPCPRowId,1),"^",2)
		.s OtherName=$p($g(^CTPCP(CTPCPRowId,3)),"^",28)
		.s SSUSRRowId=0
		.for  s SSUSRRowId=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId,SSUSRRowId)) Q:SSUSRRowId=""  d
		..s SSUSRName=$P(^SSU("SSUSR",SSUSRRowId),"^",2)
		..s SSUSRInitials=$P(^SSU("SSUSR",SSUSRRowId),"^",1)
		..s DefaultDeptDr=$P(^SSU("SSUSR",SSUSRRowId),"^",4)
		..s DefaultDept=""
		..s:DefaultDeptDr'="" DefaultDept=$p($p($g(^CTLOC(DefaultDeptDr)),"^",2),"-",2)
		..q:((OtherName'[PPStartUser)&&(SSUSRName'[PPStartUser)&&(PPStartUser'="")&&(SSUSRName'[PPStartUserD)&&(OtherName'[PPStartUserD))
		..d OutputRowStartUser*/
		
	/*}else{
		s CTPCPRowId=0
		for  s CTPCPRowId=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId)) Q:CTPCPRowId=""  d
		.s RBRowId=$O(^RB("RES",0,"CTPCP",CTPCPRowId,StartLocID,0))
		.Q:RBRowId=""   ;没有找到资源,此用户不可登陆传入科室中
		.Q:'($D(^RB("RES",RBRowId)))
		.set ScheSt=$p(^RB("RES",RBRowId),"^",6)
		.S DocID=$p(^RB("RES",RBRowId),"^",2)
		.Q:DocID=""
		.s DocCode=$p(^CTPCP(DocID,1),"^",1)
		.s DocDesc=$p(^CTPCP(DocID,1),"^",2)
		.s SSUSRRowId=0
		.for  s SSUSRRowId=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId,SSUSRRowId)) Q:SSUSRRowId=""  d
		..s SSUSRName=$P(^SSU("SSUSR",SSUSRRowId),"^",2)
		..s Othername=$p($g(^CTPCP(DocID,3)),"^",28)
		..s SSUSRInitials=$P(^SSU("SSUSR",SSUSRRowId),"^",1)
		..d OutputRowStartUser
	}*/
	 s SSUSRRowId=""
	 f  s SSUSRRowId=$O(^SSU("SSUSR",SSUSRRowId)) Q:SSUSRRowId=""  d
	 .s SSUSRName=$P(^SSU("SSUSR",SSUSRRowId),"^",2)
	 .q:SSUSRName=""
	 .s SSUSRName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",SSUSRName,langid)
	 .s SSUSRInitials=$P(^SSU("SSUSR",SSUSRRowId),"^",1)
	 .s CTPCPRowId=$P(^SSU("SSUSR",SSUSRRowId),"^",14)
	 .s StartDate=$P(^SSU("SSUSR",SSUSRRowId),"^",96)
	 .s EndDate=$P(^SSU("SSUSR",SSUSRRowId),"^",97)
	 .s SActive=$P(^SSU("SSUSR",SSUSRRowId),"^",19)
	 .Q:(StartDate'="")&&(StartDate>+$h)
	 .Q:(EndDate'="")&&(EndDate<+$h)
	 .q:SActive'="Y"
	 .s OtherName=""
	 .i CTPCPRowId='"" s OtherName=$p($g(^CTPCP(CTPCPRowId,3)),"^",28)
	 .s DefaultDeptDr=$P(^SSU("SSUSR",SSUSRRowId),"^",4)
	 .s DefaultDept=""
	 .s:DefaultDeptDr'="" DefaultDept=##class(web.DHCOPAdmReg).LocDescFormate($p($g(^CTLOC(DefaultDeptDr)),"^",2)) //$p($p($g(^CTLOC(DefaultDeptDr)),"^",2),"-",2)
	 .//q:((OtherName'[PPStartUser)&&(SSUSRName'[PPStartUser)&&(PPStartUser'="")&&(SSUSRName'[PPStartUserD)&&(OtherName'[PPStartUserD))
	 .q:((PPStartUserD'="")&&(OtherName'[PPStartUser)&&(SSUSRName'[PPStartUser)&&(PPStartUser'="")&&(SSUSRName'[PPStartUserD)&&(OtherName'[PPStartUserD))
	 .s AllHosp=$p(^SSU("SSUSR",SSUSRRowId),"^",98)	;
     .s sub=""
	 .f  s sub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",sub)) q:sub=""  d
	 ..s cHosp=$p(^SSU("SSUSR",SSUSRRowId,"OTHLL",sub),"^",3)
	 ..q:cHosp=""
	 ..i AllHosp="" s AllHosp=cHosp
	 ..e  d
	 ...i ##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,cHosp)'=1 s AllHosp=AllHosp_","_cHosp
     .q:(InHosp'="")&&(##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,InHosp)'=1)
	 .d OutputRowStartUser
	 
	 
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowStartUser
	i ShowCode="Y" s SSUSRName=SSUSRName_"("_SSUSRInitials_")"
	set Data=$lb(SSUSRName,SSUSRRowId,SSUSRInitials,DefaultDept)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariablesStartUser
	///set (repid)=0
	set (SSUSRName,SSUSRRowId,SSUSRInitials)=""
	quit
}

ClassMethod FindStartUserFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStartUserExecute ]
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

Query FindStartUser(PPStartUser As %String, InHosp = "", ShowCode = "") As %Query(ROWSPEC = "Desc:%String:姓名,Hidden:%String,SSUSRInitials:%String:工号,DefaultDept:%String:默认登陆科室") [ SqlProc ]
{
}

ClassMethod FindProjectClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindProjectExecute(ByRef QHandle As %Binary, PPCode As %String, PPDesc As %String, Flag As %String, PlanNo As %String = "", PlanName As %String, ApplicationUnit As %String, PilotCategoryDr As %String, ApprovalNo As %String, ApplyMatterDr As %String, ApplyStageDr As %String, IsHeadmanDr As %String, PPCreateDepartmentDr As %String, PPStartUserDr As %String, Indication, ArchivesFilesNo, Exp As %String = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProject","","",,"")
	//s CFDr=%request.Get("CFDr")
	//s ^gry("FindProjectExecute")=PPCode_","_PPDesc_"^"_StatusID
	//s ^zhangkui("1")=PPCode_","_PPDesc_","_Flag_","_PlanNo_","_PlanName_","_ApplicationUnit_","_PilotCategoryDr_","_ApprovalNo_","_ApplyMatterDr_","_ApplyStageDr_","_IsHeadmanDr_","_PPCreateDepartmentDr_","_PPStartUserDr_","_CFDr
	k ^tmpFindProject
	s StatusID=$p(Exp,"^",1)
	s CFDr=$p(Exp,"^",2)
	s StartDate=$p(Exp,"^",3)
	s EndDate=$p(Exp,"^",4)
	s InHosp=$p(Exp,"^",5)
	s StartDate=..%ZDH(StartDate)
	s EndDate=..%ZDH(EndDate)
	Set repid=$I(^CacheTemp)
	s ind=1
	s count=1
	;s PPCode=$ZCVT(PPCode,"U")
	;s PPDesc=$ZCVT(PPDesc,"U")
	;if ((PPCode="")&&(PPDesc="")) Set QHandle=$lb(0,repid,0)  Quit $$$OK
	;if $l(PPStartDate,"/")=3 s PPStartDate=$zdh(PPStartDate,4)
	;if $l(PPEndDate,"/")=3 s PPEndDate=$zdh(PPEndDate,4)
	
	s ProRowId=0 f  s ProRowId=$o(^DHCDocPP(ProRowId)) q:ProRowId=""  d
	.d ResetVariablesPro
	.s userflag=0
	.s ProDesc=$P(^DHCDocPP(ProRowId),"^",2)
	.s PPAccount=..GetAccountByUser(ProRowId,"") //阳远
	.;s ProDesc=$ZCVT(ProDesc,"U")
	.s ProCode=$p($g(^DHCDocPP(ProRowId)),"^",1)
	.;s ProCode=$ZCVT(ProCode,"U")
	.s PorCreateDate=$p($g(^DHCDocPP(ProRowId)),"^",8)
	.q:(StartDate'="")&&(PorCreateDate<StartDate)
	.q:(EndDate'="")&&(PorCreateDate>EndDate)
	.if PorCreateDate'="" s PorCreateDate=..%ZD(PorCreateDate)
	.s ProStartDate=$p($g(^DHCDocPP(ProRowId)),"^",11)
	.if ProStartDate'="" s ProStartDate=..%ZD(ProStartDate)
	.s ProEndDate=$p($g(^DHCDocPP(ProRowId)),"^",13)
	.if ProEndDate'="" s ProEndDate=..%ZD(ProEndDate)
	.s SumDate=$p($g(^DHCDocPP(ProRowId)),"^",68)
	.s:SumDate'="" SumDate=..%ZD(SumDate)
	.s CenterDate=$p($g(^DHCDocPP(ProRowId)),"^",67)
	.s:CenterDate'="" CenterDate=$zd(CenterDate,3)
	.s BriefDate=$p($g(^DHCDocPP(ProRowId)),"^",66)
	.s:BriefDate'="" BriefDate=..%ZD(BriefDate) //$zd(BriefDate,3)
    .;总结日期优先取BriefDate>CenterDate>SumDate
    .i SumDate'="" s ProEndDate=SumDate
    .i CenterDate'="" s ProEndDate=CenterDate
    .i BriefDate'="" s ProEndDate=BriefDate
	.S ProCreateDepartmen=""
	.s ProCreateDepartmenDr=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.q:ProCreateDepartmenDr=""
	.s Hosp=$P(^CTLOC(ProCreateDepartmenDr),"^",22)
	.q:(InHosp'="")&&(InHosp'=Hosp)
	.if ProCreateDepartmenDr'="" s ProCreateDepartmen=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(ProCreateDepartmenDr),"^",2)) //$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	.//i ProCreateDepartmen="临床药理实验室" s ProCreateDepartmen="I期临床试验研究室"
	.//i ProCreateDepartmen["免疫" s ProCreateDepartmen="风湿免疫科"
	.s ProStartUserDr=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.S ProStartUser=""
	.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	.s ProBudget=$p($g(^DHCDocPP(ProRowId)),"^",15)
	.s:ProBudget'="" ProBudget=$j(ProBudget,3,2)
	.s ProState=""
	.s State=$p($g(^DHCDocPP(ProRowId)),"^",16)
	.s ProState=##class(web.PilotProject.Extend.E1).GetProjectDesc(State)
	.q:((StatusID'="")&&(StatusID'=State))
	.q:(((Flag'="Pay")&&(Flag'="ConfirmPay")&&(Flag'="Settle"))&&(State="E"))
	.s childsub=0
	.s PPSUpdateReason=""
	.f  s childsub=$o(^DHCDocPPS(ProRowId,childsub)) q:childsub=""  d
	..;s PPSUpdateReason=$p($g(^DHCDocPPS(ProRowId,childsub)),"^",8)
	..s PPSUpdateState=$p($g(^DHCDocPPS(ProRowId,childsub)),"^",1)
	..s PPSUpdateStateDesc=##class(web.PilotProject.Extend.E1).GetProjectDesc(PPSUpdateState)
	..i PPSUpdateReason="" s PPSUpdateReason=PPSUpdateStateDesc
	..e  s PPSUpdateReason=PPSUpdateReason_"->"_PPSUpdateStateDesc
	.q:((Flag="ProApprove")&&(State'="N"))
	.s ApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",46)
	.q:((ApproveResult="N")&&(Flag'="Pay"))
	.s PlanNonow=$p($g(^DHCDocPP(ProRowId)),"^",26)
	.q:(PlanNo'="")&&(PlanNonow'[PlanNo)
	.s CheckFreqDrnow=$p($g(^DHCDocPP(ProRowId)),"^",95)  ;跟踪审查频率，add by nk
	.q:(CFDr'="")&&(CheckFreqDrnow'=CFDr)
	.s PlanNamenow=$p($g(^DHCDocPP(ProRowId)),"^",27)
	.q:(PlanName'="")&&(PlanNamenow'[PlanName)
	.s ApplicationUnitnow=$p($g(^DHCDocPP(ProRowId)),"^",25)
	.q:(ApplicationUnit'="")&&(ApplicationUnitnow'[ApplicationUnit)
	.s PilotCategoryDrnow=$p($g(^DHCDocPP(ProRowId)),"^",18)
	.q:(PilotCategoryDr'="")&&(PilotCategoryDr'=PilotCategoryDrnow)
	.s ApprovalNonow=$p($g(^DHCDocPP(ProRowId)),"^",28)
	.q:(ApprovalNo'="")&&( ApprovalNo'=ApprovalNonow)
	.s ApplyMatterDrnow=$p($g(^DHCDocPP(ProRowId)),"^",23)
	.q:(ApplyMatterDr'="")&&(ApplyMatterDrnow'=ApplyMatterDr)
	.s ApplyStageDrnow=$p($g(^DHCDocPP(ProRowId)),"^",24)
	.q:(ApplyStageDr'="")&&(ApplyStageDr'=ApplyStageDrnow)
	.s IsHeadmanDrnow=$p($g(^DHCDocPP(ProRowId)),"^",22)
	.q:(IsHeadmanDr'="")&&(IsHeadmanDr'=IsHeadmanDrnow)
	.s PPCreateDepartmentDrnow=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.;q:(PPCreateDepartmentDr'="")&&(PPCreateDepartmentDrnow'=PPCreateDepartmentDr)
	.s PPStartUserDrnow=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.i (PPStartUserDr'="")&&(PPStartUserDrnow=PPStartUserDr) s userflag=1
	.s Indicationnow=$p($g(^DHCDocPP(ProRowId)),"^",17)
	.q:(Indication'="")&&(Indicationnow'=Indication)
	.q:((Flag="EcApprove")&&((ApproveResult'="Y")||(ProState="已完成")))
	.s EthicsMeetDate=$p($g(^DHCDocPP(ProRowId)),"^",32)
	.s:EthicsMeetDate'="" EthicsMeetDate=$zd(EthicsMeetDate,3)
	.i EthicsMeetDate="" s EthicsMeetDate=$p($g(^DHCDocPP(ProRowId)),"^",113)
	.s EthicsMeetAduitDate=$p($g(^DHCDocPP(ProRowId)),"^",33)
	.s EMADate=""
	.s:EthicsMeetAduitDate'="" EMADate=$zd(EthicsMeetAduitDate,3)
	.s:EthicsMeetAduitDate'="" EthicsMeetAduitDate=$zd(EthicsMeetAduitDate,4)
	.s ArchivesFilesNoNew=$p($g(^DHCDocPP(ProRowId)),"^",34)
	.q:((ArchivesFilesNo'="")&&(ArchivesFilesNo'=ArchivesFilesNoNew))
	.s CPRCApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",48)
	.s SignProtocolDate=$p($g(^DHCDocPP(ProRowId)),"^",37)
	.q:((Flag="CPRCApprove")&&((EthicsMeetAduitDate="")||(CPRCApproveResult="Y")))
	.i CPRCApproveResult="Y" s CPRCApproveResult="同意"
	.i CPRCApproveResult="N" s CPRCApproveResult="不同意"
	.s CPRCApproveDate=$p($g(^DHCDocPP(ProRowId)),"^",49)
	.s:CPRCApproveDate'="" CPRCApproveDate=$zd(CPRCApproveDate,3)
	.;q:((Flag="Sign")&&((CPRCApproveResult'="同意")||(SignProtocolDate'="")||(ProState="已完成")||(ProState="在研")||(ProState="未进行")||(ProState="终止")))
	.;q:((Flag="Sign")&&(CPRCApproveResult'="同意"))
	.q:((Flag="Sign")&&((SignProtocolDate'="")||(ProState="已完成")||(ProState="立项")||(ProState="未进行")||(ProState="终止")))
	.q:((Flag="SignModify")&&((SignProtocolDate="")||(ProState="终止")))
	.q:((Flag="Sign")&&(ProRowId>905)&&(CPRCApproveResult'="同意"))
	.Q:((ProCode'=PPCode)&&(PPCode'=""))||((ProDesc'[PPDesc)&&(PPDesc'=""))
	.;q:((Flag="SAE")&&(ProState'="在研"))
	.q:((Flag="SAE")&&((ProState="已完成")||(ProState="立项")))
	.q:((Flag="YearCheck")&&((ProState'["在研")||(SignProtocolDate="")))
	.q:((Flag="FileManage")&&((ProState="审批中")||(ProState="未批准")||(ProState="立项")))
	.;Q:((ProEndDate<PPStartDate)&&(PPStartDate'="")&&(ProEndDate'=""))||((ProStartDate>PPEndDate)&&(PPEndDate'="")&&(ProStartDate'=""))
	.s AllDep=PPCreateDepartmentDrnow
	.s child=0
	.f  s child=$o(^DHCDocPPD(ProRowId,child)) q:child=""  d
	..s User=""
	..s UserDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",2)
	..i (PPStartUserDr'="")&&(UserDr=PPStartUserDr) s userflag=1
	..s DepDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",1)
	..i DepDr'="" s AllDep=AllDep_","_DepDr
	..s Dep=""
	..if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
	..//i Dep="临床药理实验室" s Dep="I期临床试验研究室"
	..//i Dep["免疫" s Dep="风湿免疫科"
	..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..s:User'="" ProStartUser=ProStartUser_","_User
	..s:(Dep'="")&&((","_ProCreateDepartmen_",")'[(","_Dep_",")) ProCreateDepartmen=ProCreateDepartmen_","_Dep
	.q:((userflag=0)&&(PPStartUserDr'=""))
	.s ^TEMP("DHCCQPP",AllDep)=PPCreateDepartmentDr
	.q:(PPCreateDepartmentDr'="")&&((","_AllDep_",")'[(","_PPCreateDepartmentDr_","))
	.s CheckFreqCode=""
	.s CheckFreqDr=$p($g(^DHCDocPP(ProRowId)),"^",95)
	.s:CheckFreqDr'="" CheckFreqCode=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",1)
	.s childsub=0
	.s PPYKYear=9999
	.s PPYKMonth=1
	.f  s childsub=$o(^DHCDocPPYK(ProRowId,childsub)) q:childsub=""  d
	..s PPYKIfFinish=$p($g(^DHCDocPPYK(ProRowId,childsub)),"^",4)
	..q:PPYKIfFinish="Y"
	..s PPYKYear=$p($g(^DHCDocPPYK(ProRowId,childsub)),"^",2)
	..s PPYKMonth=$p($g(^DHCDocPPYK(ProRowId,childsub)),"^",3)
	..i CheckFreqCode=12 s PPYKYear=PPYKYear+1
	..s:PPYKMonth="" PPYKMonth=1
	..s:PPYKYear="" PPYKYear=9999
	.s ^tmpFindProject($j,PPYKYear,PPYKMonth,count)=$lb(0,ProRowId,ProCode,ProDesc,ProStartDate,ProEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason,ArchivesFilesNoNew,PlanNamenow,ApplicationUnitnow,CPRCApproveDate,EthicsMeetDate,EMADate,PPAccount,PorCreateDate)
	.s count=count+1
	s i=""
	f  s i=$o(^tmpFindProject($j,i)) q:i=""  d
	.s j=""
	.f  s j=$o(^tmpFindProject($j,i,j)) q:j=""  d
	..s k=""
	..f  s k=$o(^tmpFindProject($j,i,j,k)) q:k=""  d
	...Do OutputRowPro
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPro
    set Data=$g(^tmpFindProject($j,i,j,k))
	;set Data=$lb(ProRowId,ProCode,ProDesc,ProStartDate,ProEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariablesPro
	///set (repid)=0
	set (ProCode,ProDesc,ProStartDate,ProEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason)=""
	quit
}

ClassMethod FindProjectFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProjectExecute ]
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
	 s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
	s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpAllLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpAllLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpAllLocExecute(ByRef QHandle As %Binary, Loc As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindLoc","zl")
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s CTDesc=##class(web.DHCOPAdmReg).LocDescFormate($p($g(^CTLOC(rowid)),"^",2)) //$P($p($g(^CTLOC(rowid)),"^",2),"-",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.s CTType=$p($g(^CTLOC(rowid)),"^",13)
	.s CTActive=$p($g(^CTLOC(rowid)),"^",14)
	.q:CTActive'="Y"
	.Q:CTType="OR"
	.;用作放助记码的地方
	.;s ContactName=$p($g(^CTLOC(rowid)),"^",43)   ;现在维护科室别名的地方
	.s CTContactName=##class(web.DHCOPAdmReg).LocDescFormate($p($g(^CTLOC(rowid)),"^",2)) //$P($p($g(^CTLOC(rowid)),"^",2),"-",1)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.;w CTDesc_","_CTContactName_","_(CTContactName'[(Loc))_","_(CTDesc'[(Loc)),!
	.Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.Do OutputRow1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTDesc,CTCode,rowid,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables1
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod LookUpAllLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAllLocExecute ]
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

Query LookUpWithInactive(desc As %Library.String = "") As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Code:%Library.String,Name:%Library.String,HIDDEN,IsActive:%Library.String")
{
SELECT SSUSR_Initials,SSUSR_Name,SSUSR_RowID,SSUSR_Active
FROM SQLUser.SS_User
WHERE (SSUSR_Initials %STARTSWITH :desc)
OR (SSUSR_Name %STARTSWITH :desc)
OR (SSUSR_CareProv_DR IS NOT NULL AND SSUSR_CareProv_DR->CTPCP_OtherName %STARTSWITH :desc)
ORDER BY SSUSR_Initials
}

Query LookUpAllLoc(Loc As %String) As %Query(ROWSPEC = "Desc:%String,Code:%String,Hidden:%String,Alias:%String") [ SqlProc ]
{
}

Query FindProject(PPCode As %String = "", PPDesc As %String = "", Flag As %String = "", PlanNo As %String = "", PlanName As %String = "", ApplicationUnit As %String = "", PilotCategoryDr As %String = "", ApprovalNo As %String = "", ApplyMatterDr As %String = "", ApplyStageDr As %String = "", IsHeadmanDr As %String = "", PPCreateDepartmentDr As %String = "", PPStartUserDr As %String = "", Indication, ArchivesFilesNo, Exp As %String = "") As %Query(ROWSPEC = "RecordSum:%Integer,TPPRowId:%String,TPPCode:%String,TPPDesc:%String,TPPStartDate:%String,TEndDate:%String,TPPCreateDepartment:%String,TPPStartUser:%String,TPPBudget:%String,TPPState:%String,TApproveResult:%String,TEthicsMeetAduitDate:%String,CPRCApproveResult:%String,PPSUpdateReason:%String,ArchivesFilesNo,PlanNamenow,ApplicationUnitnow,CPRCApproveDate,EthicsMeetDate,EMADate,PPAccount,PorCreateDate") [ SqlProc ]
{
}

Query LookUpProject() As %SQLQuery(CONTAINID = 1, ROWSPEC = "PPDesc:%String,Hidden:%String,PPCode:%String")
{
	SELECT PP_Desc,PP_RowId,PP_Code FROM DHC_DocPilotProject order by PP_RowId desc
}

Query LookUpProjectByPara(Para) As %SQLQuery(CONTAINID = 1, ROWSPEC = "PPDesc:%String,Hidden:%String,PPCode:%String")
{
	SELECT PP_Desc,PP_RowId,PP_Code FROM DHC_DocPilotProject where PP_Code %STARTSWITH :Para or PP_Desc %STARTSWITH :Para order by PP_RowId desc
}

/*Query FindProRem(PPRowId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "PPDesc:%String,Hidden:%String,PPRDate:%String,PPRRemAmount,SSUSRName,PPRDateAdd,PPRTimeAdd,PPRRemitter,PPRReceiver,PPRRemark")
{
	SELECT PPR_PP_ParRef->PP_Desc,PPR_RowId,TO_DATE(PPR_Date,'DD/MM/YYYY'),PPR_RemAmount,PPR_RemUser_Dr->SSUSR_Name,TO_DATE(PPR_DateAdd,'DD/MM/YYYY'),CONVERT(varchar(100),PPR_TimeAdd,8),PPR_Remitter,PPR_Receiver,PPR_Remark FROM DHC_DocPilotProRem where PPR_PP_ParRef=:PPRowId order by PPR_Date desc
}*/
ClassMethod GetSubPilotCategoryStr(PilotCategoryRowId As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetSubPilotCategoryStr()
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindSubPilotCategory")
	do rset.Execute(PilotCategoryRowId)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set ret=rset.GetData(3)_$C(1)_rset.GetData(1)
	     i ret1="" s ret1=ret
	    e  s ret1=ret1_"^"_ret
	}
	d rset.Close()
	Q ret1
}

ClassMethod FindSubPilotCategoryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindSubPilotCategoryExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSubPilotCategoryExecute(ByRef QHandle As %Binary, PilotCategoryRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindSubPilotCategory","zl")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ModuleRowId=""
	s PilotCategoryCode=""
	s:PilotCategoryRowId'="" PilotCategoryCode=$p($g(^DHCDocCT("DefineData",+PilotCategoryRowId,"D",$p(PilotCategoryRowId,"||",2))),"^",1)
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理" 
	.s CTDefineRowId=""
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..q:Define'="亚类别"
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s IndicationCode=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",1)
    ...q:((IndicationCode'[PilotCategoryCode)&&(PilotCategoryCode'=""))
	...s IndicationDesc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...s SttDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",3)
	...s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",4)
	...s rowid=CTDefineRowId_"||"_ChildSub
	...q:(+$H)<SttDate
	...q:((+$H)>=EndDate&&(EndDate'=""))
	...Do OutputRow2
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(IndicationDesc,IndicationCode,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables2
	///set (repid)=0
	set (IndicationDesc,IndicationCode,rowid)=""
	quit
}

ClassMethod FindSubPilotCategoryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSubPilotCategoryExecute ]
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

Query FindSubPilotCategory(PilotCategoryRowId As %String) As %Query(ROWSPEC = "Desc:%String,Code:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod GetDefineDataStr(MDesc As %String, DDesc As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetDefineDataStr("科研药理","类别")
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindDefineData")
	do rset.Execute(MDesc,DDesc)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set ret=rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	    i ret1="" s ret1=ret
	    e  s ret1=ret1_"^"_ret
	}
	d rset.Close()
	Q ret1
}

ClassMethod FindDefineDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindDefineDataExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDefineDataExecute(ByRef QHandle As %Binary, MDesc As %String, DDesc As %String, Alias As %String = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindDefineData","医嘱录入字典","草药录入备注")
	Set repid=$I(^CacheTemp)
	s langid=..%LanguageID()
	s ind=1
	s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'=MDesc
	.s CTDefineRowId=""
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..q:Define'=DDesc
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s IndicationCode=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",1)
	...s IndicationDesc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...s IndicationDesc= ##class(User.DHCDocCTDefineData).GetTranByDesc("DHCDocCTDefineDataDesc",IndicationDesc,langid)
	...s SttDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",3)
	...s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",4)
	...s rowid=CTDefineRowId_"||"_ChildSub
	...q:((+$H)<SttDate&&(SttDate'=""))
	...q:((+$H)>=EndDate&&(EndDate'=""))
	...q:(Alias'="")&&(IndicationCode'[Alias)&&(IndicationDesc'[Alias)
	...Do OutputRow3
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(IndicationDesc,IndicationCode,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables3
	///set (repid)=0
	set (IndicationDesc,IndicationCode,rowid)=""
	quit
}

ClassMethod FindDefineDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDefineDataExecute ]
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

Query FindDefineData(MDesc As %String, DDesc As %String, Alias As %String = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,rowid:%String") [ SqlProc ]
{
}

// w ##Class(web.PilotProject.DHCDocPilotProject).GetMaxCodeNo()

// 得到最大项目编号

ClassMethod GetMaxCodeNo(InHosp) As %String
{
	s myMAXNo=0
	Lock ^DHCDocPilotSeting(InHosp,"ProCodeStart")
    s myMAXNo=$i(^DHCDocPilotSeting(InHosp,"ProCodeStart"))
	Lock -^DHCDocPilotSeting(InHosp,"ProCodeStart")
	s myPatLen=$g(^DHCDocPilotSeting(InHosp,"ProCodeLenght"))
	i +myPatLen'=0 {
		s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
	}
	
	q myMAXNo
}

// 得到最大文件夹编号

ClassMethod GetMaxArchivesFilesNo(InHosp) As %String
{
	s myMAXNo=0
	Lock ^DHCDocPilotSeting(InHosp,"ArchivesFilesNoStart")
    s myMAXNo=$i(^DHCDocPilotSeting(InHosp,"ArchivesFilesNoStart"))
	Lock -^DHCDocPilotSeting(InHosp,"ArchivesFilesNoStart")
	;s myPatLen=6
	;s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
	q myMAXNo
}

ClassMethod ReadHealthCareProviderListBroker(JSFunName As %String = "", ListName As %String = "", DocDesc As %String = "") As %String
{
	///读取健康人员
	
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myDataFlag=0
	s myIdx=0
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	s myIdx=myIdx+1
	s mySelFlag=0
	s HCPRowId=0
	f  s HCPRowId=$O(^CT("HCP",HCPRowId)) q:HCPRowId=""  d
	.s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2)
	.q:HCPDesc'["科研"
	.s DocDesc=DocDesc_"科研"
	.i HCPDesc=DocDesc s mySelFlag=1
	.s mydes=HCPDesc
	.s myval=HCPRowId	
	.s myval=myval_"^"_HCPDesc
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

// GetPrintData

/// 获得科研立项打印信息。
ClassMethod GetPrintDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindDefineDataExecute ]
{
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrintDataExecute(ByRef QHandle As %Binary, TPPRowId As %String) As %Status
{
   
    //s ^gry("GetPrintDataExecute")=TPPRowId
    Set repid=$I(^CacheTemp)
	s ind=1
	s ProObj=##class(User.DHCDocPilotProject).%OpenId(TPPRowId)
	if '$IsObject(ProObj) Q ""
	s WebProObj=##class(web.PilotProject.PPA.DHCDocPilotProject).%New()
	if $IsObject(ProObj.PPStartUserDr) {
		s WebProObj.PPStartUserDr=ProObj.PPStartUserDr.%Id()
		s WebProObj.PPStartUser=$p(^SSU("SSUSR",WebProObj.PPStartUserDr),"^",2)
	}
	s WebProObj.PPDesc=ProObj.PPDesc
	if $IsObject(ProObj.PPCreateDepartmentDr) {
		s WebProObj.PPCreateDepartmentDr=ProObj.PPCreateDepartmentDr.%Id()
		s WebProObj.PPCreateDepartment=##class(web.DHCOPAdmReg).LocDescFormate($p(^CTLOC(WebProObj.PPCreateDepartmentDr),"^",2)) //$p($p(^CTLOC(WebProObj.PPCreateDepartmentDr),"^",2),"-",2)
	}
	s WebProObj.PlanName=ProObj.PlanName
	s WebProObj.ApplicationUnit=ProObj.ApplicationUnit
	//缺少汇款记录的设置。
    Do OutputRow4
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(TPPStartUser,TPPDesc,TPPCreateDepartment,TPlanName,ApplicationUnit,RemRecordNum)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables4
	///set (repid)=0
	set (TPPStartUser,TPPDesc,TPPCreateDepartment,TPlanName,ApplicationUnit,RemRecordNum)=""
	quit
}

ClassMethod GetPrintDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDefineDataExecute ]
{
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

Query GetPrintData(TPPRowId As %String) As %Query(ROWSPEC = "TPPStartUser:%String,TPPDesc:%String,TPPCreateDepartment:%String,TPlanName:%String,ApplicationUnit:%String,RemRecordNum:%String") [ SqlProc ]
{
}

ClassMethod InsertProjectDept(PPRowId As %String, PPCreateDepartmentDr As %String, PPStartUserDr As %String)
{
   
    ;k ^DHCDocPPD(PPRowId)
	q:PPRowId=""
	s myrtn=0
	TS
	s UObj=##class(User.DHCDocPilotProDept).%New(PPRowId)
	d UObj.PPDPPParRefSetObjectId(PPRowId)
	d UObj.PPDCreateDepartmentDrSetObjectId(PPCreateDepartmentDr)
	d UObj.PPDStartUserDrSetObjectId(PPStartUserDr)
    Set sc = UObj.%Save()
	b ;ProjectCareSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-106"
	}
	d UObj.%Close()
	if myrtn=0{
		TC
	}else{
		TRO
	}
	
	Q +myrtn
}

ClassMethod UpdateProjectDept(PPDRowId As %String, PPCreateDepartmentDr As %String, PPStartUserDr As %String)
{
	q:PPDRowId="" ""
	&sql(update DHC_DocPilotProDept set PPD_CreateDepartment_Dr=:PPCreateDepartmentDr,PPD_StartUser_Dr=:PPStartUserDr where PPD_RowId=:PPDRowId) 
	q SQLCODE
}

ClassMethod DeleteProjectDept(PPDRowId As %String)
{
	q:PPDRowId="" ""
	&sql(delete from  DHC_DocPilotProDept  where PPD_RowId=:PPDRowId) 
	q SQLCODE
}

/// 每次保存删除子表关联数据
ClassMethod DeleteProjectDeptChild(PPDRowId As %String)
{
	q:PPDRowId="" ""
	&sql(delete from  DHC_DocPilotProDept  where PPD_PP_ParRef=:PPDRowId) 
	q SQLCODE
}

ClassMethod FindProjectDeptClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProjectDeptExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindProjectDeptExecute(ByRef QHandle As %Binary, PPRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProjectDept","7")
	Set repid=$I(^CacheTemp)
	s ind=1
	if PPRowId="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	s childsub=0
	f  s childsub=$o(^DHCDocPPD(PPRowId,childsub)) q:childsub=""  d
	.s PPCreateDepartment="",PPStartUser=""
	.s PPCreateDepartmentDr=$p($g(^DHCDocPPD(PPRowId,childsub)),"^",1)
	.s:PPCreateDepartmentDr'="" PPCreateDepartment=##class(web.DHCOPAdmReg).LocDescFormate($p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)) //$p($p($g(^CTLOC(PPCreateDepartmentDr)),"^",2),"-",2)
	.s PPStartUserDr=$p($g(^DHCDocPPD(PPRowId,childsub)),"^",2)
	.s:PPStartUserDr'="" PPStartUser=$p($g(^SSU("SSUSR",PPStartUserDr)),"^",2)
	.s PPDRowId=PPRowId_"||"_childsub
	.Do OutputRow5
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(PPDRowId,PPCreateDepartmentDr,PPCreateDepartment,PPStartUserDr,PPStartUser)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables5
	///set (repid)=0
	set (IndicationDesc,IndicationCode,rowid)=""
	quit
}

ClassMethod FindProjectDeptFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProjectDeptExecute ]
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

Query FindProjectDept(PPRowId As %String) As %Query(ROWSPEC = "PPDRowId:%String,PPCreateDepartmentDr:%String,PPCreateDepartment:%String,PPStartUserDr:%String,PPStartUser:%String") [ SqlProc ]
{
}

ClassMethod UpdateApproveResult(PPRowId As %String, Result As %String, Have As %String) As %String
{
	q:PPRowId="" ""
	q:Result="" ""
	//s ^zzy("UpdateApproveResult")=PPRowId_"^"_Result
	s Aresult=$p($g(^DHCDocPP(PPRowId)),"^",46)
	q:((Result="Y")&&(Aresult="Y")) "-101"
	q:((Result="N")&&(Aresult="N")) "-102"
	TS
	&sql(update DHC_DocPilotProject set PP_ApproveResult=:Result,PP_ApproveOpinion=:Have where PP_RowId=:PPRowId) 
	s myrtn=SQLCODE
	if myrtn=0{
		if Result="N"{
			&sql(update DHC_DocPilotProject set PP_State="U" where PP_RowId=:PPRowId) 
		}
		if Result="Y" {
			;s PPCode=..GetMaxCodeNo()
			s ArchivesFilesNo=..GetMaxArchivesFilesNo()
			&sql(update DHC_DocPilotProject set PP_State="I",PP_ArchivesFilesNo=:ArchivesFilesNo where PP_RowId=:PPRowId) 
		}
		s myrtn=SQLCODE
	}
	if +myrtn=0 {
		;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPRowId
		s:Result="N" ProjectStateObj.PPSCurState="U"
		s:Result="Y" ProjectStateObj.PPSCurState="I"
		s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		s:Result="N" ProjectStateObj.PPSUpdateReason="预审不通过"
		s:Result="Y" ProjectStateObj.PPSUpdateReason="预审通过"
		;s ProjectStateObj.PPSAuthUserDr=myProObj.PPStartUserDr    ;批准人
		s myrtn=..InsertProjectState(ProjectStateObj)
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

ClassMethod GetApproveResult(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s Result=$p($g(^DHCDocPP(PPRowId)),"^",46)
	q Result
}

ClassMethod UpdateCRRCApproveResult(PPRowId As %String, Result As %String, CPRCApproveDate As %String) As %String
{
	q:PPRowId="" ""
	q:Result="" ""
	i CPRCApproveDate'="" s CPRCApproveDate=$zdh(CPRCApproveDate,4)
	e  s CPRCApproveDate=..%SysDate()
	s EthicsMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	if CPRCApproveDate<EthicsMeetAduitDate q "-103"
	s Aresult=$p($g(^DHCDocPP(PPRowId)),"^",48)
	q:((Result="Y")&&(Aresult="Y")) "-101"
	q:((Result="N")&&(Aresult="N")) "-102"
	TS
	&sql(update DHC_DocPilotProject set PP_CPRCApproveResult=:Result,PP_CPRCApproveDate=:CPRCApproveDate where PP_RowId=:PPRowId) 
	s myrtn=SQLCODE
	if +myrtn=0{
		if Result="N"{
			&sql(update DHC_DocPilotProject set PP_State="U" where PP_RowId=:PPRowId) 
			s myrtn=SQLCODE
		}
	}
	if +myrtn=0 {
		;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPRowId
		s:Result="N" ProjectStateObj.PPSCurState="U"
		s:Result="Y" ProjectStateObj.PPSCurState="I"
		s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		s:Result="N" ProjectStateObj.PPSUpdateReason="CPRC审查不通过"
		s:Result="Y" ProjectStateObj.PPSUpdateReason="CPRC审查通过"
		s myrtn=..InsertProjectState(ProjectStateObj)
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

ClassMethod GetCPRCApproveResult(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s Result=$p($g(^DHCDocPP(PPRowId)),"^",48)
	s CPRCApproveDate=$p($g(^DHCDocPP(PPRowId)),"^",49)
	s:CPRCApproveDate'="" CPRCApproveDate=$zd(CPRCApproveDate,4)
	q Result_"^"_CPRCApproveDate
}

ClassMethod GetSignProtocolDate(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s SignProtocolDate=$p($g(^DHCDocPP(PPRowId)),"^",37)
	s:SignProtocolDate'="" SignProtocolDate=$zd(SignProtocolDate,4)
	q SignProtocolDate
}

ClassMethod UpdateSignProtocolDate(PPRowId As %String, SignProtocolDate As %String, ToalAgree As %String) As %String
{
	q:PPRowId="" ""
	s CPRCApproveDate=$p($g(^DHCDocPP(PPRowId)),"^",49)
	s EthicsMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	i SignProtocolDate'="" s SignProtocolDate=$zdh(SignProtocolDate,4)
	e  s SignProtocolDate=..%SysDate()
	i SignProtocolDate<EthicsMeetAduitDate q "-201"
	i SignProtocolDate<CPRCApproveDate q "-202"
	
	TS
	&sql(update DHC_DocPilotProject set PP_State="V",PP_SignProtocolDate=:SignProtocolDate,PP_ToalAgree=:ToalAgree where PP_RowId=:PPRowId) 
	s myrtn=SQLCODE
	if +myrtn=0 {
		;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPRowId
		s ProjectStateObj.PPSCurState="V"
		s ProjectStateObj.PPSUpdateUserDr=%session.Get("LOGON.USERID")
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		s ProjectStateObj.PPSUpdateReason="签署合同"
		s myrtn=..InsertProjectState(ProjectStateObj)
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

ClassMethod FindDeptClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindDeptExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDeptExecute(ByRef QHandle As %Binary) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindDept")
	Set repid=$I(^CacheTemp)
	s ind=1
	s PPDRowId=1
	set Data=$lb(PPDRowId)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	Set QHandle=$lb(0,repid,0) Quit $$$OK
}

ClassMethod FindDeptFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDeptExecute ]
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

Query FindDept() As %Query(ROWSPEC = "PPDRowId:%String") [ SqlProc ]
{
}

ClassMethod GetPPBudget(PPRowId As %String, UserDr As %String = "") As %String
{
	/*
	q:PPRowId="" ""
	s PPBudget=$p($g(^DHCDocPP(PPRowId)),"^",15)
	q PPBudget
	*/
	s Ret="",PPBudget=""
	;1.得到PilotProject表中的研究者/委托研究者,如果用户是空,默认为此研究者/委托研究者
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if ((UserDr=ProStartUserDr)||(UserDr=UserUserDr)||(UserDr="")) {
		s Ret=$$GetPPBudget(PPRowId)
		Q Ret
	}
	;2.得到PilotProjectDept子表中的研究者
	s child=""
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUser1=""
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:ProStartUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",ProStartUserDr1),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s:UserUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",UserUserDr1),"^",2)
	.s PPDRowId=PPRowId_"||"_child
	.i ((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1)) s Ret=$$GetAcountBudget(PPDRowId)
	q Ret
GetPPBudget(PPRowId)
    &SQL(Select PP_Budget into :PPBudget from SQLUser.DHC_DocPilotProject where PP_RowId=:PPRowId)
    Q PPBudget
GetAcountBudget(PPDRowId)
    &SQL(Select PPD_AccountBudget into :PPBudget from SQLUser.DHC_DocPilotProDept where PPD_RowId=:PPDRowId)
    Q PPBudget
}

ClassMethod AddPPBudget(PPRowId As %String, PPBudget As %String, UserDr As %String = "") As %String
{
	/*
	q:PPRowId="" ""
	&sql(update DHC_DocPilotProject set PP_Budget=:PPBudget where PP_RowId=:PPRowId) 
	q SQLCODE
	*/
	s Ret=0
	;1.得到PilotProject表中的研究者/委托研究者,如果用户是空,默认为此研究者/委托研究者
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if ((UserDr=ProStartUserDr)||(UserDr=UserUserDr)||(UserDr="")) {
		s Ret=$$UpdatePPBudget(PPRowId,PPBudget)
		Q Ret
	}
	;2.得到PilotProjectDept子表中的研究者
	s child=""
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUser1=""
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:ProStartUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",ProStartUserDr1),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s:UserUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",UserUserDr1),"^",2)
	.s PPDRowId=PPRowId_"||"_child
	.i ((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1)) s Ret=$$UpdateAcountBudget(PPDRowId,PPBudget)
	q Ret
UpdatePPBudget(PPRowId,PPBudget)
    &SQL(Update SQLUser.DHC_DocPilotProject set PP_Budget=:PPBudget where PP_RowId=:PPRowId)
    Q SQLCODE
UpdateAcountBudget(PPDRowId,PPBudget)
    &SQL(Update SQLUser.DHC_DocPilotProDept set PPD_AccountBudget=:PPBudget where PPD_RowId=:PPDRowId)
    Q SQLCODE
}

/// 修改付款次数数据,2014-12-22,数据修复
/// 当前所有数据备份到^DHCDocPPRBackup("20141222")
/// W ##class(web.PilotProject.DHCDocPilotProject).UpatePayCountData()
ClassMethod UpatePayCountData() As %String
{
	k ^tmpPayCountAry
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPPR(PPRowId)) Q:PPRowId=""
		continue:'$d(^DHCDocPP(PPRowId))
		s SystemGenCountFlag=1
		s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
		;只更新系统上线以后的项目
		continue:+PPCode<924
		s ChildSub=0
		for {
			s ChildSub=$O(^DHCDocPPR(PPRowId,ChildSub)) Q:ChildSub=""
			s Count=$p(^DHCDocPPR(PPRowId,ChildSub),"^",16)
			s FirstPay=$p(^DHCDocPPR(PPRowId,ChildSub),"^",11)
			s Type=$p(^DHCDocPPR(PPRowId,ChildSub),"^",12)
			continue:Type="I"
			s IMasterUserDR=$p(^DHCDocPPR(PPRowId,ChildSub),"^",17)
			i IMasterUserDR="" {
				;如果研究者为空,则默认取项目的研究者
				s PPRUserDr=$P(^DHCDocPPR(PPRowId,ChildSub),"^",15)
				s IMasterUser=..GetPPUserByID(PPRowId,PPRUserDr)
				;通过研究者描述得到RowId
				s IMasterUserDR=..GetIdByUserName(PPRowId,IMasterUser)
			}
			continue:IMasterUserDR=""
			s IPayContract=$p(^DHCDocPPR(PPRowId,ChildSub),"^",18)
			i IPayContract="" s IPayContract=..FormatToStoreStr("一")
		 
			lock +^tmpPayCountAry(PPRowId,IPayContract,IMasterUserDR)
			s ^tmpPayCountAry(PPRowId,IPayContract,IMasterUserDR,PPRowId_"||"_ChildSub)=$I(^tmpPayCountAry(PPRowId,IPayContract,IMasterUserDR))
			lock -^tmpPayCountAry(PPRowId,IPayContract,IMasterUserDR)
		}
	}
	
	s II=0
	s PPRowId=0
	for {
		s PPRowId=$O(^tmpPayCountAry(PPRowId)) Q:PPRowId=""
		;continue:PPRowId'=982
		s IPayContract=""
		for {
			s IPayContract=$O(^tmpPayCountAry(PPRowId,IPayContract)) Q:IPayContract=""
			s IMasterUserDR=""
			for {
				s IMasterUserDR=$O(^tmpPayCountAry(PPRowId,IPayContract,IMasterUserDR)) Q:IMasterUserDR=""
				s PPRRowId=""
				for {
					s PPRRowId=$O(^tmpPayCountAry(PPRowId,IPayContract,IMasterUserDR,PPRRowId)) Q:PPRRowId=""
					s Count=+$g(^tmpPayCountAry(PPRowId,IPayContract,IMasterUserDR,PPRRowId))
					&sql(Update SQLUser.DHC_DocPilotProRem set PPR_Count=:Count Where PPR_RowId=:PPRRowId)
					i SQLCODE {
						S ^tmpPayCountAryErr(PPRRowId)=IPayContract_","_IMasterUserDR
					}else{
						s II=II+1
					}
				}
			}
			
		}
	}
	
	q II
}

/// 得到付款次数
/// input:PPRowId 项目ROWID,MasterUserDR 研究者ROWID,PayContract 合同数标识
/// output:付款次数
/// w ##class(web.PilotProject.DHCDocPilotProject).GetMaxPayCount(982,1684,"")
ClassMethod GetMaxPayCount(PPRowId As %String, MasterUserDR As %String, PayContract As %String) As %String
{
	n (PPRowId,MasterUserDR,PayContract)
	Q:(PPRowId="")||(MasterUserDR="") ""
	i PayContract="" s PayContract=..FormatToStoreStr("一")
		
	s ChildSub=0
	for {
		s ChildSub=$O(^DHCDocPPR(PPRowId,ChildSub)) Q:ChildSub=""
		s Count=$p(^DHCDocPPR(PPRowId,ChildSub),"^",16)
		s FirstPay=$p(^DHCDocPPR(PPRowId,ChildSub),"^",11)
		s Type=$p(^DHCDocPPR(PPRowId,ChildSub),"^",12)
		continue:Type="I"
		s IMasterUserDR=$p(^DHCDocPPR(PPRowId,ChildSub),"^",17)
		i IMasterUserDR="" {
			;如果研究者为空,则默认取项目的研究者
			s PPRUserDr=$P(^DHCDocPPR(PPRowId,ChildSub),"^",15)
			s IMasterUser=..GetPPUserByID(PPRowId,PPRUserDr)
			;通过研究者描述得到RowId
			s IMasterUserDR=..GetIdByUserName(PPRowId,IMasterUser)
		}
		continue:IMasterUserDR=""
		s IPayContract=$p(^DHCDocPPR(PPRowId,ChildSub),"^",18)
		i IPayContract="" s IPayContract=..FormatToStoreStr("一")
		 
		lock +PayCountAry(PPRowId,IPayContract,IMasterUserDR)
		s PayCountAry(PPRowId,IPayContract,IMasterUserDR,PPRowId_"||"_ChildSub)=$I(PayCountAry(PPRowId,IPayContract,IMasterUserDR))
		lock -PayCountAry(PPRowId,IPayContract,IMasterUserDR)
	}
	
	Q +$g(PayCountAry(PPRowId,PayContract,MasterUserDR))
}

ClassMethod FormatToStoreStr(PayContract As %String) As %String
{
	n (PayContract)
	s IPayContract=$CASE(PayContract,"1":"O","2":"T","3":"TH","4":"FO","5":"FI",:"")
	i IPayContract="" s IPayContract=$CASE(PayContract,"I":"O","II":"T","III":"TH","IV":"FO","V":"FI",:"")
	i IPayContract="" s IPayContract=$CASE(PayContract,"一":"O","二":"T","三":"TH","四":"FO","五":"V",:"")
	i IPayContract="" s IPayContract=$CASE(PayContract,"O":"O","T":"T","TH":"TH","FO":"FO","V":"V",:"")
	Q IPayContract
}

/* //协和方法
ClassMethod InsertProjectRem(PPRowId As %String, PPRRemitter As %String, PPRRemAmount As %String, PPRRemUserDr As %String, PayTypeDr As %String, PPRDateAdd, User, flag, PPRCount, MasterUserDR As %String = "", PayContract As %String = "") As %String
{
	s ^zzy("InsertProjectRem")=PPRowId_"^"_PPRRemitter_"^"_PPRRemAmount_"^"_PPRDateAdd_"^"_MasterUserDR_"^"_PayContract
	q:PPRowId="" "-101^请选择一个项目！"
	n (PPRRemitter,PPRRemAmount,PPRowId,PPRRemUserDr,PayTypeDr,PPRDateAdd,User,flag,PPRCount,MasterUserDR,PayContract)
	s PayAccount=$p($g(^DHCDocPP(PPRowId)),"^",50)
	s myrtn=0,errDesc=""
	if PayTypeDr="P" s PayTypeDr=""
	i PPRDateAdd="" s PPRDateAdd=..%SysDate()
	e  s PPRDateAdd=$zdh(PPRDateAdd,3)
	;控制导入的项目系统不由系统产生付款次数;前台js有控制付款次数是否可以录入
	s SystemGenCountFlag=1
	s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
	i +PPCode<924 s SystemGenCountFlag=0
	TS
	s UObj=##class(User.DHCDocPilotProRem).%New(PPRowId)
	d UObj.PPRPPParRefSetObjectId(PPRowId)
	s UObj.PPRRemAmount=PPRRemAmount
	d UObj.PPRRemUserDrSetObjectId(PPRRemUserDr)
	s UObj.PPRDateAdd=PPRDateAdd
	s UObj.PPRTimeAdd=..%SysTime()
	d UObj.PPRUserDrSetObjectId(User)
	i ((PayTypeDr="I")||(PayTypeDr="B")||(PayTypeDr="E")) s UObj.PPRAccount="V000001"
	s UObj.PPRRemitter=PPRRemitter
	s UObj.PPRType=PayTypeDr
	;记录付款时的主研究者UserDR
	i MasterUserDR'="" {
		d UObj.PPRMasterUserDRSetObjectId(MasterUserDR)
	}else{
		s MasterUser=..GetPPUserByID(PPRowId,User)
		;通过研究者描述得到RowId
		s MasterUserDR=..GetIdByUserName(PPRowId,MasterUser)
		i MasterUserDR'="" d UObj.PPRMasterUserDRSetObjectId(MasterUserDR)
	}
	if flag=1 {
		s UObj.PPRState="V"
		i PayTypeDr="I" s PayType="IEC"
		e  s PayType="普通付款"
		s UObj.PPRAccount=..GetAccountByUser(PPRowId,MasterUserDR,PayType)
				
	}
	else  {
		s UObj.PPRState="A"
	}
	s PayContract=..FormatToStoreStr(PayContract)
	s UObj.PPRPayContract=PayContract
	i SystemGenCountFlag=1 {
		s PPRCount=..GetMaxPayCount(PPRowId,MasterUserDR,PayContract)+1
		s UObj.PPRCount=PPRCount
	}else{
		s UObj.PPRCount=PPRCount
	}
	
	Set sc = UObj.%Save()
	b ;ProjectStateSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d UObj.%Close()
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	if +myrtn'=0 s errDesc="插入数据失败."
	
    Q +myrtn_"^"_errDesc_"^"_PPRCount
}
*/
ClassMethod GetUserPayAccount(PPRowId As %String, MasterUserDR As %String) As %String
{
	s FindAccount=""
	;在付款到账记录里面是否存在其他研究者的付款记录
	s IsExistOtherMasterUserFlag=0
	s Childsub=0
	for {
		s Childsub=$O(^DHCDocPPR(PPRowId,Childsub)) q:Childsub=""
		s Type=$p(^DHCDocPPR(PPRowId,Childsub),"^",12)
		continue:Type="I"
		s IMasterUserDR=$p(^DHCDocPPR(PPRowId,Childsub),"^",17)
		s IAccount=$p(^DHCDocPPR(PPRowId,Childsub),"^",10)
		if (IMasterUserDR'="") {
			if (IMasterUserDR=MasterUserDR) {
				s FindAccount=IAccount
				q
			}else{
				s IsExistOtherMasterUserFlag=1
			}
		}
	}
	
	Q FindAccount_"^"_IsExistOtherMasterUserFlag
}

ClassMethod GetIdByUserName(PPRowId As %String, UserName As %String) As %String
{
	Q:(PPRowId="")||(UserName="") ""
	s UserRowId=""
	s ProStartUser=""
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if UserUserDr'="" {
		s ProStartUser=$p(^SSU("SSUSR",UserUserDr),"^",2)
		if UserName=ProStartUser q UserUserDr
	}
	if UserName=ProStartUser q ProStartUserDr
	
	s child=""
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr1Desc=""
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:ProStartUserDr1'="" ProStartUserDr1Desc=$p(^SSU("SSUSR",ProStartUserDr1),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.i UserUserDr1'="" d
	..s UserUserDr1Desc=$p(^SSU("SSUSR",UserUserDr1),"^",2)
	..i (UserName=UserUserDr1Desc)  s UserRowId=ProStartUser1
	.i (UserName=ProStartUserDr1Desc) s UserRowId=ProStartUserDr1
	q UserRowId
}

ClassMethod GetOUserStr(PPRowId As %String) As %String
{
	Kill ^tmpPilotOUserStr("GetOUserStr")
	Q:PPRowId="" ""
	s ret=""
	S RowId=0 f  s RowId=$O(^DHCDocPPR(PPRowId,RowId)) Q:(RowId="")  d
	.s MasterUserDR=$P(^DHCDocPPR(PPRowId,RowId),"^",17)
	.i MasterUserDR'="" d
	..s MasterUser=$p(^SSU("SSUSR",MasterUserDR),"^",2)
	..s ^tmpPilotOUserStr("GetOUserStr",MasterUserDR)=MasterUser
	.e  d
	..;得到默认为空时的研究者
	..s PPRUserDr=$P(^DHCDocPPR(PPRowId,RowId),"^",15)
	..s MasterUserName=..GetPPUserByID(PPRowId,PPRUserDr)
	..s MasterUserId=..GetIdByUserName(PPRowId,MasterUserName)
	..i MasterUserId'="" s ^tmpPilotOUserStr("GetOUserStr",MasterUserId)=MasterUserName
	
	s OUserId=""
	for  {
		s OUserId=$o(^tmpPilotOUserStr("GetOUserStr",OUserId)) Q:OUserId=""
		s OUserName=$g(^tmpPilotOUserStr("GetOUserStr",OUserId))
		i ret="" s ret=OUserId_$C(1)_OUserName
		e  s ret=ret_"^"_OUserId_$C(1)_OUserName
	}
	
	Q ret
}

ClassMethod UpdateProjectRem(PPRRowId As %String, PPRRemitter As %String, PPRRemAmount As %String, PayTypeDr As %String, PPRDateAdd, User, PPRCount, MasterUserDR As %String = "", PayContract As %String = "") As %String
{
	//s ^zzy("UpdateProjectRem")=PPRRowId_"^"_PPRRemitter_"^"_PPRRemAmount_"^"_PPRDateAdd_"^"_User_"^"_MasterUserDR_"^"_PayContract
	q:PPRRowId="" ""
	n (PPRRemitter,PPRRemAmount,PPRowId,PayTypeDr,PPRDateAdd,PPRRowId,User,PPRCount,MasterUserDR,PayContract)
	s myrtn=0,errDesc=""
	if PayTypeDr="P" s PayTypeDr=""
	i PPRDateAdd="" s PPRDateAdd=..%SysDate()
	e  s PPRDateAdd=$zdh(PPRDateAdd,3)
	TS
	s UObj=##class(User.DHCDocPilotProRem).%OpenId(PPRRowId)
	s UObj.PPRRemAmount=PPRRemAmount
     i ((PayTypeDr="I")||(PayTypeDr="B")) s UObj.PPRAccount="V000001"
	s UObj.PPRDateAdd=PPRDateAdd
	s UObj.PPRRemitter=PPRRemitter
	s UObj.PPRType=PayTypeDr
	d UObj.PPRUserDrSetObjectId(User)
	s UObj.PPRCount=PPRCount
	s OldMasterUserDR=UObj.PPRMasterUserDRGetObjectId()
	s OldPayContract=UObj.PPRPayContract
	i MasterUserDR'="" d UObj.PPRMasterUserDRSetObjectId(MasterUserDR)
	s PayContract=..FormatToStoreStr(PayContract)
	s UObj.PPRPayContract=PayContract
	
	
	Set sc = UObj.%Save()
	b ;ProjectStateSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d UObj.%Close()
	if +myrtn=0 {
		s PPRowId=+PPRRowId
		;如果修改合同和研究者则需要重新计算付款次数
		i OldMasterUserDR'=MasterUserDR {
			s ChildSub=0
			for {
				s ChildSub=$O(^DHCDocPPR(PPRowId,ChildSub)) Q:ChildSub=""
				s Count=$p(^DHCDocPPR(PPRowId,ChildSub),"^",16)
				continue:Count=""
				s FirstPay=$p(^DHCDocPPR(PPRowId,ChildSub),"^",11)
				s Type=$p(^DHCDocPPR(PPRowId,ChildSub),"^",12)
				s IMasterUserDR=$p(^DHCDocPPR(PPRowId,ChildSub),"^",17)
				s IPayContract=$p(^DHCDocPPR(PPRowId,ChildSub),"^",18)
				continue:(IMasterUserDR'=OldMasterUserDR)&&(IMasterUserDR'=MasterUserDR)
				i IMasterUserDR="" {
					;如果研究者为空,则默认取项目的研究者
					s PPRUserDr=$P(^DHCDocPPR(PPRowId,ChildSub),"^",15)
					s IMasterUser=..GetPPUserByID(PPRowId,PPRUserDr)
					;通过研究者描述得到RowId
					s IMasterUserDR=..GetIdByUserName(PPRowId,IMasterUser)
				}
				continue:IMasterUserDR=""
				s MaxCount=..GetMaxPayCount(PPRowId,IMasterUserDR,IPayContract)
				s NextCount=MaxCount+1
				s PPRRowId=PPRowId_"||"_ChildSub
				&sql(Update SQLUser.DHC_DocPilotProRem set PPR_Count=:NextCount Where PPR_RowId=:PPRRowId)
			}
		}
		i OldPayContract'=PayContract {
			s ChildSub=0
			for {
				s ChildSub=$O(^DHCDocPPR(PPRowId,ChildSub)) Q:ChildSub=""
				s Count=$p(^DHCDocPPR(PPRowId,ChildSub),"^",16)
				continue:Count=""
				s FirstPay=$p(^DHCDocPPR(PPRowId,ChildSub),"^",11)
				s Type=$p(^DHCDocPPR(PPRowId,ChildSub),"^",12)
				s IMasterUserDR=$p(^DHCDocPPR(PPRowId,ChildSub),"^",17)
				s IPayContract=$p(^DHCDocPPR(PPRowId,ChildSub),"^",18)
				continue:(IPayContract'=OldPayContract)&&(IPayContract'=PayContract)
				i IMasterUserDR="" {
					;如果研究者为空,则默认取项目的研究者
					s PPRUserDr=$P(^DHCDocPPR(PPRowId,ChildSub),"^",15)
					s IMasterUser=..GetPPUserByID(PPRowId,PPRUserDr)
					;通过研究者描述得到RowId
					s IMasterUserDR=..GetIdByUserName(PPRowId,IMasterUser)
				}
				continue:IMasterUserDR=""
				s MaxCount=..GetMaxPayCount(PPRowId,IMasterUserDR,IPayContract)
				s NextCount=MaxCount+1
				s PPRRowId=PPRowId_"||"_ChildSub
				&sql(Update SQLUser.DHC_DocPilotProRem set PPR_Count=:NextCount Where PPR_RowId=:PPRRowId)
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

// w ##class(web.PilotProject.DHCDocPilotProject).GetProjectByID(61)

ClassMethod GetProjectByID(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s ProObj=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
	if '$IsObject(ProObj) Q ""
	s PPCode=ProObj.PPCode
	s PPDesc=ProObj.PPDesc
	s PPOrder=ProObj.PPOrder
	s PPResult=ProObj.PPResult
	s PPRemark=ProObj.PPRemark
	s SaveLastDate=ProObj.SaveLastDate  //阳远
	s PPCreateDepartment="",PPCreateDepartmentDr=""
	if $IsObject(ProObj.PPCreateDepartmentDr) {
		s PPCreateDepartmentDr=ProObj.PPCreateDepartmentDr.%Id()
		s PPCreateDepartment=##class(web.DHCOPAdmReg).LocDescFormate($p(^CTLOC(PPCreateDepartmentDr),"^",2)) //$p($p(^CTLOC(PPCreateDepartmentDr),"^",2),"-",2)
		;if PPCreateDepartment="感染内科" s PPCreateDepartment="感染科"
		;if PPCreateDepartment["免疫" s PPCreateDepartment="风湿免疫科"
		s PPCreateDepartment=##Class(web.PilotProject.DHCDocPilotProCommon).TransDeptName(PPCreateDepartment)
	}
	if $IsObject(ProObj.PPCreateUserDr) s PPCreateUserDr=ProObj.PPCreateUserDr.%Id()
	s PPCreateDate=ProObj.PPCreateDate
	if PPCreateDate'="" s PPCreateDate=$zd(PPCreateDate,4)
	s PPCreateTime=ProObj.PPCreateTime
	if PPCreateTime'="" s PPCreateTime=..%ZT(PPCreateTime,1)
	s PPStartUser="",PPStartUserDr=""
	if $IsObject(ProObj.PPStartUserDr) {
		s PPStartUserDr=ProObj.PPStartUserDr.%Id()
		s PPStartUser=$p(^SSU("SSUSR",PPStartUserDr),"^",2)
		
	}
	s UserUser=""
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	s:UserUserDr'="" UserUser=$p(^SSU("SSUSR",UserUserDr),"^",2)
	i UserUser="" s UserUser=PPStartUser
	s PPStartDate=ProObj.PPStartDate
	if PPStartDate'="" s PPStartDate=$zd(PPStartDate,4)
	s PEndUserDr=ProObj.PPEndUserDr
	;s PPEndDate=ProObj.PPEndDate
	//阳远
	s PPEndDate=$p(^DHCDocPP(PPRowId),"^",13)
	i PPEndDate'="" s PPEndDate=$zd(PPEndDate,3)
	s SumDate=$p($g(^DHCDocPP(PPRowId)),"^",68)
	s:SumDate'="" SumDate=$zd(SumDate,3)
	s CenterDate=$p($g(^DHCDocPP(PPRowId)),"^",67)
	s:CenterDate'="" CenterDate=$zd(CenterDate,3)
    s BriefDate=$p($g(^DHCDocPP(PPRowId)),"^",66)
	s:BriefDate'="" BriefDate=$zd(BriefDate,3)
	   ;总结日期优先取BriefDate>CenterDate>SumDate
	i SumDate'="" s PPEndDate=SumDate
	i CenterDate'="" s PPEndDate=CenterDate
	i BriefDate'="" s PPEndDate=BriefDate // 阳远 修改结束
	;if PPEndDate'="" s PPEndDate=$zd(PPEndDate,4) // 原先
	;s PPEndTime=ProObj.PPEndTime // 阳远
	;if PPEndTime'="" s PPEndTime=..%ZT(PPEndTime,1)
	s PPBudget=ProObj.PPBudget
	s PPState=ProObj.PPState
	s ApplicationUnit=ProObj.ApplicationUnit
	s PlanNo=ProObj.PlanNo
	s PlanName=ProObj.PlanName
	s ApprovalNo=ProObj.ApprovalNo
	s Role=ProObj.Role
	s ExamReportNum=ProObj.ExamReportNum
	s FileSubmitDate=ProObj.FileSubmitDate
	if FileSubmitDate'="" s FileSubmitDate=$zd(FileSubmitDate,4)
	s EthicsMeetDate=ProObj.EthicsMeetDate
	if EthicsMeetDate'="" s EthicsMeetDate=$zd(EthicsMeetDate,4)
	s EthicsMeetAduitDate=ProObj.EthicsMeetAduitDate
	if EthicsMeetAduitDate'="" s EthicsMeetAduitDate=$zd(EthicsMeetAduitDate,4)
	s ArchivesFilesNo=ProObj.ArchivesFilesNo
	s CollectCompany=ProObj.CollectCompany
	s EthicsFilesOffDate=ProObj.EthicsFilesOffDate
	if EthicsFilesOffDate'="" s EthicsFilesOffDate=$zd(EthicsFilesOffDate,4)
	s SignProtocolDate=ProObj.SignProtocolDate
	if SignProtocolDate'="" s SignProtocolDate=$zd(SignProtocolDate,4)
	s LeaderCompany=ProObj.LeaderCompany
	s LeaderCompanyPI=ProObj.LeaderCompanyPI
	s CROCompany=ProObj.CROCompany
	s FirstPatDate=ProObj.FirstPatDate
	i FirstPatDate'="" s FirstPatDate=$zd(FirstPatDate,4)
	;s WebProObj.ApplyMatter=ProObj.ApplyMatter
	;s JoinedUser=$$getJoinedUserByParId(PPRowId)
	s Indication=ProObj.Indication
	s SubPilotCategory="",SubPilotCategoryDr=""
	if $IsObject(ProObj.SubPilotCategoryDr) {
		s SubPilotCategoryDr=ProObj.SubPilotCategoryDr.%Id()
		s SubPilotCategory=$p($g(^DHCDocCT("DefineData",+ProObj.SubPilotCategoryDr.%Id(),"D",$p(ProObj.SubPilotCategoryDr.%Id(),"||",2))),"^",2)
	}
	
	s PilotCategory="",PilotCategoryDr=""
	if $IsObject(ProObj.PilotCategoryDr) {
		s PilotCategoryDr=ProObj.PilotCategoryDr.%Id()
		s PilotCategory=$p($g(^DHCDocCT("DefineData",+ProObj.PilotCategoryDr.%Id(),"D",$p(ProObj.PilotCategoryDr.%Id(),"||",2))),"^",2)
	}
	s EthicsFilesNextState="",EthicsFilesNextStateDr=""
	if $IsObject(ProObj.EthicsFilesNextStateDr) {
		s EthicsFilesNextStateDr=ProObj.EthicsFilesNextStateDr.%Id()
		s EthicsFilesNextState=$p($g(^DHCDocCT("DefineData",+ProObj.EthicsFilesNextStateDr.%Id(),"D",$p(ProObj.EthicsFilesNextStateDr.%Id(),"||",2))),"^",2)
	}
	s EthicsFilesState="",EthicsFilesStateDr=""
	if $IsObject(ProObj.EthicsFilesStateDr) {
		s EthicsFilesStateDr=ProObj.EthicsFilesStateDr.%Id()
		s EthicsFilesState=$p($g(^DHCDocCT("DefineData",+ProObj.EthicsFilesStateDr.%Id(),"D",$p(ProObj.EthicsFilesStateDr.%Id(),"||",2))),"^",2)
	}
	s ProjectFilesState="",ProjectFilesStateDr=""
	if $IsObject(ProObj.ProjectFilesStateDr) {
		s ProjectFilesStateDr=ProObj.ProjectFilesStateDr.%Id()
		s ProjectFilesState=$p($g(^DHCDocCT("DefineData",+ProObj.ProjectFilesStateDr.%Id(),"D",$p(ProObj.ProjectFilesStateDr.%Id(),"||",2))),"^",2)
	}
	s IsHeadman="",IsHeadmanDr=""
	if $IsObject(ProObj.IsHeadmanDr) {
		s IsHeadmanDr=ProObj.IsHeadmanDr.%Id()
		s IsHeadman=$p($g(^DHCDocCT("DefineData",+ProObj.IsHeadmanDr.%Id(),"D",$p(ProObj.IsHeadmanDr.%Id(),"||",2))),"^",2)
	}
	
	s ApplyStage="",ApplyStageDr=""
	if $IsObject(ProObj.ApplyStageDr) {
		s ApplyStageDr=ProObj.ApplyStageDr.%Id()
		s ApplyStage=$p($g(^DHCDocCT("DefineData",+ProObj.ApplyStageDr.%Id(),"D",$p(ProObj.ApplyStageDr.%Id(),"||",2))),"^",2)
	}
	s ApplyMatter="",ApplyMatterDr=""
	if $IsObject(ProObj.ApplyMatterDr) {
		s ApplyMatterDr=ProObj.ApplyMatterDr.%Id()
		s ApplyMatter=$p($g(^DHCDocCT("DefineData",+ProObj.ApplyMatterDr.%Id(),"D",$p(ProObj.ApplyMatterDr.%Id(),"||",2))),"^",2)
	}
	s ApplyContact=ProObj.ApplyContact
	s ApplyContactTel=ProObj.ApplyContactTel
	 
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s User=""
	.s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	.;s:User'="" PPStartUser=PPStartUser_","_User
	.s:(User'="")&&((","_PPStartUser_",")'[(","_User_",")) PPStartUser=PPStartUser_","_User
	.s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	.s Dep=""
	.if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
	.s Dep=##Class(web.PilotProject.DHCDocPilotProCommon).TransDeptName(Dep)
	.s:(Dep'="")&&((","_PPCreateDepartment_",")'[(","_Dep_",")) PPCreateDepartment=PPCreateDepartment_","_Dep
	s ProState=""
	i PPState="I" s ProState="审批中"
	i PPState="U" s ProState="未批准"
	i PPState="N" s ProState="立项"
	i PPState="A" s ProState="暂停"
	i PPState="S" s ProState="终止"
	i PPState="V" s ProState="在研"
	i PPState="F" s ProState="已完成"
	i PPState="B" s ProState="中止"
	i PPState="H" s ProState="未进行"
	i PPState="P" s ProState="发补后在研"
	i PPState="D" s ProState="上会未通过"
	s CheckFreq="",CheckFreqDr=""
	if $IsObject(ProObj.CheckFreqDr) {
		s CheckFreqDr=ProObj.CheckFreqDr.%Id()
		s CheckFreq=$p($g(^DHCDocCT("DefineData",+ProObj.CheckFreqDr.%Id(),"D",$p(ProObj.CheckFreqDr.%Id(),"||",2))),"^",2)
	} 
	s rtn=PPRowId_"^"_PPCode_"^"_PPDesc_"^"_PlanNo_"^"_PlanName_"^"_ApplicationUnit_"^"_PPCreateDepartment_"^"_PPStartUser_"^"_PilotCategory_"^"_ApplyMatter_"^"_ApprovalNo_"^"_ApplyStage_"^"_ApplyContact_"^"_ApplyContactTel_"^"_Indication_"^"_SubPilotCategory_"^"_CROCompany_"^"_IsHeadman_"^"_FirstPatDate_"^"_CheckFreqDr_"^"_CheckFreq_"^"_PPState_"^"_ProState_"^"_UserUser_"^"_PPEndDate_"^"_SaveLastDate
   q rtn
}

// w ##class(web.PilotProject.DHCDocPilotProject).PayCount(29)

ClassMethod PayCount(PPRRowId As %String) As %String
{
	s count=$p(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2)),"^",16)
	/*
	q:PPRowId="" ""
	s count=0
	&sql(select Count(*) into :count from dhc_docpilotprorem where PPR_PP_ParRef=:PPRowId and PPR_Type  is null)
	if PPRowId=720 s count=count+2
	if PPRowId=859 s count=count+2
	if PPRowId=540 s count=count+8
	if PPRowId=766 s count=count+3
	if PPRowId=419 s count=count+3
	;if PPRowId=664    s count=count+2
	*/
	q count
}

ClassMethod GetPayContractDesc(PayContract As %String) As %String
{
	Q:PayContract="" ""
	s PayContract=$CASE(PayContract,"O":"主合同","T":"增补合同1","TH":"增补合同2","FO":"增补合同3","V":"增补合同4",:"")
	Q PayContract
}

ClassMethod FindProRemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProRemExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindProRemExecute(ByRef QHandle As %Binary, PPRowId As %String, Flag As %String, SttDate As %String = "", EndDate As %String = "", PPStartUserDr As %String = "", PPCreateDepartmentDr As %String = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProRem")
	Set repid=$I(^CacheTemp)
	k ^TMPFindProRem($j)
	s ind=1
	i PPRowId="" {
		
			s PPRowId=0 f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
			.s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
			.s PPCode=$p($g(^DHCDocPP(PPRowId)),"^",1)
			.s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
			.S PPStartUser=""
			.if PPStartUserDr'="" s PPStartUser=$p(^SSU("SSUSR",PPStartUserDr),"^",2)
			.s child=0
			.f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
			..s User1=""
			..s UserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
			..s:UserDr1'="" User1=$p(^SSU("SSUSR",UserDr1),"^",2)
			..s:User1'="" PPStartUser=PPStartUser_","_User1
			
			.s childsub=0
			.f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
			..s PPRRemAmount=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",1)
			..s PPRRemitter=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",3)
			..s PPRRemUserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",2)
			..s PPRRemUser=""
			..s:PPRRemUserDr'="" PPRRemUser=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)
			..s PPRDateAdd1=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",7)
			..q:((SttDate'="")&&(PPRDateAdd1<SttDate))
			..q:((EndDate'="")&&(PPRDateAdd1>EndDate))
			..s PPRDateAdd=""
			..s:PPRDateAdd1'="" PPRDateAdd=..%ZD(PPRDateAdd1) //$zd(PPRDateAdd1,3)
			..i PPRDateAdd="" s PPRDateAdd1=99999
			..s PPRTimeAdd=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",8)
			..s:PPRTimeAdd'="" PPRTimeAdd=..%ZT(PPRTimeAdd,1)
			..s PPRDate=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",5)   //汇款日期
		    ..s:PPRDate'="" PPRDate=..%ZD(PPRDate) //$zd(PPRDate,3)
		    ..s PPRReceiverDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",4)   //接收人
		    ..s PPRReceiver=""
		    ..s:PPRReceiverDr'="" PPRReceiver=$p(^SSU("SSUSR",PPRReceiverDr),"^",2)
		    ..s PPRRemark=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",6)  //备注
			..s PPRState=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",9)
			..s:PPRState="A" PPRState="申请"
			..s:PPRState="V" PPRState="到账"
			..q:(PPRState="到账")&&(Flag'="Pay")
			..s PPRTypeDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
			..i PPRTypeDr="I" s PPRType="IEC"
			..e  i PPRTypeDr="B" s PPRType="备案费"
			..e  i PPRTypeDr="E" s PPRType="项目审核费"
			..e  s PPRType="普通付款"
			..s Account=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",10)
			..;研究者
			..s UserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
			..
			..s User=""
			..s MasterUserDR=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",17)
			..i MasterUserDR'="" d
			...s User=$p(^SSU("SSUSR",MasterUserDR),"^",2)
			...s UserDr=MasterUserDR
			..e  d
			...s User=..GetPPUserByID(PPRowId,UserDr)
			..s count=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",16)
			..s PPRRowId=PPRowId_"||"_childsub
			..s DeptUser=..GetPayDeptAndUser(PPRRowId)
			..s Dept1=$p(DeptUser,"^",1)
			..s User1=$p(DeptUser,"^",2)
			..q:((PPCreateDepartmentDr'="")&&(PPCreateDepartmentDr'=Dept1))
			..q:((PPStartUserDr'="")&&(PPStartUserDr'=User1))
			..;i Account="" s Account=..GetPAccountByID(PPRRowId)
			..i Account="" s Account=..GetAccountByUser(PPRowId,UserDr,PPRType)
			..s PayContract=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",18)
			..s PayContractDesc=..GetPayContractDesc(PayContract)
			..s Data1=$lb(PPRRowId,PPRRemAmount,PPRRemitter,PPRRemUser,PPRDateAdd,PPRTimeAdd,PPDesc,PPRState,Account,PPRTypeDr,PPRType,PPCode,PPStartUser,User,PPRowId,UserDr,count,$j,PayContract,PayContractDesc,PPRDate,PPRReceiver,PPRRemark)
			..d OutputRow6

	}else {
		s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
		s PPCode=$p($g(^DHCDocPP(PPRowId)),"^",1)
		s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
		S PPStartUser=""
		if PPStartUserDr'="" s PPStartUser=$p(^SSU("SSUSR",PPStartUserDr),"^",2)
		s child=0
		f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
		.s User1=""
		.s UserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
		.s:UserDr1'="" User1=$p(^SSU("SSUSR",UserDr1),"^",2)
		.s:User1'="" PPStartUser=PPStartUser_","_User1
		s childsub=0
		f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
		.s PPRRemAmount=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",1)
		.s PPRRemitter=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",3)
		.s PPRRemUserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",2)
		.s PPRRemUser=""
		.s:PPRRemUserDr'="" PPRRemUser=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)  //操作人
		.s PPRDateAdd1=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",7)
		.s PPRDateAdd=""
		.s:PPRDateAdd1'="" PPRDateAdd=..%ZD(PPRDateAdd1) //$zd(PPRDateAdd1,3)  //操作日期
		.i PPRDateAdd="" s PPRDateAdd1=99999
		.s PPRDate=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",5)   //汇款日期
		.s:PPRDate'="" PPRDate=..%ZD(PPRDate) //$zd(PPRDate,3)
		.s PPRReceiverDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",4)   //接收人
		.s PPRReceiver=""
		.s:PPRReceiverDr'="" PPRReceiver=$p(^SSU("SSUSR",PPRReceiverDr),"^",2)
		.s PPRRemark=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",6)  //备注
		.s PPRTimeAdd=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",8)
		.s PPRTimeAdd=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",8)
		.s:PPRTimeAdd'="" PPRTimeAdd=..%ZT(PPRTimeAdd,1)  //操作时间
		.s PPRState=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",9)
		.s:PPRState="A" PPRState="申请"
		.s:PPRState="V" PPRState="到账"
		.s PPRTypeDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
		.i PPRTypeDr="I" s PPRType="IEC"
		.e  i PPRTypeDr="B" s PPRType="备案费"
		.e  i PPRTypeDr="E" s PPRType="项目审核费"
		.e  s PPRType="普通付款"
		.s Account=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",10)
		.;研究者
		.s UserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
		.
		.s User=""
		.s MasterUserDR=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",17)
		.i MasterUserDR'="" d
		..s User=$p(^SSU("SSUSR",MasterUserDR),"^",2)
		..s UserDr=MasterUserDR
		.e  d
		..s User=..GetPPUserByID(PPRowId,UserDr)
		.;i (PPRTypeDr="I"||PPRTypeDr="B") s User=""
		.s PPRRowId=PPRowId_"||"_childsub
		.s count=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",16)
		.i Account="" s Account=..GetAccountByUser(PPRowId,UserDr,PPRType)
		.;i Account="" s Account=..GetPAccountByID(PPRRowId)
		.s PayContract=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",18)
		.s PayContractDesc=..GetPayContractDesc(PayContract)
		.s ^TMPPilot("FindProRem",$j,PPRDateAdd1,PPRRowId,User)=$lb(PPRRowId,PPRRemAmount,PPRRemitter,PPRRemUser,PPRDateAdd,PPRTimeAdd,PPDesc,PPRState,Account,PPRTypeDr,PPRType,PPCode,PPStartUser,User,PPRowId,UserDr,count,$j,PayContract,PayContractDesc,PPRDate,PPRReceiver,PPRRemark)
		.s:count'="" ^TMPPilot("FindProRemCount",$j,User,count)=1
		s j=0
		s Date=""  f  s Date=$o(^TMPPilot("FindProRem",$j,Date)) q:Date=""  d
		.s RowId=""
		.f  s RowId=$o(^TMPPilot("FindProRem",$j,Date,RowId)) q:RowId=""  d
		..s Useri=""
		..f  s Useri=$o(^TMPPilot("FindProRem",$j,Date,RowId,Useri)) q:Useri=""  d
		...s Data1=^TMPPilot("FindProRem",$j,Date,RowId,Useri)
		...s count1=$list(Data1,17)
		...s Type=$list(Data1,11)
		...i ((count1="")&&(Type="普通付款")) d
		....d Calcount
		....s $list(Data1,20)=calcount
		.. d OutputRow6
	}
	k ^TMPPilot("FindProRemCount",$j)
	k ^TMPPilot("FindProRem",$j)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
Calcount
  s calcount=""
  for {
	  s j=j+1
	  i '$d(^TMPPilot("FindProRemCount",$j,User,j)) s calcount=j
	  if calcount'="" q 
  }
  quit
OutputRow6
	set Data=Data1
	s ^TMPFindProRem($j)=ind
	s ^TMPFindProRem($j,ind)=PPRRemAmount_"^"_PPRRemitter_"^"_PPRRemUser_"^"_PPRDateAdd_"^"_PPDesc_"^"_PPRState_"^"_Account_"^"_PPRType_"^"_PPCode_"^"_PPStartUser_"^"_User_"^"_PPRowId_"^"_UserDr_"^"_count
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod GetFindProRemNum(Job) As %String
{
	if $d(^TMPFindProRem(Job)) q ^TMPFindProRem(Job)
	e  q 0
}

ClassMethod GetFindProRem(Job, num) As %String
{
	if $d(^TMPFindProRem(Job,num)) q ^TMPFindProRem(Job,num)
	e  q ""
}

ClassMethod FindProRemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProRemExecute ]
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

// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProRem","29")

Query FindProRem(PPRowId As %String, Flag As %String, SttDate As %String = "", EndDate As %String = "", PPStartUserDr As %String = "", PPCreateDepartmentDr As %String = "") As %Query(ROWSPEC = "PPRRowId:%String,PPRRemAmount:%String,PPRRemitter:%String,PPRRemUser:%String,PPRDateAdd:%String,PPRTimeAdd:%String,PPDesc:%String,PPRState:%String,Account:%String,PPRTypeDr,PPRType,PPCode,ProStartUser,User,PPRowId,UserDr,count,Job,PayContract,PayContractDesc,PPRDate,PPRReceiver,PPRRemark") [ SqlProc ]
{
}

ClassMethod HavePayAccount(PPRRowId As %String) As %String
{
	q:PPRRowId="" 0
	s ret=0
	s PPRTypeDr=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",12)
	i ((PPRTypeDr="I")||(PPRTypeDr="B")||(PPRTypeDr="E")) q 1
	s UserDr=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",15)
	s ProStartUserDr=$p($g(^DHCDocPP(+PPRRowId)),"^",10)
	if ((UserDr="")||((UserDr'="")&&(UserDr=ProStartUserDr))){
	s PayAccount=$p($g(^DHCDocPP(+PPRRowId)),"^",50)
	i PayAccount'="" s ret=1
	s PU=""
	if ProStartUserDr'="" s PU=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	if ##class(web.PilotProject.DHCDocPilotProCommon).getCFFixedAcountFlag(ProStartUserDr)=1 s ret=1
	}
	else{
	s child=""
	s PPRowId=+PPRRowId
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr=""
	.s ProStartUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.;s:ProStartUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",ProStartUserDr1),"^",2)
	.;s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.;s:UserUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",UserUserDr1),"^",2)
	.i UserDr=ProStartUserDr  d
	..s Account=$p($g(^DHCDocPPD(PPRowId,child)),"^",4)
	..i Account'=""  s ret=1
	}
	q ret
}

ClassMethod ConfirmPay(PPRRowId As %String, Account As %String, PPRReceiver As %String) As %String
{
	q:PPRRowId="" ""
	//s ^zzy("ConfirmPay")=PPRRowId_"^"_Account_"^"_PPRReceiver
	s PayAccount=$p($g(^DHCDocPP(+PPRRowId)),"^",50)
	s PPRowId=+PPRRowId
	s PPRTypeDr=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",12)
	i ((PPRTypeDr="I")||(PPRTypeDr="B")||(PPRTypeDr="E")) s PayAccount="V000001"
	s UserDr=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",15)
	s ProStartUserDr=$p($g(^DHCDocPP(+PPRRowId)),"^",10)
	s ProStartUserName=""
	s:ProStartUserDr'="" ProStartUserName=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	s CFFixedAcountFlag=##class(web.PilotProject.DHCDocPilotProCommon).getCFFixedAcountFlag(ProStartUserDr)
	s PU=""
	
	Ts
	
	s myrtn=0
	if ((UserDr="")||((UserDr'="")&&(UserDr=ProStartUserDr))){
	if PayAccount=""{
		if UserDr'="" s PU=$p(^SSU("SSUSR",UserDr),"^",2)
		s CFFixedAcountFlag1=##class(web.PilotProject.DHCDocPilotProCommon).getCFFixedAcountFlag(UserDr)
		i ((CFFixedAcountFlag1=1)&&(Account="")||((CFFixedAcountFlag=1)&&(UserDr="")&&(Account=""))) s Account="V000002"
		q:Account="" "-1"
		s Money=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",1)
		s PPRState=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",9)
		q:PPRState="V" "-110"
		&sql(Update dhc_docpilotprorem set PPR_State="V",PPR_Account=:Account,PPR_Receiver=:PPRReceiver,PPR_FirstPay=1 where  PPR_RowId=:PPRRowId)
		s myrtn=SQLCODE
		if +myrtn=0{
			&sql(Update dhc_docpilotproject set PP_PayAccount=:Account,PP_TotalPayment=:Money where PP_RowId=:PPRowId)
		}
		s myrtn=SQLCODE
		
		
	}else{
		s PPRState=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",9)
		q:PPRState="V" "-110"
		s OldMoney=$p($g(^DHCDocPP(PPRowId)),"^",51)
		s NewMoney=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",1)
		s Money=OldMoney+NewMoney
		&sql(Update dhc_docpilotprorem set PPR_State="V",PPR_Account=:PayAccount,PPR_Receiver=:PPRReceiver where  PPR_RowId=:PPRRowId)
	  s myrtn=SQLCODE
	  if +myrtn=0{
			&sql(Update dhc_docpilotproject set PP_TotalPayment=:Money where PP_RowId=:PPRowId)
		}
		s myrtn=SQLCODE
	}
	}
	else{
	s child=""
	s chi=""
	s PAccount=""
	s PPRowId=+PPRRowId
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr=""
	.s ProStartUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.;s:ProStartUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",ProStartUserDr1),"^",2)
	.;s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.;s:UserUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",UserUserDr1),"^",2)
	.i UserDr=ProStartUserDr  d
	..s chi=child
	..s PAccount=$p($g(^DHCDocPPD(PPRowId,child)),"^",4)
	q:chi="" "-1"
	b
	s RowId=PPRowId_"||"_chi
	s PU=""
	if UserDr'="" s PU=$p(^SSU("SSUSR",UserDr),"^",2)
	s CFFixedAcountFlag=##class(web.PilotProject.DHCDocPilotProCommon).getCFFixedAcountFlag(UserDr)
	i ((CFFixedAcountFlag=1)&&(PAccount="")) s PAccount="V000002"
	q:((PAccount="")&&(Account="")) "-1"
	if PAccount=""{
	s Money=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",1)
		s PPRState=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",9)
		q:PPRState="V" "-110"
		&sql(Update dhc_docpilotprorem set PPR_State="V",PPR_Account=:Account,PPR_Receiver=:PPRReceiver,PPR_FirstPay=1 where  PPR_RowId=:PPRRowId)
		s myrtn=SQLCODE
		if +myrtn=0{
			&sql(Update dhc_docpilotprodept set PPD_Account=:Account where PPD_RowId=:RowId)
		}
		s myrtn=SQLCODE
	} else{
		s PPRState=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",9)
		q:PPRState="V" "-110"
		&sql(Update dhc_docpilotprorem set PPR_State="V",PPR_Account=:PAccount,PPR_Receiver=:PPRReceiver where  PPR_RowId=:PPRRowId)
		s myrtn=SQLCODE
		
		
	} 
	
		
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

ClassMethod GetTotalPayment(PPRowId As %String) As %String
{
	q:PPRowId="" 0
	s Money=$p($g(^DHCDocPP(PPRowId)),"^",51)
	i Money="" q 0
	q Money
}

ClassMethod GetAccount(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s Account=$p($g(^DHCDocPP(PPRowId)),"^",50)
	q Account
}

ClassMethod UpdateFileMethod(myProjecctInfo As %String, PPRowId As %String, UserID As %String) As %String
{
    //s ^gry("UpdateFileMethod")=$lb(myProjecctInfo,PPRowId,UserID)
	n (myProjecctInfo,PPRowId,UserID)
	s myrtn=0,errDesc="",EthicsMeetAduitDate=""
	s UObj=##class(User.DHCDocPilotProject).%OpenId(PPRowId)
	if ($IsObject(UObj)) {
		s myrtn=0,errDesc=""
		s myProObj=##class(web.PilotProject.PPA.DHCDocPilotProject).%New()
		d myProObj.XMLNodeDeserialize(.myProObj, "DHCDocPilotProject", myProjecctInfo)
		TS
		s OldDataObject=..GetFileLogData(PPRowId)  ;add by nk
		s UObj.EndYear=myProObj.EndYear
		s UObj.DeptCode=myProObj.DeptCode
		s UObj.ProjectNo=myProObj.ProjectNo
		s UObj.FileCaseNo=myProObj.FileCaseNo
		s UObj.ApplyContact=myProObj.ApplyContact
		s UObj.ApplyContactTel=myProObj.ApplyContactTel
		s UObj.CROContact=myProObj.CROContact
		s UObj.CROContactTel=myProObj.CROContactTel
		s UObj.CountUnitContact=myProObj.CountUnitContact
		s UObj.CountUnitContactTel=myProObj.CountUnitContactTel
		s UObj.DesignCaseNum=myProObj.DesignCaseNum
		s UObj.LocalGroupPlanCaseNum=myProObj.LocalGroupPlanCaseNum
		s UObj.LocalGroupFactCaseNum=myProObj.LocalGroupFactCaseNum
		s:myProObj.LastCaseDate'="" myProObj.LastCaseDate=..%ZDH(myProObj.LastCaseDate) //$zdh(myProObj.LastCaseDate,4)
		s UObj.LastCaseDate=myProObj.LastCaseDate
		s UObj.FilterCaseNum=myProObj.FilterCaseNum
		s UObj.RejectCaseNum=myProObj.RejectCaseNum
		s UObj.DropCaseNum=myProObj.DropCaseNum
		s UObj.SAECaseNum=myProObj.SAECaseNum
		s:myProObj.BriefDate'="" myProObj.BriefDate=..%ZDH(myProObj.BriefDate) //$zdh(myProObj.BriefDate,4)
		s UObj.BriefDate=myProObj.BriefDate
		
		s:myProObj.CenterDate'="" myProObj.CenterDate=..%ZDH(myProObj.CenterDate) //$zdh(myProObj.CenterDate,4)
		s UObj.CenterDate=myProObj.CenterDate
		s:myProObj.SumDate'="" myProObj.SumDate=..%ZDH(myProObj.SumDate) //$zdh(myProObj.SumDate,4)
		s UObj.SumDate=myProObj.SumDate
		s oldFilingstatus=""
		s:$IsObject(UObj.FilingstatusDr) oldFilingstatus=$p($g(^DHCDocCT("DefineData",+UObj.FilingstatusDr.%Id(),"D",$p(UObj.FilingstatusDr.%Id(),"||",2))),"^",2)
	    s Filingstatus=""
		i myProObj.FilingstatusDr'="" s Filingstatus=$p($g(^DHCDocCT("DefineData",+myProObj.FilingstatusDr,"D",$p(myProObj.FilingstatusDr,"||",2))),"^",2)
		d UObj.FilingstatusDrSetObjectId(myProObj.FilingstatusDr)
		s:myProObj.FilingDate'="" myProObj.FilingDate=..%ZDH(myProObj.FilingDate) //$zdh(myProObj.FilingDate,4)
		s UObj.FilingDate=myProObj.FilingDate
		s UObj.SaveLastDate=myProObj.SaveLastDate
		s UObj.GroupTransferUser=myProObj.GroupTransferUser
		s UObj.recipient=myProObj.recipient
		d UObj.EthicsFilesOffStatusDrSetObjectId(myProObj.EthicsFilesOffStatusDr)
		s:myProObj.EthicsFilesOffDate'="" myProObj.EthicsFilesOffDate=..%ZDH(myProObj.EthicsFilesOffDate) //$zdh(myProObj.EthicsFilesOffDate,4)
		s UObj.EthicsFilesOffDate=myProObj.EthicsFilesOffDate
		s UObj.EthicsFilesOffOperator=myProObj.EthicsFilesOffOperator
		s UObj.EthicsFilesOffCompany=myProObj.EthicsFilesOffCompany
		s UObj.EthicsFilesOffTel=myProObj.EthicsFilesOffTel
		s UObj.ImageDataLocation=myProObj.ImageDataLocation
		s UObj.ImageDataNum=myProObj.ImageDataNum
		s UObj.FileNum=myProObj.FileNum
		s UObj.FormConsentNum=myProObj.FormConsentNum
		s UObj.CaseReportNum=myProObj.CaseReportNum
		s UObj.EthicsFilesNum=myProObj.EthicsFilesNum
		s UObj.OrigRecordNum=myProObj.OrigRecordNum
		;s UObj.TotalFileNum=(+myProObj.FileNum)+(+myProObj.FormConsentNum)+(+myProObj.CaseReportNum)+(+myProObj.EthicsFilesNum)+(+myProObj.OrigRecordNum)
		s UObj.TotalFileNum=myProObj.TotalFileNum
		s UObj.PPFileRemark=myProObj.PPFileRemark
		s:myProObj.FirstPatDate'="" myProObj.FirstPatDate=..%ZDH(myProObj.FirstPatDate) //$zdh(myProObj.FirstPatDate,4)
		s UObj.FirstPatDate=myProObj.FirstPatDate
		s UObj.BriefRemark=myProObj.BriefRemark
		s UObj.CenterRemark=myProObj.CenterRemark
		s UObj.ConclusionRemark=myProObj.ConclusionRemark
		i myProObj.Brief="" s myProObj.BriefDr=""
		i myProObj.Center="" s myProObj.CenterDr=""
		i myProObj.Conclusion="" s myProObj.ConclusionDr=""
		d UObj.BriefSetObjectId(myProObj.BriefDr)
		d UObj.CenterSetObjectId(myProObj.CenterDr)
		d UObj.ConclusionSetObjectId(myProObj.ConclusionDr)
		s UObj.CollectCompany=myProObj.CollectCompany
		s UObj.RegNo=myProObj.RegNo
		s UObj.EndQualityCtrlFlag=myProObj.EndQualityCtrlFlag
		s:myProObj.EndQualityCtrlDate'="" myProObj.EndQualityCtrlDate=..%ZDH(myProObj.EndQualityCtrlDate) //$zdh(myProObj.EndQualityCtrlDate,4)
		s UObj.EndQualityCtrlDate=myProObj.EndQualityCtrlDate
		
	   /* s EthicsMeetAduitDate=UObj.EthicsMeetAduitDate
		if $l(myProObj.PPStartDate,"/")=3 s myProObj.PPStartDate=$zdh(myProObj.PPStartDate,4)
		if $l(myProObj.PPEndDate,"/")=3 s myProObj.PPEndDate=$zdh(myProObj.PPEndDate,4)
		if $l(myProObj.FileSubmitDate,"/")=3 s myProObj.FileSubmitDate=$zdh(myProObj.FileSubmitDate,4)
        if $l(myProObj.EthicsMeetDate,"/")=3 s myProObj.EthicsMeetDate=$zdh(myProObj.EthicsMeetDate,4)
        if $l(myProObj.EthicsMeetAduitDate,"/")=3 s myProObj.EthicsMeetAduitDate=$zdh(myProObj.EthicsMeetAduitDate,4)
        if $l(myProObj.EthicsFilesOffDate,"/")=3 s myProObj.EthicsFilesOffDate=$zdh(myProObj.EthicsFilesOffDate,4)
        if $l(myProObj.SignProtocolDate,"/")=3 s myProObj.SignProtocolDate=$zdh(myProObj.SignProtocolDate,4)
		TS
		s UObj.PPCode=myProObj.PPCode
		s UObj.PPDesc=myProObj.PPDesc
		s UObj.PPOrder=myProObj.PPOrder
		s UObj.PPResult=myProObj.PPResult
		s UObj.PPRemark=myProObj.PPRemark
		d UObj.PPCreateDepartmentDrSetObjectId(myProObj.PPCreateDepartmentDr)
		d UObj.PPCreateUserDrSetObjectId(myProObj.PPCreateUserDr)
		;s UObj.PPCreateDate=..%SysDate()
		;s UObj.PPCreateTime=..%SysTime()
		d UObj.PPStartUserDrSetObjectId(myProObj.PPStartUserDr)  ;项目批准人
		s UObj.PPStartDate=myProObj.PPStartDate
		d UObj.IndicationDrSetObjectId(myProObj.IndicationDr)
		d UObj.PilotCategoryDrSetObjectId(myProObj.PilotCategoryDr)
		d UObj.EthicsFilesNextStateDrSetObjectId(myProObj.EthicsFilesNextStateDr)
		d UObj.EthicsFilesStateDrSetObjectId(myProObj.EthicsFilesStateDr)
		d UObj.ProjectFilesStateDrSetObjectId(myProObj.ProjectFilesStateDr)
		d UObj.IsHeadmanDrSetObjectId(myProObj.IsHeadmanDr)
		
		d UObj.ApplyStageDrSetObjectId(myProObj.ApplyStageDr)
		s UObj.ApplicationUnit=myProObj.ApplicationUnit
	    s UObj.PlanNo=myProObj.PlanNo
	    s UObj.PlanName=myProObj.PlanName
	    s UObj.ApprovalNo=myProObj.ApprovalNo
	    s UObj.Role=myProObj.Role
	    s UObj.ExamReportNum=myProObj.ExamReportNum
		s UObj.FileSubmitDate=myProObj.FileSubmitDate
		s UObj.EthicsMeetDate=myProObj.EthicsMeetDate
		s UObj.EthicsMeetAduitDate=myProObj.EthicsMeetAduitDate
		s UObj.ArchivesFilesNo=myProObj.ArchivesFilesNo
		s UObj.CollectCompany=myProObj.CollectCompany
		s UObj.EthicsFilesOffDate=myProObj.EthicsFilesOffDate
		s UObj.SignProtocolDate=myProObj.SignProtocolDate
		s UObj.LeaderCompany=myProObj.LeaderCompany
		s UObj.LeaderCompanyPI=myProObj.LeaderCompanyPI
		s UObj.CROCompany=myProObj.CROCompany
		;d UObj.PPEndUserDrSetObjectId(myProObj.PPEndUserDr)
		s UObj.PPEndDate=myProObj.PPEndDate
		;s UObj.PPEndTime=myProObj.PPEndTime
		i ((myProObj.EthicsMeetAduitDate'="")&&(EthicsMeetAduitDate'=myProObj.EthicsMeetAduitDate)&&(UObj.PPState="N")) s UObj.PPState="V"
		s UObj.PPBudget=myProObj.PPBudget
		s UObj.ApplyMatterDr=myProObj.ApplyMatterDr */
		if (Filingstatus="已归档") s UObj.PPState="F"
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		b ;ProjectSave
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-104"
		}
		d UObj.%Close()
		if +myrtn=0{
			if ((oldFilingstatus'="已归档")&&(Filingstatus="已归档")){
				;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPRowId
		s ProjectStateObj.PPSCurState="F"
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		s ProjectStateObj.PPSUpdateReason="归档"
		;s ProjectStateObj.PPSAuthUserDr=myProObj.PPStartUserDr    ;批准人
		s myrtn=..InsertProjectState(ProjectStateObj)
			}
		}
		;add by nk start
		if +myrtn=0{
			s Flag=..SaveFileLog(OldDataObject,PPRowId,UserID)
			if Flag'=0{
				s myrtn="-101"
			}
		}
		;------end
		
		if +myrtn=0{
			TC
		}else{
			TRO
		}
	/*	if ((+myrtn=0)&&(myProObj.EthicsMeetAduitDate'="")&&(EthicsMeetAduitDate'=myProObj.EthicsMeetAduitDate)&&(UObj.PPState="N")) {
		;插入子表状态
		s ProjectStateObj=##class(web.PilotProject.PPA.DHCDocPilotProState).%New()
		s ProjectStateObj.PPSPPParRef=PPSPPParRef
		s ProjectStateObj.PPSUpdateUserDr=myProObj.PPCreateUserDr
		s ProjectStateObj.PPSUpdateDate=..%SysDate()
		s ProjectStateObj.PPSUpdateTime=..%SysTime()
		;s ProjectStateObj.PPSRemark=""
		s ProjectStateObj.PPSCurState="V"
		s ProjectStateObj.PPSUpdateReason="伦理委员会批准"
		s ProjectStateObj.PPSAuthUserDr=myProObj.PPStartUserDr    ;批准人
		s myrtn=..InsertProjectState(ProjectStateObj)
	}*/
		if myrtn="-104" s errDesc="插入项目数据失败."
	}
	
	Q myrtn_"^"_errDesc
}

/// creatTime:2014-09-12
/// add by:nk
/// Description:插入档案信息修改日志信息
ClassMethod SaveFileLog(OldDataObj As %Library.ListOfObjects, PPRowId As %String, UserID) As %String
{
	n (%session,OldDataObj,PPRowId,UserID)
	q:'$IsObject(OldDataObj)
	s NewDataObj=..GetFileLogData(PPRowId)
	q:'$IsObject(NewDataObj)
	;s UPUserDr=%session.Get("LOGON.USERID")
	s UPUserDr="3335"
	s UPUserIP=$zutil(67,15,$j)   //获取IP地址
    s UPDate=..%SysDate()
 	s UPTime=..%SysTime()
    s OldSingleObj=##class(web.PilotProject.PPA.DHCDocPilotProFileLog).%New()
    s NewSingleObj=##class(web.PilotProject.PPA.DHCDocPilotProFileLog).%New()
    s OldSingleObj=OldDataObj.GetAt(1)
    s NewSingleObj=NewDataObj.GetAt(1)
    q:('$IsObject(OldSingleObj)||'$IsObject(NewSingleObj))
    s OldPPCode=OldSingleObj.PPCode
    s OldPPDesc=OldSingleObj.PPDesc
    s OldBriefDate=OldSingleObj.BriefDate
    s OldCenterDate=OldSingleObj.CenterDate
    s OldSumDate=OldSingleObj.SumDate
    s OldRowId=OldSingleObj.PPSRowID
    s:OldBriefDate'="" OldBriefDate=..%ZD(OldBriefDate) //$zd($g(OldBriefDate),3)
    s:OldCenterDate'="" OldCenterDate=..%ZD(OldCenterDate) //$zd($g(OldCenterDate),3)
    s:OldSumDate'="" OldSumDate=..%ZD(OldSumDate) //$zd($g(OldSumDate),3)   
    s NewBriefDate=NewSingleObj.BriefDate
    s NewCenterDate=NewSingleObj.CenterDate
    s NewSumDate=NewSingleObj.SumDate
    s NewRowId=NewSingleObj.PPSRowID
    s:NewBriefDate'="" NewBriefDate=..%ZD($g(NewBriefDate)) //$zd($g(NewBriefDate),3)
    s:NewCenterDate'="" NewCenterDate=..%ZD($g(NewCenterDate)) //$zd($g(NewCenterDate),3)
    s:NewSumDate'="" NewSumDate=..%ZD($g(NewSumDate)) //$zd($g(NewSumDate),3)
    s UpdPropertyStr=""   
    if (OldRowId=NewRowId)&&(OldBriefDate'=NewBriefDate)  d
    .i UpdPropertyStr="" s UpdPropertyStr="小结日期"_"由'"_OldBriefDate_"'改成了'"_NewBriefDate_"'"
    .e  s UpdPropertyStr=UpdPropertyStr_";"_"小结日期"_"由'"_OldBriefDate_"'改成了'"_NewBriefDate_"'"
	if (OldRowId=NewRowId)&&(OldCenterDate'=NewCenterDate)  d
	.i UpdPropertyStr="" s UpdPropertyStr="关中心日期"_"由'"_OldCenterDate_"'改成了'"_NewCenterDate_"'"
	.e  s UpdPropertyStr=UpdPropertyStr_";"_"关中心日期"_"由'"_OldCenterDate_"'改成了'"_NewCenterDate_"'"
	if (OldRowId=NewRowId)&&(OldSumDate'=NewSumDate)  d
	.i UpdPropertyStr="" s UpdPropertyStr="总结日期"_"由'"_OldSumDate_"'改成了'"_NewSumDate_"'"
	.e  s UpdPropertyStr=UpdPropertyStr_";"_"总结日期"_"由'"_OldSumDate_"'改成了'"_NewSumDate_"'"	 
	&sql(insert into SQLUser.DHCDoc_PilotProFileLog(PP_Code,PP_Desc,PPSUpdate_Date,PPSUpdate_Time,PPSUpdate_UserDr,PPSUpdate_UserIP,PPSUpdate_Str,DHCDoc_PilotPro_Dr)
    values(:OldPPCode,:OldPPDesc,:UPDate,:UPTime,:UserID,:UPUserIP,:UpdPropertyStr,:PPRowId))
    q SQLCODE
}

/// w ##class(web.PilotProject.DHCDocPilotProject).GetFileLogData("3")
/// add by nk
ClassMethod GetFileLogData(PPRowId As %String) As %Library.ListOfObjects
{
	s ^nk("GetFileLogData")=PPRowId
	s OutPutStream=##class(%Stream.GlobalCharacter).%New()
	q:PPRowId="" OutPutStream
	s ListObj=##class(%Library.ListOfObjects).%New()	
	s ClassObj=$ZOBJCLASSMETHOD("User.DHCDocPilotProject","%OpenId",PPRowId)
	q:'$IsObject(ClassObj)
	s SingleObj=##class(web.PilotProject.PPA.DHCDocPilotProFileLog).%New()
	if $IsObject(SingleObj)
	{
		s SingleObj.PPCode = ClassObj.PPCode
		s SingleObj.PPDesc = ClassObj.PPDesc
		s SingleObj.BriefDate = ClassObj.BriefDate
		s SingleObj.CenterDate = ClassObj.CenterDate
		s SingleObj.SumDate = ClassObj.SumDate
		s SingleObj.PPSRowID=PPRowId
	}
	d ListObj.Insert(SingleObj)
	d SingleObj.%Close()				
	q ListObj
}

ClassMethod DelLBlack(String As %String)
{
	 s length=$l(String)
	 s checkflag="",subStr=String
	 f i=1:1:length  q:(checkflag'="")&&(checkflag'=" ")  d
	 .s char=$e(String,i)
	 .s checkflag=char
	 .i (char=" ") d
	 ..s subStr=$e(String,i+1,length)
	 .e  q 
	 q subStr
}

/// 查询档案修改日志
/// add by nk
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","QueryUptLog","","15/08/2014","15/09/2014")
Query QueryUptLog(PPCode As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "TPPCode:%String,TPPDesc:%String,TUpdDate:%String,TUpdTime:%String,TUpdSSUser:%String,TUpdStr:%String,TUpdIP:%String")
{
}

ClassMethod QueryUptLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUptLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryUptLogExecute(ByRef qHandle As %Binary, PPCode As %String, StartDate As %String, EndDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s ^nk("nk")=PPCode_","_StartDate_","_EndDate
	s (TPPCode,TPPDesc,TUpdDate,TUpdTime,TUpdSSUser,TUpdStr,TUpdIP)=""  
	if StartDate="" s StartDate=..%SysDate()
    e  i $l(StartDate,"/")=3  s StartDate=$zdh(StartDate,4)
    if EndDate="" s EndDate=..%SysDate()
    e  i $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,4)
    if StartDate>EndDate d
    .s mDate=StartDate
    .s StartDate=EndDate
    .s EndDate=mDate
	if PPCode'= ""
	{
		s UPPRowid=""
		f  s UPPRowid = $o(^FileLogs("PPCode",PPCode,UPPRowid)) q:UPPRowid=""  d
		.Set TPPCode = $p($g(^FileLog(UPPRowid)),"^",1)
		.Set TPPDesc = $p($g(^FileLog(UPPRowid)),"^",2)
	    .Set TUPDate = $zd($p($g(^FileLog(UPPRowid)),"^",7),4)
	    .Set TUPTime = ..%ZT($p($g(^FileLog(UPPRowid)),"^",8),1)
	    .set TUpdIP = $p($g(^FileLog(UPPRowid)),"^",9)
	    .Set TUPUserDr = $p($g(^FileLog(UPPRowid)),"^",6)   
	    .if (TUPUserDr'="")&&($d(^SSU("SSUSR",TUPUserDr)))  d
	    ..s TUpdSSUser=$p(^SSU("SSUSR",TUPUserDr),"^",2)
	    .set TUpdStr=$p($g(^FileLog(UPPRowid)),"^",11)
	    .d OutputRow1		
	}   
	if ((PPCode="")&&(StartDate'="")&&(EndDate'="")&&(StartDate<=EndDate))
	{  
	   	f UptDate=StartDate:1:EndDate d   	
	   	.s UPPRowid=""
	   	.f  s UPPRowid=$o(^FileLogs("LogDate",UptDate,UPPRowid)) q:UPPRowid=""  d
	   	..w UPPRowid
	   	..b ;UPPRowid
		..Set TPPCode = $p($g(^FileLog(UPPRowid)),"^",1)
		..Set TPPDesc = $p($g(^FileLog(UPPRowid)),"^",2)
	    ..Set TUPDate = $zd($p($g(^FileLog(UPPRowid)),"^",7),4)
	    ..Set TUPTime = ..%ZT($p($g(^FileLog(UPPRowid)),"^",8),1)
	    ..set TUpdIP = $p($g(^FileLog(UPPRowid)),"^",9)
	    ..Set TUPUserDr = $p($g(^FileLog(UPPRowid)),"^",6)   
	    ..if (TUPUserDr'="")&&($d(^SSU("SSUSR",TUPUserDr)))  d
	    ...s TUpdSSUser=$p(^SSU("SSUSR",TUPUserDr),"^",2)
	    ..set TUpdStr=$p($g(^FileLog(UPPRowid)),"^",11)
	    ..d OutputRow1	
	   		
	}
	if ((PPCode'="")&&(StartDate'="")&&(EndDate'="")&&(StartDate<=EndDate))
	{  
	   	f UptDate=StartDate:1:EndDate d   	
	   	.s UPPRowid=""
	   	.f  s UPPRowid=$o(^FileLogs("LogDate",UptDate,UPPRowid)) q:UPPRowid=""  d
	   	..w UPPRowid
	   	..b ;UPPRowid
		..Set TPPCode = $p($g(^FileLog(UPPRowid)),"^",1)
		..q:PPCode'=TPPCode
		..Set TPPDesc = $p($g(^FileLog(UPPRowid)),"^",2)
	    ..Set TUPDate = $zd($p($g(^FileLog(UPPRowid)),"^",7),4)
	    ..Set TUPTime = ..%ZT($p($g(^FileLog(UPPRowid)),"^",8),1)
	    ..set TUpdIP = $p($g(^FileLog(UPPRowid)),"^",9)
	    ..Set TUPUserDr = $p($g(^FileLog(UPPRowid)),"^",6)   
	    ..if (TUPUserDr'="")&&($d(^SSU("SSUSR",TUPUserDr)))  d
	    ...s TUpdSSUser=$p(^SSU("SSUSR",TUPUserDr),"^",2)
	    ..set TUpdStr=$p($g(^FileLog(UPPRowid)),"^",11)
	    ..d OutputRow11
	   		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow11
	set Data=$lb(TPPCode,TPPDesc,TUPDate,TUPTime,TUpdSSUser,TUpdStr,TUpdIP)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUptLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUptLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" 
	 {	// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      
	 {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 // Save QHandle
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 接受药政部门检查界面更新方法
/// d ##class(web.PilotProject.DHCDocPilotProject).UpdateDrugExam("37","20/05/2013","21/05/2013","19/05/2013","Y","Y","Y")
ClassMethod UpdateDrugExam(PPRowId As %String, DrugExamCheckDate As %String, DrugExamSelectCheckDate As %String, DrugExamInspectDate As %String, PassCheckFlag As %String, PassSelectCheckFlag As %String, PassInspectFlag As %String) As %String
{
	s ^temp("UpdateDrugExam")=PPRowId_","_DrugExamCheckDate_","_DrugExamSelectCheckDate_","_DrugExamInspectDate_","_PassCheckFlag_","_PassSelectCheckFlag_","_PassInspectFlag
	q:PPRowId=""
	if (DrugExamCheckDate'="") s DrugExamCheckDate=$zdh(DrugExamCheckDate,4)
	if (DrugExamSelectCheckDate'="") s DrugExamSelectCheckDate=$zdh(DrugExamSelectCheckDate,4)
	if (DrugExamInspectDate'="")  s DrugExamInspectDate=$zdh(DrugExamInspectDate,4)
	&sql(update DHC_DocPilotProject 
	set PP_DrugExamCheckDate=:DrugExamCheckDate,
	    PP_DrugExamSelectCheckDate=:DrugExamSelectCheckDate,
	    PP_DrugExamInspectDate=:DrugExamInspectDate, 
	    PP_DrugExamCheckFlag=:PassCheckFlag,
	    PP_DrugExamSelectCheckFlag=:PassSelectCheckFlag,
	    PP_DrugExamInspectFlag=:PassInspectFlag
	    where PP_RowId=:PPRowId) 
	q SQLCODE
}

ClassMethod GetDrugExamCheckResult(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s Result=$p($g(^DHCDocPP(PPRowId)),"^",88)
	s DrugExamCheckDate=$p($g(^DHCDocPP(PPRowId)),"^",87)
	s:DrugExamCheckDate'="" DrugExamCheckDate=$zd(DrugExamCheckDate,4)
	q Result_"^"_DrugExamCheckDate
}

ClassMethod GetDrugExamSelectCheckResult(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s Result=$p($g(^DHCDocPP(PPRowId)),"^",90)
	s DrugExamSelectCheckDate=$p($g(^DHCDocPP(PPRowId)),"^",89)
	s:DrugExamSelectCheckDate'="" DrugExamSelectCheckDate=$zd(DrugExamSelectCheckDate,4)
	q Result_"^"_DrugExamSelectCheckDate
}

ClassMethod GetDrugExamInspectResult(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s Result=$p($g(^DHCDocPP(PPRowId)),"^",92)
	s DrugExamInspectDate=$p($g(^DHCDocPP(PPRowId)),"^",91)
	s:DrugExamInspectDate'="" DrugExamInspectDate=$zd(DrugExamInspectDate,4)
	q Result_"^"_DrugExamInspectDate
}

Query FindSettleDetails(PPRowId As %String, PPSetRowId) As %Query(ROWSPEC = "PPRRowId:%String,TDate:%String,TName:%String,TAccount:%String,TFeeType:%String,TAmountBeforeTax:%String,TAmountAfterTax:%String,TPay:%String,MessageNote:%String,RemUser,Select,NTax,PPDesc:%String,PPCode:%String") [ SqlProc ]
{
}

ClassMethod FindSettleDetailsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindSettleDetailsExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSettleDetailsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSettleDetailsExecute ]
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

/// 获得本次科研项目的经费详细信息
/// 入参：PPRowId科研项目的rowid
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindSettleDetails","36")
ClassMethod FindSettleDetailsExecute(ByRef QHandle As %Binary, PPRowId As %String, PPSetRowId) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	d ResetVariables7
	i ((PPRowId="")&&(PPSetRowId'="")) s PPRowId=$p(PPSetRowId,"||",1)
	i PPRowId="" Set QHandle=$lb(0,repid,0)  Quit $$$OK
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
	s num=0
	s TotalAmountBeforeTax=0
	s TotalAmountAfterTax=0
	s TPay=""
	s MessageNote="入账"
	s rate=0
	if PPSetRowId'="" d
	.s PPSETRems=$p(^DHCDocPPSET(+PPSetRowId,$p(PPSetRowId,"||",2)),"^",20)
	.i PPSETRems="" d FindSettle1
	.else  d
	..s PPSETRems="-"_PPSETRems_"-"
	..s childsub=0
	..f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	
	...s RemUser=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	...;i RemUser'="" d
	....;s PPCreateDepartment1=PPCreateDepartment
	....;f t=1:1:$l(PPStartUser,",") d
	.....;if $p(PPStartUser,",",t)=RemUser d
	......;s PPCreateDepartment=$p(PPCreateDepartment1,",",t)
	...s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	...s PPStartUser=$p($g(^SSU("SSUSR",PPStartUserDr)),"^",2)
	...s PPCreateDepartment=""
	...s PPCreateDepartment1=""
	...s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	...s:PPCreateDepartmentDr'="" PPCreateDepartment1=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	...s PPCreateDepartment1=##class(web.DHCOPAdmReg).LocDescFormate(PPCreateDepartment1) //$p($g(PPCreateDepartment1),"-",2)
	...i ((RemUser="")||(RemUser=PPStartUserDr)) s PPCreateDepartment=PPCreateDepartment1
	...s child=0
		...f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
		....s User=""
		....s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
		....s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
		....s Dep=""
		....if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
		....i Dep["免疫" s Dep="风湿免疫科"
		....s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		....s:RemUser=UserDr PPCreateDepartment=Dep
	
	...s PPStartUser=..GetPPUserByID(PPRowId,RemUser)
	...s PPRRemAmount=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",1)
	...s PPRRemitter=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",3)
	...s PPRRemUserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",2)
	...s PPRType=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	...s FeeType=""
	...s PPRRemUser=""
	...s:PPRRemUserDr'="" PPRRemUser=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)
	...s Tax=""
	...i PPSetRowId'="" d
	....i $d(^DHCDocPPSettle("Taxs",PPSetRowId,PPRowId_"||"_childsub)) d
	.....i ^DHCDocPPSettle("Taxs",PPSetRowId,PPRowId_"||"_childsub)="N" d
	......s Tax=1
	...s PPRDateAddTemp=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",7)
	...s:PPRDateAddTemp'="" PPRDateAdd=$zd(PPRDateAddTemp,8)
	...s rate=$s(PPRDateAddTemp<61209:1,(61209<PPRDateAddTemp)&&(PPRDateAddTemp<=62578):0.945,PPRDateAddTemp>62578:0.944)
	...i Tax=1 s rate=1
	...s AmountBeforeTax=+PPRRemAmount
	...s AmountAfterTax=AmountBeforeTax*rate
	...s AmountAfterTax=$fn(AmountAfterTax,"",2)
	...s PPRState=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",9)
	...s:PPRState="A" PPRState="申请"
	...s:PPRState="V" PPRState="到账"
	...q:PPRState="申请"
	...s TotalAmountBeforeTax=TotalAmountBeforeTax+AmountBeforeTax
	...s TotalAmountAfterTax=TotalAmountAfterTax+AmountAfterTax
	...i (PPRState="到账")&&(PPRType="I") d
	....s FeeType="IEC"
	....s PPCreateDepartment="临床药理"
	....s PPStartUser="临床药理"
	...i (PPRState="到账")&&(PPRType="B") d
	....s FeeType="备案费"
	....s PPCreateDepartment="临床药理"
	...i (PPRState="到账")&&(PPRType="E") d
	....s FeeType="项目审核费"
	....s PPCreateDepartment="临床药理"
	....s PPStartUser="临床药理"
	...i (PPRState="到账")&&(PPRType="") d
	....;s num=num+1
	....s num=$$GetPayCount(PPRowId,childsub)
	....s FeeType="第"_num_"次付款"
	...s Account=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",10)
	...s PPRRowId=PPRowId_"||"_childsub
	...s:PPSETRems[("-"_PPRRowId_"-") Select="Y"
	...s:PPSETRems'[("-"_PPRRowId_"-") Select="N"
	...Do OutputRow7
	/*..s len=$l(PPSETRems,"-")
	..f i=1:1:len d
	...s PPSETRem=$p(PPSETRems,"-",i)
	
	...s PPRRemAmount=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",1)
	...s PPRRemitter=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",3)
	...s PPRRemUserDr=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",2)
	...s PPRType=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",12)
	...s RemUser=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",15)
	...;i RemUser'="" d
	....;s PPCreateDepartment1=PPCreateDepartment
	....;f t=1:1:$l(PPStartUser,",") d
	.....;if $p(PPStartUser,",",t)=RemUser d
	......;s PPCreateDepartment=$p(PPCreateDepartment1,",",t)
	...s PPStartUserDr=$p($g(^DHCDocPP(+PPSetRowId)),"^",10)
	...s PPStartUser=$p($g(^SSU("SSUSR",PPStartUserDr)),"^",2)
	...s PPCreateDepartment=""
	...s PPCreateDepartment1=""
	...s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	...s:PPCreateDepartmentDr'="" PPCreateDepartment1=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	...s PPCreateDepartment1=$p($g(PPCreateDepartment1),"-",2)
	...i ((RemUser="")||(RemUser=PPStartUserDr)) s PPCreateDepartment=PPCreateDepartment1
	...s child=0
		...f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
		....s User=""
		....s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
		....s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
		....s Dep=""
		....if DepDr'="" s Dep=$p($P(^CTLOC(DepDr),"^",2),"-",2)
		....i Dep["免疫" s Dep="风湿免疫科"
		....s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		....s:RemUser=UserDr PPCreateDepartment=Dep
	...s PPStartUser=..GetPPUserByID(PPRowId,RemUser)
	...s FeeType=""
	...s PPRRemUser=""
	...s:PPRRemUserDr'="" PPRRemUser=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)
	...s PPRDateAddTemp=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",7)
	...s:PPRDateAddTemp'="" PPRDateAdd=$zd(PPRDateAddTemp,8)
	...s rate=$s(PPRDateAddTemp<61209:1,(61209<PPRDateAddTemp)&&(PPRDateAddTemp<=62578):0.945,PPRDateAddTemp>62578:0.944)
	...s AmountBeforeTax=+PPRRemAmount
	...s AmountAfterTax=AmountBeforeTax*rate
	...s AmountAfterTax=$fn(AmountAfterTax,"",2)
	...s PPRState=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",9)
	...s:PPRState="A" PPRState="申请"
	...s:PPRState="V" PPRState="到账"
	...q:PPRState="申请"
	...s TotalAmountBeforeTax=TotalAmountBeforeTax+AmountBeforeTax
	...s TotalAmountAfterTax=TotalAmountAfterTax+AmountAfterTax
	...i (PPRState="到账")&&(PPRType="I") d
	....s FeeType="IEC"
	....s PPCreateDepartment="临床药理"
	....s PPStartUser="临床药理"
	...i (PPRState="到账")&&(PPRType="B") d
	....s FeeType="备案费"
	....s PPCreateDepartment="临床药理"
	....s PPStartUser="临床药理"
	...i (PPRState="到账")&&(PPRType="") d
	....s num=num+1
	....s FeeType="第"_num_"次付款"
	
	...s Account=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",10)
	...s PPRRowId=PPSETRem
	...s:PPSetRowId'="" Select="Y"
	...s:PPSetRowId="" Select="N"
	...Do OutputRow7*/
	else  d FindSettle1
	do OutputRow8
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
FindSettle1
	s childsub=0
	f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	
	.s RemUser=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	.;i RemUser'="" d
	..;s PPCreateDepartment1=PPCreateDepartment
	..;f t=1:1:$l(PPStartUser,",") d
	...;if $p(PPStartUser,",",t)=RemUser d
	....;s PPCreateDepartment=$p(PPCreateDepartment1,",",t)
	.s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.s PPStartUser=$p($g(^SSU("SSUSR",PPStartUserDr)),"^",2)
	.s PPCreateDepartment=""
	.s PPCreateDepartment1=""
	.s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	.s:PPCreateDepartmentDr'="" PPCreateDepartment1=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	.s PPCreateDepartment1=##class(web.DHCOPAdmReg).LocDescFormate(PPCreateDepartment1) //$p($g(PPCreateDepartment1),"-",2)
	.i ((RemUser="")||(RemUser=PPStartUserDr)) s PPCreateDepartment=PPCreateDepartment1
	.s child=0
		.f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
		..s User=""
		..s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
		..s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
		..s Dep=""
		..if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
		..i Dep["免疫" s Dep="风湿免疫科"
		..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		..s:RemUser=UserDr PPCreateDepartment=Dep
	
	.s PPStartUser=..GetPPUserByID(PPRowId,RemUser)
	.s PPRRemAmount=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",1)
	.s PPRRemitter=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",3)
	.s PPRRemUserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",2)
	.s PPRType=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	.s FeeType=""
	.s PPRRemUser=""
	.s:PPRRemUserDr'="" PPRRemUser=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)
	.s Tax=""
	.i PPSetRowId'="" d
	..i $d(^DHCDocPPSettle("Taxs",PPSetRowId,PPRowId_"||"_childsub)) d
	...i ^DHCDocPPSettle("Taxs",PPSetRowId,PPRowId_"||"_childsub)="N" d
	....s Tax=1
	.s PPRDateAddTemp=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",7)
	.s:PPRDateAddTemp'="" PPRDateAdd=$zd(PPRDateAddTemp,8)
	.s rate=$s(PPRDateAddTemp<61209:1,(61209<PPRDateAddTemp)&&(PPRDateAddTemp<=62578):0.945,PPRDateAddTemp>62578:0.944)
	.i Tax=1 s rate=1
	.s AmountBeforeTax=+PPRRemAmount
	.s AmountAfterTax=AmountBeforeTax*rate
	.s AmountAfterTax=$fn(AmountAfterTax,"",2)
	.s PPRState=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",9)
	.s:PPRState="A" PPRState="申请"
	.s:PPRState="V" PPRState="到账"
	.q:PPRState="申请"
	.s TotalAmountBeforeTax=TotalAmountBeforeTax+AmountBeforeTax
	.s TotalAmountAfterTax=TotalAmountAfterTax+AmountAfterTax
	.i (PPRState="到账")&&(PPRType="I") d
	..s FeeType="IEC"
	..s PPCreateDepartment="临床药理"
	..s PPStartUser="临床药理"
	.i (PPRState="到账")&&(PPRType="B") d
	..s FeeType="备案费"
	..s PPCreateDepartment="临床药理"
	..s PPStartUser="临床药理"
	.i (PPRState="到账")&&(PPRType="E") d
	..s FeeType="项目审核费"
	..s PPCreateDepartment="临床药理"
	..s PPStartUser="临床药理"
	.i (PPRState="到账")&&(PPRType="") d
	..;s num=num+1
	..s num=$$GetPayCount(PPRowId,childsub)
	..s FeeType="第"_num_"次付款"
	
	.s Account=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",10)
	.s PPRRowId=PPRowId_"||"_childsub
	.s:PPSetRowId'="" Select="Y"
	.s:PPSetRowId="" Select="N"
	.Do OutputRow7
	quit
	
OutputRow7
	set Data=$lb(PPRRowId,PPRDateAdd,PPStartUser,PPCreateDepartment,FeeType,AmountBeforeTax,AmountAfterTax,TPay,MessageNote,RemUser,Select,Tax,PPDesc,PPCode)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables7
	///set (repid)=0
	set (PPRRowId,PPRDateAdd,PPStartUser,PPCreateDepartment,FeeType,AmountBeforeTax,AmountAfterTax,TPay,MessageNote,Tax,PPDesc,PPCode)=""
	quit
OutputRow8
	s Select="N"
   set Data=$lb("","合计","","","",TotalAmountBeforeTax,TotalAmountAfterTax,"","","",Select,"")
   Set ^CacheTemp(repid,ind)=Data	
   Set ind=ind+1
   quit
GetPayCount(PPRowId,childsub)
	;得到付款次数
	s LoopCount=0
	s FindCount=""
	s DateAddLoop=0
	for {
		s DateAddLoop=$O(^DHCDocPPR("DateAdd",0,DateAddLoop)) Q:(DateAddLoop="")||(FindCount'="")
		s childsubLoop=0
		for {
			s childsubLoop=$O(^DHCDocPPR("DateAdd",0,DateAddLoop,PPRowId,childsubLoop)) Q:(childsubLoop="")||(FindCount'="")
			s LoopCount=LoopCount+1
			i childsub=childsubLoop s FindCount=LoopCount
		}
		
	}
	Q LoopCount
}

/// 得到项目阶段分配的次数
/// w ##class(web.PilotProject.DHCDocPilotProject).GetDistributionCount(12)
ClassMethod GetDistributionCount(PPRowId As %String) As %String
{
	q:PPRowId="" 0
	s DistributionCount=$p($g(^DHCDocPP(PPRowId)),"^",93)
	q +DistributionCount
}

ClassMethod UpdatePilotProSettle(PPRowId As %String, Input As %String, Status As %String = "", PPSetRowId As %String = "", NTaxs As %String = "") As %String
{
	s myrtn=0
	s Date=$p(Input,"^",1)
	i Date'="" s Date=$zdh(Date,4)
	e  s Date=..%SysDate()
	s Distribution=$p(Input,"^",2)
	s DistributionTypeDr=$p(Input,"^",3)
	s CheckFee=$p(Input,"^",4)
	s ManageFee=$p(Input,"^",5)
	s ObservationFee=$p(Input,"^",6)
	s DesignFee=$p(Input,"^",7)
	s EthicsMeetReviewFee=$p(Input,"^",8)
	s TotalPay=$p(Input,"^",9)
	s ManageFeePart1=$p(Input,"^",10)
	s ManageFeePart2=$p(Input,"^",11)
	s PlanNo=$p(Input,"^",12)
	s NowNo=$p(Input,"^",13)
	s DMoney=$p(Input,"^",14)
	s ReSearchAcc=$p(Input,"^",15)
	s ReSearchAccNum=$p(Input,"^",16)
	s PlanNo1=$p(Input,"^",17)
	s NowNo1=$p(Input,"^",18)
	s DMoney1=$p(Input,"^",19)
	s PPRRowIds=$p(Input,"^",20)
	s Remark1=$p(Input,"^",21)
	s Remark2=$p(Input,"^",22)
	s Remark3=$p(Input,"^",23)
	s Remark4=$p(Input,"^",24)
	s Remark5=$p(Input,"^",25)
	s Remark6=$p(Input,"^",26)
	TS
		if (PPSetRowId=""){
		Set UObj = ##class(User.DHCDocPilotProSettle).%New(PPRowId)
		d UObj.PPSETPPParRefSetObjectId(PPRowId)
	}
	else {
		Set UObj = ##class(User.DHCDocPilotProSettle).%OpenId(PPSetRowId)
	}
	;s UObj=##class(User.DHCDocPilotProSettle).%New(PPRowId)
	
	s UObj.PPSETDate=Date
	s UObj.PPSETType=DistributionTypeDr
	s UObj.PPSETDistribution=Distribution
	s UObj.PPSETCheckFee=CheckFee
	s UObj.PPSETManageFee=ManageFee
	s UObj.PPSETObservationFee=ObservationFee
	s UObj.PPSETDesignFee=DesignFee
	s UObj.PPSETEthicsMeetReviewFee=EthicsMeetReviewFee
	s UObj.PPSETTotalPay=TotalPay
	s UObj.PPSETManageFeePart1=ManageFeePart1
	s UObj.PPSETManageFeePart2=ManageFeePart2
	s UObj.PPSETPlanNo=PlanNo
	s UObj.PPSETNowNo=NowNo
	s UObj.PPSETDMoney=DMoney
	s UObj.PPSETReSearchAcc=ReSearchAcc
	s UObj.PPSETReSearchAccNum=ReSearchAccNum
	s UObj.PPSETPlanNo1=PlanNo1
	s UObj.PPSETNowNo1=NowNo1
	s UObj.PPSETDMoney1=DMoney1
	s UObj.PPSETRems=PPRRowIds
	s UObj.PPSETRemark1=Remark1
	s UObj.PPSETRemark2=Remark2
	s UObj.PPSETRemark3=Remark3
	s UObj.PPSETRemark4=Remark4
	s UObj.PPSETRemark5=Remark5
	s UObj.PPSETRemark6=Remark6
	s UObj.PPSETStatus=Status
	Set sc = UObj.%Save()
	s RowId=UObj.%Id()
	
	b ;ProjectCareSave
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-106"
	}
	d UObj.%Close()
	if ((myrtn=0)&&(DistributionTypeDr'="E")&&(PPSetRowId="")){
		&sql(Update dhc_docpilotproject set PP_DistributionCount=:DistributionTypeDr where PP_RowId=:PPRowId)
		s myrtn=SQLCODE
		}
		if ((myrtn=0)&&(RowId'="")){
			kill ^DHCDocPPSettle("Taxs",RowId)
			
		}
		//s ^zzy("tax")=NTaxs_"^"_RowId
		if ((myrtn=0)&&(RowId'="")&&(NTaxs'="")){
			f i=1:1:$length(NTaxs,"-"){
				s NTax=$p(NTaxs,"-",i)
				s ^DHCDocPPSettle("Taxs",RowId,NTax)="N"
			}
		}
		
		
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

// 更新项目是否需要年度/跟踪审查

ClassMethod UpdateNeedCheck(PPRowId As %String, IfNeedCheck As %String, CheckFreqDr As %String, FirstPatDate As %String)
{
	s myrtn=0
	TS
	i FirstPatDate'="" s FirstPatDate=$zdh(FirstPatDate,4)
	&sql(Update dhc_docpilotproject set PP_IsNeedCheck=:IfNeedCheck,PP_CheckFreq_Dr=:CheckFreqDr,PP_FirstPatDate=:FirstPatDate where PP_RowId=:PPRowId)
	s myrtn=SQLCODE
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

// 得到是否需要年度/跟踪审查报告

ClassMethod GetNeedCheck(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s IfNeedCheck=$p($g(^DHCDocPP(PPRowId)),"^",94)
	q IfNeedCheck
}

Query FindAllSettleDetails(PPRowId As %String, SttDate As %String = "", EndDate As %String = "", PPStartUserDr As %String = "", PPCreateDepartmentDr As %String = "") As %Query(ROWSPEC = "PPRRowId:%String,PPDesc:%String,PPSetRowId:%String,PPSetDate:%String,DistributionType:%String,Distribution:%String,Status:%String,PPCode:%String,EndDate:%String,Job:%String") [ SqlProc ]
{
}

ClassMethod FindAllSettleDetailsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAllSettleDetailsExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllSettleDetailsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllSettleDetailsExecute ]
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

/// 获得本次科研项目的经费详细信息
/// 入参：PPRowId科研项目的rowid
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindAllSettleDetails","732")
ClassMethod FindAllSettleDetailsExecute(ByRef QHandle As %Binary, PPRowId As %String, SttDate As %String = "", EndDate As %String = "", PPStartUserDr As %String = "", PPCreateDepartmentDr As %String = "") As %Status
{
	s ^scl("FindAllSettleDetails")=PPRowId_","_SttDate_","_EndDate_","_PPStartUserDr_","_PPCreateDepartmentDr
	Set repid=$I(^CacheTemp)
	s ind=1
	k ^TMPFindAllSettleDetails($j)
	d ResetVariables9
	i PPRowId="" {
		s PPRowId=0 f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
		.s childsub=0
		.f  s childsub=$o(^DHCDocPPSET(PPRowId,childsub)) q:childsub=""  d
		..s Status=""
		..s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
		..s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
		..s PPEndDate=$p(^DHCDocPP(PPRowId),"^",13)
		..//i PPEndDate'="" s PPEndDate(PPEndDate,3)
		..s SumDate=$p($g(^DHCDocPP(PPRowId)),"^",68)
		..//s:SumDate'="" SumDate=$zd(SumDate,3)
		..s CenterDate=$p($g(^DHCDocPP(PPRowId)),"^",67)
		..//s:CenterDate'="" CenterDate=$zd(CenterDate,3)
		..s BriefDate=$p($g(^DHCDocPP(PPRowId)),"^",66)
		..//s:BriefDate'="" BriefDate=$zd(BriefDate,3)
	    ..;总结日期优先取BriefDate>CenterDate>SumDate
	    ..i SumDate'="" s PPEndDate=SumDate
	    ..i CenterDate'="" s PPEndDate=CenterDate
	    ..i BriefDate'="" s PPEndDate=BriefDate
		..s PPSetDate=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",1)
		..q:((SttDate'="")&&(PPSetDate<SttDate))
		..q:((EndDate'="")&&(PPSetDate>EndDate))
		..i PPEndDate'="" s PPEndDate=$zd(PPEndDate,3)
		..s:SumDate'="" SumDate=$zd(SumDate,3)
		..s:CenterDate'="" CenterDate=$zd(CenterDate,3)
		..s:BriefDate'="" BriefDate=$zd(BriefDate,3)
		..s:PPSetDate'="" PPSetDate=$zd(PPSetDate,3)
		..s DPPSetType=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",2)
		..i DPPSetType="E"  s DistributionType="结账分配"
		..i DPPSetType'="E"  s DistributionType="第"_DPPSetType_"次阶段分配"
		..s PPSetDistribution=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",3)
		..s Distribution=""
		..i PPSetDistribution="O" s Distribution="旧比例"
		..i PPSetDistribution="N" s Distribution="新比例"
		..s PPSetStatus=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",27)
		..i PPSetStatus="N" s Status="草稿"
		..i PPSetStatus="V" s Status="结账"
		..s PPSetRowId=PPRowId_"||"_childsub
		..s DeptUser=..GetSettleDeptAndUser(PPSetRowId)
		..s Dept=$p(DeptUser,"^",1)
		..s User=$p(DeptUser,"^",2)
		..q:((PPCreateDepartmentDr'="")&&(PPCreateDepartmentDr'=Dept))
		..q:((PPStartUserDr'="")&&(PPStartUserDr'=User))
		..Do OutputRow9	
	}else {
		s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
		s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
		s PPEndDate=$p(^DHCDocPP(PPRowId),"^",13)
		i PPEndDate'="" s PPEndDate=$zd(PPEndDate,3)
		s SumDate=$p($g(^DHCDocPP(PPRowId)),"^",68)
		s:SumDate'="" SumDate=$zd(SumDate,3)
		s CenterDate=$p($g(^DHCDocPP(PPRowId)),"^",67)
		s:CenterDate'="" CenterDate=$zd(CenterDate,3)
		s BriefDate=$p($g(^DHCDocPP(PPRowId)),"^",66)
		s:BriefDate'="" BriefDate=$zd(BriefDate,3)
	    ;总结日期优先取BriefDate>CenterDate>SumDate
	    i SumDate'="" s PPEndDate=SumDate
	    i CenterDate'="" s PPEndDate=CenterDate
	    i BriefDate'="" s PPEndDate=BriefDate
		s childsub=0
		f  s childsub=$o(^DHCDocPPSET(PPRowId,childsub)) q:childsub=""  d
		.s PPSetDate=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",1)
		.s Status=""
		.s:PPSetDate'="" PPSetDate=$zd(PPSetDate,3)
		.b //
		.s DPPSetType=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",2)
		.i DPPSetType="E"  s DistributionType="结账分配"
		.i DPPSetType'="E"  s DistributionType="第"_DPPSetType_"次阶段分配"
		.s PPSetDistribution=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",3)
		.s Distribution=""
		.i PPSetDistribution="O" s Distribution="旧比例"
		.i PPSetDistribution="N" s Distribution="新比例"
		.s PPSetRowId=PPRowId_"||"_childsub
		.s PPSetStatus=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",27)
		.i PPSetStatus="N" s Status="草稿"
		.i PPSetStatus="V" s Status="结账"
		.Do OutputRow9
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	s ^TMPFindAllSettleDetails($j,ind)=PPSetRowId
	s ^TMPFindAllSettleDetails($j)=ind
	set Data=$lb(PPRRowId,PPDesc,PPSetRowId,PPSetDate,DistributionType,Distribution,Status,PPCode,PPEndDate,$j)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables9
	///set (repid)=0
	set (PPRRowId,PPDesc,PPSetRowId,PPSetDate,DistributionType,Distribution,Status,PPCode,PPEndDate)=""
	quit
}

ClassMethod GetFindAllSettleNum(Job) As %String
{
	if $d(^TMPFindAllSettleDetails(Job)) q ^TMPFindAllSettleDetails(Job)
	e  q 0
}

ClassMethod GetFindAllSettle(Job, num) As %String
{
	if $d(^TMPFindAllSettleDetails(Job,num)) q ^TMPFindAllSettleDetails(Job,num)
	e  q ""
}

// w ##class(web.PilotProject.DHCDocPilotProject).GetSettleById("36||3")

ClassMethod GetSettleById(PPSetRowId As %String) As %String
{
	q:PPSetRowId="" ""
	s PPRowId=$p(PPSetRowId,"||",1)
	s childsub=$p(PPSetRowId,"||",2)
	s PPSetDate=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",1)
	s:PPSetDate'="" PPSetDate=$zd(PPSetDate,4)
	s DPPSetType=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",2)  
	s PPSetDistribution=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",3)
	s PPSETCheckFee=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",4)
	s PPSETManageFee=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",5)
	s PPSETObservationFee=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",6)
	s PPSETDesignFee=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",7)
	s PPSETEthicsMeetReviewFee=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",8)
	s PPSETTotalPay=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",9)
	s PPSETPlanNo=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",10)
	s PPSETNowNo=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",11)
	s PPSETDMoney=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",12)
	s PPSETReSearchAcc=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",13)
	s PPSETReSearchAccNum=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",14)
	s PPSETPlanNo1=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",15)
	s PPSETNowNo1=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",16)
	s PPSETDMoney1=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",17)
	s PPSETManageFeePart1=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",18)
	s PPSETManageFeePart2=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",19)
	s Remark1=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",21)
	s Remark2=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",22)
	s Remark3=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",23)
	s Remark4=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",24)
	s Remark5=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",25)
	s Remark6=$p($g(^DHCDocPPSET(PPRowId,childsub)),"^",26)
	s PPSETRems=$p(^DHCDocPPSET(+PPSetRowId,$p(PPSetRowId,"||",2)),"^",20)
	s acc=""
	i PPSETRems="" d
	.s chi=0
	.f  s chi=$o(^DHCDocPPR(PPRowId,chi)) q:chi=""  d
	..s PPRType=$p($g(^DHCDocPPR(PPRowId,chi)),"^",12)
	..i ((PPRType'="I")&&(PPRType'="B")) d
	...s acc=..GetPAccountByID(PPRowId_"||"_chi)

	else  d
	.s len=$l(PPSETRems,"-")
	.f i=1:1:len d
	..s PPSETRem=$p(PPSETRems,"-",i)
	..s PPRType=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",12)
	..s RemUser=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",15)
	..i ((PPRType'="I")&&(PPRType'="B")) d
	..s acc=..GetPAccountByID(PPSETRem)
	
	
	

	s ret=PPSetDate_"^"_DPPSetType_"^"_PPSetDistribution_"^"_PPSETCheckFee_"^"_PPSETManageFee_"^"_PPSETObservationFee_"^"_PPSETDesignFee_"^"_PPSETEthicsMeetReviewFee_"^"_PPSETTotalPay_"^"_PPSETManageFeePart1    ;10
	s ret=ret_"^"_PPSETManageFeePart2_"^"_PPSETPlanNo_"^"_PPSETNowNo_"^"_PPSETDMoney_"^"_PPSETReSearchAcc_"^"_PPSETReSearchAccNum_"^"_PPSETPlanNo1_"^"_PPSETNowNo1_"^"_PPSETDMoney1_"^"_Remark1_"^"_Remark2_"^"_Remark3_"^"_Remark4_"^"_Remark5_"^"_Remark6_"^"_acc
	q ret
}

// 得到项目所有付款信息

// w ##class(web.PilotProject.DHCDocPilotProject).GetPayDetail("36")

ClassMethod GetPayDetail(PPSetRowId As %String) As %String
{
	q:PPSetRowId="" ""
	s PPRowId=+PPSetRowId
	s PayDetails=""
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	s num=0
	s TotalAmountBeforeTax=0
	s TotalAmountAfterTax=0
	s TPay=""
	s MessageNote="入账"
	s rate=0
	if PPSetRowId'="" d
	.s PPSETRems=$p(^DHCDocPPSET(+PPSetRowId,$p(PPSetRowId,"||",2)),"^",20)
	.i PPSETRems="" d GetSettle1
	.else  d
	..s len=$l(PPSETRems,"-")
	..f i=1:1:len d
	...s PPSETRem=$p(PPSETRems,"-",i)
	...s PPStartUser=""
	...s PPStartUserDr=$p($g(^DHCDocPP(+PPSetRowId)),"^",10)
	...s:PPStartUserDr'="" PPStartUser=$p($g(^SSU("SSUSR",PPStartUserDr)),"^",2)
	...;s PPCreateDepartment=""
	...;s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	...;s:PPCreateDepartmentDr'="" PPCreateDepartment=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	...;s PPCreateDepartment=$p($g(PPCreateDepartment),"-",2)
	
	...s PPRRemAmount=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",1)
	...s PPRRemitter=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",3)
	...s PPRRemUserDr=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",2)
	...s PPRType=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",12)
	...s RemUser=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",15)
	...s PPCreateDepartment=""
	...s PPCreateDepartment1=""
	...s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	...s:PPCreateDepartmentDr'="" PPCreateDepartment1=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	...s PPCreateDepartment1=##class(web.DHCOPAdmReg).LocDescFormate(PPCreateDepartment1) //$p($g(PPCreateDepartment1),"-",2)
	...i ((RemUser="")||(RemUser=PPStartUserDr)) s PPCreateDepartment=PPCreateDepartment1
	...s child=0
		...f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
		....s User=""
		....s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
		....s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
		....s Dep=""
		....if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
		....i Dep["免疫" s Dep="风湿免疫科"
		....s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		....s:RemUser=UserDr PPCreateDepartment=Dep
	...s PPStartUser=..GetPPUserByID(PPRowId,RemUser)
	....;s PPCreateDepartment1=PPCreateDepartment
	....;f t=1:1:$l(PPStartUser,",") d
	.....;if $p(PPStartUser,",",t)=RemUser d
	......;s PPCreateDepartment=$p(PPCreateDepartment1,",",t)
	...s FeeType=""
	...s PPRRemUser=""
	...s:PPRRemUserDr'="" PPRRemUser=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)
	...s Tax=""
	...i PPSetRowId'="" d
	....i $d(^DHCDocPPSettle("Taxs",PPSetRowId,PPSETRem)) d
	.....i ^DHCDocPPSettle("Taxs",PPSetRowId,PPSETRem)="N" d
	......s Tax=1
	...s PPRDateAddTemp=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",7)
	...s:PPRDateAddTemp'="" PPRDateAdd=$zd(PPRDateAddTemp,8)
	...s rate=$s(PPRDateAddTemp<61209:1,(61209<PPRDateAddTemp)&&(PPRDateAddTemp<=62578):0.945,PPRDateAddTemp>62578:0.944)
	...i Tax=1 s rate=1
	...s AmountBeforeTax=+PPRRemAmount
	...s AmountAfterTax=AmountBeforeTax*rate
	...s AmountAfterTax=$fn(AmountAfterTax,"",2)
	...s PPRState=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",9)
	...s:PPRState="A" PPRState="申请"
	...s:PPRState="V" PPRState="到账"
	...q:PPRState="申请"
	...s TotalAmountBeforeTax=TotalAmountBeforeTax+AmountBeforeTax
	...s TotalAmountAfterTax=TotalAmountAfterTax+AmountAfterTax
	...i (PPRState="到账")&&(PPRType="I") d
	....s FeeType="IEC"
	....s PPCreateDepartment="临床药理"
	....s PPStartUser="临床药理"
	...i (PPRState="到账")&&(PPRType="B") d
	....s FeeType="备案费"
	....s PPCreateDepartment="临床药理"
	....s PPStartUser="临床药理"
	...i (PPRState="到账")&&(PPRType="E") d
	....s FeeType="项目审核费"
	....s PPCreateDepartment="临床药理"
	....s PPStartUser="临床药理"
	...i (PPRState="到账")&&(PPRType="") d
	....s num=num+1
	....s FeeType="第"_num_"次付款"
	
	...s Account=$p($g(^DHCDocPPR(+PPSETRem,$p(PPSETRem,"||",2))),"^",10)
	...s PPRRowId=PPSETRem
	...s PayDetail=PPRDateAdd_"^"_PPStartUser_"^"_PPCreateDepartment_"^"_FeeType_"^"_AmountBeforeTax_"^"_AmountAfterTax_"^"_TPay_"^"_MessageNote
	...i PayDetails="" s PayDetails=PayDetail
	...e  s PayDetails=PayDetails_"!"_PayDetail
	s PayDetails=PayDetails_"!"_"合计^^^^"_TotalAmountBeforeTax_"^"_TotalAmountAfterTax_"^^"
	q PayDetails
GetSettle1
	s childsub=0
	f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	.s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.s PPStartUser=$p($g(^SSU("SSUSR",PPStartUserDr)),"^",2)
	.s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	.s PPCreateDepartment=""
	.s:PPCreateDepartmentDr'="" PPCreateDepartment=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	.s PPCreateDepartment=##class(web.DHCOPAdmReg).LocDescFormate(PPCreateDepartment) //$p($g(PPCreateDepartment),"-",2)
	.s PPRRemAmount=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",1)
	.s PPRRemitter=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",3)
	.s PPRRemUserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",2)
	.s PPRType=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	.s FeeType=""
	.s PPRRemUser=""
	.s:PPRRemUserDr'="" PPRRemUser=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)
	.s RemUser=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	.s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.s PPStartUser=$p($g(^SSU("SSUSR",PPStartUserDr)),"^",2)
	.s PPCreateDepartment=""
	.s PPCreateDepartment1=""
	.s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	.s:PPCreateDepartmentDr'="" PPCreateDepartment1=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	.s PPCreateDepartment1=##class(web.DHCOPAdmReg).LocDescFormate(PPCreateDepartment1) //$p($g(PPCreateDepartment1),"-",2)
	.i ((RemUser="")||(RemUser=PPStartUserDr)) s PPCreateDepartment=PPCreateDepartment1
	.s child=0
		.f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
		..s User=""
		..s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
		..s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
		..s Dep=""
		..if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
		..i Dep["免疫" s Dep="风湿免疫科"
		..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		..s:RemUser=UserDr PPCreateDepartment=Dep
	
	.s PPStartUser=..GetPPUserByID(PPRowId,RemUser)
	.s Tax=""
	.i PPSetRowId'="" d
	..i $d(^DHCDocPPSettle("Taxs",PPSetRowId,PPRowId_"||"_childsub)) d
	...i ^DHCDocPPSettle("Taxs",PPSetRowId,PPRowId_"||"_childsub)="N" d
	....s Tax=1
	.s PPRDateAddTemp=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",7)
	.s:PPRDateAddTemp'="" PPRDateAdd=$zd(PPRDateAddTemp,8)
	.s rate=$s(PPRDateAddTemp<61209:1,(61209<PPRDateAddTemp)&&(PPRDateAddTemp<=62578):0.945,PPRDateAddTemp>62578:0.944)
	.i Tax=1 s rate=1
	.s AmountBeforeTax=+PPRRemAmount
	.s AmountAfterTax=AmountBeforeTax*rate
	.s AmountAfterTax=$fn(AmountAfterTax,"",2)
	.s PPRState=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",9)
	.s:PPRState="A" PPRState="申请"
	.s:PPRState="V" PPRState="到账"
	.q:PPRState="申请"
	.s TotalAmountBeforeTax=TotalAmountBeforeTax+AmountBeforeTax
	.s TotalAmountAfterTax=TotalAmountAfterTax+AmountAfterTax
	.i (PPRState="到账")&&(PPRType="I") d
	..s FeeType="IEC"
	..s PPCreateDepartment="临床药理"
	..s PPStartUser="临床药理"
	.i (PPRState="到账")&&(PPRType="B") d
	..s FeeType="备案费"
	..s PPCreateDepartment="临床药理"
	..s PPStartUser="临床药理"
	.i (PPRState="到账")&&(PPRType="E") d
	..s FeeType="项目审核费"
	..s PPCreateDepartment="临床药理"
	..s PPStartUser="临床药理"
	.i (PPRState="到账")&&(PPRType="") d
	..s num=num+1
	..s FeeType="第"_num_"次付款"
	
	.s Account=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",10)
	.s PPRRowId=PPRowId_"||"_childsub
	.s PayDetail=PPRDateAdd_"^"_PPStartUser_"^"_PPCreateDepartment_"^"_FeeType_"^"_AmountBeforeTax_"^"_AmountAfterTax_"^"_TPay_"^"_MessageNote
	.i PayDetails="" s PayDetails=PayDetail
	.e  s PayDetails=PayDetails_"!"_PayDetail
	quit
}

// 产生跟踪审查记录

// d ##class(web.PilotProject.DHCDocPilotProject).CreatCheckRecord()

ClassMethod CreatCheckRecord()
{
	s PPRowId="" 
	TS
	s myrtn=0
	f  s PPRowId=$o(^DHCDocPP(PPRowId))  q:PPRowId=""  d
	.s PPState=$p($g(^DHCDocPP(PPRowId)),"^",16)
	.q:((PPState'="V")&&(PPState'="P"))
	.s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	.q:PPDesc["诊断试剂"
	.q:PPDesc["试剂盒"
	.s IsNeedCheck=$p($g(^DHCDocPP(PPRowId)),"^",94)
	.q:IsNeedCheck="N"
	.s CheckFreqDr=$p($g(^DHCDocPP(PPRowId)),"^",95)
	.;q:CheckFreqDr=""
	.s PPState=$p($g(^DHCDocPP(PPRowId)),"^",16)
	.s FirstPatDate=$p($g(^DHCDocPP(PPRowId)),"^",96)
	.s CheckFreq=""
	.s:CheckFreqDr'="" CheckFreq=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",1)
	.i CheckFreq="" s CheckFreq=12
	.s PPYKYear="",PPYKMonth="",PPYKIfFinish=""
	.s childsub=0
	.s find=0
	.s Month=""
	.s Year=""
	.f  s childsub=$o(^DHCDocPPYK(PPRowId,childsub)) q:childsub=""  d
	..s find=1
	..s PPYKYear=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",2)
	..s PPYKMonth=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",3)
	..s PPYKIfFinish=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",4)  
	.q:((PPYKIfFinish'="Y")&&(find=1)) 
	.i CheckFreq=12 d
	..i find=0 d 
	...s Year=$p($zd(+$h,4),"/",3)
	...s Month=1
	..e  d
	...s Year=PPYKYear+1
	...s Month=1
	.e  i CheckFreq'=0 d
	..q:FirstPatDate=""
	..s FirstYear=$p($zd(FirstPatDate,4),"/",3)
	..s FirstMonth=$p($zd(FirstPatDate,4),"/",2)
	..i find=0 d 
	...s AMonth=+FirstMonth+CheckFreq
	...s Month=AMonth#12
	...s:Month=0 Month=12
	...s:AMonth>12 Year=FirstYear+1
	...s:AMonth<=12 Year=FirstYear
	..e  d
	...s AMonth=+PPYKMonth+CheckFreq
	...s Month=AMonth#12
	...s:Month=0 Month=12
	...s:AMonth>12 Year=PPYKYear+1
	...s:AMonth<=12 Year=PPYKYear
	.q:Year=""
	.q:Month=""
	.s UObj=##class(User.DHCDocPilotProYearCheck).%New(PPRowId)
	.d UObj.PPYKPPParRefSetObjectId(PPRowId)
	.s UObj.PPYKYear=Year
	.s UObj.PPYKMonth=Month
	.s UObj.PPYKIfFinish="N"
	.Set sc = UObj.%Save()
	.If ($System.Status.IsError(sc)) d
    ..Do $System.Status.DisplayError(sc)
    ..Set myrtn = "-105"
	..d UObj.%Close()	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

Query FindCheckRecord(PPRowId As %String) As %Query(ROWSPEC = "RecordSum:%Integer,PPYKRowId:%String,PPDesc:%String,PPYKYear:%String,PPYKMonth:%String,PPYKIfFinish:%String,CheckFreq:%String,PPDepartment:%String,PPStartUser:%String,PlanNo:%String,ArchivesFilesNo:%String,FirstPatDate:%String,PPYKCheckDate:%String") [ SqlProc ]
{
}

ClassMethod FindCheckRecordClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindCheckRecordExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckRecordFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckRecordExecute ]
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
		s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
		s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获得年度跟踪审查详细信息
/// 入参：PPRowId科研项目的rowid
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindCheckRecord","36")
ClassMethod FindCheckRecordExecute(ByRef QHandle As %Binary, PPRowId As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	d ResetVariables10
	i PPRowId="" {
		s j=1
		f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
		.s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
		.s State=$p($g(^DHCDocPP(PPRowId)),"^",16)
		.s FirstPatDate=$p($g(^DHCDocPP(PPRowId)),"^",96)
		.i FirstPatDate'="" s FirstPatDate=$zd(FirstPatDate,3)
		.q:((State'="V")&&(State'="P"))
		.s SignProtocolDate=$p($g(^DHCDocPP(PPRowId)),"^",37)
		.s IsNeedCheck=$p($g(^DHCDocPP(PPRowId)),"^",94)
		.q:SignProtocolDate=""
		.q:PPDesc["诊断试剂"
		.q:PPDesc["试剂盒"
		.q:IsNeedCheck="N"
		.s SubPilotCategoryDr=$p($g(^DHCDocPP(PPRowId)),"^",41)
		.s SubPilotCategory=""
		.s:SubPilotCategoryDr'="" SubPilotCategory=$p($g(^DHCDocCT("DefineData",+SubPilotCategoryDr,"D",$p(SubPilotCategoryDr,"||",2))),"^",2)
		.q:SubPilotCategory="体外诊断试剂"
		.s CheckFreq=""
		.s CheckFreqCode=""
		.s CheckFreqDr=$p($g(^DHCDocPP(PPRowId)),"^",95)
		.s:CheckFreqDr'="" CheckFreq=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",2)
		.s:CheckFreqDr'="" CheckFreqCode=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",1)
		.s DepUser=..GetPPDepartAndUser(PPRowId)
		.s PPDepartment=$p(DepUser,"^",1)
		.s PPStartUser=$p(DepUser,"^",2)
		.s PlanNo=$p($g(^DHCDocPP(PPRowId)),"^",26)
		.s ArchivesFilesNo=$p($g(^DHCDocPP(PPRowId)),"^",34)
		.s childsub=0
		.f  s childsub=$o(^DHCDocPPYK(PPRowId,childsub)) q:childsub=""  d
		..s PPYKYear=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",2)
		..s PPYKMonth=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",3)
		..s PPYKMonth1=PPYKMonth
		..;s:CheckFreqCode=12 PPYKMonth=""
		..s PPYKIfFinish=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",4)
		..i PPYKIfFinish="Y" s PPYKIfFinish="完成" 
		..e  s PPYKIfFinish="未完成"
		..q:PPYKIfFinish="完成" 
		..s PPYKRowId=PPRowId_"||"_childsub
		..s PPYKYear1=PPYKYear
		..s:CheckFreqCode=12 PPYKYear1=PPYKYear1+1
		..s:CheckFreqCode=12 PPYKMonth1=0
		..s PPYKCheckDate=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",5)
		..i (($d(^DHCDocPilotConfig("YearCheckDate",PPYKYear)))&&(PPYKCheckDate="")&&((CheckFreqCode=12)||(CheckFreqCode=""))) s PPYKCheckDate=^DHCDocPilotConfig("YearCheckDate",PPYKYear)
		..s:PPYKCheckDate'="" PPYKCheckDate=$zd(PPYKCheckDate,3)
		..s ^TMPFindCheckRecord($j,PPYKYear1,PPYKMonth1,j)=$lb(0,PPYKRowId,PPDesc,PPYKYear,PPYKMonth,PPYKIfFinish,CheckFreq,PPDepartment,PPStartUser,PlanNo,ArchivesFilesNo,FirstPatDate,PPYKCheckDate)
		..s j=j+1
		s PPYKY=""
		f  s PPYKY=$o(^TMPFindCheckRecord($j,PPYKY)) q:PPYKY=""  d
		.s PPTYM=""
		.f  s PPTYM=$o(^TMPFindCheckRecord($j,PPYKY,PPTYM)) q:PPTYM=""  d
		..s row=""
		..f  s row=$o(^TMPFindCheckRecord($j,PPYKY,PPTYM,row)) q:row=""  d
		...s Data1=$g(^TMPFindCheckRecord($j,PPYKY,PPTYM,row))
		...Do OutputRow10
		k ^TMPFindCheckRecord($j)
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
		
		}
	else{
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	s SubPilotCategoryDr=$p($g(^DHCDocPP(PPRowId)),"^",41)
	s SubPilotCategory=""
	s:SubPilotCategoryDr'="" SubPilotCategory=$p($g(^DHCDocCT("DefineData",+SubPilotCategoryDr,"D",$p(SubPilotCategoryDr,"||",2))),"^",2)
	q:SubPilotCategory="体外诊断试剂"
	s CheckFreq=""
	s CheckFreqCode=""
	s CheckFreqDr=$p($g(^DHCDocPP(PPRowId)),"^",95)
	s:CheckFreqDr'="" CheckFreq=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",2)
	s:CheckFreqDr'="" CheckFreqCode=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",1)
	s PlanNo=$p($g(^DHCDocPP(PPRowId)),"^",26)
	s DepUser=..GetPPDepartAndUser(PPRowId)
	s PPDepartment=$p(DepUser,"^",1)
	s PPStartUser=$p(DepUser,"^",2)
	s ArchivesFilesNo=$p($g(^DHCDocPP(PPRowId)),"^",34)
	s childsub=0
	f  s childsub=$o(^DHCDocPPYK(PPRowId,childsub)) q:childsub=""  d
	.s PPYKYear=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",2)
	.s PPYKMonth=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",3)
	.;s:CheckFreqCode=12 PPYKMonth=""
	.s PPYKIfFinish=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",4)
	.i PPYKIfFinish="Y" s PPYKIfFinish="完成" 
	.e  s PPYKIfFinish="未完成"  
	.s PPYKRowId=PPRowId_"||"_childsub
	.s FirstPatDate=$p($g(^DHCDocPP(PPRowId)),"^",96)
	.i FirstPatDate'="" s FirstPatDate=$zd(FirstPatDate,3)
	.s PPYKCheckDate=$p($g(^DHCDocPPYK(PPRowId,childsub)),"^",5)
	.i (($d(^DHCDocPilotConfig("YearCheckDate",PPYKYear)))&&(PPYKCheckDate="")&&((CheckFreqCode=12)||(CheckFreqCode=""))) s PPYKCheckDate=^DHCDocPilotConfig("YearCheckDate",PPYKYear)
	.s:PPYKCheckDate'="" PPYKCheckDate=$zd(PPYKCheckDate,3)
	.set Data1=$lb(0,PPYKRowId,PPDesc,PPYKYear,PPYKMonth,PPYKIfFinish,CheckFreq,PPDepartment,PPStartUser,PlanNo,ArchivesFilesNo,FirstPatDate,PPYKCheckDate)
	.Do OutputRow10
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
	}
	
	
OutputRow10
	set Data=Data1
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables10
	///set (repid)=0
	set (PPYKRowId,PPDesc,PPYKYear,PPYKMonth,PPYKIfFinish,CheckFreq,PPDepartment,PPStartUser,PlanNo,ArchivesFilesNo,FirstPatDate)=""
	quit
}

/*ClassMethod ConfirmCheckRecord(PPYKRowId As %String) As %String
{
	q:PPYKRowId="" ""
	s date=..%SysDate()
	&sql(Update DHC_DocPilotProYearCheck  set PPYK_IfFinish="Y",PPYK_Date=:date where PPYK_RowId=:PPYKRowId)
	q SQLCODE
}*/
ClassMethod ConfirmCheckRecord(PPYKRowId As %String, YKCKDate As %String = "") As %String
{
	q:PPYKRowId="" ""
	s date=..%SysDate()
	i YKCKDate'="" s YKCKDate=$zdh(YKCKDate,3)
	&sql(Update DHC_DocPilotProYearCheck  set PPYK_IfFinish="Y",PPYK_Date=:date,PPYK_CheckDate=:YKCKDate where PPYK_RowId=:PPYKRowId)
	q SQLCODE
}

ClassMethod SetCheckRecordDate(PPYKRowId As %String, YKCKDate As %String = "") As %String
{
	i YKCKDate'="" s YKCKDate=$zdh(YKCKDate,3)
	q:PPYKRowId="" ""
	s PPYKYear=$p($g(^DHCDocPPYK(+PPYKRowId,$p(PPYKRowId,"||",2))),"^",2)
	q:PPYKYear="" ""
	s ^DHCDocPilotConfig("YearCheckDate",PPYKYear)=YKCKDate
	q 0
}

// d ##class(web.PilotProject.DHCDocPilotProject).InportProjectInfo()

ClassMethod InportProjectInfo()
{
	//写日志文件
	s myrtn=0
	k ^DHCDocPilotProject
	Set file=##class(%File).%New("/temp/stream/project0829.txt")
	set ExistsFlag=##class(%File).Exists("/temp/stream/project0829.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/stream/project0829.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		set PPDesc=PatList(1)                 	;项目名称->药物/医疗器械名称
		set ApplicationUnit=PatList(2)        	;申办者->申请人     
		set PilotCategory=PatList(3)          	;类别->类别
		set ApplyMatter=PatList(4)       		;申请事项->申请事项 
		set ApplyStage=PatList(5)               ;申期期别-> + 申请期别
		set ApprovalNo=PatList(6)             	;批件号->批件号
		set PlanNo=PatList(7)      				;方案编号->方案编号
		set PlanName=PatList(8)    				;方案名称->方案名称
		set IsHeadman=PatList(9)           		;是否组长->多中心状态 
		set PPCreateDepartment=PatList(10)       ;专业组->立项科室
		set PPStartUser=PatList(11)             ;PI->主要研究者
		set Indication=PatList(12)              ;适应证->适应证
		set FileSubmitDate=PatList(13)          ;资料递交日期->资料提交日期
		set EthicsMeetDate=PatList(14)          ;伦理委员会上会日期->伦理委员会上会日期
		set EthicsMeetAduitDate=PatList(15)     ;伦理委员会批准日期->伦理委员会批准日期
		set FirstPatDate=PatList(16)            ;第一例受试者入组日期->第一例受试病人签署合同日期
		set PPEndDate=PatList(17)           	;完成日期->项目结束日期
		set ArchivesFilesNo=PatList(18)       	;档案文件夹编号->档案文件夹编号
		set CollectCompany=PatList(19)         	;统计单位->统计单位
		set PPState=PatList(20)					;是否完成->项目状态
		set YearCheckDate=PatList(21)           ;年度报告调查日期->年度报告调查日期
		set ProjectFilesState=PatList(22)       ;试验资料情况->试验资料情况
		set EthicsFilesState=PatList(23)      	;伦理委员会档案文件->伦理委员会档案情况
		set EthicsFilesNextState=PatList(24)    ;伦理资料去向->伦理资料去向情况
		set EthicsFilesOffDate=PatList(25)      ;伦理资料销毁（回收）时间->伦理资料销毁(回收)日期
		set SignProtocolDate=PatList(26)      	;签署协议日期->签署协议日期
		set LeaderCompany=PatList(27)     ;组长单位及PI->组长单+组长单位PI
		set LeaderCompanyPI=PatList(28)
		set CROCompany=PatList(29)      		;CRO公司->CRO公司
		set PPRemark=PatList(30)               	;备注->项目备注
		set CheckPerson=PatList(31)               	;核对人->核对人
		s pflag=0
		s PPCreateDepartmentDr="",PilotCategoryDr="",SubPilotCategoryDr="",ApplyMatterDr="",PPOtherCreateDepartmentDr=""
		s ApplyStageDr="",IsHeadmanDr="",ProjectFilesStateDr="",EthicsFilesStateDr="",EthicsFilesNextStateDr=""
		s ModuleRowId="", PPOtherStartUserDr="",PPStartUserDr=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s Rowid=CTDefineRowId_"||"_ChildSub
	...s Desc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...i ((PilotCategory[Desc)&&(PilotCategory'="")&&(Define="类别")) s PilotCategoryDr=Rowid
	...i ((PilotCategory=Desc)&&(PilotCategory'="")&&(Define="类别")) s pflag=1
	...i ((Desc[PilotCategory)&&(PilotCategory'="")&&(Define="亚类别")) s SubPilotCategoryDr=Rowid
	...i ((Desc[ApplyMatter)&&(ApplyMatter'="")&&(Define="申请事项")) s ApplyMatterDr=Rowid
	...i ((ApplyStage[Desc)&&(ApplyStage'="")&&(Define="申请期")) s ApplyStageDr=Rowid
	...i ((Desc[IsHeadman)&&(IsHeadman'="")&&(Define="是否是组长")) s IsHeadmanDr=Rowid
	...i ((ProjectFilesState[Desc)&&(ProjectFilesState'="")&&(Define="试验资料情况")) s ProjectFilesStateDr=Rowid
	...i ((EthicsFilesState[Desc)&&(EthicsFilesState'="")&&(Define="伦理委员会档案情况")) s EthicsFilesStateDr=Rowid
	...i ((EthicsFilesNextState[Desc)&&(EthicsFilesNextState'="")&&(Define="伦理资料去向")) s EthicsFilesNextStateDr=Rowid
    s leng=$l(PPCreateDepartment,"，")
    f i=1:1:leng d
    .S LocRowid=""
    .f  s LocRowid=$o(^CTLOC(LocRowid)) q:LocRowid=""  d
    ..s CTLoc=##class(web.DHCOPAdmReg).LocDescFormate($p(^CTLOC(LocRowid),"^",2)) //$p($p(^CTLOC(LocRowid),"^",2),"-",2)
    ..i (CTLoc=$p(PPCreateDepartment,"，",i)&&(i=1)) s PPCreateDepartmentDr=LocRowid
    ..i (CTLoc=$p(PPCreateDepartment,"，",i)&&(i'=1)) d
    ...i PPOtherCreateDepartmentDr=""  s PPOtherCreateDepartmentDr=LocRowid
    ...e  s PPOtherCreateDepartmentDr=PPOtherCreateDepartmentDr_"^"_LocRowid
    ..q:CTLoc=$p(PPCreateDepartment,"，",i)
    s len=$l(PPStartUser,"，")
    f f=1:1:len d
    .S UserRowid=""
    .f  s UserRowid=$o(^SSU("SSUSR",UserRowid)) q:UserRowid=""  d
    ..s User=$p(^SSU("SSUSR",UserRowid),"^",2)
    ..i (User=$p(PPStartUser,"，",f)&&(f=1)) s PPStartUserDr=UserRowid
    ..i (User=$p(PPStartUser,"，",f)&&(f'=1)) d
    ...i PPOtherStartUserDr=""  s PPOtherStartUserDr=UserRowid
    ...e  s PPOtherStartUserDr=PPOtherStartUserDr_"^"_UserRowid
    ..q:User=$p(PPStartUser,"，",f)
    s Err=""
    s FileSubmitDate1="",EthicsMeetDate1="",EthicsMeetAduitDate1="",FirstPatDate1="",PPEndDate1="",YearCheckDate1=""
    s EthicsFilesOffDate1="",SignProtocolDate1=""
    i ((PilotCategory'="")&&(PilotCategoryDr="")) s Err=PilotCategory
    i ((PilotCategory'="")&&(SubPilotCategoryDr="")&&(pflag=0)) s Err=Err_"^"_PilotCategory
    e  s Err=Err_"^"_""
    i ((ApplyMatter'="")&&(ApplyMatterDr="")) s Err=Err_"^"_ApplyMatter
    e  s Err=Err_"^"_""
    i ((ApplyStage'="")&&(ApplyStageDr="")) s Err=Err_"^"_ApplyStage
    e  s Err=Err_"^"_""
    i ((IsHeadman'="")&&(IsHeadmanDr="")) s Err=Err_"^"_IsHeadman
    e  s Err=Err_"^"_""
    i ((ProjectFilesState'="")&&(ProjectFilesStateDr="")) d
	    .s Err=Err_"^"_ProjectFilesState
	     .s PPRemark=PPRemark+"。 "+ProjectFilesState
    
    e  d
    .s Err=Err_"^"_""
    i ((EthicsFilesState'="")&&(EthicsFilesStateDr="")) d
	    .s Err=Err_"^"_EthicsFilesState
	    .s PPRemark=PPRemark+"。 "+EthicsFilesState
    
    e  d 
    .s Err=Err_"^"_""
    i ((EthicsFilesNextState'="")&&(EthicsFilesNextStateDr="")) d
	    .s Err=Err_"^"_EthicsFilesNextState
	     .s PPRemark=PPRemark+"。 "+EthicsFilesNextState
    
    e  d
    .s Err=Err_"^"_""
    i (((PPCreateDepartment'="")&&(PPCreateDepartmentDr=""))||((leng'=($l(PPOtherCreateDepartmentDr,"^")+1))&&(leng>1))) s Err=Err_"^"_PPCreateDepartment
    e  s Err=Err_"^"_""
    i (((PPStartUser'="")&&(PPStartUserDr=""))||((len'=($l(PPOtherStartUserDr,"^")+1))&&(len>1))) s Err=Err_"^"_PPStartUser
    e  s Err=Err_"^"_""
    i (($l(FileSubmitDate,"/")'=3)&&(FileSubmitDate'="")) d
	    .s Err=Err_"^"_FileSubmitDate
	    .s PPRemark=PPRemark+"。 "+FileSubmitDate
    
   	e  d
   	.s Err=Err_"^"_""
   	i $l(FileSubmitDate,"/")=3  s FileSubmitDate1=$zdh($p(FileSubmitDate,"/",3)_"/"_$p(FileSubmitDate,"/",2)_"/"_$p(FileSubmitDate,"/",1),4)
   	i (($l(EthicsMeetDate,"/")'=3)&&(EthicsMeetDate'="")) d
	   	 .s Err=Err_"^"_EthicsMeetDate
	   	 .s PPRemark=PPRemark+"。 "+EthicsMeetDate
   	
	   	 
   	e  d
   	.s Err=Err_"^"_""
   	i $l(EthicsMeetDate,"/")=3  s EthicsMeetDate1=$zdh($p(EthicsMeetDate,"/",3)_"/"_$p(EthicsMeetDate,"/",2)_"/"_$p(EthicsMeetDate,"/",1),4)
   	i (($l(EthicsMeetAduitDate,"/")='3)&&(EthicsMeetAduitDate'="")) d
	   	.s Err=Err_"^"_EthicsMeetAduitDate
	   	.s PPRemark=PPRemark+"。 "+EthicsMeetAduitDate
   	
   	e  d
   	.s Err=Err_"^"_""
   	i $l(EthicsMeetAduitDate,"/")=3  s EthicsMeetAduitDate1=$zdh($p(EthicsMeetAduitDate,"/",3)_"/"_$p(EthicsMeetAduitDate,"/",2)_"/"_$p(EthicsMeetAduitDate,"/",1),4)
   	i (($l(FirstPatDate,"/")'=3)&&(FirstPatDate'="")) d
	   	.s Err=Err_"^"_FirstPatDate
	   	.s PPRemark=PPRemark+"。 "+FirstPatDate
   	
   	e  d
   	.s Err=Err_"^"_""
   	i $l(FirstPatDate,"/")=3  s FirstPatDate1=$zdh($p(FirstPatDate,"/",3)_"/"_$p(FirstPatDate,"/",2)_"/"_$p(FirstPatDate,"/",1),4)
   	i (($l(PPEndDate,"/")'=3)&&(PPEndDate'="")) d
	   	.s Err=Err_"^"_PPEndDate
	   		.s PPRemark=PPRemark+"。 "+PPEndDate
   	
   	e  d
   	.s Err=Err_"^"_""
   	i $l(PPEndDate,"/")=3  s PPEndDate1=$zdh($p(PPEndDate,"/",3)_"/"_$p(PPEndDate,"/",2)_"/"_$p(PPEndDate,"/",1),4)
    i (($l(YearCheckDate,"/")='3)&&(YearCheckDate'="")) d
	    .s Err=Err_"^"_YearCheckDate
	    .s PPRemark=PPRemark+"。 "+YearCheckDate
    
   	e  d
   	.s Err=Err_"^"_""
   	i $l(YearCheckDate,"/")=3  s YearCheckDate1=$zdh($p(YearCheckDate,"/",3)_"/"_$p(YearCheckDate,"/",2)_"/"_$p(YearCheckDate,"/",1),4)
    i (($l(EthicsFilesOffDate,"/")'=3)&&(EthicsFilesOffDate'="")) d
	    .s Err=Err_"^"_EthicsFilesOffDate
	    .s PPRemark=PPRemark+"。 "+EthicsFilesOffDate
    
   	e  d
   	.s Err=Err_"^"_""
   	i $l(EthicsFilesOffDate,"/")=3  s EthicsFilesOffDate1=$zdh($p(EthicsFilesOffDate,"/",3)_"/"_$p(EthicsFilesOffDate,"/",2)_"/"_$p(EthicsFilesOffDate,"/",1),4)
    i (($l(SignProtocolDate,"/")'=3)&&(SignProtocolDate'="")) d
	    .s Err=Err_"^"_SignProtocolDate
	    .s PPRemark=PPRemark+"。 "+SignProtocolDate
    
   	e  d
   	.s Err=Err_"^"_""
   	i $l(SignProtocolDate,"/")=3  s SignProtocolDate1=$zdh($p(SignProtocolDate,"/",3)_"/"_$p(SignProtocolDate,"/",2)_"/"_$p(SignProtocolDate,"/",1),4)
    i Err="^^^^^^^^^^^^^^^^^" s Err=""
    e  s Err="^"_cou_"^"_PPDesc_"^"_Err
   
   	i PPState["已完成" s PPState="F"
   	e  i PPState["未进行" s PPState="H"
   	e  i PPState["未完成" s PPState="V"
   	e  i PPState["暂停" s PPState="A"
   	e  i PPState["中止" s PPState="B"
   	e  i PPState["终止" s PPState="S"
   	e  s PPState=""
   	
   	
   	;w !,LeaderCompany_"^"_LeaderCompanyPI
    ;w !,Err
      
		s UObj=##class(User.DHCDocPilotProject).%New()
		s UObj.PPDesc=PPDesc
		s UObj.ApplicationUnit=ApplicationUnit
		s PPCode=..GetMaxCodeNo()
		s UObj.PPCode=PPCode
		s UObj.ApprovalNo=ApprovalNo
		s UObj.PlanNo=PlanNo
		s UObj.PlanName=PlanName
		s UObj.Indication=Indication
		s UObj.FileSubmitDate=FileSubmitDate1
		s UObj.EthicsMeetDate=EthicsMeetDate1
		s UObj.EthicsMeetAduitDate=EthicsMeetAduitDate1
		s UObj.FirstPatDate=FirstPatDate1
		s UObj.PPEndDate=PPEndDate1
		s UObj.ArchivesFilesNo=ArchivesFilesNo
		s UObj.CollectCompany=CollectCompany
		s UObj.PPState=PPState
		s UObj.YearCheckDate=YearCheckDate1
		s UObj.EthicsFilesOffDate=EthicsFilesOffDate1
		s UObj.SignProtocolDate=SignProtocolDate1
		s UObj.LeaderCompany=LeaderCompany
		s UObj.LeaderCompanyPI=LeaderCompanyPI
		s UObj.CROCompany=CROCompany
		s UObj.PPRemark=PPRemark
		s UObj.CheckPerson=CheckPerson
		s UObj.ApproveResult="Y"
		s UObj.CPRCApproveResult="Y"
		d UObj.PilotCategoryDrSetObjectId(PilotCategoryDr)
		d UObj.ApplyMatterDrSetObjectId(ApplyMatterDr)
		d UObj.ApplyStageDrSetObjectId(ApplyStageDr)
		d UObj.IsHeadmanDrSetObjectId(IsHeadmanDr)
		d UObj.PPCreateDepartmentDrSetObjectId(PPCreateDepartmentDr)
		d UObj.PPStartUserDrSetObjectId(PPStartUserDr)
		d UObj.ProjectFilesStateDrSetObjectId(ProjectFilesStateDr)
		d UObj.EthicsFilesStateDrSetObjectId(EthicsFilesStateDr)
		d UObj.EthicsFilesNextStateDrSetObjectId(EthicsFilesNextStateDr)
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		i Err'="" s ^DHCDocPilotProject("InportProjectInfo",PPSPPParRef)=Err
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	if +myrtn=0{
		if (PPOtherStartUserDr)'=""{
		s length=$l(PPOtherStartUserDr,"^")
		f d=1:1:length {
			s PPCreateDepartmentDr1=$p(PPOtherCreateDepartmentDr,"^",d)
			s PPStartUserDr1=$p(PPOtherStartUserDr,"^",d)
			i PPCreateDepartmentDr1="" s PPCreateDepartmentDr1=PPCreateDepartmentDr
			s DepObj=##class(User.DHCDocPilotProDept).%New(PPSPPParRef)
			d DepObj.PPDPPParRefSetObjectId(PPSPPParRef)
			d DepObj.PPDCreateDepartmentDrSetObjectId(PPCreateDepartmentDr1)
			d DepObj.PPDStartUserDrSetObjectId(PPStartUserDr1)
			Set sc = DepObj.%Save()
			If ($System.Status.IsError(sc))
			{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-106"
			}
			d DepObj.%Close()
		}
		}	
	}
		
	}
	
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	c file
	Q myrtn
}

// d ##class(web.PilotProject.DHCDocPilotProject).InportPayInfo()

ClassMethod InportPayInfo()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectPay
	Set file=##class(%File).%New("/temp/pay2006.txt")
	set ExistsFlag=##class(%File).Exists("/temp/pay2006.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/pay2006.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s name=PatList(4)
		
		s name=$tr(name,"国际多中心首付+补充协议二首付+IEC","")
		s name=$tr(name,"伦理审评费","")
		s name=$tr(name,"伦理委员会审评费","")
		s name=$tr(name,"经费","")
		s name=$tr(name,"II期","")
		s name=$tr(name,"I期","")
		s name=$tr(name,"伦理评审费","")
		s name=$tr(name,"III期","")
		s name=$tr(name,"Ib期","")
		s name=$tr(name,"合同","")
		s name=$tr(name,"管理费","")
		s name=$tr(name,"Ⅳ期","")
		s name=$tr(name,"第二次付款","")
		s name=$tr(name,"首付","")
		s name=$tr(name,"测试费","")
		s name=$tr(name,"第三次付款","")
		s name=$tr(name,"一次付清","")
		s name=$tr(name,"尾款","")
		s name=$tr(name,"第四次付款","")
		s name=$tr(name,"第六次付款","")
		s name=$tr(name,"检查费","")
		
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		w name
		s rowid=0
		;s ^TmpProjectPay("name",rowid)=""
		;s ^TmpProjectPay("Id",rowid)=""
		s str1=""
		s str2=""
		f  s rowid=$o(^DHCDocPP(rowid)) q:rowid=""  d
		.s ProCode=$p($g(^DHCDocPP(rowid)),"^",1)
		.s ProDesc=$P(^DHCDocPP(rowid),"^",2)
		.s PlanNo=$p($g(^DHCDocPP(rowid)),"^",26)
		.s PlanName=$p($g(^DHCDocPP(rowid)),"^",27)
		.q:ProDesc=""
		.q:name=""
		.i ProDesc[name d
		..i str1="" d
		...s str1="("_ProDesc_")"
		...s str2=ProCode
		..e  d
		...s str1=str1_"，("_ProDesc_")"
		...s str2=str2_"，"_ProCode
		.e  i name[ProDesc d
		..i str1="" d
		...s str1="("_ProDesc_")"
		...s str2=ProCode
		..e  d
		...s str1=str1_"，"_"("_ProDesc_")"
		...s str2=str2_"，"_ProCode
		.e  i ((name[PlanNo)&&(PlanNo'="")) d
		..i str1="" d
		...s str1="("_ProDesc_")"
		...s str2=ProCode
		..e  d
		...s str1=str1_"，"_"("_ProDesc_")"
		...s str2=str2_"，"_ProCode
		
		s ^TmpProjectPay("name",cou)=str1
		s ^TmpProjectPay("Id",cou)=str2
	}
	s File="/tmp/paye2006.txt"
     open File:"WNS"
     u File
     s Id=""
     f  s Id=$o(^TmpProjectPay("name",Id)) q:Id=""  d
     .w ^TmpProjectPay("name",Id)_"^"_^TmpProjectPay("Id",Id),!
     c File
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	c file
	Q myrtn
}

ClassMethod InportPayInfo2006()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectPay
	Set file=##class(%File).%New("/temp/pay2006.txt")
	set ExistsFlag=##class(%File).Exists("/temp/pay2006.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/pay2006.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s FirstPay=""
		s Type=""
		s date=PatList(2)
		i $l(date,"/")=3  s date=$zdh($p(date,"/",3)_"/"_$p(date,"/",2)_"/"_$p(date,"/",1),4)
		s StartUser=PatList(3)
		s Department=PatList(4)
		s Remitter=PatList(5)
		s ProjectName=PatList(6)
		i ProjectName["首付" d
		.s FirstPay=1
		i ProjectName["IEC" d
		.s Type="I"
		i ProjectName["审评费" d
		.s Type="I"
		i ProjectName["评审费" d
		.s Type="I"
		s RemAmount=PatList(10)+PatList(11)+PatList(12)
		s Remark=PatList(14)
		s UObj=##class(User.DHCDocPilotProRemBefore).%New()
		s UObj.Remitter=Remitter
		s UObj.Date=date
		s UObj.Department=Department
		s UObj.StartUser=StartUser
		s UObj.FirstPay=FirstPay
		s UObj.ProjectName=ProjectName
		s UObj.State="V"
		s UObj.RemAmount=RemAmount
		s UObj.Type=Type
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

ClassMethod InportPayInfo2007()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectPay
	Set file=##class(%File).%New("/temp/pay2007.txt")
	set ExistsFlag=##class(%File).Exists("/temp/pay2007.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/pay2007.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s FirstPay=""
		s Type=""
		s date=PatList(11)
		i $l(date,"/")=3  s date=$zdh($p(date,"/",3)_"/"_$p(date,"/",2)_"/"_$p(date,"/",1),4)
		s StartUser=PatList(1)
		s Department=PatList(2)
		s Remitter=PatList(4)
		s ProjectName=PatList(3)
		s Account=PatList(9)
		s name=PatList(5)
		i name["首付" d
		.s FirstPay=1
		i ProjectName["IEC" d
		.s Type="I"
		i ProjectName["审评费" d
		.s Type="I"
		i ProjectName["评审费" d
		.s Type="I"
		s RemAmount=PatList(6)+PatList(7)+PatList(8)
		s Remark=PatList(12)
		s UObj=##class(User.DHCDocPilotProRemBefore).%New()
		s UObj.Remitter=Remitter
		s UObj.Date=date
		s UObj.Name=name
		s UObj.Department=Department
		s UObj.StartUser=StartUser
		s UObj.FirstPay=FirstPay
		s UObj.ProjectName=ProjectName
		s UObj.State="V"
		s UObj.RemAmount=RemAmount
		s UObj.Type=Type
		s UObj.Account=Account
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

ClassMethod InportPayInfo2008()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectPay
	Set file=##class(%File).%New("/temp/pay2008.txt")
	set ExistsFlag=##class(%File).Exists("/temp/pay2008.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/pay2008.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s FirstPay=""
		s Type=""
		s date=PatList(11)
		i $l(date,"/")=3  s date=$zdh($p(date,"/",3)_"/"_$p(date,"/",2)_"/"_$p(date,"/",1),4)
		s StartUser=PatList(1)
		s Department=PatList(2)
		s Remitter=PatList(4)
		s ProjectName=PatList(3)
		s Account=PatList(7)
		s name=PatList(5)
		i name["首付" d
		.s FirstPay=1
		i ProjectName["IEC" d
		.s Type="I"
		i ProjectName["审评费" d
		.s Type="I"
		i ProjectName["评审费" d
		.s Type="I"
		s RemAmount=PatList(6)+PatList(8)+PatList(9)
		s Remark=PatList(12)
		s UObj=##class(User.DHCDocPilotProRemBefore).%New()
		s UObj.Remitter=Remitter
		s UObj.Date=date
		s UObj.Name=name
		s UObj.Department=Department
		s UObj.StartUser=StartUser
		s UObj.FirstPay=FirstPay
		s UObj.ProjectName=ProjectName
		s UObj.State="V"
		s UObj.RemAmount=RemAmount
		s UObj.Type=Type
		s UObj.Account=Account
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

ClassMethod InportPayInfo2009()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectPay
	Set file=##class(%File).%New("/temp/pay2009.txt")
	set ExistsFlag=##class(%File).Exists("/temp/pay2009.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/pay2009.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s FirstPay=""
		s Type=""
		s date=PatList(11)
		i $l(date,"/")=3  s date=$zdh($p(date,"/",3)_"/"_$p(date,"/",2)_"/"_$p(date,"/",1),4)
		s StartUser=PatList(1)
		s Department=PatList(2)
		s Remitter=PatList(4)
		s ProjectName=PatList(3)
		s Account=PatList(7)
		s name=PatList(5)
		i name["首付" d
		.s FirstPay=1
		i ProjectName["IEC" d
		.s Type="I"
		i ProjectName["审评费" d
		.s Type="I"
		i ProjectName["评审费" d
		.s Type="I"
		s RemAmount=PatList(6)+PatList(8)+PatList(9)
		s Remark=PatList(12)
		s UObj=##class(User.DHCDocPilotProRemBefore).%New()
		s UObj.Remitter=Remitter
		s UObj.Date=date
		s UObj.Name=name
		s UObj.Department=Department
		s UObj.StartUser=StartUser
		s UObj.FirstPay=FirstPay
		s UObj.ProjectName=ProjectName
		s UObj.State="V"
		s UObj.RemAmount=RemAmount
		s UObj.Type=Type
		s UObj.Account=Account
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

ClassMethod InportPayInfo2010()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectPay
	Set file=##class(%File).%New("/temp/pay2010.txt")
	set ExistsFlag=##class(%File).Exists("/temp/pay2010.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/pay2010.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s FirstPay=""
		s Type=""
		s date=PatList(11)
		i $l(date,".")=3  s date=$zdh($p(date,".",3)_"/"_$p(date,".",2)_"/"_$p(date,".",1),4)
		s StartUser=PatList(1)
		s Department=PatList(2)
		s Remitter=PatList(4)
		s ProjectName=PatList(3)
		;s Account=PatList(7)
		s name=PatList(5)
		i name["首付" d
		.s FirstPay=1
		i ProjectName["IEC" d
		.s Type="I"
		i ProjectName["审评费" d
		.s Type="I"
		i ProjectName["评审费" d
		.s Type="I"
		s RemAmount=PatList(6)
		s Remark=PatList(12)
		s UObj=##class(User.DHCDocPilotProRemBefore).%New()
		s UObj.Remitter=Remitter
		s UObj.Date=date
		s UObj.Name=name
		s UObj.Department=Department
		s UObj.StartUser=StartUser
		s UObj.FirstPay=FirstPay
		s UObj.ProjectName=ProjectName
		s UObj.State="V"
		s UObj.RemAmount=RemAmount
		s UObj.Type=Type
		s UObj.Account=Account
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

ClassMethod InportPayInfo2011()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectPay
	Set file=##class(%File).%New("/temp/pay2011.txt")
	set ExistsFlag=##class(%File).Exists("/temp/pay2011.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/pay2011.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s FirstPay=""
		s Type=""
		s date=PatList(7)
		i $l(date,".")=3  s date=$zdh($p(date,".",3)_"/"_$p(date,".",2)_"/"_$p(date,".",1),4)
		s StartUser=PatList(1)
		s Department=PatList(2)
		s Remitter=PatList(4)
		s ProjectName=PatList(3)
		;s Account=PatList(7)
		s name=PatList(5)
		i name["首付" d
		.s FirstPay=1
		i ProjectName["IEC" d
		.s Type="I"
		i ProjectName["审评费" d
		.s Type="I"
		i ProjectName["评审费" d
		.s Type="I"
		s RemAmount=PatList(6)
		s Remark=PatList(8)
		s UObj=##class(User.DHCDocPilotProRemBefore).%New()
		s UObj.Remitter=Remitter
		s UObj.Date=date
		s UObj.Name=name
		s UObj.Department=Department
		s UObj.StartUser=StartUser
		s UObj.FirstPay=FirstPay
		s UObj.ProjectName=ProjectName
		s UObj.State="V"
		s UObj.RemAmount=RemAmount
		s UObj.Type=Type
		s UObj.Account=Account
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

// d ##class(web.PilotProject.DHCDocPilotProject).InportSAE()

ClassMethod InportSAE()
{
	//写日志文件
	s myrtn=0
	s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s Rowid=CTDefineRowId_"||"_ChildSub
	...s Desc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...i ((Desc="首次报告")&&(Define="报告类型")) s FirstTypeDr=Rowid
	...i ((Desc="随访报告")&&(Define="报告类型")) s SecondTypeDr=Rowid
	...i ((Desc="总结报告")&&(Define="报告类型")) s LastTypeDr=Rowid
	...i ((Desc="死亡")&&(Define="SAE情况")) s DeathDr=Rowid
	...i ((Desc="导致住院")&&(Define="SAE情况")) s InHospDr=Rowid
	...i ((Desc="停用药物")&&(Define="对试验药物采取的措施")) s StopDr=Rowid
	...i ((Desc="继续用药")&&(Define="对试验药物采取的措施")) s StillDr=Rowid
	k ^TmpProjectSAE
	Set file=##class(%File).%New("/temp/stream/SAE.txt")
	set ExistsFlag=##class(%File).Exists("/temp/stream/SAE.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/stream/SAE.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")

			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s PPName=PatList(1)
		s PlanName=PatList(3)
		s PlanNo=PatList(4)
		s PPSAEDocumentRegNo=PatList(6)
		s PPSAEPatNameab=PatList(9)
		s PPSAEDate=PatList(10)
		i $l(PPSAEDate,"/")=3  s PPSAEDate=$zdh($p(PPSAEDate,"/",3)_"/"_$p(PPSAEDate,"/",2)_"/"_$p(PPSAEDate,"/",1),4)
		s cou=cou+1
		s PPSAEICDCode=PatList(11)
		s PPSAEMidSummary=PatList(12)
		s PPSAERemark=PatList(13)
		s PPSAERelate=PatList(14)
		s PI=PatList(8)
		if PPSAERelate="肯定无关" s PPSAERelate="可定无关"
		if PPSAERelate="无关" s PPSAERelate="可定无关"
		if PPSAERelate="无法判定" s PPSAERelate="无法判断"
	s ModuleRowId=""
	s PPSAERelateDr=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s Rowid=CTDefineRowId_"||"_ChildSub
	...s Desc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...i ((PPSAERelate[Desc)&&(PPSAERelate'="")&&(Define="与试验药物的相关性")) s PPSAERelateDr=Rowid
		s PPSAEPPParRef=""
		s rowid="0"
		f  s rowid=$o(^DHCDocPP(rowid)) q:rowid=""  d
		.s ProCode1=$p($g(^DHCDocPP(rowid)),"^",1)
		.s ProDesc1=$P(^DHCDocPP(rowid),"^",2)
		.s PlanNo1=$p($g(^DHCDocPP(rowid)),"^",26)
		.s PlanName1=$p($g(^DHCDocPP(rowid)),"^",27)
		.s ProStartUserDr=$p($g(^DHCDocPP(rowid)),"^",10)
		.S ProStartUser=""
		.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
		

		.q:(((PlanNo'[PlanNo1)||(PI'[ProStartUser)||(PPName'[ProDesc1))&&(PlanNo'="无"))
		.q:(((PI'[ProStartUser)||(PPName'=ProDesc1))&&(PlanNo="无"))
		.s PPSAEPPParRef=rowid
        i ((PPSAEICDCode'="")&&(PPSAEICDCode'="/")){
		if PPSAEPPParRef'=""{
	    ;s cou=cou+1
		s UObj=##class(User.DHCDocPilotProSAE).%New(PPSAEPPParRef)
		d UObj.PPSAEPPParRefSetObjectId(PPSAEPPParRef)
		s UObj.PPSAEICDCode=PPSAEICDCode
		s UObj.PPSAEDocumentRegNo=PPSAEDocumentRegNo
		s UObj.PPSAEPatNameab=PPSAEPatNameab
		;s UObj.PPSAERemark=PPSAERemark
		;s UObj.PPSAEMidSummary=PPSAEMidSummary
		s UObj.PPSAEDate=PPSAEDate
		d UObj.PPSAERelateDrSetObjectId(PPSAERelateDr)
		d UObj.PPSAEReportTypeDrSetObjectId(FirstTypeDr)
		s PPSAESituationDr="",PPSAEStepDr=""
		i PPSAEICDCode["死亡" s PPSAESituationDr=DeathDr
		i PPSAEICDCode["导致住院" s PPSAESituationDr=InHospDr
		i PPSAEICDCode["继续用药" s PPSAEStepDr=StillDr
		i ((PPSAEICDCode["停用")||(PPSAEICDCode["停止试验用药")) s PPSAEStepDr=StopDr
		d UObj.PPSAESituationDrSetObjectId(PPSAESituationDr)
		d UObj.PPSAEStepDrSetObjectId(PPSAEStepDr)
		
		
		
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	else {
		s ^TmpProjectSAE(cou)=PPName
	}
    }
    i ((PPSAEMidSummary'="")&&(PPSAEMidSummary'="/")){
		if PPSAEPPParRef'=""{
	    ;s cou=cou+1
		s UObj=##class(User.DHCDocPilotProSAE).%New(PPSAEPPParRef)
		d UObj.PPSAEPPParRefSetObjectId(PPSAEPPParRef)
		s UObj.PPSAEICDCode=PPSAEMidSummary
		s UObj.PPSAEDocumentRegNo=PPSAEDocumentRegNo
		s UObj.PPSAEPatNameab=PPSAEPatNameab
		;s UObj.PPSAERemark=PPSAERemark
		;s UObj.PPSAEMidSummary=PPSAEMidSummary
		
		d UObj.PPSAERelateDrSetObjectId(PPSAERelateDr)
		d UObj.PPSAEReportTypeDrSetObjectId(SecondTypeDr)
		s PPSAESituationDr="",PPSAEStepDr=""
		i PPSAEMidSummary["死亡" s PPSAESituationDr=DeathDr
		i PPSAEMidSummary["导致住院" s PPSAESituationDr=InHospDr
		i PPSAEMidSummary["继续用药" s PPSAEStepDr=StillDr
		i ((PPSAEMidSummary["停用")||(PPSAEMidSummary["停止试验用药")) s PPSAEStepDr=StopDr
		d UObj.PPSAESituationDrSetObjectId(PPSAESituationDr)
		d UObj.PPSAEStepDrSetObjectId(PPSAEStepDr)
		s PPSAEDate1=""
		i $l(PPSAEMidSummary,"-")>=3 {
			s PPSAEDate12=$p(PPSAEMidSummary,"-",1,2)
		s PPSAEDate3=+$p(PPSAEMidSummary,"-",3)
		s PPSAEDate1=PPSAEDate12_"-"_PPSAEDate3
		s PPSAEDate1=$zdh(PPSAEDate1,3)
		
		}
		if PPSAEDate1=""{
			s UObj.PPSAEDate=PPSAEDate
		}else {
			s UObj.PPSAEDate=PPSAEDate1
		}
		
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	else {
		s ^TmpProjectSAE(cou)=PPName
	}
    }
    i ((PPSAERemark'="")&&(PPSAERemark'="/")){
		if PPSAEPPParRef'=""{
	    ;s cou=cou+1
		s UObj=##class(User.DHCDocPilotProSAE).%New(PPSAEPPParRef)
		d UObj.PPSAEPPParRefSetObjectId(PPSAEPPParRef)
		s UObj.PPSAEICDCode=PPSAERemark
		s UObj.PPSAEDocumentRegNo=PPSAEDocumentRegNo
		s UObj.PPSAEPatNameab=PPSAEPatNameab
		;s UObj.PPSAERemark=PPSAERemark
		;s UObj.PPSAEMidSummary=PPSAEMidSummary
		;s UObj.PPSAEDate=PPSAEDate
		d UObj.PPSAERelateDrSetObjectId(PPSAERelateDr)
		d UObj.PPSAEReportTypeDrSetObjectId(LastTypeDr)
		
		s PPSAESituationDr="",PPSAEStepDr=""
		i PPSAERemark["死亡" s PPSAESituationDr=DeathDr
		i PPSAERemark["导致住院" s PPSAESituationDr=InHospDr
		i PPSAERemark["继续用药" s PPSAEStepDr=StillDr
		i ((PPSAERemark["停用")||(PPSAERemark["停止试验用药")) s PPSAEStepDr=StopDr
		d UObj.PPSAESituationDrSetObjectId(PPSAESituationDr)
		d UObj.PPSAEStepDrSetObjectId(PPSAEStepDr)
		s PPSAEDate1=""
		if cou=96 s PPSAEDate1=$zdh("2013-4-11",3)
		i $l(PPSAERemark,"-")>=3 {
			s PPSAEDate12=$p(PPSAERemark,"-",1,2)
		s PPSAEDate3=+$p(PPSAERemark,"-",3)
		s PPSAEDate1=PPSAEDate12_"-"_PPSAEDate3
		i ((cou'=95)&&(cou'=104)) s PPSAEDate1=$zdh(PPSAEDate1,3)
		i cou=104 s PPSAEDate1=$zdh("2013-5-6",3)
		i cou=95  s PPSAEDate1=$zdh("2013-4-22",3)
		}
		if PPSAEDate1=""{
			s UObj.PPSAEDate=PPSAEDate
		}else {
			s UObj.PPSAEDate=PPSAEDate1
		}
		Set sc = UObj.%Save()
		s PPSPPParRef=UObj.%Id()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	else {
		s ^TmpProjectSAE(cou)=PPName
	}
    }
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

// d ##class(web.PilotProject.DHCDocPilotProject).ImportAccount()

ClassMethod ImportAccount()
{
	//写日志文件
	s myrtn=0
	Set file=##class(%File).%New("/temp/Account.txt")
	set ExistsFlag=##class(%File).Exists("/temp/Account.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/Account.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)

		s Account=PatList(1)
	
		s ProjectName=PatList(2)
		s AccountSum=PatList(4)

		s UObj=##class(User.DHCDocPilotProAccount).%New()
		s UObj.Account=Account
		s UObj.ProjectName=ProjectName
		s UObj.AccountSum=AccountSum
		
		Set sc = UObj.%Save()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

ClassMethod DeleteSettle(PPSetRowId As %String) As %String
{
	q:PPSetRowId="" ""
	//s ^zzy("DeleteSettle")=PPSetRowId
	TS
	s PPRowId=+PPSetRowId
	s DPPSetType=$p($g(^DHCDocPPSET(PPRowId,$p(PPSetRowId,"||",2))),"^",2)
	&sql(Delete from DHC_DocPilotProSettle where PPSET_RowId=:PPSetRowId)
	s myrtn=SQLCODE
	if +myrtn=0{

	s DistributionCount=$p($g(^DHCDocPP(PPRowId)),"^",93)
	s DistributionCount=DistributionCount-1
	i DPPSetType'="E"  {
		&sql(Update  DHC_DocPilotProject set PP_DistributionCount=:DistributionCount where PP_RowId=:PPRowId)
		}
		s myrtn=SQLCODE
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

// d ##class(web.PilotProject.DHCDocPilotProject).Inportdangan()

ClassMethod Inportdangan()
{
	//写日志文件
	s myrtn=0
	k ^TMPInportdangan
	Set file=##class(%File).%New("/temp/stream/DA.txt")
	set ExistsFlag=##class(%File).Exists("/temp/stream/DA.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/stream/DA.txt"
	
	;KILL ^PAPER
	TS
	w !,"导入中..."
	s cou=2
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s EndYear=+PatList(1)
		s DeptCode=PatList(2)
		s ProjectNo=PatList(3)
		s FileCaseNo=PatList(4)
		set PPCreateDepartment=PatList(5)   
		s PPStartUser=PatList(6)
		s PPDesc=PatList(7)
		set PlanName=PatList(8) 
		set PlanNo=PatList(9)
		set ApprovalNo=PatList(10)
		set Indication=PatList(11) 
		set PilotCategory=PatList(12) 
		set IsHeadman=PatList(13)
		set LeaderCompany=PatList(14)     
		set LeaderCompanyPI=PatList(15)
		set ApplicationUnit=PatList(16) 
		set ApplyContact=PatList(17)
		set ApplyContactTel=PatList(18)
		set CROCompany=PatList(19)
		s CROContact=PatList(20)
		s CROContactTel=PatList(21)
		s CollectCompany=PatList(22)
		s CountUnitContact=PatList(23)
		s CountUnitContactTel=PatList(24)
		s DesignCaseNum=PatList(25)
		s LocalGroupPlanCaseNum=PatList(26)
		s LocalGroupFactCaseNum=PatList(27)
		set FirstFormConsentDate=PatList(28)
		s LastCaseDate=PatList(29)
		s FilterCaseNum=PatList(30)
		s RejectCaseNum=PatList(31)
		s DropCaseNum=PatList(32)
		s SAECaseNum=PatList(33)
		s BriefDate=PatList(34)
		s SumDate=PatList(35)
		s FilingDate=PatList(36)
		s SaveLastDate=PatList(37)
		s GroupTransferUser=PatList(38)
		s recipient=PatList(39)
		s DrugExamCheckFlag=PatList(40)
		s DrugExamCheckDate=PatList(41)
		s EthicsFilesOffStatus=PatList(42)
		s EthicsFilesOffDate=PatList(43)
		s EthicsFilesOffOperator=PatList(44)
		s EthicsFilesOffCompany=PatList(45)
		s EthicsFilesOffTel=PatList(46)
		s ImageDataLocation=PatList(47)
		s ImageDataNum=PatList(48)
		s CheckPerson=PatList(49)
		s FirstPatDate=PatList(50)
		s InGroupNum=PatList(52)
		;s FilterCaseNum=PatList(53)
		s FileNum=PatList(54)
		s FormConsentNum=PatList(55)
		s CaseReportNum=PatList(56)
		s OrigRecordNum=PatList(57)
		s EthicsFilesNum=PatList(58)
		s TotalFileNum=PatList(59)
		w !,TotalFileNum
		s EthicsFilesOffStatusDr=""
		s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s Rowid=CTDefineRowId_"||"_ChildSub
	...s Desc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...i (((EthicsFilesOffStatus[Desc)||(Desc[EthicsFilesOffStatus))&&(EthicsFilesOffStatus'="")&&(Define="档案销毁状态")) s EthicsFilesOffStatusDr=Rowid
    s Err=""
   s FirstFormConsentDate1="",LastCaseDate1="",BriefDate1="",SumDate1="",FilingDate1="",DrugExamCheckDate1="",EthicsFilesOffDate1=""
		s rowid="0"
		s Findrowid=""
		f  s rowid=$o(^DHCDocPP(rowid)) q:((rowid="")||(Findrowid'=""))  d
		.s ProCode1=$p($g(^DHCDocPP(rowid)),"^",1)
		.s ProDesc1=$P(^DHCDocPP(rowid),"^",2)
		.s PlanNo1=$p($g(^DHCDocPP(rowid)),"^",26)
		.s PlanName1=$p($g(^DHCDocPP(rowid)),"^",27)
		.s ProStartUserDr=$p($g(^DHCDocPP(rowid)),"^",10)
		.s ApplyStage=""
		.s ApplyStageDrnow=$p($g(^DHCDocPP(rowid)),"^",24)
		.s:ApplyStageDrnow'="" ApplyStage=$p($g(^DHCDocCT("DefineData",+ApplyStageDrnow,"D",$p(ApplyStageDrnow,"||",2))),"^",2)
		.S ProStartUser=""
		.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
		.s child=0
		.f  s child=$o(^DHCDocPPD(rowid,child)) q:child=""  d
		..s User=""
		..s UserDr=$p($g(^DHCDocPPD(rowid,child)),"^",2)
		..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		..s:User'="" ProStartUser=ProStartUser_","_User
		.i ((PlanNo=PlanNo1)&&(PlanNo'="无")&&(PlanNo'="")&&(PlanNo'="/")&&(PlanNo'=" ")) s Findrowid=rowid
		.q:((PlanNo=PlanNo1)&&(PlanNo'="无")&&(PlanNo'="")&&(PlanNo'="/")&&(PlanNo'=" "))
        .i (((ProDesc1[PPDesc)||(PPDesc[ProDesc1))&&(ProStartUser[PPStartUser)&&(PPStartUser'="")&&(PilotCategory[ApplyStage)) s Findrowid=rowid
        i Findrowid="" s ^TMPInportdangan("N",cou)=cou_"^"_PPDesc
        e  s ^TMPInportdangan("Y",cou)=cou_"^"_PPDesc_"^"_Findrowid_"^"_ProDesc1
        s Err=""
      i $l(FirstFormConsentDate,"/")=3  s FirstFormConsentDate1=$zdh($p(FirstFormConsentDate,"/",3)_"/"_$p(FirstFormConsentDate,"/",2)_"/"_$p(FirstFormConsentDate,"/",1),4)
   		i (($l(FirstFormConsentDate,"/")'=3)&&(FirstFormConsentDate'="")) d
	   	 .s Err=Err_"^"_"第一例知情同意书日期:"_FirstFormConsentDate
	   
      i $l(LastCaseDate,"/")=3  s LastCaseDate1=$zdh($p(LastCaseDate,"/",3)_"/"_$p(LastCaseDate,"/",2)_"/"_$p(LastCaseDate,"/",1),4)
   		i (($l(LastCaseDate,"/")'=3)&&(LastCaseDate'="")) d
	   	 .s Err=Err_"^"_"最后一例出组日期"_LastCaseDate
	   	 
	   	 i $l(BriefDate,"/")=3  s BriefDate1=$zdh($p(BriefDate,"/",3)_"/"_$p(BriefDate,"/",2)_"/"_$p(BriefDate,"/",1),4)
   		i (($l(BriefDate,"/")'=3)&&(BriefDate'="")) d
	   	 .s Err=Err_"^"_"小结日期"_BriefDate
	   	 
	   	 i $l(SumDate,"/")=3  s SumDate1=$zdh($p(SumDate,"/",3)_"/"_$p(SumDate,"/",2)_"/"_$p(SumDate,"/",1),4)
   		i (($l(SumDate,"/")'=3)&&(SumDate'="")) d
	   	 .s Err=Err_"^"_"总结日期"_SumDate
	   	 
	   	  i $l(FilingDate,"/")=3  s FilingDate1=$zdh($p(FilingDate,"/",3)_"/"_$p(FilingDate,"/",2)_"/"_$p(FilingDate,"/",1),4)
   		i (($l(FilingDate,"/")'=3)&&(FilingDate'="")) d
	   	 .s Err=Err_"^"_"总结日期"_FilingDate
	   	 
	   	  i $l(DrugExamCheckDate,"/")=3  s DrugExamCheckDate1=$zdh($p(DrugExamCheckDate,"/",3)_"/"_$p(DrugExamCheckDate,"/",2)_"/"_$p(DrugExamCheckDate,"/",1),4)
   		i (($l(DrugExamCheckDate,"/")'=3)&&(DrugExamCheckDate'="")) d
	   	 .s Err=Err_"^"_"现场核查日期"_DrugExamCheckDate
	   	 
	   	  i $l(EthicsFilesOffDate,"/")=3  s EthicsFilesOffDate1=$zdh($p(EthicsFilesOffDate,"/",3)_"/"_$p(EthicsFilesOffDate,"/",2)_"/"_$p(EthicsFilesOffDate,"/",1),4)
   		i (($l(EthicsFilesOffDate,"/")'=3)&&(EthicsFilesOffDate'="")) d
	   	 .s Err=Err_"^"_"现场核查日期"_EthicsFilesOffDate
	   	 i Findrowid'=""{
	   	 s ^TMPInportdanganErr(Findrowid)=Err
		s UObj=##class(User.DHCDocPilotProject).%OpenId(Findrowid)
		s UObj.EndYear=+EndYear
		s UObj.DeptCode=DeptCode
		s UObj.ProjectNo= ProjectNo
		s UObj.FileCaseNo=FileCaseNo
		i UObj.LeaderCompany="" s UObj.LeaderCompany=LeaderCompany   
		i UObj.LeaderCompanyPI="" s UObj.LeaderCompanyPI=LeaderCompanyPI
		i UObj.ApplyContact="" s UObj.ApplyContact=ApplyContact
		i UObj.ApplyContactTel="" s UObj.ApplyContactTel=ApplyContactTel
		i UObj.CROCompany="" s UObj.CROCompany=CROCompany
		i UObj.CROContact="" s UObj.CROContact=CROContact
		i UObj.CROContactTel="" s UObj.CROContactTel=CROContactTel
		s UObj.CollectCompany=CollectCompany
		s UObj.CountUnitContact=CountUnitContact
		s UObj.CountUnitContactTel=CountUnitContactTel
		s UObj.DesignCaseNum=DesignCaseNum
		s UObj.LocalGroupPlanCaseNum=LocalGroupPlanCaseNum
		s UObj.LocalGroupFactCaseNum=LocalGroupFactCaseNum
		s UObj.FirstFormConsentDate=FirstFormConsentDate1
		s UObj.LastCaseDate=LastCaseDate1
		s UObj.FilterCaseNum=FilterCaseNum
		s UObj.RejectCaseNum=RejectCaseNum
		s UObj.DropCaseNum=DropCaseNum
		s UObj.SAECaseNum=SAECaseNum
		s UObj.BriefDate=BriefDate1
		s UObj.SumDate=SumDate1
		s UObj.FilingDate=FilingDate1
		s UObj.SaveLastDate=SaveLastDate
		s UObj.GroupTransferUser=GroupTransferUser
		s UObj.recipient=recipient
		s UObj.DrugExamCheckFlag=DrugExamCheckFlag
		s UObj.DrugExamCheckDate=DrugExamCheckDate1
		s UObj.EthicsFilesOffDate=EthicsFilesOffDate1
		s UObj.EthicsFilesOffOperator=EthicsFilesOffOperator
		s UObj.EthicsFilesOffCompany=EthicsFilesOffCompany
		s UObj.EthicsFilesOffTel=EthicsFilesOffTel
		s UObj.ImageDataLocation=ImageDataLocation
		s UObj.ImageDataNum=ImageDataNum
		s UObj.CheckPerson=CheckPerson
		;s FirstPatDate=PatList(50)
		s UObj.InGroupNum=InGroupNum
		s UObj.FilterCaseNum=FilterCaseNum
		s UObj.FileNum=FileNum
		s UObj.FormConsentNum=FormConsentNum
		s UObj.CaseReportNum=CaseReportNum
		s UObj.OrigRecordNum=OrigRecordNum
		s UObj.EthicsFilesNum=EthicsFilesNum
		s UObj.TotalFileNum=TotalFileNum
	
		d UObj.EthicsFilesOffStatusDrSetObjectId(EthicsFilesOffStatusDr)
		
		Set sc = UObj.%Save()
		
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
		b
	}
	
	d UObj.%Close()
	   	 }
	
		
	}
	
	w !,"导入完成!"
	w myrtn
	if +myrtn=0{
	TC
	}else{
		TRO
	}
}

ClassMethod GetProjectUser(PPRowId As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProject).GetProjectUser(484)
	q:PPRowId="" ""
	s ProStartUser=""
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	S ProStartUser=""
	if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if UserUserDr'="" s ProStartUser=$p(^SSU("SSUSR",UserUserDr),"^",2)
	s ret1=""
	set ret1=ProStartUserDr_$C(1)_ProStartUser
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s User=""
	.s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s:UserUserDr1'="" User=$p(^SSU("SSUSR",UserUserDr1),"^",2)
    .s ret1=ret1_"^"_UserDr_$C(1)_User
	 q ret1
}

// 授权研究者

ClassMethod EpStartUser(PPRowId As %String, PPStartUserDr As %String, UserUserDr As %String) As %String
{
	if PPRowId="" q "-101"
	if PPStartUserDr="" q "-102"
	;if UserUserDr="" q "-103"
	s mytrtn=""
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	if ProStartUserDr=PPStartUserDr{
		&sql(Update DHC_DocPilotProject set PP_UserUser_Dr=:UserUserDr where PP_RowId=:PPRowId)
		s mytrtn=SQLCODE
	}
	else {
		&sql(Update DHC_DocPilotProDept set PPD_UserUser_Dr=:UserUserDr where PPD_PP_ParRef=:PPRowId and PPD_StartUser_Dr=:PPStartUserDr)
	   s mytrtn=SQLCODE
	}
	q mytrtn
}

// 查找是否授权研究者

Query FindEPUser(PPRowId As %String) As %Query(ROWSPEC = "ProStartUserDr ,ProStartUser ,UserUserDr ,TUserUser ") [ SqlProc ]
{
}

ClassMethod FindEPUserClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindEPUserExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindEPUserFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEPUserExecute ]
{
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

/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindEPUser","24584")
ClassMethod FindEPUserExecute(ByRef QHandle As %Binary, PPRowId) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	//s ^zzy("FindEPUserExecute")=PPRowId
	s ProStartUser=""
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	s UserUser=""
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if UserUserDr'="" s UserUser=$p(^SSU("SSUSR",UserUserDr),"^",2)
	Do OutputRow13
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUser=""
	.s ProStartUserDr=""
	.s UserUser=""
	.s UserUserDr=""
	.s ProStartUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:ProStartUserDr'="" ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	.s UserUserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s:UserUserDr'="" UserUser=$p(^SSU("SSUSR",UserUserDr),"^",2)
	
	.Do OutputRow13
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow13
	set Data=$lb(ProStartUserDr,ProStartUser,UserUserDr,UserUser)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

// w ##class(web.PilotProject.DHCDocPilotProject).GetPPUserByID(982,"")

ClassMethod GetPPUserByID(PPRowId, UserDr)
{
	n (PPRowId,UserDr)
	if PPRowId="" q ""
	s ProStartUser=""
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if UserUserDr'="" s ProStartUser=$p(^SSU("SSUSR",UserUserDr),"^",2)
	if UserDr="" q ProStartUser
	
	if ((UserDr=ProStartUserDr)||(UserDr=UserUserDr)) q ProStartUser
	
	s User=""
	s child=""
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUser1=""
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:ProStartUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",ProStartUserDr1),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s:UserUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",UserUserDr1),"^",2)
	.i ((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1))  s User=ProStartUser1
	q User
}

ClassMethod GetPAccountByID(PPRRowId)
{
	if PPRRowId="" q ""
	s ProStartUser=""
	s PPAccount=$p($g(^DHCDocPP(+PPRRowId)),"^",50)
	s PPRowId=+PPRRowId
	s UserDr=$p($g(^DHCDocPPR(+PPRRowId,$p(PPRRowId,"||",2))),"^",15)
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s PU=""
	if ProStartUserDr'="" s PU=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	s CFFixedAcountFlag=##class(web.PilotProject.DHCDocPilotProCommon).getCFFixedAcountFlag(ProStartUserDr)
	if ((CFFixedAcountFlag=1)&&(PPAccount="")) q "V000002"
	if UserDr="" q PPAccount
	if ((UserDr=ProStartUserDr)||(UserDr=UserUserDr)) q PPAccount
	s PAccount=""
	s child=""
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s PAccount1=""
	.s PAccount1=$p($g(^DHCDocPPD(PPRowId,child)),"^",4)
	.i ((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1))  s PAccount=PAccount1
	
	q PAccount
}

// 新建财务专用数据

ClassMethod UpdateProjectForPay(PPRowId As %String, PPDesc As %String, PPCreateDepartmentDr As %String, PPStartUserDr As %String, ApplicationUnit As %String)
{
	s myrtn=0
	TS
	if (PPRowId=""){
		Set UObj = ##class(User.DHCDocPilotProject).%New()
	}
	else {
		Set UObj = ##class(User.DHCDocPilotProject).%OpenId(PPRowId)
	}
	s UObj.PPDesc=PPDesc
	d UObj.PPCreateDepartmentDrSetObjectId(PPCreateDepartmentDr)
	;d UObj.PPCreateUserDrSetObjectId(PPStartUserDr)
	s UObj.PPCreateDate=..%SysDate()
	s UObj.PPCreateTime=..%SysTime()
	d UObj.PPStartUserDrSetObjectId(PPStartUserDr)  
	s UObj.PPState="E"
	s UObj.ApplicationUnit=ApplicationUnit
	Set sc = UObj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

/// // d ##class(web.PilotProject.DHCDocPilotProject).GetAccountByUser(1058,"")
ClassMethod GetAccountByUser(PPRowId, UserDr, PPRType = "")
{
	if PPRowId="" q ""
	;s ^zzy("GetAccountByUser",PPRowId,$i(^zzy("GetAccountByUser",PPRowId)))=PPRowId_"^"_UserDr_"^"_PPRType
	;从付款记录得到研究者账户
	s PPAccount=""
	i (PPRType'="")&&(PPRType'="IEC")&&(UserDr'="") {
		s PPAccountStr=..GetUserPayAccount(PPRowId,UserDr)
		s PPAccount=$p(PPAccountStr,"^",1)
		s IsExistMasterUserFlag=$p(PPAccountStr,"^",2)
		if IsExistMasterUserFlag=1 Q PPAccount
	}
	
	s PPAccount=$p($g(^DHCDocPP(PPRowId)),"^",50)
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	s PCDepartmenDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	if (((UserDr=ProStartUserDr)||(UserDr=UserUserDr))&&(UserDr'="")&&(PCDepartmenDr=810)&&(PPAccount="")) q "V000002"
	if (((UserDr=ProStartUserDr)||(UserDr=UserUserDr))&&(UserDr'="")) q PPAccount
	if ((UserDr="")&&(PCDepartmenDr=810)&&(PPAccount="")) q "V000002"
	if UserDr="" q PPAccount
	s PAccount=""
	s more=0
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s more=1
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s PCDepartmenDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	.s PAccount1=""
	.s PAccount1=$p($g(^DHCDocPPD(PPRowId,child)),"^",4)
	.i (((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1))&&(UserDr'=""))  s PAccount=PAccount1
	.i (((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1))&&(UserDr'="")&&(PCDepartmenDr1=810)&&(PAccount1=""))  s PAccount="V000002"
	if ((more=0)&&(PCDepartmenDr=810)&&(PAccount1="")) q "V000002"
	if more=0 q PPAccount
	q PAccount
}

// d ##class(web.PilotProject.DHCDocPilotProject).InportdanganNew()

ClassMethod InportdanganNew(ex, ro)
{
	//写日志文件
	s myrtn=0
	//k ^TMPInportdangan
	Set file=##class(%File).%New("/temp/stream/DA.txt")
	set ExistsFlag=##class(%File).Exists("/temp/stream/DA.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/stream/DA.txt"
	
	;KILL ^PAPER
	TS
	w !,"导入中..."
	s cou=2
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s EndYear=+PatList(1)
		s DeptCode=PatList(2)
		s ProjectNo=PatList(3)
		s FileCaseNo=PatList(4)
		set PPCreateDepartment=PatList(5)   
		s PPStartUser=PatList(6)
		s PPDesc=PatList(7)
		set PlanName=PatList(8) 
		set PlanNo=PatList(9)
		set ApprovalNo=PatList(10)
		set Indication=PatList(11) 
		set PilotCategory=PatList(12) 
		set IsHeadman=PatList(13)
		set LeaderCompany=PatList(14)     
		set LeaderCompanyPI=PatList(15)
		set ApplicationUnit=PatList(16) 
		set ApplyContact=PatList(17)
		set ApplyContactTel=PatList(18)
		set CROCompany=PatList(19)
		s CROContact=PatList(20)
		s CROContactTel=PatList(21)
		s CollectCompany=PatList(22)
		s CountUnitContact=PatList(23)
		s CountUnitContactTel=PatList(24)
		s DesignCaseNum=PatList(25)
		s LocalGroupPlanCaseNum=PatList(26)
		s LocalGroupFactCaseNum=PatList(27)
		set FirstFormConsentDate=PatList(28)
		s LastCaseDate=PatList(29)
		s FilterCaseNum=PatList(30)
		s RejectCaseNum=PatList(31)
		s DropCaseNum=PatList(32)
		s SAECaseNum=PatList(33)
		s BriefDate=PatList(34)
		s SumDate=PatList(35)
		s FilingDate=PatList(36)
		s SaveLastDate=PatList(37)
		s GroupTransferUser=PatList(38)
		s recipient=PatList(39)
		s DrugExamCheckFlag=PatList(40)
		s DrugExamCheckDate=PatList(41)
		s EthicsFilesOffStatus=PatList(42)
		s EthicsFilesOffDate=PatList(43)
		s EthicsFilesOffOperator=PatList(44)
		s EthicsFilesOffCompany=PatList(45)
		s EthicsFilesOffTel=PatList(46)
		s ImageDataLocation=PatList(47)
		s ImageDataNum=PatList(48)
		s CheckPerson=PatList(49)
		s FirstPatDate=PatList(50)
		s InGroupNum=PatList(52)
		;s FilterCaseNum=PatList(53)
		s FileNum=PatList(54)
		s FormConsentNum=PatList(55)
		s CaseReportNum=PatList(56)
		s OrigRecordNum=PatList(57)
		s EthicsFilesNum=PatList(58)
		s TotalFileNum=PatList(59)
		i cou=ex {
		w !,TotalFileNum
		
		s EthicsFilesOffStatusDr=""
		s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s Rowid=CTDefineRowId_"||"_ChildSub
	...s Desc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...i (((EthicsFilesOffStatus[Desc)||(Desc[EthicsFilesOffStatus))&&(EthicsFilesOffStatus'="")&&(Define="档案销毁状态")) s EthicsFilesOffStatusDr=Rowid
    s Err=""
   s FirstFormConsentDate1="",LastCaseDate1="",BriefDate1="",SumDate1="",FilingDate1="",DrugExamCheckDate1="",EthicsFilesOffDate1=""
		s rowid="0"
		s Findrowid=""
		f  s rowid=$o(^DHCDocPP(rowid)) q:((rowid="")||(Findrowid'=""))  d
		.s ProCode1=$p($g(^DHCDocPP(rowid)),"^",1)
		.s ProDesc1=$P(^DHCDocPP(rowid),"^",2)
		.s PlanNo1=$p($g(^DHCDocPP(rowid)),"^",26)
		.s PlanName1=$p($g(^DHCDocPP(rowid)),"^",27)
		.s ProStartUserDr=$p($g(^DHCDocPP(rowid)),"^",10)
		.s ApplyStage=""
		.s ApplyStageDrnow=$p($g(^DHCDocPP(rowid)),"^",24)
		.s:ApplyStageDrnow'="" ApplyStage=$p($g(^DHCDocCT("DefineData",+ApplyStageDrnow,"D",$p(ApplyStageDrnow,"||",2))),"^",2)
		.S ProStartUser=""
		.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
		.s child=0
		.f  s child=$o(^DHCDocPPD(rowid,child)) q:child=""  d
		..s User=""
		..s UserDr=$p($g(^DHCDocPPD(rowid,child)),"^",2)
		..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		..s:User'="" ProStartUser=ProStartUser_","_User
		.i ((PlanNo=PlanNo1)&&(PlanNo'="无")&&(PlanNo'="")&&(PlanNo'="/")&&(PlanNo'=" ")) s Findrowid=rowid
		.q:((PlanNo=PlanNo1)&&(PlanNo'="无")&&(PlanNo'="")&&(PlanNo'="/")&&(PlanNo'=" "))
        .i (((ProDesc1[PPDesc)||(PPDesc[ProDesc1))&&(ProStartUser[PPStartUser)&&(PPStartUser'="")&&(PilotCategory[ApplyStage)) s Findrowid=rowid
        ;i Findrowid="" s ^TMPInportdangan("N",cou)=cou_"^"_PPDesc
        ;e  s ^TMPInportdangan("Y",cou)=cou_"^"_PPDesc_"^"_Findrowid_"^"_ProDesc1
        s Findrowid=ro
        s cc=$P(^DHCDocPP(Findrowid),"^",2)
        w !,cc
        w !,PPDesc
        b
        s Err=""
      i $l(FirstFormConsentDate,"/")=3  s FirstFormConsentDate1=$zdh($p(FirstFormConsentDate,"/",3)_"/"_$p(FirstFormConsentDate,"/",2)_"/"_$p(FirstFormConsentDate,"/",1),4)
   		i (($l(FirstFormConsentDate,"/")'=3)&&(FirstFormConsentDate'="")) d
	   	 .s Err=Err_"^"_"第一例知情同意书日期:"_FirstFormConsentDate
	   
      i $l(LastCaseDate,"/")=3  s LastCaseDate1=$zdh($p(LastCaseDate,"/",3)_"/"_$p(LastCaseDate,"/",2)_"/"_$p(LastCaseDate,"/",1),4)
   		i (($l(LastCaseDate,"/")'=3)&&(LastCaseDate'="")) d
	   	 .s Err=Err_"^"_"最后一例出组日期"_LastCaseDate
	   	 
	   	 i $l(BriefDate,"/")=3  s BriefDate1=$zdh($p(BriefDate,"/",3)_"/"_$p(BriefDate,"/",2)_"/"_$p(BriefDate,"/",1),4)
   		i (($l(BriefDate,"/")'=3)&&(BriefDate'="")) d
	   	 .s Err=Err_"^"_"小结日期"_BriefDate
	   	 
	   	 i $l(SumDate,"/")=3  s SumDate1=$zdh($p(SumDate,"/",3)_"/"_$p(SumDate,"/",2)_"/"_$p(SumDate,"/",1),4)
   		i (($l(SumDate,"/")'=3)&&(SumDate'="")) d
	   	 .s Err=Err_"^"_"总结日期"_SumDate
	   	 
	   	  i $l(FilingDate,"/")=3  s FilingDate1=$zdh($p(FilingDate,"/",3)_"/"_$p(FilingDate,"/",2)_"/"_$p(FilingDate,"/",1),4)
   		i (($l(FilingDate,"/")'=3)&&(FilingDate'="")) d
	   	 .s Err=Err_"^"_"总结日期"_FilingDate
	   	 
	   	  i $l(DrugExamCheckDate,"/")=3  s DrugExamCheckDate1=$zdh($p(DrugExamCheckDate,"/",3)_"/"_$p(DrugExamCheckDate,"/",2)_"/"_$p(DrugExamCheckDate,"/",1),4)
   		i (($l(DrugExamCheckDate,"/")'=3)&&(DrugExamCheckDate'="")) d
	   	 .s Err=Err_"^"_"现场核查日期"_DrugExamCheckDate
	   	 
	   	  i $l(EthicsFilesOffDate,"/")=3  s EthicsFilesOffDate1=$zdh($p(EthicsFilesOffDate,"/",3)_"/"_$p(EthicsFilesOffDate,"/",2)_"/"_$p(EthicsFilesOffDate,"/",1),4)
   		i (($l(EthicsFilesOffDate,"/")'=3)&&(EthicsFilesOffDate'="")) d
	   	 .s Err=Err_"^"_"现场核查日期"_EthicsFilesOffDate
	   	 i Findrowid'=""{
	   	 ;s ^TMPInportdanganErr(Findrowid)=Err
		s UObj=##class(User.DHCDocPilotProject).%OpenId(Findrowid)
		s UObj.EndYear=+EndYear
		s UObj.DeptCode=DeptCode
		s UObj.ProjectNo= ProjectNo
		s UObj.FileCaseNo=FileCaseNo
		i UObj.LeaderCompany="" s UObj.LeaderCompany=LeaderCompany   
		i UObj.LeaderCompanyPI="" s UObj.LeaderCompanyPI=LeaderCompanyPI
		i UObj.ApplyContact="" s UObj.ApplyContact=ApplyContact
		i UObj.ApplyContactTel="" s UObj.ApplyContactTel=ApplyContactTel
		i UObj.CROCompany="" s UObj.CROCompany=CROCompany
		i UObj.CROContact="" s UObj.CROContact=CROContact
		i UObj.CROContactTel="" s UObj.CROContactTel=CROContactTel
		s UObj.CollectCompany=CollectCompany
		s UObj.CountUnitContact=CountUnitContact
		s UObj.CountUnitContactTel=CountUnitContactTel
		s UObj.DesignCaseNum=DesignCaseNum
		s UObj.LocalGroupPlanCaseNum=LocalGroupPlanCaseNum
		s UObj.LocalGroupFactCaseNum=LocalGroupFactCaseNum
		s:UObj.FirstFormConsentDate="" UObj.FirstFormConsentDate=FirstFormConsentDate1
		s UObj.LastCaseDate=LastCaseDate1
		s UObj.FilterCaseNum=FilterCaseNum
		s UObj.RejectCaseNum=RejectCaseNum
		s UObj.DropCaseNum=DropCaseNum
		s UObj.SAECaseNum=SAECaseNum
		s UObj.BriefDate=BriefDate1
		s:UObj.PPEndDate="" UObj.PPEndDate=BriefDate1
		s UObj.SumDate=SumDate1
		s UObj.FilingDate=FilingDate1
		s UObj.SaveLastDate=SaveLastDate
		s UObj.GroupTransferUser=GroupTransferUser
		s UObj.recipient=recipient
		s UObj.DrugExamCheckFlag=DrugExamCheckFlag
		s UObj.DrugExamCheckDate=DrugExamCheckDate1
		s UObj.EthicsFilesOffDate=EthicsFilesOffDate1
		s UObj.EthicsFilesOffOperator=EthicsFilesOffOperator
		s UObj.EthicsFilesOffCompany=EthicsFilesOffCompany
		s UObj.EthicsFilesOffTel=EthicsFilesOffTel
		s UObj.ImageDataLocation=ImageDataLocation
		s UObj.ImageDataNum=ImageDataNum
		s UObj.CheckPerson=CheckPerson
		;s FirstPatDate=PatList(50)
		s UObj.InGroupNum=InGroupNum
		s UObj.FilterCaseNum=FilterCaseNum
		s UObj.FileNum=FileNum
		s UObj.FormConsentNum=FormConsentNum
		s UObj.CaseReportNum=CaseReportNum
		s UObj.OrigRecordNum=OrigRecordNum
		s UObj.EthicsFilesNum=EthicsFilesNum
		s UObj.TotalFileNum=TotalFileNum
	
		d UObj.EthicsFilesOffStatusDrSetObjectId(EthicsFilesOffStatusDr)
		
		Set sc = UObj.%Save()
		
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
		b
	}
	
	d UObj.%Close()
	   	 }
		}
		
	}
	
	w !,"导入完成!"
	w myrtn
	if +myrtn=0{
	TC
	}else{
		TRO
	}
}

ClassMethod UpdateEthicsMeetAduitDate(PPRowId As %String, EMADate As %String) As %String
{
	//s ^zzy(10)=PPRowId_"^"_EMADate
	q:PPRowId="" "-1"
	q:EMADate="" "-1"
	s EMADate=$zdh(EMADate,4)
	
	&sql(Update  DHC_DocPilotProject set PP_EthicsMeetAduitDate=:EMADate where PP_RowId=:PPRowId)
		
		s myrtn=SQLCODE
		q myrtn
}

ClassMethod DeletePay(PPRRowId As %String) As %String
{
	i PPRRowId="" q "-1"
	&sql(Delete from DHC_DocPilotProRem where  PPR_RowId=:PPRRowId)
	s myrtn=SQLCODE
	q myrtn
}

ClassMethod FindProjectForPayClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProjectForPayExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindProjectForPayExecute(ByRef QHandle As %Binary, PilotCategoryRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProjectForPay","zl")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ProRowId=0 f  s ProRowId=$o(^DHCDocPP(ProRowId)) q:ProRowId=""  d
	.s TProDesc=$P(^DHCDocPP(ProRowId),"^",2)
	.s ProCode=$p($g(^DHCDocPP(ProRowId)),"^",1)
	.S TProCreateDepartment=""
	.s ProCreateDepartmenDr=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.if ProCreateDepartmenDr'="" s TProCreateDepartment=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(ProCreateDepartmenDr),"^",2)) //$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	.//i TProCreateDepartment="临床药理实验室" s TProCreateDepartment="I期临床试验研究室"
	.//i TProCreateDepartment["免疫" s TProCreateDepartment="风湿免疫科"
	.s ProStartUserDr=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.S TProStartUser=""
	.if ProStartUserDr'="" s TProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	.s ProState=""
	.s State=$p($g(^DHCDocPP(ProRowId)),"^",16)
	.q:State'="E" 
	.s TApplicationUnit=$p($g(^DHCDocPP(ProRowId)),"^",25)
	
	.Do OutputRow14
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow14
	set Data=$lb(ProRowId,TProDesc,TProCreateDepartment,TProStartUser,TApplicationUnit,ProCreateDepartmenDr,ProStartUserDr)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindProjectForPayFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProjectForPayExecute ]
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

Query FindProjectForPay(PilotCategoryRowId As %String) As %Query(ROWSPEC = "ProRowId,TProDesc,TProCreateDepartment,TProStartUser,TApplicationUnit:%String,ProCreateDepartmenDr,ProStartUserDr") [ SqlProc ]
{
}

Query FindProjectDoc(PPDesc As %String = "", InHosp = "") As %Query(ROWSPEC = "RecordSum:%Integer,PPRowId,ProCode,ProDesc,ProCreateDepartmen,ProStartUser,ProBudget,ProState,CheckFreq,InRemNum,Balance,Account,ProCreateDate") [ SqlProc ]
{
}

ClassMethod FindProjectDocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindProjectDocExecute(ByRef QHandle As %Binary, PPDesc As %String, InHosp = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProjectDoc","")
	Set repid=$I(^CacheTemp)
	s langid=..%LanguageID()
	s ind=1
	s count=1
	s UserID=%session.Get("LOGON.USERID")
	;s UserID=4175
	s PPRowId=0 f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
    .s flag=0
    .s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
    .S ProStartUser=""
    .s ProCreateDate=$p($g(^DHCDocPP(PPRowId)),"^",8)
    .s ProCreateDate=..%ZD(ProCreateDate)
	.if ProStartUserDr'="" d
	..s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
    ..s ProStartUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ProStartUser,langid)
    
	.s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
    .i ((UserID=ProStartUserDr)||(UserID=UserUserDr)) s flag=1
    .i flag'=1 d
    ..s chi=""
    ..f  s chi=$o(^DHCDocPPD(PPRowId,chi)) q:chi=""  d
	...s ProStartUserDr=""
	...s UserUserDr=""
	...s ProStartUserDr=$p($g(^DHCDocPPD(PPRowId,chi)),"^",2)
	...s UserUserDr=$p($g(^DHCDocPPD(PPRowId,chi)),"^",3)
	...i ((UserID=ProStartUserDr)||(UserID=UserUserDr))  s flag=1
	.i flag'=1 d
	..s sub=0
	..f  s sub=$o(^DHCDocPPC(PPRowId,sub)) q:sub=""  d
	...s PPCJoinUserDr=$p($g(^DHCDocPPC(PPRowId,sub)),"^",1)
	...if UserID=PPCJoinUserDr d
	....s flag=1
	.q:flag'=1 
	.s AllDepStr=""
	.s ProDesc=$P(^DHCDocPP(PPRowId),"^",2)
	.s ProDesc= ##class(User.DHCDocPilotProject).GetTranByDesc("PPDesc",ProDesc,langid)
	.s ProCode=$p($g(^DHCDocPP(PPRowId)),"^",1)
	.s ProStartDate=$p($g(^DHCDocPP(PPRowId)),"^",11)
	.if ProStartDate'="" s ProStartDate=$zd(ProStartDate,4)
	.s ProEndDate=$p($g(^DHCDocPP(PPRowId)),"^",13)
	.if ProEndDate'="" s ProEndDate=$zd(ProEndDate,4)
	.S ProCreateDepartmen=""
	.s ProCreateDepartmenDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	.s Hosp=$P($g(^CTLOC(ProCreateDepartmenDr)),"^",22)
	.q:(InHosp'="")&&(InHosp'=Hosp)
	.if ProCreateDepartmenDr'="" d
	..i AllDepStr="" s AllDepStr=ProCreateDepartmenDr
	..e  s AllDepStr=AllDepStr_","_ProCreateDepartmenDr
	..s ProCreateDepartmen=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(ProCreateDepartmenDr),"^",2)) //$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	..s ProCreateDepartmen= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ProCreateDepartmen,langid)
	.s ProBudget=$p($g(^DHCDocPP(PPRowId)),"^",15)
	.s ProBudget=$j(ProBudget,3,2)
	.s ProState=""
	.s State=$p($g(^DHCDocPP(PPRowId)),"^",16)
	.s ProState=##class(web.PilotProject.Extend.E1).GetProjectDesc(State)
	.s ProState= ##class(User.DHCDocPilotProject).GetTranByDesc("PPState",ProState,langid)
	.s PlanNonow=$p($g(^DHCDocPP(PPRowId)),"^",26)
	.s PlanNamenow=$p($g(^DHCDocPP(PPRowId)),"^",27)
	.s ApplicationUnitnow=$p($g(^DHCDocPP(PPRowId)),"^",25)
	.s PilotCategoryDrnow=$p($g(^DHCDocPP(PPRowId)),"^",18)
	.s ApplyMatterDrnow=$p($g(^DHCDocPP(PPRowId)),"^",23)
	.s ApplyStageDrnow=$p($g(^DHCDocPP(PPRowId)),"^",24)
	.s Indicationnow=$p($g(^DHCDocPP(PPRowId)),"^",17)
	.s child=0
	.;s AllDepStr=""
	.f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	..s User=""
	..s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	..s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	..s Dep=""
	..i DepDr'="" d 
	...q:##class(DHCAnt.KSS.Common.Method).InArray(AllDepStr,DepDr)=1
	...s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) // //$p($P(^CTLOC(DepDr),"^",2),"-",2)
	...s Dep= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Dep,langid)
	...i AllDepStr="" s AllDepStr=DepDr
	...e  s AllDepStr=AllDepStr_","_DepDr
	...s ProCreateDepartmen=ProCreateDepartmen_","_Dep
	..i UserDr'="" d
	...s User=$p(^SSU("SSUSR",UserDr),"^",2)
	...s User= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",User,langid)
	..s:User'="" ProStartUser=ProStartUser_","_User
	..;s:Dep'="" ProCreateDepartmen=ProCreateDepartmen_","_Dep
	.s CheckFreq=""
	.s CheckFreqDr=$p($g(^DHCDocPP(PPRowId)),"^",95)
	.s:CheckFreqDr'="" CheckFreq=$p($g(^DHCDocCT("DefineData",+CheckFreqDr,"D",$p(CheckFreqDr,"||",2))),"^",2)
	.s Balance=$j(..FormateSum(..GetPilotBalance(PPRowId,UserID)),6,2)
	.s InRemNum=$j(..FormateSum(..GetRemNum(PPRowId,UserID)),6,2)
	.s Account=..FormateSum(..GetAccountByUser(PPRowId,UserID))
	.Do OutputRowPro1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPro1
	set Data=$lb(0,PPRowId,ProCode,ProDesc,ProCreateDepartmen,ProStartUser,ProBudget,ProState,CheckFreq,InRemNum,Balance,Account,ProCreateDate)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FormateSum(Sum) As %String
{
	Q:Sum="" ""
	if (Sum["-") {
		s Sum1=$p(Sum,"-",2)
		i Sum1["." {
			s Sum2=$p(Sum1,".",1) 
			if Sum2="" s Sum="-0"_Sum1
		}
	}
	if (Sum[".") {
		s Sum2=$p(Sum,".",1)
		if Sum2="" s Sum="0"_Sum
	}
	Q Sum
}

ClassMethod FindProjectDocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProjectDocExecute ]
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
	 s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
	s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##class(web.PilotProject.DHCDocPilotProject).InsertDHCDocPilotProCareAuto()

ClassMethod InsertDHCDocPilotProCareAuto()
{
	s PPRowId=0 f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
	.s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.s SamePPCRowId=..FindSameUser(PPRowId,ProStartUserDr)
	.i SamePPCRowId="" d ..InsertProjectCare("",PPRowId,ProStartUserDr,"",ProStartUserDr)
	.s child=0
	.f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	..s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	..s SamePPCRowId=..FindSameUser(PPRowId,UserDr)
	..i SamePPCRowId="" d ..InsertProjectCare("",PPRowId,UserDr,"",UserDr)
}

/// creator:guorongyong
/// date:2013-12-16
/// desc:判断添加的参与者中必须有一个联系人
/// input:科研项目的RowId
/// output:0 不存在,1 存在
ClassMethod CheckIsExistContact(PPRowId As %String, SeledUserListStr As %String, ContactFlag As %String) As %String
{
	/*s Rtn=0
	Q:PPRowId="" Rtn
	s PPCRowId=0
	s JoinUserDr=""
	for {
		s PPCRowId=$o(^DHCDocPPC(PPRowId,PPCRowId)) Q:PPCRowId=""
		s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
		s ContactFlag=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",10)
		i ContactFlag="Y" s Rtn=1 quit
	}
	Q Rtn_"^"_JoinUserDr*/
	s SeledUserListStr=$replace(SeledUserListStr,$c(1),"^")
	s SeledUserListStr="^"_SeledUserListStr_"^"
	s Rtn=0
	Q:PPRowId="" Rtn
	s tmpJoinUserDr=""
	s PPCRowId=0
	f  s PPCRowId=$o(^DHCDocPPC(PPRowId,PPCRowId)) Q:PPCRowId=""  d
	.s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
	.s ContactFlag=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",10)
	.i (ContactFlag="Y")&&(SeledUserListStr'[("^"_JoinUserDr_"^")) d
	..s Rtn=1
	..i tmpJoinUserDr="" s tmpJoinUserDr=JoinUserDr
	..e  s tmpJoinUserDr=tmpJoinUserDr_"^"_JoinUserDr
	if (Rtn=0){
		if (ContactFlag="Y") s tmpJoinUserDr=SeledUserListStr
	}
	Q Rtn_"$"_tmpJoinUserDr
}

// 根据项目rowid，以及小组成员UserId得到，该组花费的费用。如果UserId，得到该项目所花费所用费用

// w ##class(web.PilotProject.DHCDocPilotProject).GetMoneySpeed(949)

ClassMethod GetMoneySpeed(PPRowId As %String, UserId As %String)
{
	q:PPRowId="" 0
	s PPPRowId=""
	s Total=0
	s Acc=""
	s:UserId="" Acc=##class(web.PilotProject.DHCDocPilotProCommon).GetAccount(PPRowId,UserId)
	s PPPARowId="",FindAdmID=""
	f  s PPPRowId=$O(^DHCDocPPPA(PPRowId,PPPRowId)) q:PPPRowId=""  d
	.s PPPARowId=0
	.f  s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)) q:PPPARowId=""  d
	..s PAAdmRowId=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
	..q:PAAdmRowId=""
	..s CFEntryOrdBillPad=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("EntryOrdBillPad")
	..i CFEntryOrdBillPad=1 s pay=..IGetPilotFee("",PAAdmRowId,Acc,"^^^^^")
	..e  s pay=##class(web.DHCBillInterface).IGetPilotFee("", PAAdmRowId, "^^^^^")
	..s Total=Total+pay
	q Total
}

// 药理 下医嘱直接计费模式下，获取指定科研项目的花费金额

ClassMethod IGetPilotFee(PilotDR, EpisodeID, Acc, ExpStr) As %String
{
	Q:EpisodeID="" 0
	s OEORDRowId=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:OEORDRowId="" 0
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s EpissubtypeId=$P($g(^PAADM(EpisodeID,1)),"^",6)
	s AdmReasonId=$P($g(^PAADM(EpisodeID,1)),"^",7)
	Set FeeSum=0
	Set Type=$p($g(^PAADM(EpisodeID)),"^",2)
	if (Type'="I"){
		s OEORIChildsub=0
		f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
		.Set OrdPliotDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DHC")),"^",10)  ;存科研项目的指针
		.Q:OrdPliotDR=""
		.Q:(PilotDR'="")&(OrdPliotDR'=PilotDR)
		.s ItemStatDR=$P(^OEORD(+OEORDRowId,"I",OEORIChildsub,1),"^",13) ;OEORI_ItemStat_DR
	    .s ItmStat=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	    .Q:(ItmStat'="V")&&(ItmStat'="E")
		.s ordstr1=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,1))
		.s ordstr3=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,3))
		.s ordstr9=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,9))
		.s OrderPackQty=$p(ordstr9,"^",4)
		.s ArcimId=$p(ordstr1,"^",2)
		.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
		.s arctype=$p(^ARC("IC",arctpdr),"^",7)
		.;非药品
		.i arctype'="R" d
		..s DoseqtySum=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",12)
		..s OrderPackQty=DoseqtySum
		.s ReLocID=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
		.s OEORIPrice=$p(ordstr3,"^",25)
		.s ProtocolPackUOMDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DHC")),"^",13)
		.i OrderPackQty'="" d
		..i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
		..;包含基础单位和整包装代为的价格转换
		..s ExpStr=OEORDRowId_"||"_OEORIChildsub_"^^"_EpisodeID_"^"_ReLocID 
		..s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
		.else  d
		..;只是基本单位的价格
		..s ExpStr=PAADMRegConDisDR_"^"_OEORDRowId_"||"_OEORIChildsub_"^^"_EpisodeID_"^"_ReLocID
		..s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",ExpStr)
		.s ArcPrice=$j($p(ArcPrice,"^",1),3,4)
		.s OrderSum=OrderPackQty*ArcPrice
		.s convFac=##class(appcom.OEDispensing).convFac(ArcimId,ProtocolPackUOMDR)
	    .i (arctype'="R")&&(+convFac'=0) s OrderSum=OrderSum/convFac
		.s FeeSum=FeeSum+OrderSum
	}else{
		s OEORIChildsub=0
		f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
		.Set OrdPliotDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DHC")),"^",10)  ;存科研项目的指针
		.Q:OrdPliotDR=""
		.Q:(PilotDR'="")&(OrdPliotDR'=PilotDR)
		.s ItemStatDR=$P(^OEORD(+OEORDRowId,"I",OEORIChildsub,1),"^",13) ;OEORI_ItemStat_DR
	    .s ItmStat=$p(^OEC("OSTAT",ItemStatDR),"^",1)	
	    .Q:(ItmStat="C")||(ItmStat'="U")
		.s ordstr1=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,1))
		.s ordstr3=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,3))
		.s ordstr9=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,9))
		.s OrderPackQty=$p(ordstr9,"^",4)
		.s ArcimId=$p(ordstr1,"^",2)
		.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
		.s arctype=$p(^ARC("IC",arctpdr),"^",7)
		.;非药品
		.i arctype'="R" d
		..s DoseqtySum=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",12)
		..s OrderPackQty=DoseqtySum
		.s ReLocID=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
		.s OEORIPrice=$p(ordstr3,"^",25)
		.s ProtocolPackUOMDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DHC")),"^",13)
		.i OrderPackQty'="" d
		..i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
		..;包含基础单位和整包装代为的价格转换
		..s ExpStr=OEORDRowId_"||"_OEORIChildsub_"^^"_EpisodeID_"^"_ReLocID 
		..s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
		.else  d
		..;只是基本单位的价格
		..s ExpStr=PAADMRegConDisDR_"^"_OEORDRowId_"||"_OEORIChildsub_"^^"_EpisodeID_"^"_ReLocID
		..s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",ExpStr)
		.s ArcPrice=$j($p(ArcPrice,"^",1),3,4)
		.s INCIrow=##class(appcom.OEDispensing).GetINCI(+ArcimId)
		.s Pqty=0
		.i INCIrow'="" d
		..s oeori=OEORDRowId_"||"_OEORIChildsub
		..s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
		..q:dis=""
		..q:'$d(^DHCOEDISQTY(dis))
		..s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		..Q:dstatus="R"
		..s Pqty=Pqty+$p(^DHCOEDISQTY(dis),"^",2)
		.e  d
		..s OEOREChildsub=0
		..f  s OEOREChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub)) q:OEOREChildsub=""  d
		...s OEOREOrderStatusCode=""
		...s OEOREOrderStatusDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub),"^",16)
		...i OEOREOrderStatusDR'="" s OEOREOrderStatusCode=$p(^OEC("STAT",OEOREOrderStatusDR),"^",1)
		...Q:(OEOREOrderStatusCode="D")||(OEOREOrderStatusCode="R")
		...s OEOREPhQtyOrd=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub),"^",4)
		...s Pqty=Pqty+OEOREPhQtyOrd
		.s OrderSum=ArcPrice*Pqty
		.s convFac=##class(appcom.OEDispensing).convFac(ArcimId,ProtocolPackUOMDR)
	    .i (arctype'="R")&&(+convFac'=0) s OrderSum=OrderSum/convFac
		.s FeeSum=FeeSum+OrderSum
	}
	Q FeeSum
}

// 判断是否超过科研费用限制

// w ##class(web.PilotProject.DHCDocPilotProject).GetRemNum(949,"")

ClassMethod CheckPilotSum(Sum As %String, PPRowId As %String, UserId As %String) As %String
{
	s qflag=0
	q:PPRowId="" -1
	s Message=""
	i Sum="" s Sum=0
	s Speed=..GetMoneySpeed(PPRowId,UserId)
	s AllSpeed=..GetMoneySpeed(PPRowId,UserId)
	s AccountNo=##class(web.PilotProject.DHCDocPilotProCommon).GetAccount(PPRowId,UserId)
	q:AccountNo="V000002" 0
	s PPBudget=$p($g(^DHCDocPP(PPRowId)),"^",15)
	i ((PPBudget="")||(PPBudget=0))  q "-1"_"^"_"预算金额为空"
	i qflag="-1" q qflag_"^"_Message
	i AllSpeed+Sum>PPBudget q "-1"_"^"_"所花费金额("_(AllSpeed+Sum)_"元)超出预算("_PPBudget_"元)"
	s RemNum=..GetRemNum(PPRowId,UserId)
	i AllSpeed+Sum>RemNum q "-1"_"^"_"所花费金额("_(AllSpeed+Sum)_"元)超出汇款金额("_PPBudget_"元)"
	
	q qflag
}

// 计算汇款金额

// w ##class(web.PilotProject.DHCDocPilotProject).GetRemNum(949,"")

ClassMethod GetRemNum(PPRowId As %String, UserId As %String)
{
	s child=0
	s UID=""
	s simp=0
	s paysum=0
	s AccSum=0
	s UserDr=""
	f  s child=$o(^DHCDocPPC(PPRowId,child)) q:child=""  d
	.s PPCJoinUserDr=$p($g(^DHCDocPPC(PPRowId,child)),"^",1)
	.;w !,PPCJoinUserDr
	.s PPUesr=$p($g(^DHCDocPPC(PPRowId,child)),"^",12)
	.if UserId=PPCJoinUserDr d
	..s UserDr=PPUesr
	i UserDr="" s UserDr=UserId
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	s AccountSum1=$p($g(^DHCDocPP(PPRowId)),"^",110)
	i AccountSum1="" s AccountSum1=0
	i UserDr="" s AccSum=AccSum+AccountSum1
	else  if ((UserDr=ProStartUserDr)||(UserDr=UserUserDr))  d
	.s UID=ProStartUserDr
	.s AccSum=AccSum+AccountSum1
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s simp=1
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s AccountSum2=$p($g(^DHCDocPPD(PPRowId,child)),"^",5)
	.i AccountSum1="" s AccountSum1=0
	.i UserDr="" s AccSum=AccSum+AccountSum2
	.e  i ((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1))  d
	.s UID=ProStartUserDr1
	.s AccSum=AccSum+AccountSum2
	s childsub=0
	f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	.s PPRRemAmount=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",1)
	.s PPRRemitter=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",3)
	.s PPRRemUserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",2)
	.s PPRState=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",9)
	.q:PPRState'="V" 
	.s PPRTypeDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	.;s Account=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",10)
	.s User=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	.i simp=0 s paysum=paysum+PPRRemAmount
	.e  d
	..i UID=UserId
	..s paysum=paysum+PPRRemAmount
	i paysum=0 s paysum=AccSum
	q paysum
}

// 得到项目立项科室以及PI

// w ##class(web.PilotProject.DHCDocPilotProject).GetPPDepartAndUser(1)

ClassMethod GetPPDepartAndUser(PPRowId As %String) As %String
{
	q:PPRowId="" ""
	s Departs=""
	s Users=""
	S ProCreateDepartmen="",ProStartUser=""
	s ProCreateDepartmenDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	if ProCreateDepartmenDr'="" s ProCreateDepartmen=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(ProCreateDepartmenDr),"^",2)) //$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	//i ProCreateDepartmen="临床药理实验室" s ProCreateDepartmen="I期临床试验研究室"
	//i ProCreateDepartmen["免疫" s ProCreateDepartmen="风湿免疫科"
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	s Departs=ProCreateDepartmen
	s Users=ProStartUser
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s User=""
	.s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	.s:User'="" Users=Users_","_User
	.s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	.s Dep=""
	.if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
	.//if Dep="感染内科" s Dep="感染科"
	.//if Dep["免疫" s Dep="风湿免疫科"
	.s:Dep'="" Departs=Departs_","_Dep
	q Departs_"^"_Users
}

ClassMethod GetPilotBalance(PPRowId As %String, UserId As %String) As %String
{
	s AllSpeed=..GetMoneySpeed(PPRowId,UserId)
	s RemNum=..GetRemNum(PPRowId,UserId)
	q RemNum-AllSpeed
}

// 得到余额提醒

// w ##class(web.PilotProject.DHCDocPilotProject).GetWarnSum(1,"")

ClassMethod GetWarnSum(PPRowId As %String, UserId As %String) As %String
{
	i PPRowId="" q ""
	s PPWarnSum=$p($g(^DHCDocPP(PPRowId)),"^",112)
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if (((UserId=ProStartUserDr)||(UserId=UserUserDr))&&(UserId'="")) q PPWarnSum
	if UserId="" q PPWarnSum
	s PPDWarnSum=""
	s more=0
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s more=1
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s PPDWarnSum1=$p($g(^DHCDocPPD(PPRowId,child)),"^",7)
	.i (((UserId=ProStartUserDr1)||(UserId=UserUserDr1))&&(UserId'=""))  s PPDWarnSum=PPDWarnSum1
	if more=0 q PPWarnSum
	q PPDWarnSum
}

ClassMethod AddPPWarnSum(PPRowId As %String, PPWarnSum As %String, UserDr As %String = "") As %String
{
	/*
	q:PPRowId="" ""
	&sql(update DHC_DocPilotProject set PP_Budget=:PPBudget where PP_RowId=:PPRowId) 
	q SQLCODE
	*/
	//s ^zzy("AddPPWarnSum")=PPRowId_"^"_PPWarnSum_"^"_UserDr
	s Ret=0
	;1.得到PilotProject表中的研究者/委托研究者,如果用户是空,默认为此研究者/委托研究者
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if ((UserDr=ProStartUserDr)||(UserDr=UserUserDr)||(UserDr="")) {
		s Ret=$$UpdatePPWarnSum(PPRowId,PPWarnSum)
		Q Ret
	}
	;2.得到PilotProjectDept子表中的研究者
	s child=""
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUser1=""
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s:ProStartUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",ProStartUserDr1),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s:UserUserDr1'="" ProStartUser1=$p(^SSU("SSUSR",UserUserDr1),"^",2)
	.s PPDRowId=PPRowId_"||"_child
	.i ((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1)) s Ret=$$UpdatePPDWarnSum(PPDRowId,PPWarnSum)
	q Ret
UpdatePPWarnSum(PPRowId,PPWarnSum)
    &SQL(Update SQLUser.DHC_DocPilotProject set PP_WarnSum=:PPWarnSum where PP_RowId=:PPRowId)
    Q SQLCODE
UpdatePPDWarnSum(PPDRowId,PPWarnSum)
    &SQL(Update SQLUser.DHC_DocPilotProDept set PPD_WarnSum=:PPWarnSum where PPD_RowId=:PPDRowId)
    Q SQLCODE
}

// w ##class(web.PilotProject.DHCDocPilotProject).ifWarning(6,600)

ClassMethod ifWarning(PPRowId, UserDr) As %String
{
	s Warning=""
	if PPRowId=""  q Warning
	/*s ppcchild=""
	s PPCUserDr=""
	f  s ppcchild=$O(^DHCDocPPC("JoinUserDr",0,UserDr,PPRowId,ppcchild)) q:ppcchild=""  d
	.s PPCUserDr=$p($g(^DHCDocPPC(PPRowId,ppcchild)),"^",12)*/
	s langid=..%LanguageID()
	s PPCUserDr=UserDr
	s WarnSum=##class(web.PilotProject.DHCDocPilotProject).GetWarnSum(PPRowId,PPCUserDr)
    s PilotBalance=##class(web.PilotProject.DHCDocPilotProject).GetPilotBalance(PPRowId,PPCUserDr)
    
    i (WarnSum'="")&&(PilotBalance<WarnSum) s Warning=1
    s PPName=$p($g(^DHCDocPP(PPRowId)),"^",2)
    s PPName= ##class(User.DHCDocPilotProject).GetTranByDesc("PPDesc",PPName,langid)
    s CN1=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","临床试验项目")
    s CN2=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","余额")
    s CN3=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","不足")
    i Warning=1 q CN1_"："_PPName_" "_CN2_"("_PilotBalance_")"_CN3_"！"
    q ""
}

ClassMethod isNormalStatus(PatientID, PPRowId) As %String
{
	s PPPRowId=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowId,""))
	q:PPPRowId="" ""
	s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
	q VisitState
}

// 得到当年跟踪审查默认日期

// w ##class(web.PilotProject.DHCDocPilotProject).GetYearCheckDate("96||3")

ClassMethod GetYearCheckDate(PPYKRowId As %String) As %String
{
	n (PPYKRowId)
	s Date=""
	q:PPYKRowId="" ""
	s PPYKYear=$p($g(^DHCDocPPYK(+PPYKRowId,$p(PPYKRowId,"||",2))),"^",2)
	q:PPYKYear="" ""
	i $d(^DHCDocPilotConfig("YearCheckDate",PPYKYear)) d
	.i ^DHCDocPilotConfig("YearCheckDate",PPYKYear)'="" d
	..s Date=$zd(^DHCDocPilotConfig("YearCheckDate",PPYKYear),3)
	q Date
}

/// 按病人筛选号导出病人检验结果
/// w ##class(web.PilotProject.DHCDocPilotProject).ProExportLabByScreenNo(87,"00010001","00010001",153)
ClassMethod ProExportLabByScreenNo(PPRowId As %String, StartScreenNo As %String, EndScreenNo As %String, UserID As %String = "") As %String
{
	n (PPRowId,StartScreenNo,EndScreenNo,UserID)
	s ^TMPGRY("ProExportLabByScreenNo")=PPRowId_","_StartScreenNo_","_EndScreenNo_","_UserID
	Q:(PPRowId="")||(StartScreenNo="") 0
	;if UserID="" s UserID=%session.Get("LOGON.USERID")
	k ^TMPProExportLab(UserID)
	i EndScreenNo="" s EndScreenNo=StartScreenNo
	s Count=0
	s PPPRowId=0
	for {
		s PPPRowId=$O(^DHCDocPPP(PPRowId,PPPRowId)) Q:PPPRowId=""
		s PPPScreenNo=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",17)
		s CreateDate=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",6)
		continue:PPPScreenNo=""
		continue:(PPPScreenNo<StartScreenNo)
		continue:(PPPScreenNo>EndScreenNo)
		;得到检验医嘱结果
		s PPPARowId=0
		for {
			s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)) Q:PPPARowId=""
			s AdmId=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
			s Ord=$O(^OEORD(0,"Adm",AdmId,0))
			continue:Ord=""
			s Chl=0
			for {
				s Chl=$O(^OEORD(Ord,"I",Chl)) Q:Chl=""
				continue:$d(^TMPProExportLab(UserID,$j,"OrdItem",Ord_"||"_Chl))
				s data1=$g(^OEORD(Ord,"I",Chl,1))
				continue:data1=""
 				s data3=$g(^OEORD(Ord,"I",Chl,3))
 				s ArcimRowId=$p(data1,"^",2)
 				continue:+ArcimRowId=0
 				s ItemCatDR=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10)
 				s OrderType=$P($g(^ARC("IC",+ItemCatDR)),"^",7)
 				continue:OrderType'="L"
 				//d ##Class(%ResultSet).RunQuery("LabService.TSResult","GetResultByOrderId","19||11")
 				;s Rtn=##Class(web.DHCDocOrderCommon).GetTestSetDRInfos(Ord_"||"_Chl)
 				;Set rs=##Class(%ResultSet).%New("web.DHCLabResult:GetResultsByOrder")
 				Set rs=##Class(%ResultSet).%New("LabService.TSResult:GetResultByOrderId")
				If rs.QueryIsValid() {
					Set ^TMPProExportLab(UserID,$j,"OrdItem",Ord_"||"_Chl)=1
					Set Status=rs.Execute(Ord_"||"_Chl)
					If 'Status Quit
					Set columns = rs.GetColumnCount()
					While rs.Next() {
						s RowStr=""
						for i=1:1:columns {
							s ColValue=rs.GetData(i)
							i RowStr="" s RowStr=ColValue
							e  s RowStr=RowStr_"$"_ColValue
						}
						;s ^TMPProExportLab(UserID,$j,"OrdItem",PPRowId,PPPRowId,Count,Ord_"||"_Chl)=""
						s ^TMPProExportLab(Ord_"||"_Chl,UserID,$j,"Pro",PPRowId,PPPRowId,Count)=RowStr
		 				s PPCode=$p(^DHCDocPP(PPRowId),"^",1)
						s PPName=$p(^DHCDocPP(PPRowId),"^",2)
						s BloodDate=$p(RowStr,"^",13)
						i BloodDate'="" s BloodDate=$zdh(BloodDate,3)
						e  s BloodDate=..%SysDate()
						//s $p(^TMPProExportLab(UserID,$j,"Pro",PPRowId,PPPRowId,Count),"^",4)=PPName_","_PPPScreenNo
						//s $p(^TMPProExportLab(UserID,$j,"Pro",PPRowId,PPPRowId,Count),"^",12)="D"_(BloodDate-CreateDate)
		 				
		 				s Count=Count+1
					}
				}

			}
		}
	}
	b //00
	;按排序后输出
	s OEORIRowID=0,Count1=0
	for{
	   s OEORIRowID=$O(^TMPProExportLab(OEORIRowID)) q:(OEORIRowID="")
	   continue:'$d(^TMPProExportLab(OEORIRowID,UserID,$j,"Pro"))
	   s ARCIMRowID=$p(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),1),"^",2)
	   s ARCIMDesc=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",2)
	   s EpisodeID=$p(^OEORD(+OEORIRowID),"^",1)
	   s PAADMPAPMIDR=$p(^PAADM(EpisodeID),"^",1)
	   s PatNo=$p(^PAPER(PAADMPAPMIDR,"PAT",1),"^",1)
	   s PatName=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",1)
	   s Count1=Count1+1
	   s ^TMPProExportLab(UserID,$j,"Count",Count1)="患者:"_PatName_",登记号:"_PatNo_","_ARCIMDesc_"医嘱的检验结果:"
			s PPRowId=0
			for {
				s PPRowId=$O(^TMPProExportLab(OEORIRowID,UserID,$j,"Pro",PPRowId)) q:PPRowId=""
				s PPPRowId=0
				for {
					s PPPRowId=$O(^TMPProExportLab(OEORIRowID,UserID,$j,"Pro",PPRowId,PPPRowId)) Q:PPPRowId=""
					s Ind=""
					for {
						s Ind=$O(^TMPProExportLab(OEORIRowID,UserID,$j,"Pro",PPRowId,PPPRowId,Ind)) Q:Ind=""
						s Count1=Count1+1
						s ^TMPProExportLab(UserID,$j,"Count",Count1)=$g(^TMPProExportLab(OEORIRowID,UserID,$j,"Pro",PPRowId,PPPRowId,Ind))
					}
				}
			}
	}
	/*s PPRowId=0
	for {
		s PPRowId=$O(^TMPProExportLab(UserID,$j,"Pro",PPRowId)) q:PPRowId=""
		s PPPRowId=0
		for {
			s PPPRowId=$O(^TMPProExportLab(UserID,$j,"Pro",PPRowId,PPPRowId)) Q:PPPRowId=""
			s Ind=""
			for {
				s Ind=$O(^TMPProExportLab(UserID,$j,"Pro",PPRowId,PPPRowId,Ind)) Q:Ind=""
				s ^TMPProExportLab(UserID,$j,"Count",Ind)=$g(^TMPProExportLab(UserID,$j,"Pro",PPRowId,PPPRowId,Ind))
			}
		}
	}*/
	b //90
	
	Q (Count1)_"@"_$j
}

/// 按病人筛选号导出病人一条检验结果
ClassMethod ProExportLabOneItem(UserID As %String, Job As %String, Count As %String) As %String
{
	Q $g(^TMPProExportLab(UserID,Job,"Count",Count))
}

/// 按病人筛选号导出病人所有检验结果
/// w ##class(web.PilotProject.DHCDocPilotProject).ProExportLabItem(17331,3681)
ClassMethod ProExportLabItem(UserID As %String, Job As %String) As %String
{
	s ArrObj=##Class(DHCDoc.Util.ListData).%New()
	s index="",Count=0
	for {
		s index=$O(^TMPProExportLab(UserID,Job,"Count",index),1,Item)
		q:(index="")||(Count>100)
		continue:(Item="")
		s Count=Count+1
		s ItemObj=##Class(DHCDoc.Util.ArrayData).%New()
		d ItemObj.SetAt(Item,"Item")
		d ArrObj.Push(ItemObj)
		k ^TMPProExportLab(UserID,Job,"Count",index)
	}
	Q ArrObj.%ToJSON().Read()
}

/// 得到多PI信息
ClassMethod FindPIInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPIInfoExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPIInfoExecute(ByRef QHandle As %Binary, PPRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindPIInfo",2)
	Set repid=$I(^CacheTemp)
	s ind=1
	s PPCode="",PPDesc="",LocId="",UserId="",Loc="",User="",Account="",PPBudget="",PPDRowId=""
	s PPCode=$p($g(^DHCDocPP(PPRowId)),"^",1)
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
	s LocId=$p($g(^DHCDocPP(PPRowId)),"^",6)
	if LocId'="" s Loc=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(LocId),"^",2)) //$p($P(^CTLOC(LocId),"^",2),"-",2)
	s Loc=##class(web.PilotProject.DHCDocPilotProCommon).TransDeptName(Loc)
	s UserId=$p($g(^DHCDocPP(PPRowId)),"^",10)
	if UserId'="" s User=$p(^SSU("SSUSR",UserId),"^",2)
	s Account=$p($g(^DHCDocPP(PPRowId)),"^",50)
	i ((Account="")&&(LocId=810)) s Account="V000002"
	s PPBudget=$p($g(^DHCDocPP(PPRowId)),"^",15)
	;s PPBudget=$j(PPBudget,3,2)
	d OutputRow15
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s LocId="",UserId="",Loc="",User="",Account="",PPBudget="",PPDRowId=""
	.s UserId=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s LocId=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	.if LocId'="" s Loc=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(LocId),"^",2)) //$p($P(^CTLOC(LocId),"^",2),"-",2)
	.s:UserId'="" User=$p(^SSU("SSUSR",UserId),"^",2)
	.s Account=$p($g(^DHCDocPPD(PPRowId,child)),"^",4)
	.i ((Account="")&&(LocId=810)) s Account="V000002"
    .s PPBudget=$p($g(^DHCDocPPD(PPRowId,child)),"^",6)
    .;s PPBudget=$j(PPBudget,3,2)
    .s PPDRowId=PPRowId_"||"_child
    .d OutputRow15
	Set QHandle=$lb(0,repid,0) Quit $$$OK
OutputRow15
	set Data=$lb(PPRowId,PPCode,PPDesc,LocId,UserId,Loc,User,Account,PPBudget,PPDRowId)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindPIInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPIInfoExecute ]
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

Query FindPIInfo(PPRowId As %String) As %Query(ROWSPEC = "TPPRowId:%String,PPCode:%String,PPDesc:%String,LocId:%String,UserId:%String,Loc:%String,User:%String,Account:%String,PPBudget:%String,PPDRowId") [ SqlProc ]
{
}

ClassMethod UpdateProPIInfo(PPRowId As %String, PPDRowId As %String, PPBudget As %String)
{
	//s ^zzy("UpdateProPIInfo")=PPRowId_"^"_PPDRowId_"^"_PPBudget
	if (PPRowId="")  q:"-1"
	if PPDRowId'="" d
	.s Ret=$$UpdateAcountBudgetNew(PPDRowId,PPBudget)
	else  d
	.s Ret=$$UpdatePPBudgetNew(PPRowId,PPBudget)
	q Ret
UpdatePPBudgetNew(PPRowId,PPBudget)
    &SQL(Update SQLUser.DHC_DocPilotProject set PP_Budget=:PPBudget where PP_RowId=:PPRowId)
    Q SQLCODE
UpdateAcountBudgetNew(PPDRowId,PPBudget)
    &SQL(Update SQLUser.DHC_DocPilotProDept set PPD_AccountBudget=:PPBudget where PPD_RowId=:PPDRowId)
    Q SQLCODE
}

// 根据项目rowid以及主要研究者rowid 得到所属立项科室

ClassMethod GetDepartmentByUser(PPRowId, UserId)
{
	n (PPRowId,UserId)
	s PPCreateDepartment=""
	s PPCreateDepartment1=""
	s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	s:PPCreateDepartmentDr'="" PPCreateDepartment1=$p($g(^CTLOC(PPCreateDepartmentDr)),"^",2)
	s PPCreateDepartment1=##class(web.DHCOPAdmReg).LocDescFormate(PPCreateDepartment1) //$p($g(PPCreateDepartment1),"-",2)
	i ((UserId="")||(UserId=PPStartUserDr)) s PPCreateDepartment=PPCreateDepartment1
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s User=""
	.s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	.s Dep=""
	.if DepDr'="" s Dep=##class(web.DHCOPAdmReg).LocDescFormate($P(^CTLOC(DepDr),"^",2)) //$p($P(^CTLOC(DepDr),"^",2),"-",2)
	.s:UserId=UserDr PPCreateDepartment=Dep
	s PPCreateDepartment=##class(web.PilotProject.DHCDocPilotProCommon).TransDeptName(PPCreateDepartment)
	q PPCreateDepartment
}

ClassMethod GetSettleDeptAndUser(PPSetRowId)
{
	n (PPSetRowId)
	s PPDept=""
	s PPUser=""
	s PPRowId=+PPSetRowId
	s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s PPSETRems=$p(^DHCDocPPSET(+PPSetRowId,$p(PPSetRowId,"||",2)),"^",20)
	i PPSETRems="" d
	.s childsub=0
	.f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	..s RemUser=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	..s PPRType=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	..q:((PPRType="I")||(PPRType="B")||(PPRType="E"))
	..s PPUser=RemUser
	..i ((RemUser="")||(RemUser=PPStartUserDr)) s PPDept=PPCreateDepartmentDr
	..s child=0
	..if PPDept="" d
	...f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	....s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	....s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	....s:RemUser=UserDr PPDept=DepDr
	else  d
	.s PPSETRems="-"_PPSETRems_"-"
	.s childsub=0
	.f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	..s RemUser=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	..s PPRType=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	..;q:((PPRType="I")||(PPRType="B")||(PPRType="E"))
	..s PPUser=RemUser
	..i ((RemUser="")||(RemUser=PPStartUserDr)) s PPDept=PPCreateDepartmentDr
	..s child=0
	..if PPDept="" d
	...f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	....s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	....s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	....s:RemUser=UserDr PPDept=DepDr
	i PPDept="" s PPDept=PPCreateDepartmentDr
	i PPUser="" s PPUser=PPStartUserDr
	q PPDept_"^"_PPUser
}

ClassMethod GetPayDeptAndUser(PPRRowId)
{
	n (PPRRowId)
	s PPDept=""
	s PPUser=""
	s PPRowId=+PPRRowId
	s childsub=$p(PPRRowId,"||",2)
	s PPCreateDepartmentDr=$p($g(^DHCDocPP(PPRowId)),"^",6)
	s PPStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s RemUser=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	s PPRType=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	s PPUser=RemUser
	i ((RemUser="")||(RemUser=PPStartUserDr)) s PPDept=PPCreateDepartmentDr
	s child=0
	if PPDept="" d
	.f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	..s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	..s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	..s:RemUser=UserDr PPDept=DepDr
	i PPDept="" s PPDept=PPCreateDepartmentDr
	i PPUser="" s PPUser=PPStartUserDr
	q PPDept_"^"_PPUser
}

Query Finduse(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSUSR_Name:%String,SSUSR_RowId:%Integer,SSUSR_Initials:%String")
{
	select SSUSR_Name,SSUSR_RowId ,SSUSR_Initials from SS_User where 
	((SSUSR_Name like '%'||:Desc||'%') or (:Desc is null) or (SSUSR_Initials =:Desc) or (SSUSR_Initials like '%'||:Desc||'%'))
}

/// 保存药理项目免费医嘱 
/// w ##class(web.PilotProject.DHCDocPilotProject).SaveProFreeOrd(1,"1||8","<DHCDocPilotProFreeOrd><PPFEndDate></PPFEndDate><PPFEndTime></PPFEndTime><PPFItmMastDR>2551||1</PPFItmMastDR><PPFSttDate>13/11/2014</PPFSttDate><PPFSttTime></PPFSttTime><PPFFreeNum>2</PPFFreeNum></DHCDocPilotProFreeOrd>","")
ClassMethod SaveProFreeOrd(PPRowID As %String, PPFRowID As %String, ProFreeOrdInfo As %String, myExpStr As %String) As %String
{
	n (PPRowID,PPFRowID,ProFreeOrdInfo,myExpStr)
	s InUser = $p(myExpStr,"^",1)
	s InLoc = $p(myExpStr,"^",2)
	if (PPFRowID="") {
		s UObj=##class(User.DHCDocPilotProFreeOrd).%New(PPRowID)
		d UObj.PPFAddUserSetObjectId(InUser)
		d UObj.PPFAddLocSetObjectId(InLoc)
		s UObj.PPFAddDate=+$h
		s UObj.PPFAddTime=$p($h,",",2)
	} else {
		s UObj=##class(User.DHCDocPilotProFreeOrd).%OpenId(PPFRowID)
	}
	s myrtn=0,errDesc=""
	
	s myProObj=##class(web.PilotProject.PPA.DHCDocPilotProFreeOrd).%New()
	d myProObj.XMLNodeDeserialize(.myProObj, "DHCDocPilotProFreeOrd", ProFreeOrdInfo)
	if (myProObj.PPFSttDate'="") {
		s myProObj.PPFSttDate=..%ZDH(myProObj.PPFSttDate)
	}
	if (myProObj.PPFEndDate'="") {
		s myProObj.PPFEndDate=..%ZDH(myProObj.PPFEndDate)
	}
	if (myProObj.PPFSttTime[":") s myProObj.PPFSttTime=..%ZTH(myProObj.PPFSttTime)
	if (myProObj.PPFEndTime[":") s myProObj.PPFEndTime=..%ZTH(myProObj.PPFEndTime)
	if ((myProObj.PPFSttDate'="")&&(myProObj.PPFEndDate'="")) {
		Q:myProObj.PPFSttDate>myProObj.PPFEndDate -2
		if ((myProObj.PPFSttTime'="")&&(myProObj.PPFEndTime'="")) {
			Q:myProObj.PPFSttTime>myProObj.PPFEndTime -2
		}
	}
	
	s ItmMastDR=myProObj.PPFItmMastDR
	s StageDr=myProObj.PPFPrjStage
	s Flag=0
	if (PPFRowID=""){
		/*s PPFSub=0
		f   s PPFSub=$o(^DHCDocPPF(0,"ARCIM",ItmMastDR,PPRowID,PPFSub)) q:PPFSub=""  d
		.s EndDate=+$p(^DHCDocPPF(PPRowID,PPFSub),"^",3)
		.s EndTime=$p(^DHCDocPPF(PPRowID,PPFSub),"^",4)
		.q:(EndDate'=0)&&((EndDate<+$h)||((EndDate=..%SysDate())&&(EndTime<..%SysTime())))
		.s Flag=1*/
		i $d(^DHCDocPPF(0,"PrjStageArcim",PPRowID,StageDr,ItmMastDR)) s Flag=1
	} else {
		//
		
		s oldStage=UObj.PPFPrjStageGetObjectId()
		S oldArcim=UObj.PPFItmMastDRGetObjectId()
		//s ^QP("SS",1)=$LB(oldStage,oldArcim,StageDr,ItmMastDR)
		i (oldArcim=ItmMastDR)&&(oldStage=StageDr) {
			//	
		} else {
			i $d(^DHCDocPPF(0,"PrjStageArcim",PPRowID,StageDr,ItmMastDR)) s Flag=1	
		}
		
	}
	q:Flag=1 -1
	TS
	d UObj.PPFPPPParRefSetObjectId(PPRowID)
	s UObj.PPFSttDate=myProObj.PPFSttDate
	s UObj.PPFSttTime=myProObj.PPFSttTime
	s UObj.PPFEndDate=myProObj.PPFEndDate
	s UObj.PPFEndTime=myProObj.PPFEndTime
	d UObj.PPFItmMastDRSetObjectId(myProObj.PPFItmMastDR)
	d UObj.PPFPrjStageSetObjectId(myProObj.PPFPrjStage)
	s UObj.PPFFreeNum=myProObj.PPFFreeNum
	s UObj.PPFLimitEntryAfterNoFreeNum=myProObj.PPFLimitEntryAfterNoFreeNum
	Set sc = UObj.%Save()
	s PPSPPParRef=UObj.%Id()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	if +myrtn=0{
		s Input=PPSPPParRef_","_myProObj.PPFSttDate_","_myProObj.PPFSttTime_","_myProObj.PPFEndDate_","_myProObj.PPFEndTime_","_myProObj.PPFItmMastDR_","_myProObj.PPFFreeNum_","_myExpStr
		s myrtn=..InsertPilotFreeOrdSetLog(Input)
	}
    Q +myrtn
}

ClassMethod InsertPilotFreeOrdSetLog(Input As %String) As %String
{
	s PPFLPPParRef=$p(Input,",",1)
	s myrtn=0
	TS
	s Obj=##class(User.DHCDocPilotProFreeOrdLog).%New(PPFLPPParRef)
	s UserID=$p($p(Input,",",8),"^")
	d Obj.PPFLPPParRefSetObjectId(PPFLPPParRef)
	s Obj.PPFLSttDate=$p(Input,",",2)
	s Obj.PPFLSttTime=$p(Input,",",3)
	s Obj.PPFLEndDate=$p(Input,",",4)
	s Obj.PPFLEndTime=$p(Input,",",5)
	d Obj.PPFLItmMastDRSetObjectId($p(Input,",",6))
	s Obj.PPFLFreeNum=$p(Input,",",7)
	s Obj.PPFLUpDate=..%SysDate()
	s Obj.PPFLUpTime=..%SysTime()
	d Obj.PPFLUserDrSetObjectId(UserID)
	Set sc = Obj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d Obj.%Close()
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q +myrtn
}

ClassMethod FindProFreeOrdClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProFreeOrdExecute ]
{
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindProFreeOrd(PPRowId As %String = "", InArcim = "", InStage = "") As %Query(ROWSPEC = "ArcimRowId:%String,Arcimdesc:%String,PPFRowId:%String,PPFSttDate:%String,PPFSttTime:%String,PPFEndDate:%String,PPFEndTime:%String,PPFFreeNum:%String,PPFLimitEntryAfterNoFreeNum:%String,PPFStageDr,PPFStageDesc,PPFAddTime,PPFAddDate,PPFAddUser,PPFAddLoc") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindProFreeOrd",100)

ClassMethod FindProFreeOrdExecute(ByRef QHandle As %Binary, PPRowId As %String, InArcim = "", InStage = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	k TMPList
	s PPFChildSub=0
	f  s PPFChildSub=$o(^DHCDocPPF(PPRowId,PPFChildSub)) q:PPFChildSub=""  d
	.s str=$g(^DHCDocPPF(PPRowId,PPFChildSub))
	.s PPFSttDate=$p(str,"^",1)
	.i PPFSttDate'="" s PPFSttDate=..%ZD(PPFSttDate)
	.s PPFSttTime=$p(str,"^",2)
	.i PPFSttTime'="" s PPFSttTime=..%ZT(PPFSttTime,1)
	.s PPFEndDate=$p(str,"^",3)
	.i PPFEndDate'="" s PPFEndDate=..%ZD(PPFEndDate)
	.s PPFEndTime=$p(str,"^",4)
	.i PPFEndTime'="" s PPFEndTime=..%ZT(PPFEndTime,1)
	.s PPFItmMastDR=$p(str,"^",5)
	.s PPFItmMastDesc=$p($g(^ARCIM(+PPFItmMastDR,$p(PPFItmMastDR,"||",2),1)),"^",2)
	.s PPFFreeNum=$p(str,"^",6)
	.s PPFLimitEntryAfterNoFreeNum=$p(str,"^",7)
	.s PPFStageDesc=""
	.s (PPFAddTime,PPFAddDate,PPFAddUser,PPFAddLoc)=""
	.s PPFAddTime=$p(str,"^",9)
	.s PPFAddDate=$p(str,"^",10)
	.s PPFAddUser=$p(str,"^",11)
	.s PPFAddLoc=$p(str,"^",12)
	.s PPFAddDate = ##class(websys.Conversions).DateLogicalToHtml(PPFAddDate)
	.i PPFAddTime'="" s PPFAddTime = $zt(PPFAddTime,2)
	.i PPFAddUser'="" s PPFAddUser=$P(^SSU("SSUSR",PPFAddUser),"^",2)
	.i PPFAddLoc'="" s PPFAddLoc=$p(^CTLOC(PPFAddLoc),"^",2)
	.s PPFStageDr=$p(str,"^",8)
	.q:(InStage'="")&&(PPFStageDr'=InStage)
	.q:(InArcim'="")&&(InArcim'=PPFItmMastDR)
	.i PPFStageDr'="" d
	..s PPFStageDesc=$p(^CF.DOC.Pilot.OEStageD(PPFStageDr),"^",1)
	.s sort=PPFStageDr
	.i sort="" s sort=0
	.s TMPList(sort,PPFItmMastDR)=$lb(PPFItmMastDR,PPFItmMastDesc,PPRowId_"||"_PPFChildSub,PPFSttDate,PPFSttTime,PPFEndDate,PPFEndTime,PPFFreeNum,PPFLimitEntryAfterNoFreeNum,PPFStageDr,PPFStageDesc,PPFAddTime,PPFAddDate,PPFAddUser,PPFAddLoc)
	
	s sort=""
	f  s sort=$o(TMPList(sort)) q:sort=""  d
	.s id=""
	.f  s id=$o(TMPList(sort,id)) q:id=""  d
	..s outData=TMPList(sort,id)
	..d OutputRowFreeOrd
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFreeOrd
    B //1
	set Data=outData	//$lb(PPFItmMastDR,PPFItmMastDesc,PPRowId_"||"_PPFChildSub,PPFSttDate,PPFSttTime,PPFEndDate,PPFEndTime,PPFFreeNum,PPFLimitEntryAfterNoFreeNum,PPFStageDr,PPFStageDesc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindProFreeOrdFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProFreeOrdExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 判断医嘱项是否在药理项目的免费医嘱内
/// ##class(web.PilotProject.DHCDocPilotProject).CheckArcim(1,"11496||1")
ClassMethod CheckArcim(PPRowID As %String, ArcimRowId As %String) As %String
{
	q:(PPRowID="")||(ArcimRowId="") ""
	s CurrentDate=..%SysDate()
	s CurrentTime=..%SysTime()
	s PPFChildSub=$o(^DHCDocPPF(0,"ARCIM",ArcimRowId,PPRowID,""))
	Q:PPFChildSub="" ""
	s SttDate=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",1)
	s SttTime=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",2)
	Q:(SttDate'="")&&(SttDate>CurrentDate) "N"
	Q:(SttDate=CurrentDate)&&(SttTime>CurrentTime)&&(SttTime'="") "N"
	s EndDate=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",3) 
	s EndTime=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",4)
	Q:(EndDate'="")&&(EndDate<CurrentDate) "N"
	Q:(EndDate=CurrentDate)&&(EndTime<=CurrentTime)&&(EndTime'="") "N"
	s Num=+$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",6)
	s PPFLimitEntryAfterNoFreeNum=$p(^DHCDocPPF(PPRowID,PPFChildSub),"^",7)
	Q "Y^"_Num_"^"_PPFLimitEntryAfterNoFreeNum
}

/// 得到免费项目已经使用的免费数量(目前只支持判断医嘱)
/// w ##class(web.PilotProject.DHCDocPilotProject).GetPilotProFreeSum("108||2||2") //10093||1
ClassMethod GetPilotProFreeSum(PPPARowId As %String, ArcimRowId As %String, InStage = "") As %String
{
	s Sum=0
	s PPPAORowId=0
	f  s PPPAORowId=$o(^DHCDocPPPAO("PPPAOAdmDr",PPPARowId,PPPAORowId)) q:PPPAORowId=""  d
	.s PPPAOOEORIDr=$p(^DHCDocPPPAO(PPPAORowId),"^",2)
	.Q:PPPAOOEORIDr=""
	.s arcimDr=$p($g(^OEORD(+PPPAOOEORIDr,"I",$p(PPPAOOEORIDr,"||",2),1)),"^",2)
	.Q:arcimDr'=ArcimRowId
	.s PPPAOFreeOrdFlag=$p(^DHCDocPPPAO(PPPAORowId),"^",3)
	.Q:PPPAOFreeOrdFlag'="Y"
	.s PPPAOStageDr=$p(^DHCDocPPPAO(PPPAORowId),"^",10)
	.Q:(InStage'="")&&(PPPAOStageDr'=InStage)
	.s Sum=Sum+1
	Q Sum
}

/// w ##class(web.PilotProject.DHCDocPilotProject).GetPilotProPatAdmRowId(108,"5114||1",2) //10093||1
ClassMethod GetPilotProPatAdmRowId(PPRowID As %String, ArcimRowId As %String, EpisodeID As %String) As %String
{
	s PPPARowId=""
	s PPPChildSub=0
	f  s PPPChildSub=$o(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowID,PPPChildSub)) q:(PPPChildSub="")||(PPPARowId'="")  d
	.s PPPAChildSub=0
	.f  s PPPAChildSub=$o(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowID,PPPChildSub,PPPAChildSub)) q:(PPPAChildSub="")||(PPPARowId'="")  d
	..s PPPAActiveFlag=$p(^DHCDocPPPA(PPRowID,PPPChildSub,PPPAChildSub),"^",4)
	..Q:PPPAActiveFlag'="Y"
	..s PPPARowId=PPRowID_"||"_PPPChildSub_"||"_PPPAChildSub
	Q PPPARowId
}

ClassMethod InsertPPAOrdFree(PPPARowId As %String, newOrdIdDR As %String, User As %String, StageDr = "", VisitFlag = "") As %String
{
	s myrtn=0
	TS
	s Obj=##class(User.DHCDocPilotProPatAdmOrd).%New()
	d Obj.PPPAOAdmDrSetObjectId(PPPARowId)
	d Obj.PPPAOOEORIDrSetObjectId(newOrdIdDR)
	d Obj.PPPAOAddUserDrSetObjectId(User)
	s Obj.PPPAOAddDate=..%SysDate()
	s Obj.PPPAOAddTime=..%SysTime()
	s Obj.PPPAOLastUpdateDate=..%SysDate()
	s Obj.PPPAOLastUpdateTime=..%SysTime()
    d Obj.PPPAOLastUpdateUserDrSetObjectId(User)
	s Obj.PPPAOFreeOrdFlag="Y"
	d Obj.PPPAOStageSetObjectId(StageDr)
	s Obj.PPPAOVisitFlag=VisitFlag
	Set sc = Obj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d Obj.%Close()
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q +myrtn
}

ClassMethod CancelPPAOrdFree(PPRowId As %String, newOrdIdDR As %String, User As %String) As %String
{
	s myrtn=0
	S OrderARCIMRowid=$P(^OEORD(+newOrdIdDR,"I",$p(newOrdIdDR,"||",2),1),"^",2)
	s Adm=$p(^OEORD(+newOrdIdDR),"^",1)
	s PPPARowId=##class(web.PilotProject.DHCDocPilotProject).GetPilotProPatAdmRowId(PPRowId,OrderARCIMRowid,Adm)
	Q:PPPARowId="" myrtn
	s PPPAORowId=$o(^DHCDocPPPAO("PPPAOOEORIDr",PPPARowId,newOrdIdDR,""))
	Q:PPPAORowId="" myrtn
	TS
	s Obj=##class(User.DHCDocPilotProPatAdmOrd).%OpenId(PPPAORowId)
	s Obj.PPPAOLastUpdateDate=..%SysDate()
	s Obj.PPPAOLastUpdateTime=..%SysTime()
    d Obj.PPPAOLastUpdateUserDrSetObjectId(User)
	s Obj.PPPAOFreeOrdFlag="N"
	Set sc = Obj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d Obj.%Close()
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q +myrtn
}

/// 判断药理患者是否可录入检验检查医嘱(供通过检验检查申请使用)
/// w ##class(web.PilotProject.DHCDocPilotProject).CheckIsFreeOrd(42,108,"5114||1")
ClassMethod CheckIsFreeOrd(EpisodeID As %String, PPRowId As %String, OrderARCIMRowid As %String, CspName As %String = "") As %String
{
	Q:(EpisodeID="")||(PPRowId="")||(OrderARCIMRowid="") "0^"
	s langid=..%LanguageID()
	i CspName="" s CspName="dhcapp.reportreq.csp"
	s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
	s PilotCatStr=$G(^DHCDocPilotSeting(AdmDepHospId,"PilotProSubCatStr"))
	s ArcimDesc=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",2) 
	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	s ItemCatDr=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",10) 
	s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	if (("!"_PilotCatStr_"!")'[("!"_ItemCatDr_"!")){ //只需验证非药理子类
		s PPOpenOrdEntryLimit=$p($g(^DHCDocPP(PPRowId)),"^",117)
		if (PPOpenOrdEntryLimit="Y"){
			//药项目开启医嘱录入限制,只有项目维护的免费检验/检查医嘱才可开立
			//if (OrderType="L")||(##Class(web.DHCDocOrderCommon).GetItemServiceFlag(OrderARCIMRowid)=1){
			if (1=1){
				//s FreeStr=##class(web.PilotProject.DHCDocPilotProject).CheckArcim(PPRowId,OrderARCIMRowid)
				s FreeStr=##class(web.PilotProject.CFG.FindGCP).CheckArcim(PPRowId,OrderARCIMRowid,EpisodeID)
				s FreeFlag=$p(FreeStr,"^",1)
				if (FreeFlag="Y"){
					s PPFreeNum=$p(FreeStr,"^",2) //项目免费次数
					s PPFLimitEntryAfterNoFreeNum=$p(FreeStr,"^",3) //免费次数用完是否限制录入
					//已免费的数量
					s PPPARowId=##class(web.PilotProject.DHCDocPilotProject).GetPilotProPatAdmRowId(PPRowId,OrderARCIMRowid,EpisodeID)
					s InStage=##class(web.PilotProject.Extend.PatAdd).GetStageByAdm(PPRowId,EpisodeID,"")
					s PilotProHasFreeNum=##class(web.PilotProject.DHCDocPilotProject).GetPilotProFreeSum(PPPARowId,OrderARCIMRowid,InStage)	
					//s PilotProHasFreeNum=##class(web.PilotProject.DHCDocPilotProject).GetPilotProFreeSum(PPPARowId,OrderARCIMRowid)
					s LeftFreeNum=PPFreeNum-PilotProHasFreeNum
					if (LeftFreeNum<=0){
						if (PPFLimitEntryAfterNoFreeNum="Y"){
							Q "-1^"_ArcimDesc_..%Translate(CspName,"药理项目维护的医嘱免费次数已用完!")
						}else{
							Q "0^"_ArcimDesc_..%Translate(CspName,"药理项目维护的医嘱免费次数已用完!请谨慎使用!")
						}
					}
				}elseif(FreeFlag="N"){
					Q "-1^"_ArcimDesc_..%Translate(CspName,"药理项目维护的免费医嘱未启用或已过期!")
				}else{
					Q "-1^"_ArcimDesc_..%Translate(CspName,"在有药理项目的情况下,药项目开启医嘱录入限制时只有项目维护的免费医嘱才可开立.")
				}
			}else{
				Q "-1^"_ArcimDesc_..%Translate(CspName,"在有药理项目的情况下,药项目开启医嘱录入限制时只有项目维护的免费医嘱才可开立.")
			}
		}else{
			//药项目不开启医嘱录入限制,非药理子类的非药品可无限制录入且全部免费
			if (OrderType="R"){
				Q "-1^"_ArcimDesc_..%Translate(CspName,"此药品医嘱为非药理项目药品,不能在有药理项目的情况下开.")
			}
		}
	}
	Q "0^"
}

}
