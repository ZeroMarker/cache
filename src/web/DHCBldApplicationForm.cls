Class web.DHCBldApplicationForm Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Query QueryAppFormList(DateFrom As %String, DateTo As %String, EpisodeID As %String) As %Query(ROWSPEC = "CreateDT:%String,AppNo:%String,TransDT:%String,PatName:%String,Debtor:%String,ABO:%String,RH:%String,Location:%String,Doctor:%String,AppInfo:%String,Remark:%String")
{
}

ClassMethod QueryAppFormListExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, EpisodeID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
 	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set LabData=Config.LabDataNamespace
    If '$Length(LabData) Set LabData="LABDATA"
    s ^TMPAPPP(1)=EpisodeID
    k ^TMP($zn,$j)
    i '$l(EpisodeID) Set qHandle=$lb(0,repid,0) Quit $$$OK
    s Debtor=##class(web.DHCLabCommon).GetRegNobyEpisodeID(EpisodeID)
    i '$l(Debtor) Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ^TMPAPPP(2)=Debtor_","_DateFrom_","_DateTo
    ///
    //DHCBLDAPPFORMi(0,"DEBTOR","0000110413",20110609001) = "" 
    s RepNo="" f  s RepNo=$o(^DHCBLDAPPFORMi(0,"DEBTOR",Debtor,RepNo),-1) q:RepNo=""  d
    .s PStr=$g(^DHCBLDAPPFORM(RepNo,"P"))
    .i '$l(PStr) q
    .s OperSub=$o(^DHCBLDAPPFORM(RepNo,"OPERATION",""))
    .s (OperType,OperDr)=""
    .i $l(OperSub) s OperType=$o(^DHCBLDAPPFORM(RepNo,"OPERATION",OperSub,""))
    .i $l(OperType) s OperDr=$o(^DHCBLDAPPFORM(RepNo,"OPERATION",OperSub,OperType,""))
    .s (CrtDate,CrtTime)=""
    .i $l(OperDr) d
    ..s CrtDate=$p(^DHCBLDAPPFORM(RepNo,"OPERATION",OperSub,OperType,OperDr),"\",4)
    ..s CrtTime=$p(^DHCBLDAPPFORM(RepNo,"OPERATION",OperSub,OperType,OperDr),"\",5)
    .i $l(DateFrom),CrtDate-DateFrom<0 q
    .i $l(DateTo),CrtDate-DateTo>0 q
    .s TransDate=$p(^DHCBLDAPPFORM(RepNo,"F"),"\",5)
    .s TransTime=$p(^DHCBLDAPPFORM(RepNo,"F"),"\",6)
    .i $l(TransDate) s TransDate=$zd(TransDate,3)
    .i $l(TransTime) s TransTime=$zt(TransTime,2)
    .s TransDT=TransDate_" "_TransTime
    .//
    .s Name=$p(PStr,"\",2)
    .s RegNo=$p(PStr,"\",15)
    .s BAH=$p(PStr,"\",29)
    .s RegNo=BAH
    .s ABO=$p(PStr,"\",26)
    .s RH=$p(PStr,"\",27)
    .s Remark=$p(^DHCBLDAPPFORM(RepNo,"F"),"\",15)
    .s Loc=$p(PStr,"\",22)
    .s Location=""
    .i $l(Loc),$d(^CTLOC(Loc)) s Location=$p(^CTLOC(Loc),"^",2)
    .s curWardDr=$p(PStr,"\",13)
    .i $l(curWardDr) S patWardDesc=$P($g(^PAWARD(curWardDr)),"^",2)
    .s Location=$g(patWardDesc)
    .S:Location["-" Location=$P(Location,"-",2)
    .s Doc=""
    .i $l(CrtDate) s CrtDate=$zd(CrtDate,3)
    .i $l(CrtTime) s CrtTime=$zt(CrtTime,2)
    .s CrtDT=CrtDate_" "_CrtTime
    .s AppInfo=""
    .//^DHCBLDAPPFORM(20110609001,"ORDER","76373-1")
    .s ordid="" f  s ordid=$o(^DHCBLDAPPFORM(RepNo,"ORDER",ordid)) q:ordid=""  d
    ..s AppName=$p(^DHCBLDAPPFORM(RepNo,"ORDER",ordid),"\",2)
    ..s AppVolum=$p(^DHCBLDAPPFORM(RepNo,"ORDER",ordid),"\",6)
    ..s Unit=$p(^DHCBLDAPPFORM(RepNo,"ORDER",ordid),"\",7)
    ..s AppInfo=AppInfo_AppName_" "_AppVolum_Unit_";"
    .d OutputRow
    ///
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=$lb(CrtDT,RepNo,TransDT,Name,RegNo,ABO,RH,Location,Doc,AppInfo,Remark)
 	Set ind=ind+1
	quit
}

ClassMethod QueryAppFormListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppFormListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAppFormListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppFormListExecute ]
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

}
