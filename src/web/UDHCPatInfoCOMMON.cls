Import SQLUser

Class web.UDHCPatInfoCOMMON Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 141;

ClassMethod GetMedcarebyEpisodeID(EpisodeID)
{
 n (EpisodeID)
 q:$g(EpisodeID)="" ""
 q:'$d(^PAADM(EpisodeID)) ""
 s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 q ..GetMedcare(PaitentID)
}

ClassMethod GetNamebyEpisodeID(EpisodeID)
{
 n (EpisodeID)
 q:$g(EpisodeID)="" ""
 q:'$d(^PAADM(EpisodeID)) ""
 s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 q ..GetName(PaitentID)
}

ClassMethod GetSexbyEpisodeID(EpisodeID)
{
 n (EpisodeID)
 q:$g(EpisodeID)="" ""
 q:'$d(^PAADM(EpisodeID)) ""
 s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 q ..GetSex(PaitentID)
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
 n (EpisodeID)
 q:$g(EpisodeID)="" ""
 q:'$d(^PAADM(EpisodeID)) ""
 s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 q ..GetRegNo(PaitentID)
}

ClassMethod GetMedcare(PaitentID)
{
 n (PaitentID)
 q:$g(PaitentID)="" ""
 q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 q $p(^PAPER(PaitentID,"PAT",1),"^",22)
}

ClassMethod GetName(PaitentID)
{
 n (PaitentID)
 q:$g(PaitentID)="" ""
 q:'$D(^PAPER(PaitentID,"ALL")) ""
 q $p(^PAPER(PaitentID,"ALL"),"^",1)
}

ClassMethod GetSex(PaitentID)
{
 n (PaitentID)
 q:$g(PaitentID)="" ""
 q:'$D(^PAPER(PaitentID,"ALL")) ""
 s sexdr=$p(^PAPER(PaitentID,"ALL"),"^",7)
 s sex=$p(^CT("SEX",sexdr),"^",2)
 q sex
}

ClassMethod GetRegNo(PaitentID)
{
 n (PaitentID)
 q:$g(PaitentID)="" ""
 q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 s IP=$p(^PAPER(PaitentID,"PAT",1),"^",1)
 s OP=$p(^PAPER(PaitentID,"PAT",1),"^",2)
 s PAPMINo=$S($G(XFUNC("CLASS"))="OP":OP,1:IP)
 q PAPMINo
}

ClassMethod InPatientLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InPatientLocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid) 	
 Quit $$$OK
}

ClassMethod InPatientLocExecute(ByRef qHandle As %Binary, rescDesc As %String, locDesc As %String, locType As %String, admType As %String, admDate As %String, Hospitals As %String, HospDesc As %String, userFlag As %String, RestrictDept As %String) As %Status
{
 //s ^XINTMP="aaaaa"_locDesc_"^"_admType
 Set repid=$I(^CacheTemp)  ;这个是大家公用的?
 Set qHandle=$lb(0,repid,0)
 i $g(admType)="" Quit $$$OK
 ;w "aa"
 s tmpid=..GetInPatientLoc($g(locDesc), $g(admType))
 i tmpid=0 Quit $$$OK
 s ind=1
 s j=0 f   s j=$o(^mPLIST(tmpid,j)) q:j=""  d
 .s ^CacheTemp(repid,ind)=^mPLIST(tmpid,j)
 .S ind=ind+1
  k ^mPLIST(tmpid)
	Quit $$$OK
}

ClassMethod InPatientLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InPatientLocExecute ]
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

Query InPatientLoc(rescDesc As %String, locDesc As %String, locType As %String, admType As %String, admDate As %String, Hospitals As %String, HospDesc As %String, userFlag As %String, RestrictDept As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTLOCCode:%String,CTLOCDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Hospital:%String,HIDDEN:%String")
{
}

// 从PAC_AdmTypeLocation 中取得住院科室

ClassMethod GetInPatientLoc(locDesc, admType)
{
  n (locDesc,admType)
  q:admType="" 0
  s tmpid=$I(^mPLIST)
  s m=0
  s locdr="" f  s locdr=$o(^PAC("ADMLOC",0,"AdmType",admType,locdr)) q:locdr=""  d
  .q:'$d(^CTLOC(locdr))
  .s locCode=$p(^CTLOC(locdr),"^",1)
  .s locDesc1=$p(^CTLOC(locdr),"^",2)
  .q:(locDesc'="")&(locDesc1'[locDesc)
  .s m=m+1
  .;w !,locCode_"^"_locDesc
  .s ^mPLIST(tmpid,m)=$lb($g(locCode),$g(locDesc1),"","","","",$g(Hospitals),"")
  q tmpid
}

ClassMethod GetAdmDatebyEpisodeID(EpisodeID)
{
 n (EpisodeID)
 s AdmDay=""
 s AdmDateInfo=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
 s AdmDate=$p(AdmDateInfo,"^",1)
 s AdmTime=$p(AdmDateInfo,"^",2)
 s DisDateInfo=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
 s DisDate=$p(DisDateInfo,"^",1)
 s DisTime=$p(DisDateInfo,"^",2)
 i DisDate'="" s AdmDay=DisDate-AdmDate
 i DisDate=""  s AdmDay=+$H-AdmDate
 i AdmDay=0 s AdmDay=1
 i AdmDate'="" s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
 e  s AdmDate=""
 i AdmTime'="" s AdmTime=##class(websys.Conversions).TimeLogicalToHtml(AdmTime,1)
 e  s AdmTime=""
 i DisDate'="" s DisDate=##class(websys.Conversions).DateLogicalToHtml(DisDate)
 e  s DisDate=""
 i DisTime'="" s DisTime=##class(websys.Conversions).TimeLogicalToHtml(DisTime,1)
 e  s DisTime=""
 
 q AdmDate_" "_AdmTime_"^"_AdmDay_"^"_DisDate_"^"_DisTime
}

ClassMethod GetAdmDaybyEpisodeID(EpisodeID)
{
 n (EpisodeID)
 q:$g(EpisodeID)="" ""
 q:'$d(^PAADM(EpisodeID)) ""
 s admType=$p(^PAADM(EpisodeID),"^",2)
 q:admType'="I" ""
 s AdmDateRet=##class(web.DHCADMQTREC).PACInPatDateBed(EpisodeID)
 q:AdmDateRet="" ""
 s ADate=$p(AdmDateRet,"^",1)
 s DocDisDate=$p(^PAADM(EpisodeID),"^",59)
 s curdate=+$h
 i DocDisDate'="" s AdmDay=DocDisDate-ADate
 i DocDisDate=""  s AdmDay=curdate-ADate
 i AdmDay=0 s AdmDay=1
 q AdmDay
}

ClassMethod GetBedNoByEpisodeID(EpisodeID)
{
 n (EpisodeID)
 s BedNo=""
 q:$g(EpisodeID)=""
 q:'$d(^PAADM(EpisodeID))
 s bedid=$p(^PAADM(EpisodeID),"^",73)
 i bedid'="" s BedNo=$p(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
 q BedNo
}

}
