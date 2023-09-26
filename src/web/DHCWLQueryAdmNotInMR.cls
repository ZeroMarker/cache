Class web.DHCWLQueryAdmNotInMR Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 统计一个时间段出院且未在统计病案表中的患者，并标注改患者是否已经在病案系统中编目
/// d ##class(%ResultSet).RunQuery("web.DHCWLQueryAdmNotInMR","GetAdmNotInMR","2022-07-01","2022-07-10")
Query GetAdmNotInMR(SDate As %String, EDate As %String, hosId As %String) As %Query(ROWSPEC = "AmdId:%String,PapmiName:%String,PapmiNo:%String,AdmReasonDesc:%String,DepDesc:%String,AdmDocDesc:%String,AdmisMR:%String,RepDate:%String,DischDate:%String") [ SqlProc ]
{
}

ClassMethod GetAdmNotInMRExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, hosId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
 	if SDate="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	if EDate="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
 	

 	f day=SDate:1:EDate d
 	.w day,!
 	.s AmdId=""
 	.f  s AmdId=$o(^PAADMi("DischDate",day,AmdId)) q:AmdId=""  d
 	..if ('$d(^DHCMRInfo(0,"MR_PAADM_DR",AmdId))) d
 	...s PAPMIDR=$p(^PAADM(AmdId),"^",1)
 	...s MotherAdm=$p(^PAADM(AmdId),"^",75)
 	...q:MotherAdm'=""
 	...s VisitStatus=$p(^PAADM(AmdId),"^",20)
 	...q:VisitStatus="C"
 	...s PapmiName=$$GetPapmiName^DHCWLCommon(PAPMIDR)
 	...s PapmiNo=$$GetPapmiNo^DHCWLCommon(PAPMIDR)
 	...s AdmReasonDR=$p(^PAADM(AmdId,"1"),"^",7)
 	...s AdmReasonDesc=$p(^PAC("ADMREA",AdmReasonDR),"^",2)
 	...s DepCodeDR=$p(^PAADM(AmdId),"^",4) 
 	...s hosDr=$p(^CTLOC(DepCodeDR),"^",22)
 	...q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 	...s DepDesc=$p(^CTLOC(DepCodeDR),"^",2)
 	...s AdmDocCodeDR=+$p(^PAADM(AmdId),"^",9)
 	...i AdmDocCodeDR=0 s AdmDocDesc="Null"
 	...e  s AdmDocDesc=$p(^CTPCP(AdmDocCodeDR,"1"),"^",2)
 	...s PatWardr=$p(^PAADM(AmdId),"^",70)
 	...s PatWardDesc=""
 	...i (+PatWardr'=0)&&($D(^PAWARD(PatWardr))) d
 	....s PatWardDesc=$P(^PAWARD(PatWardr),"^",2)
 	...i PatWardDesc["-" s PatWardDesc=$P(PatWardDesc,"-",2)
 	...s VolumeRowid="" s WMRFPRowId=""
 	...s ret=##class(DHCWMR.IO.OutService).IGetFrontpageInfo(AmdId)
 	...i +ret=1 d
 	....s AdmisMR="Y"
 	....s RepDate=$P(ret,"^",2)
 	...else  d
 	....s AdmisMR="N"
 	....s RepDate=""
 	...s DischDate=$zd(day,3)
    ...d GetAdmNotInMRInfo



	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GetAdmNotInMRInfo
	s data=$lb(AmdId,PapmiName,PapmiNo,AdmReasonDesc,DepDesc,AdmDocDesc,AdmisMR,RepDate,DischDate)
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod GetAdmNotInMRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmNotInMRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmNotInMRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmNotInMRExecute ]
{
    S AtEnd=$LIST(qHandle,1)
    S repid=$LIST(qHandle,2)
    S ind=$LIST(qHandle,3)

    S ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else{				//fetch row
	   Set Row=^CacheTemp(repid,ind)
	 }
	 // Save QHandle
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
