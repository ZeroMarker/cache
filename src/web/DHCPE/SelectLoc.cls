Class web.DHCPE.SelectLoc Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/*
ClassMethod Save(InString As %Library.String = "")
{
   s LocId=$p($g(InString),"^",1)
   s PreRef=$p($g(InString),"^",2)
   &sql(insert into sqluser.DHC_PE_StationOrderLoc(STORDL_ParRef,STORDL_Loc_DR)values(:PreRef,:LocId))	     
   q SQLCODE
}
*/
ClassMethod Save(InString As %Library.String = "")
{
   s LocId=$p($g(InString),"^",1)
   s PreRef=$p($g(InString),"^",2)
   s NoPrint=$p($g(InString),"^",3)
   s RowID=$p($g(InString),"^",4)
   if RowID=""{
   &sql(insert into sqluser.DHC_PE_StationOrderLoc(STORDL_ParRef,STORDL_Loc_DR)values(:PreRef,:LocId))}    
   else { 
   &sql(update sqluser.DHC_PE_StationOrderLoc
	     set STORDL_Loc_DR =:LocId
	     where STORDL_RowId= :RowID
	     )
   }
   i SQLCODE=0  d
   .i RowID='""  s %ROWID=RowID
   .s ^DHCPEDataEx("DHCPEStationOrderLoc","NoPrint",PreRef,LocId)=NoPrint
   q SQLCODE
}

Query Search(RowId As %String = "") As %SQLQuery(ROWSPEC = "TSelectLoc:%String,TLocId:%String,TRowId:%String")
{
	select B.CTLOC_Desc,A.STORDL_Loc_DR,A.STORDL_RowId
	from sqluser.DHC_PE_StationOrderLoc as A
	inner join sqluser.CT_Loc as B on A.STORDL_Loc_DR=B.CTLOC_RowId
	where A.STORDL_ParRef=:RowId
}

ClassMethod IsExistLoc(LocId As %Library.String = "", PreRef As %Library.String = "")
{
   s flag=0
	s child=""
	f  s child=$o(^DHCPEST(+PreRef,"O",$p(PreRef,"||",2),"STORDL",child)) q:(child="")||(flag="1")  d
	.s locid=$p(^DHCPEST(+PreRef,"O",$p(PreRef,"||",2),"STORDL",child),"^",1)
	.i LocId=locid s flag=1
	q flag
}

ClassMethod Info(PreRef, ChildSub)
{
	q:PreRef=""
	q:ChildSub=""
	s child=$o(^DHCPEST(PreRef,"O",ChildSub,"STORDL",0))
	q:child=""
	s locid=$p(^DHCPEST(PreRef,"O",ChildSub,"STORDL",child),"^",1)
	q:locid=""
	s loc=$p($g(^CTLOC(locid)),"^",2)
	f  s child=$o(^DHCPEST(PreRef,"O",ChildSub,"STORDL",child)) q:child=""  d
	.s locid=$p(^DHCPEST(PreRef,"O",ChildSub,"STORDL",child),"^",1)
	.s locdesc=$p(^CTLOC(locid),"^",2)
	.s loc=loc_","_locdesc
	q loc
}

ClassMethod Delete(string As %Library.String = "")
{
   s LocId=$p($g(string),"^",1)
   s Loc=$p($g(string),"^",2)
   s RowId=$p($g(string),"^",3)
   &sql(delete from sqluser.DHC_PE_StationOrderLoc where STORDL_RowId=:RowId)	     
   i SQLCODE=0  d
  .k ^DHCPEDataEx("DHCPEStationOrderLoc","NoPrint",$p(RowId,"||",1,2),LocId)  //add byzl
   q SQLCODE
}

ClassMethod SaveED(InString As %Library.String = "")
{
   s LocId=$p($g(InString),"^",1)
   s PreRef=$p($g(InString),"^",2)
   &sql(insert into sqluser.DHC_PE_EDLoc(EDL_ParRef,EDL_Loc_DR)values(:PreRef,:LocId))	     
   q SQLCODE
}

Query SearchED(ParrefRowId As %String = "") As %SQLQuery(ROWSPEC = "TSelectLoc:%String,TLocId:%String,TRowId:%String")
{
    
    select B.CTLOC_Desc,A.EDL_Loc_DR,A.EDL_RowId
	from sqluser.DHC_PE_EDLoc as A
	inner join sqluser.CT_Loc as B on A.EDL_Loc_DR=B.CTLOC_RowId
	where A.EDL_ParRef=:ParrefRowId
}

ClassMethod InfoED(edrowid)
{
	q:edrowid=""
	s child=$o(^DHCPEED(edrowid,"EDL",0))
	q:child=""
	s locid=$p(^DHCPEED(edrowid,"EDL",child),"^",1)
	s loc=$p(^CTLOC(locid),"^",2)
	f  s child=$o(^DHCPEED(edrowid,"EDL",child)) q:child=""  d
	.s locid=$p(^DHCPEED(edrowid,"EDL",child),"^",1)
	.s locdesc=$p(^CTLOC(locid),"^",2)
	.s loc=loc_","_locdesc
	q loc
}

ClassMethod DeleteED(string As %Library.String = "")
{
   s LocId=$p($g(string),"^",1)
   s Loc=$p($g(string),"^",2)
   s RowId=$p($g(string),"^",3)
   &sql(delete from sqluser.DHC_PE_EDLoc where EDL_RowId=:RowId)	     
   q
}

ClassMethod SaveOrd(InString As %Library.String = "")
{
   s LocId=$p($g(InString),"^",1)
   s RowId=$p($g(InString),"^",2)
   s ^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",LocId)=0
   q 0
}

ClassMethod SearchOrdExecute(ByRef qHandle As %Binary, RowId) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s locid=0
    f  s locid=$o(^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",locid))  q:locid=""  d
    .s locdesc=$p(^CTLOC(locid),"^",2)
 	.d SearchOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(locdesc,locid,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)

 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				
 	Set Row=^CacheTemp(repid,ind)
 	}
 	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SearchOrd(RowId) As %Query(ROWSPEC = "TSelectLoc:%String,TLocId:%String,TRowId:%String")
{
}

ClassMethod SearchOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchOrdExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeleteOrd(string As %Library.String = "")
{
   s LocId=$p($g(string),"^",1)
   s Loc=$p($g(string),"^",2)
   s RowId=$p($g(string),"^",3)	     
   K ^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",LocId)
   q 0
}

/*
ClassMethod InfoOrd(RowId)
{
    q:RowId=""
    s locid=$o(^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",0))
    q:locid=""
    s loc=$p(^CTLOC(locid),"^",2)
    f  s locid=$o(^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",locid))  q:locid=""  d
    .s locdesc=$p(^CTLOC(locid),"^",2)
	.s loc=loc_","_locdesc
	q loc
}
*/
ClassMethod InfoOrd(RowId)
{
    q:RowId="" ""
    S loc=""
    s locid=""
    f  s locid=$o(^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",locid)) q:locid=""  d
    .s locdesc=$p(^CTLOC(locid),"^",2)
    .I loc="" S loc=locdesc
	.e  s loc=loc_","_locdesc
	q loc
}

// d ##class(web.DHCPE.SelectLoc).SetStationOrderLoc("14")

ClassMethod SetStationOrderLoc(RowId)
{
    s LocId="124"
    s STORDChildSub=0
	f  s STORDChildSub=$o(^DHCPEST(RowId,"O",STORDChildSub))  q:STORDChildSub=""  d
	.s STORDARCIMDR=$p(^DHCPEST(RowId,"O",STORDChildSub),"^",1)
    .s ParRef=RowId_"||"_STORDChildSub
    .//W !,ParRef
    .&sql(insert into sqluser.DHC_PE_StationOrderLoc(STORDL_ParRef,STORDL_Loc_DR)values(:ParRef,:LocId))  
    .//&sql(delete from sqluser.DHC_PE_StationOrderLoc where STORDL_ParRef=:ParRef and STORDL_Loc_DR=:LocId)
    .S ^DHCPEDataEx("DHCPEStationOrderLoc","NoPrint",ParRef,LocId)="Y"
}

/*
ClassMethod SetStationOrderLoc(RowId)
{ 
    s LocId="64"
    s STORDChildSub=0
	f  s STORDChildSub=$o(^DHCPEST(RowId,"O",STORDChildSub))  q:STORDChildSub=""  d
	.s STORDARCIMDR=$p(^DHCPEST(RowId,"O",STORDChildSub),"^",1)
    .s ParRef=RowId_"||"_STORDChildSub
    .&sql(delete from sqluser.DHC_PE_StationOrderLoc where STORDL_ParRef=:ParRef)

   s ParRef=0
   f  s ParRef=$o(^DHCPEDataEx("DHCPEStationOrderLoc","NoPrint",ParRef))  q:ParRef=""  d
   .s station=$p(ParRef,"||",1)
   .i station="8"  d
   .k ^DHCPEDataEx("DHCPEStationOrderLoc","NoPrint",ParRef)
}
*/
}
