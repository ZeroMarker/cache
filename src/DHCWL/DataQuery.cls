Class DHCWL.DataQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 挂号、手术、入院、出院总人数
/// d ##class(%ResultSet).RunQuery("DHCWL.DataQuery","CollectData","2020-09-01","2020-09-20","2")
Query CollectData(Sday As %String, Eday As %String, hosId As %String) As %Query(ROWSPEC = "regCount:%Float,opCount:%Float,totalcyrs:%Float,totalryrs:%Float") [ SqlProc ]
{
}

ClassMethod CollectDataExecute(ByRef qHandle As %Binary, Sday As %String, Eday As %String, hosId As %String) As %Status
{
 k ^TEMPDHCWL($j)
 n (qHandle,Sday,Eday,hosId)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:Sday="" $$$OK
 q:Eday="" $$$OK
 s Sday=$zdh(Sday,3)
 s Eday=$zdh(Eday,3)
 f day=Sday:1:Eday  d
 .s wrId=0 f  s wrId=$o(^DHCWorkRegReport(0,"ADMDATE",day,wrId)) q:wrId=""  d
 ..s wrAdmId=$p(^DHCWorkRegReport(wrId),"^",15)
 ..s depDr=$p(^PAADM(wrAdmId),"^",4)
 ..s hosDr=$p(^CTLOC(depDr),"^",22)
 ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 ..s num=$p(^DHCWorkRegReport(wrId),"^",29)
 ..s regCount=$g(regCount)+num
 
 .s wlanId=0 f  s wlanId=$o(^DHCWLAnaesthesia(0,"STATDATE",day,wlanId)) q:wlanId=""  d
 ..s wrAdmId=$p($g(^DHCWLAnaesthesia(wlanId)),"^",1)
 ..s opdepDr=$p(^PAADM(wrAdmId),"^",4)
 ..s hosDr=$p(^CTLOC(opdepDr),"^",22)
 ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 ..s opCount=$g(opCount)+1
 
 .s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",day,mrId)) q:mrId=""  d
 ..q:$p(^MRIPdaily(mrId),"^",7)=""
 ..s mdepDr=$p(^MRIPdaily(mrId),"^",7)
 ..s hosDr=$p(^CTLOC(mdepDr),"^",22)
 ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 ..s cyrs=$p(^MRIPdaily(mrId),"^",5)
 ..s ryrs=$p(^MRIPdaily(mrId),"^",8)
 ..;w !,mrId_"^"_cyrs_"^"_ryrs
 ..s totalcyrs=$g(totalcyrs)+cyrs
 ..s totalryrs=$g(totalryrs)+ryrs
 ..//w !,totalcyrs_"^"_totalryrs
 s ^CacheTemp(repid,ind)=$lb(regCount,opCount,totalcyrs,totalryrs)
 s ind=ind+1
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
}

ClassMethod CollectDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CollectDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CollectDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CollectDataExecute ]
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
