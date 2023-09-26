Import SQLUser

Class web.PilotProject.UDHCDocPilotProRemBefore Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Query FindRemBefore(PPName, User, Amount, Year, Remr) As %Query(ROWSPEC = "RecordSum:%Integer,RowId,RemAmount,Department,StartUser,ProjectName,Remitter,Date,Remark,Project,status,name") [ SqlProc ]
{
}

ClassMethod FindRemBeforeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindRemBeforeExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRemBeforeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRemBeforeExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotProRemBefore","FindRemBefore","","","","","")
ClassMethod FindRemBeforeExecute(ByRef QHandle As %Binary, PPName, User, Amount, Year, Remr) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s RowId=0
	f  s RowId=$o(^DHCDocPPEB(RowId)) q:RowId=""  d
	.;s TPPSOPRowId=PPSOPRowId
	.s RemAmount=$p($g(^DHCDocPPEB(RowId)),"^",1)
	.q:((Amount'=RemAmount)&&(Amount'=""))
	.s Department=$p($g(^DHCDocPPEB(RowId)),"^",3)
	.s StartUser=$p($g(^DHCDocPPEB(RowId)),"^",4)
	.q:(((User'="")&&(User'[StartUser)&&(StartUser'[User))||((User'="")&&(StartUser="")))
	.s ProjectName=$p($g(^DHCDocPPEB(RowId)),"^",5)
	.q:(((PPName'="")&&(PPName'[ProjectName)&&(ProjectName'[PPName))||((PPName'="")&&(ProjectName="")))
	.s Remitter=$p($g(^DHCDocPPEB(RowId)),"^",6)
	.q:(((Remr'="")&&(Remitter'[Remr)&&(Remr'[Remitter))||((Remr'="")&&(Remitter="")))
	.s Date=$p($g(^DHCDocPPEB(RowId)),"^",7)
	.s:Date'="" Date=$zd(Date,3)
	.q:((Year'="")&&(Year'=$p(Date,"-",1)))
	.s Remark=$p($g(^DHCDocPPEB(RowId)),"^",8)
    .s name=$p($g(^DHCDocPPEB(RowId)),"^",2)
	.s Project=""
	.s status="否"
	.s ProjectDr=$p($g(^DHCDocPPEB(RowId)),"^",12)
	.s:ProjectDr'="" status="已匹配"
	.s:ProjectDr'="" Project=$p($g(^DHCDocPP(ProjectDr)),"^",2)
	.q:((Department="")&&(StartUser="")&&(ProjectName="")&&(Remitter="")&&(Date=""))
	.Do OutputRow
	s PPRowId=""
	f  s PPRowId=$o(^DHCDocPPR(PPRowId)) q:PPRowId=""  d
	.b
	.s childsub=""
	.f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	..s ProjectName=$p($g(^DHCDocPP(PPRowId)),"^",2)
	..s RemAmount=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",1)
	..s PPRRemitter=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",3)
	..s PPRRemUserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",2)
	..s PPRRemBeforeDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",13)
	..q:PPRRemBeforeDr'=""
	..s Remitter=""
	..s:PPRRemUserDr'="" Remitter=$p(^SSU("SSUSR",PPRRemUserDr),"^",2)
	..s Date=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",7)
	..s:Date'="" Date=$zd(Date,3)
	..s PPRTimeAdd=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",8)
	..s:PPRTimeAdd'="" PPRTimeAdd=$zt(PPRTimeAdd,1)
	..s PPRState=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",9)
	..s:PPRState="A" PPRState="申请"
	..s:PPRState="V" PPRState="到账"
	..q:PPRState'="到账"
	..s PPRTypeDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",12)
	..i PPRTypeDr="I" s PPRType="IEC"
	..e  i PPRTypeDr="B" s PPRType="备案费"
	..e  i PPRTypeDr="E" s PPRType="项目审核费"
	..e  s PPRType="普通付款"
	..s Account=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",10)
	..s StartUser=""
	..s UserDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",15)
	..s StartUser=##class(web.PilotProject.DHCDocPilotProject).GetPPUserByID(PPRowId,UserDr)
	..s Department=##class(web.PilotProject.DHCDocPilotProject).GetDepartmentByUser(PPRowId,UserDr)
	..s count=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",16)
	..s PPRRowId=PPRowId_"||"_childsub
	..i Account="" s Account=##class(web.PilotProject.DHCDocPilotProject).GetAccountByUser(PPRowId,UserDr)
	..s RowId=""
	..s Remark=PPRType_" "_PPRState
	..;s ProjectName="通过系统录入"
	..s status="通过系统录入,不可匹配"
	..s name=""
	..q:((Amount'=RemAmount)&&(Amount'=""))
	..q:(((User'="")&&(User'[StartUser)&&(StartUser'[User))||((User'="")&&(StartUser="")))
	..q:(((PPName'="")&&(PPName'[ProjectName)&&(ProjectName'[PPName))||((PPName'="")&&(ProjectName="")))
	..q:(((Remr'="")&&(Remitter'[Remr)&&(Remr'[Remitter))||((Remr'="")&&(Remitter="")))
	..q:((Year'="")&&(Year'=$p(Date,"-",1)))
	..Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(0,RowId,RemAmount,Department,StartUser,ProjectName,Remitter,Date,Remark,Project,status,name)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

Query FindProject(PPCode As %String, PPDesc As %String, PPStartDate As %String, PlanNo As %String = "", PlanName As %String, ApplicationUnit As %String, ApprovalNo As %String, PPCreateDepartment As %String, PPStartUser As %String, UserFlag, DeptFlag, AppFlag, Year) As %Query(ROWSPEC = "TPPRowId:%String,TPPCode:%String,TPPDesc:%String,TPPStartDate:%String,TEndDate:%String,TPPCreateDepartment:%String,TPPStartUser:%String,TPPBudget:%String,TPPState:%String,TApproveResult:%String,TEthicsMeetAduitDate:%String,CPRCApproveResult:%String,PPSUpdateReason:%String,PlanNonow,PlanNamenow,ApplicationUnitnow,TIndication,ApplyStage,CROCompany,EthicsMeetDate,SignProtocolDate") [ SqlProc ]
{
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
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindProjectExecute(ByRef QHandle As %Binary, PPCode As %String, PPDesc As %String, PPStartDate As %String, PlanNo As %String = "", PlanName As %String, ApplicationUnit As %String, ApprovalNo As %String, PPCreateDepartment As %String, PPStartUser As %String, UserFlag, DeptFlag, AppFlag, Year) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	
	;d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotProRemBefore","FindProject","","",,"")
	Set repid=$I(^CacheTemp)
	s ind=1
	s count=1
	s PPCode=$ZCVT(PPCode,"U")
	s PPDesc=$ZCVT(PPDesc,"U")
	
	;if ((PPCode="")&&(PPDesc="")) Set QHandle=$lb(0,repid,0)  Quit $$$OK
	if $l(PPStartDate,"/")=3 s PPStartDate=$zdh(PPStartDate,4)
	
	s ^zzy(1)=PPDesc
	
	
	s ProRowId=0 f  s ProRowId=$o(^DHCDocPP(ProRowId)) q:ProRowId=""  d
	.d ResetVariablesPro
	.s dflag=""
	.s ProDesc=$P(^DHCDocPP(ProRowId),"^",2)
	.s ProDesc=$ZCVT(ProDesc,"U")
	.s ProCode=$p($g(^DHCDocPP(ProRowId)),"^",1)
	.s ProCode=$ZCVT(ProCode,"U")
	
	.s ProStartDate=$p($g(^DHCDocPP(ProRowId)),"^",11)
	.if ProStartDate'="" s ProStartDate=$zd(ProStartDate,4)
	.s ProEndDate=$p($g(^DHCDocPP(ProRowId)),"^",13)
	.if ProEndDate'="" s ProEndDate=$zd(ProEndDate,4)
	.S ProCreateDepartmen=""
	.s ProCreateDepartmenDr=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.if ProCreateDepartmenDr'="" s ProCreateDepartmen=$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	.s ProStartUserDr=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.S ProStartUser=""
	.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	.s ProBudget=$p($g(^DHCDocPP(ProRowId)),"^",15)
	.s ProBudget=$j(ProBudget,3,2)
	.s ProState=""
	.s State=$p($g(^DHCDocPP(ProRowId)),"^",16)
	.i State="I" s ProState="审批中"
	.i State="U" s ProState="未批准"
	.i State="N" s ProState="立项"
	.i State="A" s ProState="暂停"
	.i State="S" s ProState="终止"
	.i State="V" s ProState="在研"
	.s childsub=0
	.s PPSUpdateReason=""
	.f  s childsub=$o(^DHCDocPPS(ProRowId,childsub)) q:childsub=""  d
	..s PPSUpdateReason=$p($g(^DHCDocPPS(ProRowId,childsub)),"^",8)
	.s ApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",46)
	.s PlanNonow=$p($g(^DHCDocPP(ProRowId)),"^",26)
	.s PlanNamenow=$p($g(^DHCDocPP(ProRowId)),"^",27)
	.q:((PlanName'="")&&(PlanNamenow'[PlanName))
	.;i PPDesc=""  
	.q:ProDesc=""
	.i (((PPDesc'[ProDesc)&&(PPDesc'=""))&&((ProDesc'[PPDesc)&&(PPDesc'=""))&&(PlanNamenow'[PPDesc)&&(PPDesc'[PlanNamenow)) s dflag=1
	.q:((PlanNo'="")&&(PlanNonow'[PlanNo)&&(PlanNo'[PlanNonow)&&(dflag=1)&&(UserFlag'="on")&&(DeptFlag'="on")&&(AppFlag'="on")&&(Year=""))
	.q:((PlanNo'="")&&(PlanNonow'[PlanNo)&&(PlanNo'[PlanNonow)&&(PPDesc="")&&(UserFlag'="on")&&(DeptFlag'="on")&&(AppFlag'="on")&&(Year=""))
    .q:PlanNo=""&&dflag=1&&(UserFlag'="on")&&(DeptFlag'="on")&&(AppFlag'="on")&&(Year="")
	.;q:((dflag'=1)&&(PlanNo="")&&(PPDesc'=""))
     .s CROCompany=$p($g(^DHCDocPP(ProRowId)),"^",40)
	.s ApplicationUnitnow=$p($g(^DHCDocPP(ProRowId)),"^",25)
	.q:(ApplicationUnit'="")&&(ApplicationUnitnow'[ApplicationUnit)&&((ApplicationUnit'[ApplicationUnitnow))&&(CROCompany'[ApplicationUnit)&&(AppFlag="on")
	.s PilotCategoryDrnow=$p($g(^DHCDocPP(ProRowId)),"^",18)
	.;q:(PilotCategoryDr'="")&&(PilotCategoryDr'=PilotCategoryDrnow)
	.s ApprovalNonow=$p($g(^DHCDocPP(ProRowId)),"^",28)
	.q:(ApprovalNo'="")&&( ApprovalNo'=ApprovalNonow)
	.s ApplyMatterDrnow=$p($g(^DHCDocPP(ProRowId)),"^",23)
	.;q:(ApplyMatterDr'="")&&(ApplyMatterDrnow'=ApplyMatterDr)
	.s ApplyStageDrnow=$p($g(^DHCDocPP(ProRowId)),"^",24)
	.;q:(ApplyStageDr'="")&&(ApplyStageDr'=ApplyStageDrnow)
	.s ApplyStage=""
	.s:ApplyStageDrnow'="" ApplyStage=$p($g(^DHCDocCT("DefineData",+ApplyStageDrnow,"D",$p(ApplyStageDrnow,"||",2))),"^",2)
	.s IsHeadmanDrnow=$p($g(^DHCDocPP(ProRowId)),"^",22)
	.;q:(IsHeadmanDr'="")&&(IsHeadmanDr'=IsHeadmanDrnow)
	.s PPCreateDepartmentDrnow=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.;q:(PPCreateDepartmentDr'="")&&(PPCreateDepartmentDrnow'=PPCreateDepartmentDr)
	.s PPStartUserDrnow=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.;q:(PPStartUserDr'="")&&(PPStartUserDrnow'=PPStartUserDr)
	.s EthicsMeetDate=$p($g(^DHCDocPP(ProRowId)),"^",32)
	.s:EthicsMeetDate'="" EthicsMeetDate=$zd(EthicsMeetDate,4)
	.q:((Year'="")&&($p(EthicsMeetDate,"/",3)'=Year))
	.s EthicsMeetAduitDate=$p($g(^DHCDocPP(ProRowId)),"^",33)
	.s:EthicsMeetAduitDate'="" EthicsMeetAduitDate=$zd(EthicsMeetAduitDate,4)
	.s CPRCApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",48)
	.s SignProtocolDate=$p($g(^DHCDocPP(ProRowId)),"^",37)
	.s:SignProtocolDate'="" SignProtocolDate=$zd(SignProtocolDate,4)
	.i CPRCApproveResult="Y" s CPRCApproveResult="同意"
	.i CPRCApproveResult="N" s CPRCApproveResult="不同意"
	
	
	.s child=0
	.f  s child=$o(^DHCDocPPD(ProRowId,child)) q:child=""  d
	..s User=""
	..s UserDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",2)
	..s DepDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",1)
	..s Dep=""
	..if DepDr'="" s Dep=$p($P(^CTLOC(DepDr),"^",2),"-",2)
	..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..s:User'="" ProStartUser=ProStartUser_","_User
	..s:Dep'="" ProCreateDepartmen=ProCreateDepartmen_","_Dep
	.s TIndication=$p($g(^DHCDocPP(ProRowId)),"^",17)
	.q:((ProStartUser'[PPStartUser)&&(UserFlag="on"))
	.q:((ProCreateDepartmen'[PPCreateDepartment)&&(DeptFlag="on"))
	.Do OutputRowPro
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPro
    ;set Data=$g(^tmpFindProject($j,i,j,k))
	set Data=$lb(ProRowId,ProCode,ProDesc,ProStartDate,ProEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason,PlanNonow,PlanNamenow,ApplicationUnitnow,TIndication,ApplyStage,CROCompany,EthicsMeetDate,SignProtocolDate)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariablesPro
	///set (repid)=0
	set (ProCode,ProDesc,ProStartDate,ProEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason,TIndication)=""
	quit
}

ClassMethod FindProjectClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//d ##class(web.PilotProject.UDHCDocPilotProRemBefore).Check(353,20910)

ClassMethod Check(PPEBRowId As %String, TPPRowId As %String) As %String
{
	s ^zzy(0)=PPEBRowId_"^"_TPPRowId
	
 q:PPEBRowId="" ""
 q:TPPRowId="" ""
 s PayAccount=$p($g(^DHCDocPP(TPPRowId)),"^",50)
 s RemAmount=$p($g(^DHCDocPPEB(PPEBRowId)),"^",1)
 s Department=$p($g(^DHCDocPPEB(PPEBRowId)),"^",3)
 s StartUser=$p($g(^DHCDocPPEB(PPEBRowId)),"^",4)
 s ProjectName=$p($g(^DHCDocPPEB(PPEBRowId)),"^",5)
 s Remitter=$p($g(^DHCDocPPEB(PPEBRowId)),"^",6)
 s Date=$p($g(^DHCDocPPEB(PPEBRowId)),"^",7)
 s Remark=$p($g(^DHCDocPPEB(PPEBRowId)),"^",8)
 s FirstPay=$p($g(^DHCDocPPEB(PPEBRowId)),"^",13)
 s Type=$p($g(^DHCDocPPEB(PPEBRowId)),"^",11)
 s Name=$p($g(^DHCDocPPEB(PPEBRowId)),"^",2)
 if Name="IEC" s Type="I"
 if Name="备案" s Type="B"
 s myrtn=0
 TS
 &sql(delete from DHC_DocPilotProRem where PPR_RemBefore_Dr=:PPEBRowId)
 &sql(update DHC_DocPilotProRemBefore set PPEB_PProject_Dr=:TPPRowId where PPEB_RowId=:PPEBRowId) 
 s myrtn=SQLCODE
 i +myrtn=0{
	 s UObj=##class(User.DHCDocPilotProRem).%New(TPPRowId)
	d UObj.PPRPPParRefSetObjectId(TPPRowId)
	s UObj.PPRRemAmount=RemAmount
	;d UObj.PPRRemUserDrSetObjectId(PPRRemUserDr)
	s UObj.PPRDateAdd=Date
	s UObj.PPRRemitter=Remitter
	s UObj.PPRState="V"
	i Type="" s UObj.PPRAccount=PayAccount
	s UObj.PPRFirstPay=FirstPay
	s UObj.PPRType=Type
	i ((Type="I")||(Type="B")) s UObj.PPRAccount="V000001"
	s UObj.PPRRemark=Remark
	s UObj.PPRRemBeforeDr=PPEBRowId
	s UObj.PPRUser=StartUser
	Set sc = UObj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	 
 }
 if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

Query FindAccount(PPName, Acc, ProStartUser) As %Query(ROWSPEC = "RecordSum:%Integer,RowId,Account,AccountSum,ProjectName,status,Project") [ SqlProc ]
{
}

ClassMethod FindAccountClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAccountExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAccountFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAccountExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotProRemBefore","FindAccount","赵","")
ClassMethod FindAccountExecute(ByRef QHandle As %Binary, PPName, Acc, ProStartUser) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s RowId=0
	s ^zzy("FindAccountExecute")=PPName_"^"_Acc
	f  s RowId=$o(^DHCDocPPA(RowId)) q:RowId=""  d
	.s Account=$p($g(^DHCDocPPA(RowId)),"^",1)
	.i Account'="" s ^TMPAccount($j,Account)=""
	.q:((Acc'="")&&(Acc'=Account))
	.s ProjectName=$p($g(^DHCDocPPA(RowId)),"^",2)
	.q:ProjectName=""
	.q:(ProjectName'[PPName)
	.q:(ProjectName'[ProStartUser)
	.s AccountSum=$p($g(^DHCDocPPA(RowId)),"^",4)
	.s Project=""
	.s status="否"
	.s ProjectDr=$p($g(^DHCDocPPA(RowId)),"^",3)
	.s:ProjectDr'="" status="已匹配"
	.s:ProjectDr'="" Project=$p($g(^DHCDocPP(ProjectDr)),"^",2)
	.Do OutputRow1
	s PPRowId=""
	s RowId=""
	s AccountSum=""
	s status="新建账号"
	s Project=""
	f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
	.s ProjectName=$p($g(^DHCDocPP(PPRowId)),"^",2)
	.s Account=$p($g(^DHCDocPP(PPRowId)),"^",50)
	.s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	.s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	.s UserDr=UserUserDr
	.i UserDr="" s UserDr=ProStartUserDr
	.s AccountSum=##class(web.PilotProject.DHCDocPilotProject).GetRemNum(PPRowId,UserDr)
	.s User=""
	.s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	.s ProjectName=User_"-"_ProjectName
	.q:((Acc'="")&&(Acc'=Account))
	.q:ProjectName=""
	.q:(ProjectName'[PPName)
	.q:(ProjectName'[ProStartUser)
	.i Account'="" d
	..q:$d(^TMPAccount($j,Account))
	..d OutputRow1
	.s chil=0
	.f  s chil=$o(^DHCDocPPD(PPRowId,chil)) q:chil=""  d
	..s ProjectName=$p($g(^DHCDocPP(PPRowId)),"^",2)
	..s ProStartUserDr1=""
	..s UserUserDr1=""
	..s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,chil)),"^",2)
	..s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,chil)),"^",3)
	..s UserDr=UserUserDr1
	..i UserDr="" s UserDr=ProStartUserDr1
	..s AccountSum=##class(web.PilotProject.DHCDocPilotProject).GetRemNum(PPRowId,UserDr)
	..s User=""
	..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..s ProjectName=User_"-"_ProjectName
	..s Account=""
	..s Account=$p($g(^DHCDocPPD(PPRowId,chil)),"^",4)
	..q:((Acc'="")&&(Acc'=Account))
	..q:ProjectName=""
	..q:(ProjectName'[PPName)
	..q:(ProjectName'[ProStartUser)
	..i Account'="" d
	...q:$d(^TMPAccount($j,Account))
	...d OutputRow1
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(0,RowId,Account,AccountSum,ProjectName,status,Project)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

//D ##class(web.PilotProject.UDHCDocPilotProRemBefore).CheckUser()

ClassMethod CheckUser()
{
	s PPRowId=0 
	f  s PPRowId=$o(^DHCDocPP(PPRowId)) q:PPRowId=""  d
	.s childsub=""
	.f  s childsub=$o(^DHCDocPPR(PPRowId,childsub)) q:childsub=""  d
	..s PPRRemBeforeDr=$p($g(^DHCDocPPR(PPRowId,childsub)),"^",13)
	..Q:PPRRemBeforeDr=""
	..s StartUser=$p($g(^DHCDocPPEB(PPRRemBeforeDr)),"^",4)
	..s $p(^DHCDocPPR(PPRowId,childsub),"^",14)=StartUser
}

Query FindAccProject(PPCode As %String, PPDesc As %String, PPStartDate As %String, PlanNo As %String = "", PlanName As %String, ApplicationUnit As %String, ApprovalNo As %String, PPCreateDepartment As %String, PPStartUser As %String, UserFlag, DeptFlag, AppFlag, Year, PPARowId) As %Query(ROWSPEC = "TPPRowId:%String,TPPCode:%String,TPPDesc:%String,TPPStartDate:%String,TEndDate:%String,TPPCreateDepartment:%String,TPPStartUser:%String,TPPBudget:%String,TPPState:%String,TApproveResult:%String,TEthicsMeetAduitDate:%String,CPRCApproveResult:%String,PPSUpdateReason:%String,PlanNonow,PlanNamenow,ApplicationUnitnow,TIndication,ApplyStage,CROCompany,EthicsMeetDate,SignProtocolDate") [ SqlProc ]
{
}

ClassMethod FindAccProjectFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAccProjectExecute ]
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

ClassMethod FindAccProjectExecute(ByRef QHandle As %Binary, PPCode As %String, PPDesc As %String, PPStartDate As %String, PlanNo As %String = "", PlanName As %String, ApplicationUnit As %String, ApprovalNo As %String, PPCreateDepartment As %String, PPStartUser As %String, UserFlag, DeptFlag, AppFlag, Year, PPARowId) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	s ^scl("FindAccProject")=PPCode_","_PPDesc_","_PPStartDate_","_PlanNo_","_PlanName_","_ApplicationUnit_","_ApprovalNo_","_PPCreateDepartment_","_PPStartUser_","_UserFlag_","_DeptFlag_","_AppFlag_","_Year_","_PPARowId
	;d ##class(%ResultSet).RunQuery("web.PilotProject.UDHCDocPilotProRemBefore","FindAccProject","","",,"")
	Set repid=$I(^CacheTemp)
	s ind=1
	s count=1
	s PPCode=$ZCVT(PPCode,"U")
	s PPDesc=$ZCVT(PPDesc,"U")
	
	;if ((PPCode="")&&(PPDesc="")) Set QHandle=$lb(0,repid,0)  Quit $$$OK
	if $l(PPStartDate,"/")=3 s PPStartDate=$zdh(PPStartDate,4)
	
	s ^zzy(1)=PPDesc
	
	
	s ProRowId=0 f  s ProRowId=$o(^DHCDocPP(ProRowId)) q:ProRowId=""  d
	.d ResetVariablesPro1
	.s dflag=""
	.s ProDesc=$P(^DHCDocPP(ProRowId),"^",2)
	.s ProDesc=$ZCVT(ProDesc,"U")
	.s ProCode=$p($g(^DHCDocPP(ProRowId)),"^",1)
	.s ProCode=$ZCVT(ProCode,"U")
	
	.s ProStartDate=$p($g(^DHCDocPP(ProRowId)),"^",11)
	.if ProStartDate'="" s ProStartDate=$zd(ProStartDate,4)
	.s ProEndDate=$p($g(^DHCDocPP(ProRowId)),"^",13)
	.if ProEndDate'="" s ProEndDate=$zd(ProEndDate,4)
	.S ProCreateDepartmen=""
	.s ProCreateDepartmenDr=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.if ProCreateDepartmenDr'="" s ProCreateDepartmen=$p($P(^CTLOC(ProCreateDepartmenDr),"^",2),"-",2)
	.s ProStartUserDr=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.S ProStartUser=""
	.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	.s ProBudget=$p($g(^DHCDocPP(ProRowId)),"^",15)
	.s ProBudget=$j(ProBudget,3,2)
	.s ProState=""
	.s State=$p($g(^DHCDocPP(ProRowId)),"^",16)
	.i State="I" s ProState="审批中"
	.i State="U" s ProState="未批准"
	.i State="N" s ProState="立项"
	.i State="A" s ProState="暂停"
	.i State="S" s ProState="终止"
	.i State="V" s ProState="在研"
	.s childsub=0
	.s PPSUpdateReason=""
	.f  s childsub=$o(^DHCDocPPS(ProRowId,childsub)) q:childsub=""  d
	..s PPSUpdateReason=$p($g(^DHCDocPPS(ProRowId,childsub)),"^",8)
	.s ApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",46)
	.s PlanNonow=$p($g(^DHCDocPP(ProRowId)),"^",26)
	.s PlanNamenow=$p($g(^DHCDocPP(ProRowId)),"^",27)
	.q:((PlanName'="")&&(PlanNamenow'[PlanName))
	.;i PPDesc=""  
	.q:ProDesc=""
	.i (((PPDesc'[ProDesc)&&(PPDesc'=""))&&((ProDesc'[PPDesc)&&(PPDesc'=""))&&(PlanNamenow'[PPDesc)&&((PPDesc'[PlanNonow&&PlanNonow'="")||(PlanNonow=""))) s dflag=1
	.q:((PlanNo'="")&&(PlanNonow'[PlanNo)&&(PlanNo'[PlanNonow)&&(dflag=1)&&(UserFlag'="on")&&(DeptFlag'="on")&&(AppFlag'="on")&&(Year=""))
	.q:((PlanNo'="")&&(PlanNonow'[PlanNo)&&(PlanNo'[PlanNonow)&&(PPDesc="")&&(UserFlag'="on")&&(DeptFlag'="on")&&(AppFlag'="on")&&(Year=""))
    .i ProDesc["折叠式人工玻璃" b //123
    .q:PlanNo=""&&dflag=1&&(UserFlag'="on")&&(DeptFlag'="on")&&(AppFlag'="on")&&(Year="")
    .//w ProDesc,!
	.;q:((dflag'=1)&&(PlanNo="")&&(PPDesc'=""))
     .s CROCompany=$p($g(^DHCDocPP(ProRowId)),"^",40)
	.s ApplicationUnitnow=$p($g(^DHCDocPP(ProRowId)),"^",25)
	.q:(ApplicationUnit'="")&&(ApplicationUnitnow'[ApplicationUnit)&&((ApplicationUnit'[ApplicationUnitnow))&&(CROCompany'[ApplicationUnit)&&(AppFlag="on")
	.s PilotCategoryDrnow=$p($g(^DHCDocPP(ProRowId)),"^",18)
	.;q:(PilotCategoryDr'="")&&(PilotCategoryDr'=PilotCategoryDrnow)
	.s ApprovalNonow=$p($g(^DHCDocPP(ProRowId)),"^",28)
	.q:(ApprovalNo'="")&&( ApprovalNo'=ApprovalNonow)
	.s ApplyMatterDrnow=$p($g(^DHCDocPP(ProRowId)),"^",23)
	.;q:(ApplyMatterDr'="")&&(ApplyMatterDrnow'=ApplyMatterDr)
	.s ApplyStageDrnow=$p($g(^DHCDocPP(ProRowId)),"^",24)
	.;q:(ApplyStageDr'="")&&(ApplyStageDr'=ApplyStageDrnow)
	.s ApplyStage=""
	.s:ApplyStageDrnow'="" ApplyStage=$p($g(^DHCDocCT("DefineData",+ApplyStageDrnow,"D",$p(ApplyStageDrnow,"||",2))),"^",2)
	.s IsHeadmanDrnow=$p($g(^DHCDocPP(ProRowId)),"^",22)
	.;q:(IsHeadmanDr'="")&&(IsHeadmanDr'=IsHeadmanDrnow)
	.s PPCreateDepartmentDrnow=$p($g(^DHCDocPP(ProRowId)),"^",6)
	.;q:(PPCreateDepartmentDr'="")&&(PPCreateDepartmentDrnow'=PPCreateDepartmentDr)
	.s PPStartUserDrnow=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.;q:(PPStartUserDr'="")&&(PPStartUserDrnow'=PPStartUserDr)
	.s EthicsMeetDate=$p($g(^DHCDocPP(ProRowId)),"^",32)
	.s:EthicsMeetDate'="" EthicsMeetDate=$zd(EthicsMeetDate,4)
	.q:((Year'="")&&($p(EthicsMeetDate,"/",3)'=Year))
	.s EthicsMeetAduitDate=$p($g(^DHCDocPP(ProRowId)),"^",33)
	.s:EthicsMeetAduitDate'="" EthicsMeetAduitDate=$zd(EthicsMeetAduitDate,4)
	.s CPRCApproveResult=$p($g(^DHCDocPP(ProRowId)),"^",48)
	.s SignProtocolDate=$p($g(^DHCDocPP(ProRowId)),"^",37)
	.s:SignProtocolDate'="" SignProtocolDate=$zd(SignProtocolDate,4)
	.i CPRCApproveResult="Y" s CPRCApproveResult="同意"
	.i CPRCApproveResult="N" s CPRCApproveResult="不同意"
	
	
	.s child=0
	.f  s child=$o(^DHCDocPPD(ProRowId,child)) q:child=""  d
	..s User=""
	..s UserDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",2)
	..s DepDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",1)
	..s Dep=""
	..if DepDr'="" s Dep=$p($P(^CTLOC(DepDr),"^",2),"-",2)
	..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..s:User'="" ProStartUser=ProStartUser_","_User
	..s:Dep'="" ProCreateDepartmen=ProCreateDepartmen_","_Dep
	.s TIndication=$p($g(^DHCDocPP(ProRowId)),"^",17)
	.q:((ProStartUser'[PPStartUser)&&(UserFlag="on"))
	.q:((ProCreateDepartmen'[PPCreateDepartment)&&(DeptFlag="on"))
	.Do OutputRowPro1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPro1
    ;set Data=$g(^tmpFindProject($j,i,j,k))
	set Data=$lb(ProRowId,ProCode,ProDesc,ProStartDate,ProEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason,PlanNonow,PlanNamenow,ApplicationUnitnow,TIndication,ApplyStage,CROCompany,EthicsMeetDate,SignProtocolDate)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariablesPro1
	///set (repid)=0
	set (ProCode,ProDesc,ProStartDate,ProEndDate,ProCreateDepartmen,ProStartUser,ProBudget,ProState,ApproveResult,EthicsMeetAduitDate,CPRCApproveResult,PPSUpdateReason,TIndication)=""
	quit
}

ClassMethod FindAccProjectClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAccProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckAccount(PPARowId As %String, TPPRowId As %String) As %String
{
	s ^zzy(0)=PPARowId_"^"_TPPRowId
	
 q:PPARowId="" ""
 q:TPPRowId="" ""

 s myrtn=0
 TS
	s ProStartUserDr=$p($g(^DHCDocPP(TPPRowId)),"^",10)
  	s UObj=##class(User.DHCDocPilotProAccount).%OpenId(PPARowId)
	d UObj.ProjectDrSetObjectId(TPPRowId)
	d UObj.UserDrSetObjectId(ProStartUserDr)
	s PayAccount=UObj.Account
	Set sc = UObj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()

 if +myrtn=0{
	 &sql(update DHC_DocPilotProject set PP_PayAccount=:PayAccount where PP_RowId=:TPPRowId)
	  s myrtn=SQLCODE
 }
 if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

ClassMethod CheckAccount1(PPARowId As %String, TPPRowId As %String, UserDr As %String) As %String
{
	s ^zzy(0)=PPARowId_"^"_TPPRowId_"^"_UserDr
	
 q:PPARowId="" ""
 q:TPPRowId="" ""
 q:UserDr="" ""

 s myrtn=0
 TS
	s ProStartUserDr=$p($g(^DHCDocPP(TPPRowId)),"^",10)
  	s UObj=##class(User.DHCDocPilotProAccount).%OpenId(PPARowId)
	d UObj.ProjectDrSetObjectId(TPPRowId)
  	d UObj.UserDrSetObjectId(UserDr)
	s AccountSum=UObj.AccountSum
	s PayAccount=UObj.Account
	Set sc = UObj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()

 if +myrtn=0{
	 if (UserDr=ProStartUserDr){
	 &sql(update DHC_DocPilotProject set PP_PayAccount=:PayAccount,PP_AccountSum=:AccountSum where PP_RowId=:TPPRowId)
	  s myrtn=SQLCODE
	 }else{
		 &sql(update DHC_DocPilotProDept set PPD_Account=:PayAccount,PPD_AccountSum=:AccountSum where PPD_PP_ParRef=:TPPRowId and PPD_StartUser_Dr=:UserDr)
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

}
