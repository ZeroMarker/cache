Class DHCWL.CompareRegData Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 挂号数据核对
/// d ##class(%ResultSet).RunQuery("DHCWL.CompareRegData","GetRegData","2020-5-1","2020-9-1","")
Query GetRegData(Sday As %String, Eday As %String, hosId) As %Query(ROWSPEC = "admCount:%Float,wrCount:%Float") [ SqlProc ]
{
}

ClassMethod GetRegDataExecute(ByRef qHandle As %Binary, Sday As %String, Eday As %String, hosId = "") As %Status
{
 k ^TEMPDHCWL($j)
 s ^tmpdwq=Sday_","_Eday_","_hosId
 n (qHandle,Sday,Eday,hosId)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:Sday="" $$$OK
 q:Eday="" $$$OK
 s Sday=$zdh(Sday,3)
 s Eday=$zdh(Eday,3)
 f day=Sday:1:Eday  d
 .s admId=0 f  s admId=$o(^PAADMi("PAADM_AdmDate",day,admId)) q:admId=""  d
 ..q:$p(^PAADM(admId),"^",2)="I"
 ..q:$p(^PAADM(admId),"^",2)="H"	;add by zl 2017-03-27
 ..q:$p(^PAADM(admId),"^",20)="C"
 ..s mPAADMDepCodeDR=$p(^PAADM(admId),"^",4)   //PAADM_DepCode_DR
 ..s mCTLOCHospitalDR=$p(^CTLOC(mPAADMDepCodeDR),"^",22)         //院区
 ..q:((","_hosId_",")'[(","_mCTLOCHospitalDR_","))&&(hosId'="")
 ..s upDate=$p(^PAADM(admId,1),"^",42)
 ..q:upDate=(+$h)
 ..s admCount=$g(admCount)+1
 
 .s wrId=0 f  s wrId=$o(^DHCWorkRegReport(0,"ADMDATE",day,wrId)) q:wrId=""  d
 ..s wrAdmId=$p(^DHCWorkRegReport(wrId),"^",15)
 ..s num=$p(^DHCWorkRegReport(wrId),"^",29)
 ..s mWRADMDEPDR=$p(^DHCWorkRegReport(wrId),"^",5)       //WR_ADMDEP_DR
 ..s mCTLOCHospitalDR=$p(^CTLOC(mWRADMDEPDR),"^",22)         //院区
 ..q:((","_hosId_",")'[(","_mCTLOCHospitalDR_","))&&(hosId'="")
 ..s wrCount=$g(wrCount)+num
 
 s ^CacheTemp(repid,ind)=$lb(admCount,wrCount)
 s ind=ind+1
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
}

ClassMethod GetRegDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRegDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegDataExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCWL.CompareRegData","GetRegDataDetails","2020-5-1","2020-9-2")
Query GetRegDataDetails(Sday As %String, Eday As %String, hosId As %String) As %Query(ROWSPEC = "adm:%String,PatNo:%String,PatName:%String,PatAge:%String,PatSex:%String,PatReason:%String,admdate:%String,update:%String,AdmStatus:%String,datePara:%String") [ SqlProc ]
{
}

ClassMethod GetRegDataDetailsExecute(ByRef qHandle As %Binary, Sday As %String = "2020-5-1", Eday As %String = "2020-9-2", hosId As %String = "") As %Status
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
 .s admId=0 f  s admId=$o(^PAADMi("PAADM_AdmDate",day,admId)) q:admId=""  d
 ..q:$p(^PAADM(admId),"^",2)="I"
 ..q:$p(^PAADM(admId),"^",2)="H"	;add by zl 2017-03-27
 ..q:$p(^PAADM(admId),"^",20)="C"
 ..s upDate=$p(^PAADM(admId,1),"^",42)
 ..q:upDate=(+$h)
 ..s depDr=$p(^PAADM(admId),"^",4)
 ..s hosDr=$p(^CTLOC(depDr),"^",22)
 ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 ..s ^TEMPDHCWL($j,admId,"adm")=1
 
 .s wrId=0 f  s wrId=$o(^DHCWorkRegReport(0,"ADMDATE",day,wrId)) q:wrId=""  d
 ..s wrAdmId=$p(^DHCWorkRegReport(wrId),"^",15)
 ..s num=$p(^DHCWorkRegReport(wrId),"^",29)
 ..s mWRADMDEPDR=$p(^DHCWorkRegReport(wrId),"^",5)       //WR_ADMDEP_DR
 ..s hosDr=$p(^CTLOC(mWRADMDEPDR),"^",22)
 ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 ..s ^TEMPDHCWL($j,wrAdmId,"wr")=$g(^TEMPDHCWL($j,wrAdmId,"wr"))+num
 
 s paadmDr=0 f  s paadmDr=$o(^TEMPDHCWL($j,paadmDr)) q:paadmDr=""  d
 .q:$g(^TEMPDHCWL($j,paadmDr,"wr"))=0
 .s err=$g(^TEMPDHCWL($j,paadmDr,"adm"))-$g(^TEMPDHCWL($j,paadmDr,"wr"))
 .q:err=0
 .s papmi=$p(^PAADM(paadmDr),"^",1)
 .s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
 .s PatName=$$GetPapmiName^DHCWLCommon(papmi)
 .s PatAge=$$GetAge^DHCWLCommon(papmi)
 .i PatAge=0  d	//显示不足一岁的患者年龄为几个月
 ..s birthDate=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
 ..s birthDate=$zd(birthDate,3)
 ..s birthMonth=$p(birthDate,"-",2)
 ..s nowMonth=$p($zd(+$h,3),"-",2)
 ..s month=nowMonth-birthMonth
 ..i month<0  s month=nowMonth+12-birthMonth
 ..s PatAge=month_"月"
 .e  s PatAge=PatAge_"岁"	//在年龄后面加岁
 .s PatSex=$$GetSex^DHCWLCommon(papmi)
 .s PatReason=$$GetReason^DHCWLCommon(paadmDr)
 .s admdate=$zd($p(^PAADM(paadmDr),"^",6),3)
 .s update=$p(^PAADM(paadmDr,1),"^",42)
 .i update="" s update=""
 .e  s update=$zd(update,3)
 .s AdmStatus=$p(^PAADM(paadmDr),"^",20)
 .s datePara=""
 .s wrDr=0 f  s wrDr=$o(^DHCWorkRegReport(0,"PAADM",paadmDr,wrDr)) q:wrDr=""  d
 ..s wrDate=$p(^DHCWorkRegReport(wrDr),"^",4)
 ..i datePara="" s datePara=$zd(wrDate,3)
 ..e  s datePara=datePara_","_$zd(wrDate,3)
 .d OutputRow
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
 
OutputRow
	set Data=$lb(paadmDr,PatNo,PatName,PatAge,PatSex,PatReason,admdate,update,AdmStatus,datePara)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRegDataDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegDataDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRegDataDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegDataDetailsExecute ]
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
