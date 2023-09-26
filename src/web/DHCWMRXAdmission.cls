Import SQLUser

/// 对接诊统计查询
/// by ZF 2007-07-31
Class web.DHCWMRXAdmission Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 78;

ClassMethod QueryAdmiCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmiCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryAdmiCountExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:((FromDate=0)||(ToDate=0)) $$$OK
	Quit:((FromDate="")||(ToDate="")) $$$OK
	
	s JIndex=$j
	k ^CacheTemp(JIndex,"DHCWMRAdmission")
	
	f Date=FromDate:1:ToDate d
	.q:'$d(^PAADMi("PAADM_AdmDate",Date))
	.s Rowid=0
	.f  s Rowid=$o(^PAADMi("PAADM_AdmDate",Date,Rowid)) q:Rowid=""  d
	..s PatType=$p($g(^PAADM(Rowid)),"^",2)
	..q:PatType'="I"
	..;
	..;判断是否接诊
	..s PaadmRowid=Rowid                          
	..s CheckFlg=$$CheckAdmission(PaadmRowid)
	..q:CheckFlg=0
	..;
	..s VisitStatus=$p($g(^PAADM(Rowid)),"^",20)
	..q:((VisitStatus'="A")&&(VisitStatus'="D"))
	..s MRADMRowid=$p($g(^PAADM(Rowid)),"^",61)
	..s:MRADMRowid'="" PatCondRowid=$p($g(^MR(MRADMRowid,"PRO",1)),"^",40)
	..s:PatCondRowid'="" PatCond=$p($g(^MRC("COND",PatCondRowid)),"^",2)
	..q:$g(PatCond)=""
	..s WardRowid=+$p($g(^PAADM(Rowid)),"^",70)
	..s WardDesc=$p($g(^PAWARD(WardRowid)),"^",2)
	..s LocRowid=+$p($g(^PAWARD(WardRowid)),"^",5)
	..;s LocDesc=$p($g(^CTLOC(LocRowid)),"^",2)
	..s DepRowid=+$p($g(^CTLOC(LocRowid)),"^",19)
	..s DepDesc=$p($g(^RBC("DEP",DepRowid)),"^",2)
	..q:((DepDesc="")||(WardDesc=""))
	..;w DepDesc_"---"_WardDesc_"---"_PatCond,!
	..s ^CacheTemp(JIndex,"DHCWMRAdmission",DepRowid,WardRowid,PatCond)=+$g(^CacheTemp(JIndex,"DHCWMRAdmission",DepRowid,WardRowid,PatCond))+1
	..s ^CacheTemp(JIndex,"DHCWMRAdmission",DepRowid,0,PatCond)=+$g(^CacheTemp(JIndex,"DHCWMRAdmission",DepRowid,0,PatCond))+1
	..s ^CacheTemp(JIndex,"DHCWMRAdmission","N",0,PatCond)=+$g(^CacheTemp(JIndex,"DHCWMRAdmission","N",0,PatCond))+1
	
	s DepId=""
	f  s DepId=$o(^CacheTemp(JIndex,"DHCWMRAdmission",DepId)) q:DepId=""  d
	.s WardId=""
	.f  s WardId=$o(^CacheTemp(JIndex,"DHCWMRAdmission",DepId,WardId)) q:WardId=""  d
	..s (DepDesc,WardDesc,OPRatio,EPRatio,YBRatio,JRatio,WRatio)="",(OPCount,EPCount,Count,tmpRatio,YBCount,WCount,JCount)=0
	..s PatCond=""
	..f  s PatCond=$o(^CacheTemp(JIndex,"DHCWMRAdmission",DepId,WardId,PatCond)) q:PatCond=""  d
	...b:DepId="N"  //
	...s:((PatCond="危")||(PatCond="急")||(PatCond="病危")||(PatCond="病重")) EPCount=+$g(^CacheTemp(JIndex,"DHCWMRAdmission",DepId,WardId,PatCond))+EPCount
	...s:((PatCond="一般")||(PatCond="平稳")||(PatCond="单轨")||(PatCond="双轨")) OPCount=+$g(^CacheTemp(JIndex,"DHCWMRAdmission",DepId,WardId,PatCond))+OPCount
	...s YBCount=OPCount
	...s:((PatCond="急")||(PatCond="病重")) JCount=+$g(^CacheTemp(JIndex,"DHCWMRAdmission",DepId,WardId,PatCond))+JCount
	...s:((PatCond="危")||(PatCond="病危")) WCount=+$g(^CacheTemp(JIndex,"DHCWMRAdmission",DepId,WardId,PatCond))+WCount
	..s Count=EPCount+OPCount
	..i Count'=0 d
	...s tmpRatio=OPCount*100/Count
	...s OPRatio=$e(tmpRatio,1,5)_"%"
	...s tmpRatio=EPCount*100/Count
	...s EPRatio=$e(tmpRatio,1,5)_"%"
	...s tmpRatio=YBCount*100/Count
	...s YBRatio=$e(tmpRatio,1,5)_"%"
	...s tmpRatio=JCount*100/Count
	...s JRatio=$e(tmpRatio,1,5)_"%"
	...s tmpRatio=WCount*100/Count
	...s WRatio=$e(tmpRatio,1,5)_"%"
	..i WardId'=0 d
	...s WardDesc=$p($g(^PAWARD(WardId)),"^",2)
	...s DepDesc=""
	..e  d
	...s WardDesc=""
	...s:+DepId'=0 DepDesc=$p($g(^RBC("DEP",+DepId)),"^",2)
	...s:+DepId=0 DepDesc="合计"
	..s s=DepDesc_"^"_WardDesc_"^"_Count_"^"_OPCount_"^"_OPRatio_"^"_EPCount_"^"_EPRatio_"^"_YBCount_"^"_YBRatio_"^"_JCount_"^"_JRatio_"^"_WCount_"^"_WRatio
	..d BuildData
	
	k ^CacheTemp(JIndex,"DHCWMRAdmission")
	Quit $$$OK
	
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
CheckAdmission(PaadmRowid)
    ;是否接诊
    ;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s ret=0
	q:'$d(^DHCWMRVOL(0,"VolAdm",PaadmRowid)) ret
	s VolRowid=0
	f  s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",PaadmRowid,VolRowid)) q:VolRowid=""  d
	.s VolumeInfo=$g(^DHCWMRVOL(VolRowid))
	.s ActiveFlg=$p(VolumeInfo,"^",7)
	.s:ActiveFlg="Y" ret=1
	q ret
}

ClassMethod QueryAdmiCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmiCountExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 按科室，病区，病人入院情况统计入院人数
Query QueryAdmiCount(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "DepDesc:%String,WardDesc:%String,Count:%String,OPCount:%String,OPRatio:%String,EPCount:%String,EPRatio:%String,YBCount:%String,YBRatio:%String,JCount:%String,JRatio:%String,WCount:%String,WRatio:%String")
{
}

ClassMethod QueryAdmiByProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmiByProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryAdmiByProvExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:((FromDate=0)||(ToDate=0)) $$$OK
	Quit:((FromDate="")||(ToDate="")) $$$OK
	
	s JIndex=$j
	k ^CacheTemp(JIndex,"DHCWMRAdmiByProv")
	
	f Date=FromDate:1:ToDate d
	.q:'$d(^PAADMi("PAADM_AdmDate",Date))
	.s Rowid=0
	.f  s Rowid=$o(^PAADMi("PAADM_AdmDate",Date,Rowid)) q:Rowid=""  d
	..s PatType=$p($g(^PAADM(Rowid)),"^",2)
	..q:PatType'="I"
	..;
	..;判断是否接诊
	..s PaadmRowid=Rowid                          
	..s CheckFlg=$$CheckAdmission(PaadmRowid)
	..q:CheckFlg=0
	..;
	..s VisitStatus=$p($g(^PAADM(Rowid)),"^",20)
	..q:((VisitStatus'="A")&&(VisitStatus'="D"))
	..s PapmiRowid=$p($g(^PAADM(Rowid)),"^",1)             ;PaPatmas,PaPerson两个表相同的Rowid
	..s CityRowid=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",5) ;PaPerson
	..s ProvRowid=""
	..s:CityRowid'="" ProvRowid=$p($g(^CT("CIT",CityRowid)),"^",4)
	..s:ProvRowid="" ProvRowid=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",2) ;PaPatmas
	..s:ProvRowid="" ProvRowid="O"
	..s:CityRowid="" CityRowid=0
	..s ^CacheTemp(JIndex,"DHCWMRAdmiByProv",ProvRowid,CityRowid)=+$g(^CacheTemp(JIndex,"DHCWMRAdmiByProv",ProvRowid,CityRowid))+1
	..s:CityRowid'=0 ^CacheTemp(JIndex,"DHCWMRAdmiByProv",ProvRowid,0)=+$g(^CacheTemp(JIndex,"DHCWMRAdmiByProv",ProvRowid,0))+1
	
	s ProvRowid=0
	f  s ProvRowid=$o(^CacheTemp(JIndex,"DHCWMRAdmiByProv",ProvRowid)) q:ProvRowid=""  d
	.s CityRowid=""
	.f  s CityRowid=$o(^CacheTemp(JIndex,"DHCWMRAdmiByProv",ProvRowid,CityRowid)) q:CityRowid=""  d
	..s Count=0,ProvDesc="",CityDesc=""
	..s Count=+$g(^CacheTemp(JIndex,"DHCWMRAdmiByProv",ProvRowid,CityRowid))
	..s (CityDesc,ProvDesc)=""
	..s CityId=+CityRowid
	..s ProvId=+ProvRowid
	..s:CityId'=0 CityDesc=$p($g(^CT("CIT",CityId)),"^",2)
	..s:ProvId'=0 ProvDesc=$p($g(^CT("PROV",ProvId)),"^",2)
	..s:CityDesc'="" ProvDesc=""
	..s:((CityDesc="")&(ProvDesc="")) ProvDesc="其它"
	..s s=ProvDesc_"^"_CityDesc_"^"_Count
	..d BuildData
	
	k ^CacheTemp(JIndex,"DHCWMRAdmiByProv")
	Quit $$$OK
}

ClassMethod QueryAdmiByProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmiByProvExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 按省，市统计病人入院情况
Query QueryAdmiByProv(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "ProvDesc:%String,CityDesc:%String,Count:%String")
{
}

}
