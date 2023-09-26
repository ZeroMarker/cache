Include webimport

IncludeGenerator webimport

Class web.DHCCTAntUsePurposeBuilder Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod DHCCTAntUsePurposeDelete(ID)
{
	TStart
	&sql(delete from DHC_CT_AntUsePurpose where DTAUP_Rowid=:ID)
     i SQLCODE=0  d
	 .Tcommit
	  e  d
	 .Trollback
	 q SQLCODE
}

/// w ##class(web.DHCCTAntUsePurposeBuilder).DHCCTAntUsePurposeInsert(^tempshp("Antipurse"))
ClassMethod DHCCTAntUsePurposeInsert(InsInfo)
{
	s ^tempshp("Antipurse")=InsInfo
	s DTAUPCode=$p(InsInfo,"^",1)
	s DTAUPDesc=$p(InsInfo,"^",2)
	s DTAUPAURID=$p(InsInfo,"^",3)
	if DTAUPAURID'=""  s DTAUPAUR=$p($g(^DCTAR("AUR",DTAUPAURID)),"^",2)
	s DTAUPActiveFlag=$p(InsInfo,"^",4)
	s DTAUPReqStr=$p(InsInfo,"^",5)
	s DTAUPNote=$p(InsInfo,"^",6)
	s DTAUPItemID=$p(InsInfo,"^",7)
	if DTAUPItemID'=""  s DTAUPItem=$p(^DCTAR("AUR",+DTAUPItemID,"I",$P(DTAUPItemID,"||",2)),"^",2)
	s DTAUPDesc=DTAUPAUR_"-"_DTAUPItem_"-"_DTAUPDesc
	&sql(SELECT count(*) INTO :mycount   
 FROM  DHC_CT_AntUsePurpose
 WHERE (DTAUP_Code=:DTAUPCode)and(DTAUP_Desc=:DTAUPDesc))
 b  ;01
 if (mycount'=0)
 {	  
	 Quit 100
 }else{
	TStart
	&sql(insert into DHC_CT_AntUsePurpose(DTAUP_Code,DTAUP_Desc,DTAUP_AUR_DR,DTAUP_ActiveFlag,DTAUP_ReqStr,DTAUP_Note,DTAUP_PurposeItem_Dr)values(:DTAUPCode,:DTAUPDesc,:DTAUPAURID,:DTAUPActiveFlag,:DTAUPReqStr,:DTAUPNote,:DTAUPItemID))
    b  ;02
     i SQLCODE=0  d
	 .Tcommit
	  e  d
	 .Trollback
	 q SQLCODE
 }
}

ClassMethod GetDHCCTAntUsePurposeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetDHCAntIndicationsExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///  w ##class(web.DHCCTAntUsePurposeBuilder).DHCCTAntUsePurposeUpdate(^tempshp("UpdateAntipurse"))
ClassMethod DHCCTAntUsePurposeUpdate(InsInfo)
{
	s ^tempshp("UpdateAntipurse")=InsInfo
	s ID=$p(InsInfo,"^",1)
	s DTAUPCode=$p(InsInfo,"^",2)
	s DTAUPDesc=$p(InsInfo,"^",3)
	s DTAUPAURID=$p(InsInfo,"^",4)
	if DTAUPAURID'=""  s DTAUPAUR=$p($g(^DCTAR("AUR",DTAUPAURID)),"^",2)
	s DTAUPActiveFlag=$p(InsInfo,"^",5)
	s DTAUPReqStr=$p(InsInfo,"^",6)
	s DTAUPNote=$p(InsInfo,"^",7)
	s DTAUPItemID=$p(InsInfo,"^",8)
	if DTAUPItemID'=""  s DTAUPItem=$p(^DCTAR("AUR",+DTAUPItemID,"I",$P(DTAUPItemID,"||",2)),"^",2)
	s DTAUPDesc=DTAUPAUR_"-"_DTAUPItem_"-"_DTAUPDesc
	TStart
	&sql(update DHC_CT_AntUsePurpose set DTAUP_Code=:DTAUPCode,DTAUP_Desc=:DTAUPDesc,DTAUP_AUR_DR=:DTAUPAURID,DTAUP_ActiveFlag=:DTAUPActiveFlag,DTAUP_Note=:DTAUPNote,DTAUP_ReqStr=:DTAUPReqStr,DTAUP_PurposeItem_Dr=:DTAUPItemID where DTAUP_Rowid=:ID)
     i SQLCODE=0  d
	 .Tcommit
	  e  d
	 .Trollback
	 q SQLCODE
}

// d ##class(%ResultSet).RunQuery("web.DHCCTAntUsePurposeBuilder","GetDHCCTAntUsePurpose","2-1-1","清洁手术")

ClassMethod GetDHCCTAntUsePurposeExecute(ByRef QHandle As %Binary, DTAUPCode As %String, DTAUPDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTAUPRowID=0
	f  s DTAUPRowID=$o(^DTAUP("AUP",DTAUPRowID)) q:DTAUPRowID=""  d
	 .s DDTAUPID=DTAUPRowID
	 .s DDTAUPCode=$p(^DTAUP("AUP",DTAUPRowID),"^",1)
	 .s DDTAUPDesc=$p(^DTAUP("AUP",DTAUPRowID),"^",2)
	 .s DDTAUPAURID=$p($g(^DTAUP("AUP",DTAUPRowID)),"^",3)
	 .i DDTAUPAURID'="" d
	 ..s DDTAUPAUR=$p($g(^DCTAR("AUR",DDTAUPAURID)),"^",2)
	 .s DDTAUPActiveFlag=$p(^DTAUP("AUP",DTAUPRowID),"^",4)
	 .s DDTAUPReqStr=$p(^DTAUP("AUP",DTAUPRowID),"^",5)
	 .s DDTAUPNote=$p(^DTAUP("AUP",DTAUPRowID),"^",6)
	 .s DDTAUPItemID=$p(^DTAUP("AUP",DTAUPRowID),"^",7)
	 .S DTAUPItem=""
	 .if DDTAUPItemID'=""  s DTAUPItem=$p(^DCTAR("AUR",+DDTAUPItemID,"I",$P(DDTAUPItemID,"||",2)),"^",2)
	 .q:(DTAUPCode'="")&&(DTAUPCode'=DDTAUPCode)
	 .b  ;
	 .q:(DTAUPDesc'="")&&(DDTAUPDesc'[DTAUPDesc)
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DDTAUPID,DDTAUPCode,DDTAUPDesc,DDTAUPAURID,DDTAUPAUR,DDTAUPActiveFlag,DDTAUPReqStr,DDTAUPNote,DTAUPItem,DDTAUPItemID)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod GetDHCCTAntUsePurposeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
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

Query GetDHCCTAntUsePurpose(DTAUPCode As %String, DTAUPDesc As %String) As %Query(ROWSPEC = "DDTAUPID:%String,DDTAUPCode:%String,DDTAUPDesc:%String,DDTAUPAURID:%String,DDTAUPAUR:%String,DDTAUPActiveFlag:%String,DDTAUPReqStr:%String,DDTAUPNote:%String,DTAUPItem:%String,DDTAUPItemID:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCTAntUsePurposeBuilder","GetPurpseItem","")
Query GetPurpseItem(ReasonID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "AUR_Desc:%String,AUR_RowId:%String")
{
	select DAURI_Desc,DAURI_Rowid from DHC_CTAntUseReasonItem where DAURI_AUR_ParRef =:ReasonID and DAURI_ActiveFlag='Y'
}

}
