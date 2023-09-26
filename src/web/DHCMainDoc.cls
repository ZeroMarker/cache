Import SQLUser

Class web.DHCMainDoc Extends %RegisteredObject
{

Query FindLocPatient(LocId As %String = "", DocId As %String = "") As %Query(ROWSPEC = "EpisodeID,regNo,bedCode,patName,DocDes")
{
}

ClassMethod FindLocPatientExecute(ByRef qHandle As %Binary, LocId As %String = "", DocId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1	
 	;i DocId="" s DocId=%request.Get("DocId")
 
    //取值未分配医生Checkbookvalue
 	i DocId="" d
 	.s DocId="ALL"
 	//.s userID=%session.Data("LOGON.USERID")
 	//.i userID'="" s DocId=$p($g(^SSU("SSUSR",userID)),"^",14)
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	s admDate=""
	f  s admDate=$O(^PAADMi("CurrLoc",LocId,admDate)) q:admDate=""  d
	.s admTime="" f  s admTime=$O(^PAADMi("CurrLoc",LocId,admDate,admTime)) q:admTime=""  d
    ..s RowId="" f  s RowId=$O(^PAADMi("CurrLoc",LocId,admDate,admTime,RowId)) q:RowId=""  d
    ...s EpisodeID=RowId
    ...s VistStatus=$P(^PAADM(RowId),"^",20)
	...q:VistStatus="D"
	...s CurDoc=$P(^PAADM(RowId),"^",9)
	...q:(CurDoc'=DocId)&(DocId'="")&(DocId'="ALL")
	...q:(DocId="ALL")&(CurDoc'="")
	...s regNo=##class(web.DHCCLCom).GetRegNobyEpisodeID(RowId)
	...s DocDes=""
	...i CurDoc'="" s DocDes=$P($g(^CTPCP(CurDoc,1)),"^",2)
	...e  s DocDes=""
	...s papmiId=+$g(^PAADM(+RowId))
    ...q:papmiId=0
	...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	...s bedId=$p($g(^PAADM(RowId)),"^",73)
	...s curWardId=$p(bedId,"||")
	...s bedSub=$p(bedId,"||",2)
    ...s bedCode=""
    ...i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    ...i bedCode'="" s bedCode=bedCode_"床"
 	...d OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(EpisodeID,regNo,bedCode,patName,$g(DocDes))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocPatientExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDocByLoc(IsAdmit As %String = "", LocId As %String = "", Input As %String = "") As %Query(ROWSPEC = "DocId,DocDesc")
{
}

ClassMethod GetDocByLocExecute(ByRef qHandle As %Binary, IsAdmit As %String = "", LocId As %String = "", Input As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s userID=%session.Data("LOGON.USERID")
 	i userID'="" s curdocID=$p($g(^SSU("SSUSR",userID)),"^",14)
 	e  s curdocID=""
 	s IsAdmit=$g(IsAdmit)
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocId,ResRowId)) q:(ResRowId="")  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.q:DocId=""
	.q:(IsAdmit="N")&(curdocID'=DocId)
	.s DocDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.s DateTo=$p($G(^RB("RES",ResRowId)),"^",19)
	.q:(DateTo'="")&(DateTo<+$H)
	.s CTCPTypeId=$P($G(^CTPCP(DocId,1)),"^",4)
	.q:CTCPTypeId=""
	.s CTCPType=$P($G(^CT("CPT",CTCPTypeId)),"^",4)
	.q:CTCPType'="DOCTOR"
	.s CTCPCode=$P($G(^CTPCP(DocId,1)),"^",1)
	.s CTCPDesc=$P($G(^CTPCP(DocId,1)),"^",2)
	.q:(CTCPCode'[Input)&(CTCPDesc'[Input)&(Input'="") //lq
 	.d OutputRow1
 	i IsAdmit="N" d
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DocId,DocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocByLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDocByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod TransferDoc(EpisodeID As %String, TransToDoc As %String, locId As %String, userId As %String) As %String
{
	q:(EpisodeID="")||(TransToDoc="") "请选择病人和要指定的医生!"
	i userId="" s userId=%session.Get("LOGON.USERID")
	i locId="" s locId=%session.Get("LOGON.CTLOCID")
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","T",""))
    s curDate=+$H,curTime=$p($h,",",2)
    s TRANSMain="Y"
	&sql(insert into SQLUser.PA_AdmTransaction 
	    (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
	     TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
	     TRANS_TransType_DR,TRANS_CTLOC_DR,TRANS_CTCP_DR,TRANS_Main)  
		Values (:EpisodeID,:curDate,:curTime,:reqstId,:curDate,:curTime,:userId,
				:transtypId,:locId,:TransToDoc,:TRANSMain))	
	i SQLCODE q "指定医生出错!"
		
	&sql(update SQLUser.PA_Adm 
	(PAADM_AdmDocCodeDR) 
	Values (:TransToDoc) Where PAADM_RowId=:EpisodeID)
	i SQLCODE q "指定医生出错!"
	q 0
}

ClassMethod GetDefaultDoc()
{
   
    s userID=%session.Data("LOGON.USERID")
 	i userID'="" s curdocID=$p($g(^SSU("SSUSR",userID)),"^",14)
 	e  s curdocID=""
 	s docDesc=$P($G(^CTPCP(curdocID,1)),"^",2)   
 	q curdocID_"^"_docDesc
}

}
