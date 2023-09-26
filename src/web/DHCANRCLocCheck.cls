Import SQLUSER

Class web.DHCANRCLocCheck Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCANRCLocCheck","FindLocCheck")
Query FindLocCheck() As %Query(ROWSPEC = "anrclcRowId,anrcmcDr,anrcmcDesc,anrcciDr,anrcciItem,ctlocDr,ctlocDesc")
{
}

ClassMethod FindLocCheckExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	k ^TMPAN("LocCheck",$j)
	s anrclcRowId=0  f  s anrclcRowId=$o(^DHCANRC("LocCheck",anrclcRowId)) q:anrclcRowId=""  d
	.s anrcmcDr=$li(^DHCANRC("LocCheck",anrclcRowId),1)
	.s anrcmcDesc=$li(^DHCANRC("ManageClass",anrcmcDr),2)
	.s anrcciDr=$li(^DHCANRC("LocCheck",anrclcRowId),2)
	.s anrcciItem=$li(^DHCANRC("CheckItem",anrcciDr),2)
	.s ctlocDr=$li(^DHCANRC("LocCheck",anrclcRowId),3)
	.s ctlocDesc=$p($p(^CTLOC(ctlocDr),"^",2),"-",2)
	.s ^TMPAN("LocCheck",$j,ctlocDr,anrcmcDr,anrcciDr)=$lb(anrclcRowId,anrcmcDr,anrcmcDesc,anrcciDr,anrcciItem,ctlocDr,ctlocDesc)
	s ctlocDr="" f  s ctlocDr=$o(^TMPAN("LocCheck",$j,ctlocDr)) q:ctlocDr=""  d                                                                                         
		.s anrcmcDr="" f  s anrcmcDr=$o(^TMPAN("LocCheck",$j,ctlocDr,anrcmcDr)) q:anrcmcDr=""  d
			..s anrcciDr="" f  s anrcciDr=$o(^TMPAN("LocCheck",$j,ctlocDr,anrcmcDr,anrcciDr)) q:anrcciDr=""  d
			 ...d OutPutLocCheck
	k ^TMPAN("LocCheck",$j)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutPutLocCheck
	//set Data=$lb(anrclcRowId,anrcmcDr,anrcmcDesc,anrcciDr,anrcciItem,ctlocDr,ctlocDesc)
 	Set ^CacheTemp(repid,ind)=^TMPAN("LocCheck",$j,ctlocDr,anrcmcDr,anrcciDr)
 	Set ind=ind+1
	quit
}

ClassMethod FindLocCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocCheckExecute ]
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

ClassMethod FindLocCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InsertLocCheck(AnrcmcId, CheckItemId, CtlocId) As %String
{
	q:AnrcmcId="" "-1"
	q:CheckItemId="" "-2"
	q:CtlocId="" "-3"
	&sql(insert into DHC_ANRC_LocCheck set ANRCLC_Anrcmc_Dr=:AnrcmcId,ANRCLC_Anrcci_Dr=:CheckItemId,ANRCLC_Ctloc_Dr=:CtlocId)
	q SQLCODE
}

ClassMethod DeleteLocCheck(anrclcRowId) As %String
{
	q:anrclcRowId="" "-1"
	&sql(delete from DHC_ANRC_LocCheck where ANRCLC_RowId=:anrclcRowId)
	q SQLCODE
}

ClassMethod UpdateLocCheck(anrclcRowId, AnrcmcId, CheckItemId, CtlocId) As %String
{
	q:anrclcRowId="" "-1"
	q:AnrcmcId="" "-2"
	q:CheckItemId="" "-3"
	q:CtlocId="" "-4"
	&sql(update DHC_ANRC_LocCheck set ANRCLC_Anrcmc_Dr=:AnrcmcId,ANRCLC_Anrcci_Dr=:CheckItemId,ANRCLC_Ctloc_Dr=:CtlocId where ANRCLC_RowId=:anrclcRowId)
	q SQLCODE
}

}
