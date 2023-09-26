Import SQLUser

Class web.PilotProject.UDHCDocPilotIntergrateQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindStartUser() As %SQLQuery(CONTAINID = 1, ROWSPEC = "RowId:%String,Desc:%String")
{
	select PP_StartUser_Dr,PP_StartUser_Dr->SSUSR_Name from dhc_docpilotproject where PP_StartUser_Dr->SSUSR_Name is not null union 
select PPD_StartUser_Dr,PPD_StartUser_Dr->SSUSR_Name  from dhc_docpilotprodept   order by 2
}

Query FindDept() As %Query(ROWSPEC = "RowId:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod FindDeptClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindDeptExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
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

/// d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","FindDept")
ClassMethod FindDeptExecute(ByRef QHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	d ResetVariables
	 &SQL(DECLARE OrdCur0 CURSOR FOR
	 	select PP_CreateDepartment_Dr ,PP_CreateDepartment_Dr->ctloc_desc into :RowId,:Desc from dhc_docpilotproject  union 
select PPD_CreateDepartment_Dr,PPD_CreateDepartment_Dr->ctloc_desc  from dhc_docpilotprodept  order by 2
	   
	 )
	
	&SQL(OPEN OrdCur0)
 For  &SQL(FETCH OrdCur0) QUIT:SQLCODE  do
 	.q:Desc=""	
    .i Desc["-"
    .s Desc=$p(Desc,"-",2)
    .i Desc="临床药理实验室" s Desc="I期临床试验研究室"
	.i Desc["免疫" s Desc="风湿免疫科"
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,Desc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (RowId,Desc)=""
	quit
}

Query LookUpProject() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowId:%String")
{
	SELECT DISTINCT PP_Desc,PP_RowId FROM DHC_DocPilotProject group by  PP_Desc order by PP_Desc
}

Query GetPlanNo() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowId:%String")
{
	SELECT DISTINCT PP_PlanNo,PP_RowId FROM DHC_DocPilotProject group by  PP_PlanNo order by PP_PlanNo
}

Query GetIndication(Arg1) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowId:%String")
{
	SELECT DISTINCT PP_Indication,PP_RowId FROM DHC_DocPilotProject where PP_Indication %startswith :Arg1  group by  PP_Indication order by PP_Indication
}

Query QueryProject(DeptRowId, StartUser, PPDescStr, PlanNoStr, IndicationStr, PilotCategoryStr, ApplyMatterStr, IsHeadmanStr, OtherStr) As %Query(ROWSPEC = "RecordSum:%Integer,Job:%String,TPPRowId:%String,TPPCode:%String,TPPDesc:%String,TPPStartDate:%String,TEndDate:%String,TPPCreateDepartment:%String,TPPStartUser:%String,TPPBudget:%String,TPPState:%String,TApproveResult:%String,TEthicsMeetAduitDate:%String,CPRCApproveResult:%String,PPSUpdateReason:%String,PlanNonow:%String,Indication:%String,PilotCategory,ApplyMatter,ApplicationUnitnow,ApplyStage,ApprovalNonow,PlanNamenow,IsHeadman,FileSubmitDate,EthicsMeetDate,EthicsMeetAduitDate,FirstPatDate,ArchivesFilesNo,CollectCompany,ProState,YearCheckDate,ProjectFilesState,EthicsFilesState,EthicsFilesNextState,EthicsFilesOffDate,SignProtocolDate,LeaderCompany,LeaderCompanyPI,CROCompany,PPRemark,CheckPerson,EndYear,Filingstatus,CenterDate,SaveLastDate,CPRCApproveDate,BriefDate,ToalAgree") [ SqlProc ]
{
}

ClassMethod QueryProjectClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryProjectExecute(ByRef QHandle As %Binary, DeptRowId As %String, StartUser As %String, PPDescStr, PlanNoStr, IndicationStr, PilotCategoryStr, ApplyMatterStr, IsHeadmanStr, OtherStr) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","QueryProject","","","")
	s ^zzy("QueryProjectExecute")=DeptRowId_"^"_StartUser_"^"_PPDescStr_"^"_PlanNoStr_"^"_IndicationStr_"^"_PilotCategoryStr_"^"_ApplyMatterStr_"^"_IsHeadmanStr_"^"_OtherStr
	Set repid=$I(^CacheTemp)
	s ind=1
	s count=0
	;s PPCode=$ZCVT(PPCode,"U")
	;s PPDesc=$ZCVT(PPDesc,"U")
	;if ((PPCode="")&&(PPDesc="")) Set QHandle=$lb(0,repid,0)  Quit $$$OK
	;if $l(PPStartDate,"/")=3 s PPStartDate=$zdh(PPStartDate,4)
	;if $l(PPEndDate,"/")=3 s PPEndDate=$zdh(PPEndDate,4)
	s USERID=%session.Get("LOGON.USERID")
	s Desc=$p(OtherStr,"^",1)
	s EMDateFrom=$p(OtherStr,"^",2)
	s EMDateTo=$p(OtherStr,"^",3) 
	s PlanNo1=$p(OtherStr,"^",4) 
	s TUser=$p(OtherStr,"^",5) 
	s EMADateFrom=$p(OtherStr,"^",6)
	s EMADateTo=$p(OtherStr,"^",7) 
	s ApplicationUnit=$p(OtherStr,"^",8) 
	s SubPilotCategoryStr=$p(OtherStr,"^",9)
	s StatusStr=$p(OtherStr,"^",10)
	s EndYearStr=$p(OtherStr,"^",11)
	s FilingstatusStr=$p(OtherStr,"^",12)
	s PPEndDateFrom=$p(OtherStr,"^",13)
	s PPEndDateTo=$p(OtherStr,"^",14)
	s CenterDateFrom=$p(OtherStr,"^",15)
	s CenterDateTo=$p(OtherStr,"^",16)
	s SaveLastDateStr=$p(OtherStr,"^",17)
	s ArchivesFilesNoF=$p(OtherStr,"^",18)
	s PPCode=$p(OtherStr,"^",19)
	if EMDateFrom'="" s EMDateFrom=$zdh(EMDateFrom,3)
	if EMDateTo'="" s EMDateTo=$zdh(EMDateTo,3)
	if EMADateFrom'="" s EMADateFrom=$zdh(EMADateFrom,3)
	if EMADateTo'="" s EMADateTo=$zdh(EMADateTo,3)
	if PPEndDateFrom'="" s PPEndDateFrom=$zdh(PPEndDateFrom,3)
	if PPEndDateTo'="" s PPEndDateTo=$zdh(PPEndDateTo,3)
	if CenterDateFrom'="" s CenterDateFrom=$zdh(CenterDateFrom,3)
	if CenterDateTo'="" s CenterDateTo=$zdh(CenterDateTo,3)
	
	k ^TMPQueryProject(USERID)
	s Job=$j
	s ProRowId=0 f  s ProRowId=$o(^DHCDocPP(ProRowId)) q:ProRowId=""  d
	.d ResetVariablesPro1
	.s ProDesc=$P(^DHCDocPP(ProRowId),"^",2)
	.s PlanNonow=$p($g(^DHCDocPP(ProRowId)),"^",26)
	.q:((PlanNonow'[PlanNo1)&&(PlanNoStr=""))
	.s Descflag=0
	.s PlanNoflag=0
	.s Indicationflag=0
	.i PPDescStr'=""  d
	..f d1=1:1:$l(PPDescStr,",") d
	...s PPDescDr=$p(PPDescStr,",",d1)
	...s PPDesc=$P($g(^DHCDocPP(PPDescDr)),"^",2)
	...i ((ProDesc=PPDesc)&&(PPDesc'="")) s Descflag=1
	.q:((Descflag=0)&&(PPDescStr'=""))
	.q:((PPDescStr="")&&(ProDesc'[Desc))
	.i PlanNoStr'=""  d
	..f d2=1:1:$l(PlanNoStr,",") d
	...s PlanNoDr=$p(PlanNoStr,",",d2)
	...s PlanNo=$P($g(^DHCDocPP(PlanNoDr)),"^",26)
	...i ((PlanNonow=PlanNo)&&(PlanNo'="")) s PlanNoflag=1
	.q:((PlanNoflag=0)&&(PlanNoStr'=""))
	.s Indication=$p($g(^DHCDocPP(ProRowId)),"^",17)
	.i IndicationStr'=""  d
	..f d3=1:1:$l(IndicationStr,",") d
	...s IndicationDr=$p(IndicationStr,",",d3)
	...s Indication1=$P($g(^DHCDocPP(IndicationDr)),"^",17)
	...i ((Indication=Indication1)&&(Indication1'="")) s Indicationflag=1
	.q:((Indicationflag=0)&&(IndicationStr'=""))
	.;s ProDesc=$ZCVT(ProDesc,"U")
	.s ProCode=$p($g(^DHCDocPP(ProRowId)),"^",1)
	.q:((PPCode'=ProCode)&&(PPCode'=""))
	.;s ProCode=$ZCVT(ProCode,"U")
	.s ProStartDate=$p($g(^DHCDocPP(ProRowId)),"^",11)
	.if ProStartDate'="" s ProStartDate=$zd(ProStartDate,4)
	.s ProEndDate=$p($g(^DHCDocPP(ProRowId)),"^",13)
	.if ProEndDate'="" s ProEndDate=$zd(ProEndDate,4)
	.S ProCreateDepartmen=""
	.s ProCreateDepartmenDr=$p($g(^DHCDocPP(ProRowId)),"^",6)
	
	.if ProCreateDepartmenDr'="" s ProCreateDepartmen=$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	.i ProCreateDepartmen="临床药理实验室" s ProCreateDepartmen="I期临床试验研究室"
	.i ProCreateDepartmen["免疫" s ProCreateDepartmen="风湿免疫科"
	.s ProStartUserDr=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.S ProStartUser=""
	.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	.s userflag=0
	.i ((TUser'="")&&(ProStartUser[TUser)) s userflag=1
	.s ProBudget=$p($g(^DHCDocPP(ProRowId)),"^",15)
	.s ProBudget=$j(ProBudget,3,2)
	.s ProState=""
	.s State=$p($g(^DHCDocPP(ProRowId)),"^",16)
	.s ApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",46)
	.i ApproveResult="N" s State="C"
	.i State="I" s ProState="审批中"
	.i State="U" s ProState="未批准"
	.i State="N" s ProState="立项"
	.i State="A" s ProState="暂停"
	.i State="S" s ProState="终止"
	.i State="V" s ProState="在研"
	.i State="H" s ProState="未进行"
	.i State="F" s ProState="已完成"
	.i State="B" s ProState="中止"
	.i State="C" s ProState="预审未通过"
	.i State="D" s ProState="上会未通过"
	.i State="P" s ProState="发补后在研"
	.q:State="E"
	.s Statusflag=0
	.i StatusStr'="" d
	..f d7=1:1:$l(StatusStr,",") d
	...s Status=$p(StatusStr,",",d7)
	...i ((Status=State)&&(Status'="")) s Statusflag=1
	.q:((Statusflag=0)&&(StatusStr'="")) 
	.s childsub=0
	.s PPSUpdateReason=""
	.f  s childsub=$o(^DHCDocPPS(ProRowId,childsub)) q:childsub=""  d
	..s PPSUpdateReason=$p($g(^DHCDocPPS(ProRowId,childsub)),"^",8)
	.s ApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",46)
	.s PlanNamenow=$p($g(^DHCDocPP(ProRowId)),"^",27)
	.s ApplicationUnitnow=$p($g(^DHCDocPP(ProRowId)),"^",25)
	.q:ApplicationUnitnow'[ApplicationUnit
	.s PilotCategoryDrnow=$p($g(^DHCDocPP(ProRowId)),"^",18)
	.s PilotCategory=""
	.s:PilotCategoryDrnow'="" PilotCategory=$p($g(^DHCDocCT("DefineData",+PilotCategoryDrnow,"D",$p(PilotCategoryDrnow,"||",2))),"^",2)
	.s SubPilotCategoryDr=$p($g(^DHCDocPP(ProRowId)),"^",41)
	.s SubPilotCategory=""
	.s:SubPilotCategoryDr'="" SubPilotCategory=$p($g(^DHCDocCT("DefineData",+SubPilotCategoryDr,"D",$p(SubPilotCategoryDr,"||",2))),"^",2)
	.s PilotCategory1=""
	.i SubPilotCategory="" s PilotCategory1=PilotCategory
	.e  s PilotCategory1=SubPilotCategory
	.s PilotCategoryflag=0
	.i PilotCategoryStr'=""  d
	..f d4=1:1:$l(PilotCategoryStr,",") d
	...s PilotCategoryDr=$p(PilotCategoryStr,",",d4)
	...i ((PilotCategoryDrnow=PilotCategoryDr)&&(PilotCategoryDr'="")) s PilotCategoryflag=1
	.q:((PilotCategoryflag=0)&&(PilotCategoryStr'=""))
	.s SubPilotCategoryflag=0
	.i SubPilotCategoryStr'=""  d
	..f d6=1:1:$l(SubPilotCategoryStr,",") d
	...s SubPilotCategoryDr1=$p(SubPilotCategoryStr,",",d6)
	...i ((SubPilotCategoryDr1=SubPilotCategoryDr)&&(SubPilotCategoryDr1'="")) s SubPilotCategoryflag=1
	.q:((SubPilotCategoryflag=0)&&(SubPilotCategoryStr'=""))
	.s ApprovalNonow=$p($g(^DHCDocPP(ProRowId)),"^",28)
	.s ApplyMatterDrnow=$p($g(^DHCDocPP(ProRowId)),"^",23)
	.s ApplyMatter=""
	.s:ApplyMatterDrnow'="" ApplyMatter=$p($g(^DHCDocCT("DefineData",+ApplyMatterDrnow,"D",$p(ApplyMatterDrnow,"||",2))),"^",2)
	.s ApplyMatterflag=0
	.i ApplyMatterStr'=""  d
	..f d4=1:1:$l(ApplyMatterStr,",") d
	...s ApplyMatterDr=$p(ApplyMatterStr,",",d4)
	...i ((ApplyMatterDrnow=ApplyMatterDr)&&(ApplyMatterDr'="")) s ApplyMatterflag=1
	.q:((ApplyMatterflag=0)&&(ApplyMatterStr'=""))
	.s ApplyStageDrnow=$p($g(^DHCDocPP(ProRowId)),"^",24)
	.s ApplyStage=""
	.s:ApplyStageDrnow'="" ApplyStage=$p($g(^DHCDocCT("DefineData",+ApplyStageDrnow,"D",$p(ApplyStageDrnow,"||",2))),"^",2)
	.s IsHeadmanDrnow=$p($g(^DHCDocPP(ProRowId)),"^",22)
	.s IsHeadmanflag=0
	.s IsHeadman=""
	.s:IsHeadmanDrnow'="" IsHeadman=$p($g(^DHCDocCT("DefineData",+IsHeadmanDrnow,"D",$p(IsHeadmanDrnow,"||",2))),"^",2)
	.i IsHeadmanStr'=""  d
	..f d5=1:1:$l(IsHeadmanStr,",") d
	...s IsHeadmanId=$p(IsHeadmanStr,",",d5)
	...i ((IsHeadmanDrnow=IsHeadmanId)&&(IsHeadmanId'="")) s IsHeadmanflag=1
	.q:((IsHeadmanflag=0)&&(IsHeadmanStr'=""))
	.s PPCreateDepartmentDrnow=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.s PPStartUserDrnow=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.s EthicsMeetAduitDate=$p($g(^DHCDocPP(ProRowId)),"^",33)
	.s:EthicsMeetAduitDate'="" EthicsMeetAduitDate=$zd(EthicsMeetAduitDate,4)
	.s CPRCApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",48)
	.s SignProtocolDate=$p($g(^DHCDocPP(ProRowId)),"^",37)
	.i CPRCApproveResult="Y" s CPRCApproveResult="同意"
	.i CPRCApproveResult="N" s CPRCApproveResult="不同意"
    .s lengthD=$l(DeptRowId,",")
    .s dflag=0
	.f d=1:1:lengthD d
	..s CreateDepartmenDr=$p(DeptRowId,",",d)
	..i ((ProCreateDepartmenDr=CreateDepartmenDr)&&(CreateDepartmenDr'="")) s dflag=1
	.s lengthS=$l(StartUser,",")
	.s sflag=0
	.f d=1:1:lengthS d
	..s StartUserDr=$p(StartUser,",",d)
	..i ((ProStartUserDr=StartUserDr)&&(StartUserDr'="")) s sflag=1
	.s child=0
	.f  s child=$o(^DHCDocPPD(ProRowId,child)) q:child=""  d
	..s User=""
	..s UserDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",2)
	..s DepDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",1)
	..f d=1:1:lengthD d
	...s CreateDepartmenDr=$p(DeptRowId,",",d)
	...i ((DepDr=CreateDepartmenDr)&&(CreateDepartmenDr'="")) s dflag=1
	..f d=1:1:lengthS d
	...s StartUserDr=$p(StartUser,",",d)
	...i ((UserDr=StartUserDr)&&(StartUserDr'="")) s sflag=1
	..s Dep=""
	..if DepDr'="" s Dep=$p($P(^CTLOC(DepDr),"^",2),"-",2)
	..i Dep="临床药理实验室" s Dep="I期临床试验研究室"
	..i Dep["免疫" s Dep="风湿免疫科"
	..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..i ((TUser'="")&&(ProStartUser[TUser)) s userflag=1
	..s:User'="" ProStartUser=ProStartUser_","_User
	..s:Dep'="" ProCreateDepartmen=ProCreateDepartmen_","_Dep
	.q:((DeptRowId'="")&&(dflag=0))
	.q:((StartUser'="")&&(sflag=0))
	.q:((TUser'="")&&(userflag=0)&&(StartUser="")) 
	.s FileSubmitDate=$p($g(^DHCDocPP(ProRowId)),"^",31)
	.;新项目资料提交日期取立项日期
	.i FileSubmitDate="" s FileSubmitDate=$p($g(^DHCDocPP(ProRowId)),"^",8)
	.s:FileSubmitDate'="" FileSubmitDate=$zd(FileSubmitDate,3)
	.s EthicsMeetDate=$p($g(^DHCDocPP(ProRowId)),"^",32)
	.q:((EthicsMeetDate<EMDateFrom)&&(EMDateFrom'=""))
	.q:((EthicsMeetDate>EMDateTo)&&(EMDateTo'=""))
	.s:EthicsMeetDate'="" EthicsMeetDate=$zd(EthicsMeetDate,3)
	.i EthicsMeetDate="" s EthicsMeetDate=$p($g(^DHCDocPP(ProRowId)),"^",113)
	.s EthicsMeetAduitDate=$p($g(^DHCDocPP(ProRowId)),"^",33)
	.q:((EthicsMeetAduitDate<EMADateFrom)&&(EMADateFrom'=""))
	.q:((EthicsMeetAduitDate>EMADateTo)&&(EMADateTo'=""))
	.s:EthicsMeetAduitDate'="" EthicsMeetAduitDate=$zd(EthicsMeetAduitDate,3)
	.s FirstPatDate=$p($g(^DHCDocPP(ProRowId)),"^",96)
	.s:FirstPatDate'="" FirstPatDate=$zd(FirstPatDate,3)
	.s PPEndDate=$p($g(^DHCDocPP(ProRowId)),"^",13)
	.s:PPEndDate'="" PPEndDate=$zd(PPEndDate,3)
	.s CenterDate=$p($g(^DHCDocPP(ProRowId)),"^",67)
	.q:((CenterDate<CenterDateFrom)&&(CenterDateFrom'=""))
	.q:((CenterDate>CenterDateTo)&&(CenterDateTo'=""))
	.q:((CenterDate="")&&(CenterDateFrom'=""))
	.q:((CenterDate="")&&(CenterDateTo'=""))
	.s:CenterDate'="" CenterDate=$zd(CenterDate,3)
	.s ArchivesFilesNo=$p($g(^DHCDocPP(ProRowId)),"^",34)
	.q:ArchivesFilesNo'[ArchivesFilesNoF
	.s CollectCompany=$p($g(^DHCDocPP(ProRowId)),"^",35)
	.s YearCheckDate=$p($g(^DHCDocPP(ProRowId)),"^",97)
	.s:YearCheckDate'="" YearCheckDate=$zd(YearCheckDate,3)
	.s ProjectFilesState=""
	.s ProjectFilesStateDr=$p($g(^DHCDocPP(ProRowId)),"^",21)
	.s:ProjectFilesStateDr'="" ProjectFilesState=$p($g(^DHCDocCT("DefineData",+ProjectFilesStateDr,"D",$p(ProjectFilesStateDr,"||",2))),"^",2)
	.s EthicsFilesStateDr=$p($g(^DHCDocPP(ProRowId)),"^",20)
	.s EthicsFilesState=""
	.s:EthicsFilesStateDr'="" EthicsFilesState=$p($g(^DHCDocCT("DefineData",+EthicsFilesStateDr,"D",$p(EthicsFilesStateDr,"||",2))),"^",2)
    .s EthicsFilesNextStateDr=""
    .s EthicsFilesNextState=""
    .s EthicsFilesNextStateDr=$p($g(^DHCDocPP(ProRowId)),"^",19)
	.s:EthicsFilesNextStateDr'="" EthicsFilesNextState=$p($g(^DHCDocCT("DefineData",+EthicsFilesNextStateDr,"D",$p(EthicsFilesNextStateDr,"||",2))),"^",2)
    .s EthicsFilesOffDate=$p($g(^DHCDocPP(ProRowId)),"^",36)
    .s:EthicsFilesOffDate'="" EthicsFilesOffDate=$zd(EthicsFilesOffDate,3)
    .s SignProtocolDate=$p($g(^DHCDocPP(ProRowId)),"^",37)
    .s:SignProtocolDate'="" SignProtocolDate=$zd(SignProtocolDate,3)
    .s LeaderCompany=$p($g(^DHCDocPP(ProRowId)),"^",38)
    .s LeaderCompanyPI=$p($g(^DHCDocPP(ProRowId)),"^",39)
    .s CROCompany=$p($g(^DHCDocPP(ProRowId)),"^",40)
    .s PPRemark=$p($g(^DHCDocPP(ProRowId)),"^",5)
    .i PPRemark=0 s PPRemark=""
    .s CheckPerson=$p($g(^DHCDocPP(ProRowId)),"^",98)
    .s EndYear=$p($g(^DHCDocPP(ProRowId)),"^",52)
    .s EndYearflag=0
    .i EndYearStr'=""  d
	..f d8=1:1:$l(EndYearStr,",") d
	...s EndYear1=$p(EndYearStr,",",d8)
	...i ((EndYear1=EndYear)&&(EndYear1'="")) s EndYearflag=1
	...i ((EndYear="")&&(EndYear1="empty")) s EndYearflag=1
	.q:((EndYearflag=0)&&(EndYearStr'=""))
	.s FilingstatusDr=$p($g(^DHCDocPP(ProRowId)),"^",69)
	.s Filingstatus=""
	.s:FilingstatusDr'="" Filingstatus=$p($g(^DHCDocCT("DefineData",+FilingstatusDr,"D",$p(FilingstatusDr,"||",2))),"^",2)
    .s Filingstatusflag=0
    .i FilingstatusStr'=""  d
	..f d9=1:1:$l(FilingstatusStr,",") d
	...s Filingstatusf=""
	...s Filingstatus1=$p(FilingstatusStr,",",d9)
	...i ((Filingstatus1=FilingstatusDr)&&(Filingstatus1'="")) s Filingstatusflag=1
	...s:Filingstatus1'="" Filingstatusf=$p($g(^DHCDocCT("DefineData",+Filingstatus1,"D",$p(Filingstatus1,"||",2))),"^",2)
	...i ((Filingstatus'="已归档")&&(Filingstatusf="未归档")) s Filingstatusflag=1
	.q:((Filingstatusflag=0)&&(FilingstatusStr'=""))
	.s SaveLastDate=$p($g(^DHCDocPP(ProRowId)),"^",71)
    .s SaveLastDateflag=0
    .i SaveLastDateStr'=""  d
	..f d10=1:1:$l(SaveLastDateStr,",") d
	...s SaveLastDate1=$p(SaveLastDateStr,",",d10)
	...i (($e(SaveLastDate1,1,4)=$e(SaveLastDate,1,4))&&(SaveLastDate1'="")&&(SaveLastDate'="")) s SaveLastDateflag=1
	...i ((SaveLastDate="")&&(SaveLastDate1="empty")) s SaveLastDateflag=1
	.q:((SaveLastDateflag=0)&&(SaveLastDateStr'=""))
	.s DeptCode=$p($g(^DHCDocPP(ProRowId)),"^",53)
	.s FileCaseNo=$p($g(^DHCDocPP(ProRowId)),"^",55)
	.s ApplyContact=$p($g(^DHCDocPP(ProRowId)),"^",42)
	.s ApplyContactTel=$p($g(^DHCDocPP(ProRowId)),"^",43)
	.s CROContact=$p($g(^DHCDocPP(ProRowId)),"^",44)
	.s CROContactTel=$p($g(^DHCDocPP(ProRowId)),"^",45)
	.s CPRCApproveDate=$p($g(^DHCDocPP(ProRowId)),"^",49)
	.s:CPRCApproveDate'="" CPRCApproveDate=$zd(CPRCApproveDate,3)
	.s CountUnitContact=$p($g(^DHCDocPP(ProRowId)),"^",56)
	.s CountUnitContactTel=$p($g(^DHCDocPP(ProRowId)),"^",57)
	.s DesignCaseNum=$p($g(^DHCDocPP(ProRowId)),"^",58)
	.s LocalGroupPlanCaseNum=$p($g(^DHCDocPP(ProRowId)),"^",59)
	.s LocalGroupFactCaseNum=$p($g(^DHCDocPP(ProRowId)),"^",60)
	.s LastCaseDate=$p($g(^DHCDocPP(ProRowId)),"^",61)
	.s FilterCaseNum=$p($g(^DHCDocPP(ProRowId)),"^",62)
	.s RejectCaseNum=$p($g(^DHCDocPP(ProRowId)),"^",63)
	.s DropCaseNum=$p($g(^DHCDocPP(ProRowId)),"^",64)
	.s SAECaseNum=$p($g(^DHCDocPP(ProRowId)),"^",65)
	.s SumDate=$p($g(^DHCDocPP(ProRowId)),"^",68)
	.s:SumDate'="" SumDate=$zd(SumDate,3)
	.s FilingDate=$p($g(^DHCDocPP(ProRowId)),"^",70)
	.s:FilingDate'="" FilingDate=$zd(FilingDate,3)
	.s:LastCaseDate'="" LastCaseDate=$zd(LastCaseDate,3)
	.s FirstFormConsentDate=$p($g(^DHCDocPP(ProRowId)),"^",100)
	.s:FirstFormConsentDate'="" FirstFormConsentDate=$zd(FirstFormConsentDate,3)
	.s GroupTransferUser=$p($g(^DHCDocPP(ProRowId)),"^",72)
	.s recipient=$p($g(^DHCDocPP(ProRowId)),"^",73)
	.s DrugExamCheckDate=$p($g(^DHCDocPP(ProRowId)),"^",87)
	.s:DrugExamCheckDate'="" DrugExamCheckDate=$zd(DrugExamCheckDate,3)
	.s DrugExamCheckFlag=$p($g(^DHCDocPP(ProRowId)),"^",88)
	.s EthicsFilesOffStatusDr=$p($g(^DHCDocPP(ProRowId)),"^",74)
	.s EthicsFilesOffStatus=""
	.s:EthicsFilesOffStatusDr'="" EthicsFilesOffStatus=$p($g(^DHCDocCT("DefineData",+EthicsFilesOffStatusDr,"D",$p(EthicsFilesOffStatusDr,"||",2))),"^",2)
    .s EthicsFilesOffOperator=$p($g(^DHCDocPP(ProRowId)),"^",75)
    .s EthicsFilesOffCompany=$p($g(^DHCDocPP(ProRowId)),"^",76)
    .s EthicsFilesOffTel=$p($g(^DHCDocPP(ProRowId)),"^",77)
    .s EthicsFilesOffDate=$p($g(^DHCDocPP(ProRowId)),"^",36)
    .s:EthicsFilesOffDate'="" EthicsFilesOffDate=$zd(EthicsFilesOffDate,3)
    .s ImageDataLocation=$p($g(^DHCDocPP(ProRowId)),"^",78)
    .s ImageDataNum=$p($g(^DHCDocPP(ProRowId)),"^",79)
    .s CheckPerson=$p($g(^DHCDocPP(ProRowId)),"^",98)
    .s FileNum=$p($g(^DHCDocPP(ProRowId)),"^",80)
    .s FormConsentNum=$p($g(^DHCDocPP(ProRowId)),"^",81)
    .s CaseReportNum=$p($g(^DHCDocPP(ProRowId)),"^",82)
    .s EthicsFilesNum=$p($g(^DHCDocPP(ProRowId)),"^",83)
    .s OrigRecordNum=$p($g(^DHCDocPP(ProRowId)),"^",84)
    .s TotalFileNum=$p($g(^DHCDocPP(ProRowId)),"^",85)
    .s BriefDate=$p($g(^DHCDocPP(ProRowId)),"^",66)
    .q:((BriefDate<PPEndDateFrom)&&(PPEndDateFrom'=""))
	.q:((BriefDate>PPEndDateTo)&&(PPEndDateTo'=""))
	.q:((BriefDate="")&&(PPEndDateFrom'=""))
	.q:((BriefDate="")&&(PPEndDateTo'=""))
    .s:BriefDate'="" BriefDate=$zd(BriefDate,3)
    .;总结日期优先取BriefDate>CenterDate>SumDate
    .i SumDate'="" s PPEndDate=SumDate
    .i CenterDate'="" s PPEndDate=CenterDate
    .i BriefDate'="" s PPEndDate=BriefDate
    .s ToalAgree=$p($g(^DHCDocPP(ProRowId)),"^",86)
	.s count=count+1
	.s ^TMPQueryProject(USERID,Job)=count
	.s ^TMPQueryProject(USERID,Job,count)=ProCode_"^"_ProDesc_"^"_ApplicationUnitnow_"^"_PilotCategory1_"^"_ApplyMatter_"^"_ApplyStage_"^"_ApprovalNonow_"^"_PlanNonow_"^"_PlanNamenow_"^"_IsHeadman_"^"_ProCreateDepartmen
	.s ^TMPQueryProject(USERID,Job,count)=^TMPQueryProject(USERID,Job,count)_"^"_ProStartUser_"^"_Indication_"^"_FileSubmitDate_"^"_EthicsMeetDate_"^"_EthicsMeetAduitDate_"^"_FirstPatDate_"^"_PPEndDate_"^"_ArchivesFilesNo_"^"_CollectCompany_"^"_ProState
	.s ^TMPQueryProject(USERID,Job,count)=^TMPQueryProject(USERID,Job,count)_"^"_YearCheckDate_"^"_ProjectFilesState_"^"_EthicsFilesState_"^"_EthicsFilesNextState_"^"_EthicsFilesOffDate_"^"_SignProtocolDate_"^"_LeaderCompany_"^"_LeaderCompanyPI_"^"_CROCompany_"^"_PPRemark
	.s ^TMPQueryProject(USERID,Job,count)=^TMPQueryProject(USERID,Job,count)_"^"_CheckPerson_"^"_EndYear_"^"_DeptCode_"^"_FileCaseNo_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROContact_"^"_CROContactTel_"^"_CountUnitContact_"^"_CountUnitContactTel
	.s ^TMPQueryProject(USERID,Job,count)=^TMPQueryProject(USERID,Job,count)_"^"_DesignCaseNum_"^"_LocalGroupPlanCaseNum_"^"_LocalGroupFactCaseNum_"^"_FirstFormConsentDate_"^"_LastCaseDate_"^"_FilterCaseNum_"^"_RejectCaseNum_"^"_DropCaseNum_"^"_SAECaseNum_"^"_SumDate
	.s ^TMPQueryProject(USERID,Job,count)=^TMPQueryProject(USERID,Job,count)_"^"_FilingDate_"^"_SaveLastDate_"^"_GroupTransferUser_"^"_recipient_"^"_DrugExamCheckFlag_"^"_DrugExamCheckDate_"^"_EthicsFilesOffStatus_"^"_EthicsFilesOffDate_"^"_EthicsFilesOffOperator_"^"_EthicsFilesOffCompany
	.s ^TMPQueryProject(USERID,Job,count)=^TMPQueryProject(USERID,Job,count)_"^"_EthicsFilesOffTel_"^"_ImageDataLocation_"^"_ImageDataNum_"^"_CheckPerson_"^"_FileNum_"^"_FormConsentNum_"^"_CaseReportNum_"^"_EthicsFilesNum_"^"_OrigRecordNum_"^"_TotalFileNum_"^"_CPRCApproveDate_"^"_BriefDate
	.Do OutputRowPro1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPro1
    ;set Data=$g(^tmpFindProject($j,i,j,k))
	set Data=$lb(0,Job,ProRowId,ProCode,ProDesc,ProStartDate,PPEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason,PlanNonow,Indication,PilotCategory1,ApplyMatter,ApplicationUnitnow,ApplyStage,ApprovalNonow,PlanNamenow,IsHeadman,FileSubmitDate,EthicsMeetDate,EthicsMeetAduitDate,FirstPatDate,ArchivesFilesNo,CollectCompany,ProState,YearCheckDate,ProjectFilesState,EthicsFilesState,EthicsFilesNextState,EthicsFilesOffDate,SignProtocolDate,LeaderCompany,LeaderCompanyPI,CROCompany,PPRemark,CheckPerson,EndYear,Filingstatus,CenterDate,SaveLastDate,CPRCApproveDate,BriefDate,ToalAgree)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariablesPro1
	///set (repid)=0
	set (ProCode,ProDesc,ProStartDate,PPEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason,Filingstatus,CPRCApproveDate)=""
	quit
}

ClassMethod QueryProjectFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryProjectExecute ]
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

ClassMethod GetProjectNum(ProcessNo As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	s num=^TMPQueryProject(USERID,ProcessNo)
	q num
}

ClassMethod GetProject(ProcessNo As %String, Num As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQueryProject(USERID,ProcessNo,Num))
}

ClassMethod FindPilotCategoryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPilotCategoryExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPilotCategoryExecute(ByRef QHandle As %Binary) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindPilotCategory","科研药理","类别")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..q:Define'="类别"
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s IndicationCode=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",1)
	...s IndicationDesc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...s SttDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",3)
	...s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",4)
	...s rowid=CTDefineRowId_"||"_ChildSub
	...q:((+$H)<SttDate&&(SttDate'=""))
	...q:((+$H)>=EndDate&&(EndDate'=""))
	...Do OutputRow3
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(IndicationDesc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables3
	///set (repid)=0
	set (IndicationDesc,IndicationCode,rowid)=""
	quit
}

ClassMethod FindPilotCategoryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPilotCategoryExecute ]
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

Query FindPilotCategory() As %Query(ROWSPEC = "Desc:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod FindApplyMatterClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindApplyMatterExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApplyMatterExecute(ByRef QHandle As %Binary) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindPilotCategory","科研药理","类别")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..q:Define'="申请事项"
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s IndicationCode=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",1)
	...s IndicationDesc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...s SttDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",3)
	...s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",4)
	...s rowid=CTDefineRowId_"||"_ChildSub
	...q:((+$H)<SttDate&&(SttDate'=""))
	...q:((+$H)>=EndDate&&(EndDate'=""))
	...Do OutputRow4
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(IndicationDesc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables4
	///set (repid)=0
	set (IndicationDesc,IndicationCode,rowid)=""
	quit
}

ClassMethod FindApplyMatterFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApplyMatterExecute ]
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

Query FindApplyMatter() As %Query(ROWSPEC = "Desc:%String,RowId:%String") [ SqlProc ]
{
}

Query FindKSPJProject(SttDate, EndDate) As %Query(ROWSPEC = "Job,ProDesc,ApplicationUnit,PlanName,ApplyMatterStage,PlanName,ProCreateDepartment,ProStartUser,ProCode") [ SqlProc ]
{
}

ClassMethod FindKSPJProjectClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindKSPJProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindKSPJProjectFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKSPJProjectExecute ]
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

ClassMethod FindSubPilotCategoryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindSubPilotCategoryExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSubPilotCategoryExecute(ByRef QHandle As %Binary) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindPilotCategory","科研药理","类别")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ModuleRowId=""
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
	...s IndicationDesc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...s SttDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",3)
	...s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",4)
	...s rowid=CTDefineRowId_"||"_ChildSub
	...q:((+$H)<SttDate&&(SttDate'=""))
	...q:((+$H)>=EndDate&&(EndDate'=""))
	...Do OutputRow5
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(IndicationDesc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables5
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

Query FindSubPilotCategory() As %Query(ROWSPEC = "Desc:%String,RowId:%String") [ SqlProc ]
{
}

/// 获得快审详细信息
/// 入参：
/// d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","FindKSPJProject","01/01/2013","23/08/2013")
ClassMethod FindKSPJProjectExecute(ByRef QHandle As %Binary, SttDate, EndDate) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^zzy("FindKSPJProject")=SttDate_","_EndDate
	s USERID=%session.Get("LOGON.USERID")
	 k ^TMPDHCDocKSPJProject(USERID)
	s Job=$j
     if SttDate="" s SttDate=+$h
     e  i $l(SttDate,"/")=3  s SttDate=$zdh(SttDate,4)
     if EndDate="" s EndDate=+$h
      e  i $l(EndDate,"/")=3  s EndDate=$zdh(EndDate,4)
      if SttDate>EndDate d
      .s mDate=SttDate
      .s SttDate=EndDate
      .s EndDate=mDate
      s i=0
      s ProRowId=0 f  s ProRowId=$o(^DHCDocPP(ProRowId)) q:ProRowId=""  d
      	.s PPERowId=0
      	.s flag=0
		.f  s PPERowId=$o(^DHCDocPPE(0,"ProjectDr",ProRowId,PPERowId)) q:PPERowId=""  d
		..s CreateDate=$p($g(^DHCDocPPE(PPERowId)),"^",12)
		..s PPEType=$p($g(^DHCDocPPE(PPERowId)),"^",14)
		..q:PPEType'="F" 
		..i ((CreateDate<=EndDate)&&(CreateDate>=SttDate)) s flag=1
		..;s:CreateDate'="" CreateDate=$zd(CreateDate,4)
		.q:flag=0
		.s ProDesc=$P(^DHCDocPP(ProRowId),"^",2)
		.s ProCode=$p($g(^DHCDocPP(ProRowId)),"^",1)
		.S ProCreateDepartment=""
		.s ProCreateDepartmenDr=$p($g(^DHCDocPP(ProRowId)),"^",6)
		.if ProCreateDepartmenDr'="" s ProCreateDepartment=$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
		.i ProCreateDepartment["免疫" s ProCreateDepartment="风湿免疫科"
		.s ProStartUserDr=$p($g(^DHCDocPP(ProRowId)),"^",10)
		.S ProStartUser=""
		.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	    .s ApplicationUnit=$p($g(^DHCDocPP(ProRowId)),"^",25)
	    .s ApplyMatterDr=$p($g(^DHCDocPP(ProRowId)),"^",23)
		.s ApplyStageDr=$p($g(^DHCDocPP(ProRowId)),"^",24)
		.s ApplyMatter=""
		.s:ApplyMatterDr'="" ApplyMatter=$p($g(^DHCDocCT("DefineData",+ApplyMatterDr,"D",$p(ApplyMatterDr,"||",2))),"^",2)
	    .s ApplyStage=""
		.s:ApplyStageDr'="" ApplyStage=$p($g(^DHCDocCT("DefineData",+ApplyStageDr,"D",$p(ApplyStageDr,"||",2))),"^",2)
	    .s ApplyMatterStage=ApplyMatter_ApplyStage
	    .s PlanName=$p($g(^DHCDocPP(ProRowId)),"^",27)
	    .s child=0
		.f  s child=$o(^DHCDocPPD(ProRowId,child)) q:child=""  d
		..s User=""
		..s UserDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",2)
		..s DepDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",1)
		..s Dep=""
		..if DepDr'="" s Dep=$p($P(^CTLOC(DepDr),"^",2),"-",2)
		..i Dep["免疫" s Dep="风湿免疫科"
		..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
		..s:User'="" ProStartUser=ProStartUser_","_User
		..s:Dep'="" ProCreateDepartment=ProCreateDepartment_","_Dep
	  	.s i=i+1
	  	.s ^TMPDHCDocKSPJProject(USERID,Job)=i
	  	.s ^TMPDHCDocKSPJProject(USERID,Job,i)=ProDesc_"^"_ApplicationUnit_"^"_ApplyMatterStage_"^"_PlanName_"^"_ProCreateDepartment_"^"_ProStartUser
		.Do OutputRow7
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(Job,ProDesc,ApplicationUnit,PlanName,ApplyMatterStage,PlanName,ProCreateDepartment,ProStartUser,ProCode)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindIsHeadmanClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindIsHeadmanExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindIsHeadmanExecute(ByRef QHandle As %Binary) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindPilotCategory","科研药理","类别")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..q:Define'="是否是组长"
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s IndicationCode=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",1)
	...s IndicationDesc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...s SttDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",3)
	...s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",4)
	...s rowid=CTDefineRowId_"||"_ChildSub
	...q:((+$H)<SttDate&&(SttDate'=""))
	...q:((+$H)>=EndDate&&(EndDate'=""))
	...Do OutputRow8
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(IndicationDesc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables8
	///set (repid)=0
	set (IndicationDesc,IndicationCode,rowid)=""
	quit
}

ClassMethod FindIsHeadmanFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIsHeadmanExecute ]
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

Query FindIsHeadman() As %Query(ROWSPEC = "Desc:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod GetKSPJProjectNum(ProcessNo As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	s num=^TMPDHCDocKSPJProject(USERID,ProcessNo)
	q num
}

ClassMethod GetKSPJProject(ProcessNo As %String, Num As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q $g(^TMPDHCDocKSPJProject(USERID,ProcessNo,Num))
}

Query GetEndYear() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowId:%String")
{
	select left(PP_EndYear,4),(case when PP_EndYear is null  
 then 'empty' else PP_EndYear end 
)PP_EndYear from dhc_docpilotproject group by left(PP_EndYear,4) order by left(PP_EndYear,4)
}

//d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","GetSaveLastDate")

Query GetSaveLastDate() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowId:%String")
{
	select left(PP_SaveLastDate,4),(case when PP_SaveLastDate is null  
 then 'empty' else PP_SaveLastDate end 
)PP_SaveLastDate from dhc_docpilotproject group by left(PP_SaveLastDate,4) order by left(PP_SaveLastDate,4)
}

ClassMethod FindFilingstatusClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindFilingstatusExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFilingstatusExecute(ByRef QHandle As %Binary) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","FindFilingstatus")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="科研药理"
	.s CTDefineRowId=""
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..q:Define'="归档情况"
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)) q:ChildSub=""  d
	...s IndicationCode=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",1)
	...s IndicationDesc=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",2)
	...s SttDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",3)
	...s EndDate=$p($g(^DHCDocCT("DefineData",CTDefineRowId,"D",ChildSub)),"^",4)
	...s rowid=CTDefineRowId_"||"_ChildSub
	...q:((+$H)<SttDate&&(SttDate'=""))
	...q:((+$H)>=EndDate&&(EndDate'=""))
	...Do OutputRow9
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(IndicationDesc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables9
	///set (repid)=0
	set (IndicationDesc,IndicationCode,rowid)=""
	quit
}

ClassMethod FindFilingstatusFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFilingstatusExecute ]
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

Query FindFilingstatus() As %Query(ROWSPEC = "Desc:%String,RowId:%String") [ SqlProc ]
{
}

//伦理委员会工作总结

//w ##Class(web.PilotProject.UDHCDocPilotIntergrateQuery).ECwork("01/01/2013","20/11/2013")

//output:Total:签发批件,ec：伦理委员会批准的新项目，ks:签发快审批件，但未在我院上会的项目

ClassMethod ECwork(SttDate As %String, EndDate As %String)
{
	if SttDate'="" s SttDate=$zdh(SttDate,4)
	if EndDate'="" s EndDate=$zdh(EndDate,4)
	s Total=0
	s ks=0
	s ec=0
	s sae=0
	s YK=0
	s PPRowId="" f  s PPRowId=$o(^DHCDocPPE(0,"ProjectDr",PPRowId)) q:PPRowId=""  d
	.s PPERowId=""
	.s FFlag=0
	.s CFlag=0
	.s AFlag=0
	.s EthicsMeetAduitDate=$p($g(^DHCDocPP(PPRowId)),"^",33)
	.f  s PPERowId=$o(^DHCDocPPE(0,"ProjectDr",PPRowId,PPERowId)) q:PPERowId=""  d
	..s EthicsMeetDate=$p($g(^DHCDocPPE(PPERowId)),"^",9)
	..s Result=""
	..s ResultDr=$p($g(^DHCDocPPE(PPERowId)),"^",1)
	..i ResultDr'="" s Result=$p($g(^DHCDocCT("DefineData",+ResultDr,"D",$p(ResultDr,"||",2))),"^",2)
	..i (EthicsMeetAduitDate<=EndDate)&&(EthicsMeetAduitDate>=SttDate) s AFlag=1
	..s InstrucNo=$p($g(^DHCDocPPE(PPERowId)),"^",13)
	..s PPEType=$p($g(^DHCDocPPE(PPERowId)),"^",14)
	..s CreateDate=$p($g(^DHCDocPPE(PPERowId)),"^",12)
	..i (PPEType="F"&&(AFlag=1)) s FFlag=1
	..i PPEType="C" d
	...s CFlag=1
	...i (EthicsMeetDate<=EndDate)&&(EthicsMeetDate>=SttDate) d
	....s Total=Total+1
	..e  d
	...i (CreateDate<=EndDate)&&(CreateDate>=SttDate) d
	....s Total=Total+1
	.i (FFlag=1) s ks=ks+1
	.i AFlag=1 s ec=ec+1
	 f date=SttDate:1:EndDate d
     .s PPRowId=0
     .f  s PPRowId=$o(^DHCDocPPSAE("Date",0,date,PPRowId)) q:PPRowId=""  d
     ..s childsub=""
     ..f  s childsub=$o(^DHCDocPPSAE("Date",0,date,PPRowId,childsub)) q:childsub=""  d
     ...s PPSAEReportTypeDr=$p($g(^DHCDocPPSAE(PPRowId,childsub)),"^",9)
	 ...s:PPSAEReportTypeDr'="" PPSAEReportType=$p($g(^DHCDocCT("DefineData",+PPSAEReportTypeDr,"D",$p(PPSAEReportTypeDr,"||",2))),"^",2)
	 ...q:PPSAEReportType'="首次报告"
     ...s sae=sae+1
     .s ProRowId=0
     .f  s ProRowId=$o(^DHCDocPPYK("PPYKDate",0,date,ProRowId)) q:ProRowId=""  d
     ..s child=0
     ..f  s child=$o(^DHCDocPPYK("PPYKDate",0,date,ProRowId,child)) q:child=""  d
     ...s YK=YK+1
	q Total_"^"_ec_"^"_ks_"^"_sae_"^"_YK
}

ClassMethod FindPJNumClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPJNumExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPJNumExecute(ByRef QHandle As %Binary, SttDate As %String, EndDate As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","FindPJNum","01/01/2013","20/11/2013")
	;if SttDate'="" s SttDate=$zdh(SttDate,4)
	;if EndDate'="" s EndDate=$zdh(EndDate,4)
	s USERID=%session.Get("LOGON.USERID")
	;s USERID=1
	k ^TMPFindPJNumOut(USERID)
	Set repid=$I(^CacheTemp)
	s ind=1
	s PPRowId="" f  s PPRowId=$o(^DHCDocPPE(0,"ProjectDr",PPRowId)) q:PPRowId=""  d
	.s PPERowId=""
	.s FFlag=0
	.s CFlag=0
	.s AFlag=0
	.f  s PPERowId=$o(^DHCDocPPE(0,"ProjectDr",PPRowId,PPERowId)) q:PPERowId=""  d
	..s EthicsMeetDate=$p($g(^DHCDocPPE(PPERowId)),"^",9)
	..q:EthicsMeetDate=""
	..s Result=""
	..s ResultDr=$p($g(^DHCDocPPE(PPERowId)),"^",1)
	..i ResultDr'="" s Result=$p($g(^DHCDocCT("DefineData",+ResultDr,"D",$p(ResultDr,"||",2))),"^",2)
	..i ResultDr="" s seq=5
	..i Result="同意" s seq=1
	..i Result="作必要的修正后同意" s seq=2
	..i Result="作必要的修正后重审" s seq=3
	..i Result="不同意" s seq=4
	..s PPEType=$p($g(^DHCDocPPE(PPERowId)),"^",14)
	..q:PPEType'="C"
	..q:((EthicsMeetDate<SttDate)||(EthicsMeetDate>EndDate))
	..i '$d(^TMPFindPJNum(USERID,$j,EthicsMeetDate)) s ^TMPFindPJNum(USERID,$j,EthicsMeetDate)=1
	..e  s ^TMPFindPJNum(USERID,$j,EthicsMeetDate)=^TMPFindPJNum(USERID,$j,EthicsMeetDate)+1
	..i '$d(^TMPFindPJNum(USERID,$j,EthicsMeetDate,seq)) s ^TMPFindPJNum(USERID,$j,EthicsMeetDate,seq)=1
	..e  s ^TMPFindPJNum(USERID,$j,EthicsMeetDate,seq)=^TMPFindPJNum(USERID,$j,EthicsMeetDate,seq)+1
	s Rowid=0
	s Date=""
	s AllTotal=0
	s Toptal1=0
	s Toptal2=0
	s Toptal3=0
	s Toptal4=0
	f  s Date=$o(^TMPFindPJNum(USERID,$j,Date)) q:Date=""  d
	.s Total=0
	.s Num1=0
	.s Num2=0
	.s Num3=0
	.s Num4=0
	.s EDate=$zd(Date,3)
	.s:$d(^TMPFindPJNum(USERID,$j,Date)) Total=^TMPFindPJNum(USERID,$j,Date)
	.s:$d(^TMPFindPJNum(USERID,$j,Date,1)) Num1=^TMPFindPJNum(USERID,$j,Date,1)
	.s:$d(^TMPFindPJNum(USERID,$j,Date,2)) Num2=^TMPFindPJNum(USERID,$j,Date,2)
	.s:$d(^TMPFindPJNum(USERID,$j,Date,3)) Num3=^TMPFindPJNum(USERID,$j,Date,3)
	.s:$d(^TMPFindPJNum(USERID,$j,Date,4)) Num4=^TMPFindPJNum(USERID,$j,Date,4)
	.s AllTotal=AllTotal+Total
	.s Toptal1=Toptal1+Num1
	.s Toptal2=Toptal2+Num2
	.s Toptal3=Toptal3+Num3
	.s Toptal4=Toptal4+Num4
	.Do OutputRow10
	s EDate="合计："
	s Total=AllTotal
	s Num1=Toptal1
	s Num2=Toptal2
	s Num3=Toptal3
	s Num4=Toptal4
	Do OutputRow10
	k ^TMPFindPJNum(USERID,$j)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow10
	set Data=$lb(EDate,Total,Num1,Num2,Num3,Num4,$j)
	set ^TMPFindPJNumOut(USERID,$j,ind)=EDate_"^"_Total_"^"_Num1_"^"_Num2_"^"_Num3_"^"_Num4
	set ^TMPFindPJNumOut(USERID,$j)=ind
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindPJNumFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPJNumExecute ]
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

Query FindPJNum(SttDate As %String, EndDate As %String) As %Query(ROWSPEC = "EDate,Total,Num1,Num2,Num3,Num4,ProcesNo") [ SqlProc ]
{
}

ClassMethod GetPJNum(ProcesNo As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q ^TMPFindPJNumOut(USERID,ProcesNo)
}

ClassMethod GetPJNumDetail(ProcesNo As %String, Number As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q ^TMPFindPJNumOut(USERID,ProcesNo,Number)
}

Query FindTotalDA(FilingSttDate, FilingEndDate, QualitySttDate, QualityEndDate) As %Query(ROWSPEC = "ProNum,FileNum,DeptNum,UserNum,EndQualityCtrlNum,Job") [ SqlProc ]
{
}

ClassMethod FindTotalDAClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindTotalDAExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTotalDAFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TotalDAExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","FindTotalDA")
ClassMethod FindTotalDAExecute(ByRef QHandle As %Binary, FilingSttDate, FilingEndDate, QualitySttDate, QualityEndDate) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	;s ^zzy("FilingSttDate")=FilingSttDate
	k ^TMPFindTotalDA($j)
	
	i (FilingSttDate="")&&(FilingEndDate="")&&(QualitySttDate="")&&(QualityEndDate="") Set QHandle=$lb(0,repid,0) Quit $$$OK
	
	i FilingSttDate["/" s FilingSttDate=$zdh(FilingSttDate,4)
	i FilingEndDate["/" s FilingEndDate=$zdh(FilingEndDate,4)
	i QualitySttDate["/" s QualitySttDate=$zdh(QualitySttDate,4)
	i QualityEndDate["/" s QualityEndDate=$zdh(QualityEndDate,4)

	s ProNum=0
	s FileNum=0
	s PPRowId=0
	s DeptNum=0
	s UserNum=0
	s EndQualityCtrlNum=0
	f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
	.s FilingDate=$p(^DHCDocPP(PPRowId),"^",70)
	.s TotalFileNum=$p(^DHCDocPP(PPRowId),"^",85)
	.s ArchivesFilesNo=$p(^DHCDocPP(PPRowId),"^",34)
	.s PPStartUserDr=$p(^DHCDocPP(PPRowId),"^",10)
	.s SSName=##class(web.PilotProject.DHCDocPilotProject).GetPPUserByID(PPRowId,"") //PI
	.s PPDesc=$p(^DHCDocPP(PPRowId),"^",2)
	.s PlanName=$p(^DHCDocPP(PPRowId),"^",26)
	.s ApplicationUnit=$p(^DHCDocPP(PPRowId),"^",25)
	.s ApplyContact=$p(^DHCDocPP(PPRowId),"^",42)
	.s ApplyContactTel=$p(^DHCDocPP(PPRowId),"^",43)
	.s CROCompany=$p(^DHCDocPP(PPRowId),"^",40)
	.s CROContact=$p(^DHCDocPP(PPRowId),"^",44)
	.s CROContactTel=$p(^DHCDocPP(PPRowId),"^",45)
	.s ProCreateDepartmenDr=$p($g(^DHCDocPP(PPRowId)),"^",6) //专业组
	.s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.q:((FilingSttDate'="")&&(FilingDate<FilingSttDate))||((FilingEndDate'="")&&(FilingDate>FilingEndDate))
	.s EndQualityCtrlDate=$p(^DHCDocPP(PPRowId),"^",115)
	.q:((QualitySttDate'="")&&(EndQualityCtrlDate<QualitySttDate))||((QualityEndDate'="")&&(EndQualityCtrlDate>QualityEndDate))
	.s CTLOCDesc=$p(^CTLOC(ProCreateDepartmenDr),"^",2)  //阳远
	.s EndQualityCtrlFlag=$p(^DHCDocPP(PPRowId),"^",114)
	.i EndQualityCtrlFlag="Y" d
	..s EndQualityCtrlNum=EndQualityCtrlNum+1
	..s ^TMPFindTotalDA($j,"EndQuality",PPRowId)=ArchivesFilesNo_"^"_CTLOCDesc_"^"_SSName_"^"_PPDesc_"^"_PlanName_"^"_ApplicationUnit_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROCompany_"^"_CROContact_"^"_CROContactTel
	.s ProNum=ProNum+1
	.s ^TMPFindTotalDA($j,"Pro",PPRowId)=ArchivesFilesNo_"^"_CTLOCDesc_"^"_SSName_"^"_PPDesc_"^"_PlanName_"^"_ApplicationUnit_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROCompany_"^"_CROContact_"^"_CROContactTel
	.s FileNum=FileNum+TotalFileNum
	.i ProCreateDepartmenDr'="" d
	..i '$d(^TMPFindTotalDA($j,"DepDr",ProCreateDepartmenDr)) d
	...s DeptNum=DeptNum+1
	...s ^TMPFindTotalDA($j,"DepDr",ProCreateDepartmenDr)=ArchivesFilesNo_"^"_CTLOCDesc_"^"_SSName_"^"_PPDesc_"^"_PlanName_"^"_ApplicationUnit_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROCompany_"^"_CROContact_"^"_CROContactTel
	.i ProStartUserDr'="" d
	..i '$d(^TMPFindTotalDA($j,"UserDr",ProStartUserDr)) d
	...s UserNum=UserNum+1
	...s ^TMPFindTotalDA($j,"UserDr",ProStartUserDr)=ArchivesFilesNo_"^"_CTLOCDesc_"^"_SSName_"^"_PPDesc_"^"_PlanName_"^"_ApplicationUnit_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROCompany_"^"_CROContact_"^"_CROContactTel
	.s child=0
	.f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	..;s User=""
	..s UserDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	..s DepDr=$p($g(^DHCDocPPD(PPRowId,child)),"^",1)
	..i DepDr'="" d
	...i '$d(^TMPFindTotalDA($j,"DepDr",DepDr)) d
	....s DeptNum=DeptNum+1
	....s ^TMPFindTotalDA($j,"DepDr",DepDr)=ArchivesFilesNo_"^"_CTLOCDesc_"^"_SSName_"^"_PPDesc_"^"_PlanName_"^"_ApplicationUnit_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROCompany_"^"_CROContact_"^"_CROContactTel
	..i UserDr'="" d
	...i '$d(^TMPFindTotalDA($j,"UserDr",UserDr)) d
	....s UserNum=UserNum+1
	....s ^TMPFindTotalDA($j,"UserDr",UserDr)=ArchivesFilesNo_"^"_CTLOCDesc_"^"_SSName_"^"_PPDesc_"^"_PlanName_"^"_ApplicationUnit_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROCompany_"^"_CROContact_"^"_CROContactTel
	..;s Dep=""
	..;if DepDr'="" s Dep=$p($P(^CTLOC(DepDr),"^",2),"-",2)
	..;s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	Do OutputRow11
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow11
	set Data=$lb(ProNum,FileNum,DeptNum,UserNum,EndQualityCtrlNum,$j)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

/// 
/// 
/// 2014-12-30
Query FindDAANProject(Job, TypeNode) As %Query(ROWSPEC = "ArchivesFilesNo,CTLOCDesc,SSName,PPDesc,PlanName,ApplicationUnit,ApplyContact,ApplyContactTel,CROCompany,CROContact,CROContactTel") [ SqlProc ]
{
}

ClassMethod FindDAANProjectClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindDAANProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDAANProjectFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDAANProjectExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotIntergrateQuery","FindTotalDA")
ClassMethod FindDAANProjectExecute(ByRef QHandle As %Binary, Job, TypeNode) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	if (TypeNode="")||(Job="") Set QHandle=$lb(0,repid,0) Quit $$$OK
	s ID=""
	for {
		s ID=$O(^TMPFindTotalDA(Job,TypeNode,ID)) Q:ID=""
		s Data=$g(^TMPFindTotalDA(Job,TypeNode,ID))
		;ArchivesFilesNo_"^"_CTLOCDesc_"^"_SSName_"^"_PPDesc_"^"_PlanName_"^"_ApplicationUnit_"^"_ApplyContact_"^"_ApplyContactTel_"^"_CROCompany_"^"_CROContact_"^"_CROContactTel
		s ArchivesFilesNo=$p(Data,"^",1)
		s CTLOCDesc=$p(Data,"^",2)
		s SSName=$p(Data,"^",3)
		s PPDesc=$p(Data,"^",4)
		s PlanName=$p(Data,"^",5)
		s ApplicationUnit=$p(Data,"^",6)
		s ApplyContact=$p(Data,"^",7)
		s ApplyContactTel=$p(Data,"^",8)
		s CROCompany=$p(Data,"^",9)
		s CROContact=$p(Data,"^",10)
		s CROContactTel=$p(Data,"^",11)
		Do OutputDAANRow
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDAANRow
	set Data=$lb(ArchivesFilesNo,CTLOCDesc,SSName,PPDesc,PlanName,ApplicationUnit,ApplyContact,ApplyContactTel,CROCompany,CROContact,CROContactTel)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

}
