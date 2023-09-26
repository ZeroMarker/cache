Import sqluser

Class web.DHCADMNurseSet Extends %RegisteredObject
{

Query FindMasterItem(ARCIMDesc As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ArcimCode:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, ARCIMDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..q:AlisDR=""
	..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s ArcimCode=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",1)
	..s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..q:ArcimDesc'[ARCIMDesc
	..//q:$p(ArcimDesc,ARCIMDesc,1)'=""
	..Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ArcimDesc,ArcimCode,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
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

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindNurLevelTyp() As %Query(ROWSPEC = "RowID:%String,ArcimCode:%String,ArcimDesc:%String,ArcimRowID:%String")
{
}

ClassMethod FindNurLevelTypExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s DHCNurLeRowID=0 
 	f  s DHCNurLeRowID=$o(^User.DHCNurLevelTYPD(DHCNurLeRowID)) q:DHCNurLeRowID=""  d
	.s RowID=DHCNurLeRowID
	.s ArcimCode=$listget(^User.DHCNurLevelTYPD(RowID),2)
	.s ArcimDesc=$listget(^User.DHCNurLevelTYPD(RowID),3)
	.s ArcimDR=$listget(^User.DHCNurLevelTYPD(RowID),4)
	.Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DHCNurLeRowID,ArcimCode,ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurLevelTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurLevelTypExecute ]
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

ClassMethod FindNurLevelTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurLevelTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod Insert(ArcimDesc As %String, ArcimCode As %String, ArcimID As %String) As %String
{
	/*s a=##class(DHCADMNurseRecord).%New()
	s a.NurRecADMDR=NurRecADMDR
	s a.NurRecPATBed=NurRecPATBed
	s a.NurRecPATName=NurRecPATName
	s a.NurRecPATSex=NurRecPATSex
	s a.NurRecDATE=NurRecDATE
	s a.NurRecTIME=NurRecTIME
	s a.NurRecTYPDR=NurRecTYPDR
	s a.NurRecItmMastDR=NurRecItmMastDR
	s a.NurRecUSRDR=NurRecUSRDR
	d a.%Save()
	i a.%Id()="" s ret=1
	e  s ret=0*/
	k PLIST
	s PLIST(2)=NurMedTourADMDR
	s PLIST(3)=NurMedTourPATBed
	s PLIST(4)=NurMedTourPATName
	s PLIST(5)=NurMedTourPATSex
	s PLIST(6)=NurMedTourDATE
	s PLIST(7)=NurMedTourTIME
	s PLIST(8)=NurMedTourItmMastDR
	s PLIST(9)=NurMedTourUSRDR
	s PLIST(10)=NurMedTourCTLOCDR
	s PLIST(11)=NurMedTourMedDeal
	s PLIST(12)=NurMedTourMedSituation
	s PLIST(13)=BarCodeDr
	&sql(insert into DHCNur_MedTourRecord Values PLIST())
	
	q SQLCODE
	//q ret
}

ClassMethod Insert1(ArcimDesc As %String, ArcimCode As %String, ArcimID As %String) As %String
{
	s a=##class(User.DHCNurLevelTYP).%New()
	s a.DHCNurLeCode=ArcimCode
	s a.DHCNurLeDesc=ArcimDesc
	s a.DHCNurLeArcimRowidStr=ArcimID
	
	d a.%Save()
	i a.%Id()="" s ret=1
	e  s ret=0
	Q ret
}

ClassMethod Update1(RowID As %String, ArcimDesc As %String, ArcimCode As %String, ArcimID As %String) As %String
{
	q:RowID="" 0
	s a=##class(User.DHCNurLevelTYP).%OpenId(RowID)
	s a.DHCNurLeCode=ArcimCode
	s a.DHCNurLeDesc=ArcimDesc
	s a.DHCNurLeArcimRowidStr=ArcimID
	
	d a.%Save()
	Q 0
}

ClassMethod Delete1(RowID As %String) As %String
{
	q:RowID="" 0
	s a=##class(User.DHCNurLevelTYP).%OpenId(RowID)
	d a.%DeleteId(RowID)
	Q 0
}

}
