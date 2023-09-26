/// CTOR: QP
/// DATE: 2021-08-30
/// DESC: 交班本主界面润乾工具类
Class DHCDoc.PW.RPX.GZTH Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-20
/// DESC: 查询统计值
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.RPX.GZTH","QryPrintData","4","113","2021-08-30","M")
Query QryPrintData(NID = "", LocId, BCDate, InBCCode) As %Query(ROWSPEC = "mDate,mTitle,OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum,SubmitUser,AcceptUser") [ SqlProc ]
{
}

ClassMethod QryPrintDataExecute(ByRef qHandle As %Binary, NID = "", LocId, BCDate, InBCCode) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^QP("QryPrintData")=$LB(NID="",LocId, BCDate, InBCCode)
 	s BCDateHtml = BCDate
 	s BCDate = ##class(websys.Conversions).DateHtmlToLogical(BCDate)
 	s BCDate3=$ZD(BCDate,3)
 	;s BCDateHtml = ##class(websys.Conversions).DateLogicalToHtml(BCDate)
	i NID="" s NID=##class(DHCDoc.PW.COM.Method).GetNID(LocId,BCDate,InBCCode)
	i (NID="") {
	 	 Set qHandle=$lb(0,repid,0)
		 Quit $$$OK
	}
	s LocDesc=$P(^CTLOC(LocId),"^",2)
	s NXML = $lg(^User.DHCDocPassWorkNMainD(NID),7) 
	s BCName = $lg(^User.DHCDocPassWorkNMainD(NID),10) 
	s SubmitUser = $lg(^User.DHCDocPassWorkNMainD(NID),6) 
	s AcceptUser = $lg(^User.DHCDocPassWorkNMainD(NID),17) 
	i SubmitUser'="" s SubmitUser=$P(^SSU("SSUSR",SubmitUser),"^",2)
	i AcceptUser'="" s AcceptUser=$P(^SSU("SSUSR",AcceptUser),"^",2)
	s SubmitUser="交班人："_SubmitUser
	s AcceptUser="接班人："_AcceptUser
	s mDate=$P(BCDate3,"-",1)_"年"_+$P(BCDate3,"-",2)_"月"_+$P(BCDate3,"-",3)_"日"
	s mTitle=LocDesc_"科 "_BCName_"值班交接记录表"
	d ##class(DHCDoc.PW.COM.Method).ParseXML(NXML,.XMList)
	s elements=##class(DHCDoc.PW.CFG.BCPatType).GetActiveTypeStr("",LocId)
	s (OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum)=""
	s Len = $l(elements,"^")
	f i=1:1:Len  {
		s record=$p(elements,"^",i)
		s cName=$p(record,":",1)
		s cDesc=$p(record,":",2)
		s cValue=0
		i $d(XMList(cName)) s cValue=XMList(cName)
		s cContent=cValue
		i cName="OutHospNum" s OutHospNum=cContent
		i cName="PreSum" s PreSum=cContent
		i cName="InHospNum" s InHospNum=cContent
		i cName="OutWardNum" s OutWardNum=cContent
		i cName="InWardNum" s InWardNum=cContent
		i cName="OperNum" s OperNum=cContent
		i cName="SeverityNum" s SeverityNum=cContent
		i cName="CritiNum" s CritiNum=cContent
		i cName="DeathNum" s DeathNum=cContent
		i cName="NowSum" s NowSum=cContent
	}
	d OutwardRow
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(mDate,mTitle,OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum,SubmitUser,AcceptUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryPrintDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrintDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPrintDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrintDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 查询项目明细
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.RPX.GZTH","ItemSubQry","4","2021-08-30","113","12175","M")
Query ItemSubQry(NID = "", BCDate, LocId, UserId, InBCCode, InHBPType = "", InPatNo = "", InExt = "", InNoType = "") As %Library.Query(ROWSPEC = "SID,EpisodeID,PType,PatName,PatNo,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,SubmitContent,SubmitUser,FillFlag,EZLPlan,EQuestion,EMainAction") [ SqlProc ]
{
}

ClassMethod ItemSubQryExecute(ByRef qHandle As %Library.Binary, NID = "", BCDate, LocId, UserId, InBCCode, InHBPType = "", InPatNo = "", InExt = "", InNoType = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^QP("ItemSubQry")=$LB(NID, BCDate, LocId, UserId, InBCCode, InHBPType,InPatNo)
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)
	s FoldBC=##class(DHCDoc.PW.CFG.BCRule).GetRuleValue(LocId,"FoldBC")
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	s IsSelf=$p(InExt,$C(1),1)	//1是本科室，0是本人
	s InFillFlag=$p(InExt,$C(1),2)	//填写标志
	i IsSelf="" s IsSelf=1
	i NID="" {
		s CTime=$p($h,",",2)
		d ##class(DHCDoc.PW.BS.DataFunc).GetLocItemSummary(LocId, BCDate, BCDate, CTime, "", UserId, InBCCode,.DList)
		s CType=""
		f  s CType=$o(^||BS.PW.NMain("RealCount",LocId,BCDate,InBCCode,CType)) q:CType=""  d
		.;q:(InHBPType'="")&&(InHBPType'=CType)
		.q:##class(DHCDoc.PW.BS.NSub).ContainPType(InHBPType,CType)=1
		.q:##class(DHCDoc.PW.BS.NSub).FilterNoPType(InNoType,CType)=1
		.s PType=##class(DHCDoc.PW.BS.NSub).GetPTypeDesc(CType,MID)
		.q:PType=""
		.s EpisodeID=""
		.f  s EpisodeID=$o(^||BS.PW.NMain("RealCount",LocId,BCDate,InBCCode,CType,EpisodeID)) q:EpisodeID=""  d
		..s SID="",sub=""
		..d OuputRow1
	} else {
		s sub=""
		f  s sub=$o(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub)) Q:sub=""  d
		.s EpisodeID=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub),3)
		.s SID=NID_"||"_sub
		.i FoldBC=1 d	;展开
		..s CHL=""
		..f  s CHL=$O(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub,"ChildType",CHL)) Q:CHL=""  D
		...S PType=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub,"ChildType",CHL),3)
		...Q:##class(DHCDoc.PW.CFG.BCPatType).IsHiddenByCode(MID,PType)=0
		...;Q:(InHBPType'="")&&(PType'[InHBPType)
		...q:##class(DHCDoc.PW.BS.NSub).ContainPType(InHBPType,PType)=1
		...q:##class(DHCDoc.PW.BS.NSub).FilterNoPType(InNoType,PType)=1
		...s PType=##class(DHCDoc.PW.BS.NSub).GetPTypeDesc(PType,MID)
		...q:PType=""
		...d OuputRow1
		.e  d		;合并
		..s PType=##class(DHCDoc.PW.BS.NSub).GetPType(SID,EpisodeID,MID)
		..;Q:(InHBPType'="")&&(PType'[InHBPType)
		..Q:##class(DHCDoc.PW.BS.NSub).ContainPType(InHBPType,PType)=1
		..Q:##class(DHCDoc.PW.BS.NSub).FilterNoPType(InNoType,PType)=1
		..s PType=##class(DHCDoc.PW.BS.NSub).GetPTypeDesc(PType,MID)
		..q:PType=""
		..d OuputRow1
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	s AdmDocId=$p(^PAADM(EpisodeID),"^",9)
	s uid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(AdmDocId)
	q:(IsSelf=0)&&(uid'=UserId)
	s PatWard=$p(^PAADM(EpisodeID),"^",70)
	i PatWard'="" s PatWard=$p(^PAWARD(PatWard),"^",5)
	;q:(FindWard'="")&&(FindWard'=PatWard)
	i PatWard'="" s PatWardDesc=$p(^CTLOC(PatWard),"^",2)
	s AdmDocDesc=""
	i AdmDocId'="" s AdmDocDesc=$p(^CTPCP(AdmDocId,1),"^",2)
	;q:(USERCareID'="")&&(AdmDocId'=USERCareID)
	;s PatWorkTypeDesc=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",1)
	;s isNeedDisplay=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",2)
	;q:isNeedDisplay'=1
	s PatInfo=##class(web.DHCDocPassWork).GetPatInfo(EpisodeID)
	s PatNo=$p(PatInfo,"^",2)
	q:(InPatNo'="")&&(InPatNo'=PatNo)
	s PatName=$p(PatInfo,"^",3)
	s PatSex=$p(PatInfo,"^",4)
	s PatAge=$p(PatInfo,"^",5)
	s PatDiagnos=$p(PatInfo,"^",9)
	s PatOperName=##class(DHCDoc.PW.COM.Method).GetOperNameByAdmid(EpisodeID)
	s PatMedicareNo=$p(PatInfo,"^",6)
	s CurBedCode=$p(PatInfo,"^",14)
	s FillFlag=0
	i SID'="" {
		s SubmitContent=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",sub),9)
		i SubmitContent'="" s FillFlag=1
		e  s FillFlag=2
	}
	q:(InFillFlag'="")&&(InFillFlag'=FillFlag)
	s SubmitUser=""		
	s EZLPlan="",EQuestion="",EMainAction=""
	s EID=##class(DHCDoc.PW.BS.NSubExt).GetEID(SID)
	;扩展
	i EID'="" {
		s EZLPlan=$lg(^User.DHCDocPassWorkNSubExtD(EID),3)
		s EQuestion=$lg(^User.DHCDocPassWorkNSubExtD(EID),4)
		s EMainAction=$lg(^User.DHCDocPassWorkNSubExtD(EID),5)
	}
	set Data=$lb(SID,EpisodeID,PType,PatName,PatNo,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,SubmitContent,SubmitUser,FillFlag,EZLPlan,EQuestion,EMainAction)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ItemSubQryFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemSubQryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
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
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ItemSubQryClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemSubQryFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
