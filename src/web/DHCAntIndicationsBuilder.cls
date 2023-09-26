Include webimport

IncludeGenerator webimport

Class web.DHCAntIndicationsBuilder Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod DHCAntIndicationsDelete(ID)
{
	TStart
	&sql(delete from DHC_Ant_Indications where DAIND_Rowid=:ID)
     i SQLCODE=0  d
	 .Tcommit
	  e  d
	 .Trollback
	 q SQLCODE
}

ClassMethod DHCAntIndicationsInsert(InsInfo)
{
	s AICode=$p(InsInfo,"^",1)
	s AIDesc=$p(InsInfo,"^",2)
	s AIAURID=$p(InsInfo,"^",3)
	s AIFlag=$p(InsInfo,"^",4)
	s AINote=$p(InsInfo,"^",5)
	&sql(SELECT count(*) INTO :mycount   
 FROM  DHC_Ant_Indications
 WHERE (DAIND_Code=:AICode)and(DAIND_Desc=:AIDesc)and(DAIND_AUR_DR=:AIAURID ) )
 if (mycount'=0)
 {	  
	 Quit 100
 }else{
	TStart
	&sql(insert into DHC_Ant_Indications(DAIND_Code,DAIND_Desc,DAIND_AUR_DR,DAIND_ActiveFlag,DAIND_Note)values(:AICode,:AIDesc,:AIAURID,:AIFlag,:AINote))
     i SQLCODE=0  d
	 .Tcommit
	  e  d
	 .Trollback
	 q SQLCODE
 }
}

ClassMethod DHCAntIndicationsUpdate(InsInfo)
{
	s ID=$p(InsInfo,"^",1)
	s AICode=$p(InsInfo,"^",2)
	s AIDesc=$p(InsInfo,"^",3)
	s AIAURID=$p(InsInfo,"^",4)
	s AIFlag=$p(InsInfo,"^",5)
	s AINote=$p(InsInfo,"^",6)
	TStart
	&sql(update DHC_Ant_Indications set DAIND_Code=:AICode,DAIND_Desc=:AIDesc,DAIND_AUR_DR=:AIAURID,DAIND_ActiveFlag=:AIFlag,DAIND_Note=:AINote where DAIND_Rowid=:ID)
     i SQLCODE=0  d
	 .Tcommit
	  e  d
	 .Trollback
	 q SQLCODE
}

ClassMethod GetDHCAntIndicationsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetDHCAntIndicationsExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCAntIndicationsBuilder","GetDHCAntIndications","","")

ClassMethod GetDHCAntIndicationsExecute(ByRef QHandle As %Binary, AICode As %String, AIDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DAINDRowID=0
	f  s DAINDRowID=$o(^DAIND("DAIND",DAINDRowID)) q:DAINDRowID=""  d
	 .s AID=DAINDRowID
	 .s AAICode=$p(^DAIND("DAIND",DAINDRowID),"^",1)
	 .s AAIDesc=$p(^DAIND("DAIND",DAINDRowID),"^",2)
	 .s AAIAURID=$p($g(^DAIND("DAIND",DAINDRowID)),"^",3)
	 .i AAIAURID'="" d
	 ..s AAIAUR=$p($g(^DCTAR("AUR",AAIAURID)),"^",2)
	 .s AAIFlag=$p(^DAIND("DAIND",DAINDRowID),"^",4)
	 .s AAINote=$p(^DAIND("DAIND",DAINDRowID),"^",5)
	 .q:(AICode'="")&&(AICode'=AAICode)
	 .q:(AIDesc'="")&&(AIDesc'=AAIDesc)
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(AID,AAICode,AAIDesc,AAIAURID,AAIAUR,AAIFlag,AAINote)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod GetDHCAntIndicationsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
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

Query GetDHCAntIndications(AICode As %String, AIDesc As %String) As %Query(ROWSPEC = "AID:%String,AAICode:%String,AAIDesc:%String,AAIAURID:%String,AAIAUR:%String,AAIFlag:%String,AAINote:%String") [ SqlProc ]
{
}

Query GetAUR() As %SQLQuery(CONTAINID = 1, ROWSPEC = "AUR_Desc:%String,AUR_RowId:%Integer")
{
	select AUR_Desc,AUR_RowId from DHC_CT_AntUseReason
}

}
