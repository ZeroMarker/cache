/// CTOR: QP
/// DATE: 2020-06-28
/// DESC: 化疗申请单
Class DHCDoc.Chemo.BS.Find Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-05-14
/// DESC: 查询化疗组项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Find","QryPlan",^TEMP("QryPlan",1))
Query QryPlan(ParaList = "", InHosp = "") As %Query(ROWSPEC = "id,PatDR,PatName,PatNo,PLName,TPID,Dep,DepDesc,User,UserName,Adm,Status,Note,PLDate,PLTime,StatusCode")
{
}

ClassMethod QryPlanExecute(ByRef qHandle As %Binary, ParaList = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s ^TEMP("QryPlan",1)=ParaList
 	s langid=..%LanguageID()
 	s InPatNo=$p(ParaList,$C(1),1)
 	s InPatName=$p(ParaList,$C(1),2)
 	s InStartDate=$p(ParaList,$C(1),3)
 	s InEndDate=$p(ParaList,$C(1),4)
 	s InOrderLoc=$p(ParaList,$C(1),5)
 	s InOrderDoc=$p(ParaList,$C(1),6)
 	s InPlanName=$p(ParaList,$C(1),7)
 	S InPlanName=$zcvt(InPlanName,"U")
 	s InStartDate=##class(websys.Conversions).DateHtmlToLogical(InStartDate)
 	s InEndDate=##class(websys.Conversions).DateHtmlToLogical(InEndDate)
 	k TempList
 	
 	s PLID="",Count=0
 	f  s PLID=$o(^BS.DOC.Chemo.PlanD(PLID)) q:PLID=""  d
 	.s PatDR=$p(^BS.DOC.Chemo.PlanD(PLID),"^",1)
 	.;q:'$d(^PAPER(PatDR,"ALL",1))
 	.s PatName=$p($g(^PAPER(PatDR,"ALL")),"^",1)
 	.s PatNo=$p(^PAPER(PatDR,"PAT",1),"^",1)
 	.s PLName=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)
 	.s PLName=##class(User.ChemoTemplate).GetTranByDesc("TPName",PLName,langid)
 	.s PLNameU=$zcvt(PLName,"U")
 	.s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
 	.s Dep=$p(^BS.DOC.Chemo.PlanD(PLID),"^",4)
 	.s hospDr=$p(^CTLOC(Dep),"^",22)
 	.q:(InHosp'="")&&(hospDr'=InHosp)
 	.s DepDesc=$p(^CTLOC(Dep),"^",2)
 	.s DepDesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DepDesc,langid)
 	.s User=$p(^BS.DOC.Chemo.PlanD(PLID),"^",5)
 	.s UserName=$p(^SSU("SSUSR",User),"^",2)
 	.s UserName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",UserName,langid)
 	.s Adm=$p(^BS.DOC.Chemo.PlanD(PLID),"^",6)
 	.s Status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
 	.q:Status="D"
 	.s StatusCode=Status
 	.s Status=##class(DHCDoc.Chemo.COM.Func).GetPlanStatusDesc(Status)
 	.s Status=##class(websys.Translation).Get("chemo.bs.find.csp",Status)
	.s Note=$p(^BS.DOC.Chemo.PlanD(PLID),"^",8)
	.s PLDateNum=$p(^BS.DOC.Chemo.PlanD(PLID),"^",10)
	.s PLTimeNum=$p(^BS.DOC.Chemo.PlanD(PLID),"^",11)
	.;s isEixt=$$Filter()
	.;q:isEixt=1
 	.d Filter

	s num=""
	f  s num=$o(TempList(num),-1) q:num=""  d
	.s outdata=TempList(num)
	.d output1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Filter
	q:(InStartDate'="")&&(PLDate<InStartDate)
	q:(InEndDate'="")&&(PLDate>InEndDate)
	q:(InPatNo'="")&&(InPatNo'=PatNo)
	q:(InPatName'="")&&(PatName'[InPatName)
	q:(InOrderLoc'="")&&(InOrderLoc'=Dep)
	q:(InOrderDoc'="")&&(InOrderDoc'=User)
	q:(InPlanName'="")&&(PLNameU'[InPlanName)
	s PLDate=##class(websys.Conversions).DateLogicalToHtml(PLDateNum)
	i PLTimeNum'="" s PLTime=$zt(PLTimeNum,2)
	s Count=Count+1
	if PLDateNum'="" { 
		s TempList(PLDateNum_PLTimeNum)=$lb(PLID,PatDR,PatName,PatNo,PLName,TPID,Dep,DepDesc,User,UserName,Adm,Status,Note,PLDate,PLTime,StatusCode)
	}else  {
		s TempList(99_Count)=$lb(PLID,PatDR,PatName,PatNo,PLName,TPID,Dep,DepDesc,User,UserName,Adm,Status,Note,PLDate,PLTime,StatusCode)
	}
	;d output1
	
	Q

output1
	Set Data=outdata	//$lb(PLID,PatDR,PatName,PatNo,PLName,TPID,Dep,DepDesc,User,UserName,Adm,Status,Note,PLDate,PLTime,StatusCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPlanExecute ]
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

}
