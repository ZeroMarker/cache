Class web.DHCENS.STBLL.HERP.Method.HisChargeZY Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 住院收费日报表
/// 包名之间用下划线连接，类名前用点，类名和方法名之间用下划线
/// d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.HERP.Method.HisChargeZY","HisChargeZY","2016-07-01","2016-08-01")
Query HisChargeZY(SDate As %String, EDate As %String) As %Query(ROWSPEC = "chargedate:%String,deptcode:%String,chargekindcode:%String,chargekindname:%String,patienttypecode:%String,chargemoney:%String,checkno:%String,patientname:%String,chargecode:%String,chargename:%String,beginno:%String,endno:%String,isback:%String") [ SqlProc ]
{
}

ClassMethod HisChargeZYExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s (chargedate,deptcode,chargekindcode,chargekindname,patienttypecode,chargemoney,checkno,patientname,chargecode,chargename,beginno,endno,isback)=""
	;s:(SDate="")||(SDate=$c(0)) SDate=$zd(+$h-1,3)
	;s:(EDate="")||(EDate=$c(0)) EDate=$zd(+$h-1,3)
	s:(SDate'="")&&(SDate'=$c(0)) SDate=$zdh(SDate,3)
	s:(EDate'="")&&(EDate'=$c(0)) EDate=$zdh(EDate,3)
	s:(SDate="")||(SDate=$c(0)) SDate=+$h-2
	s:(EDate="")||(EDate=$c(0)) EDate=+$h-2
	
	f Date=SDate:1:EDate d
	.s wlRowid=0 f  s wlRowid=$o(^Data.DHCWorkLoadI("FlagDate",Date,wlRowid)) q:wlRowid=""  d	;flagdate结算索引
 	..s WLData=$g(^Data.DHCWorkLoadD(wlRowid))
 	..s type=$list(WLData,11)       ;病人类型
 	..q:type="I"										;只取门诊病人
 	..s resLoc=$list(WLData,12)    ;开单科室
	..;s mTarAC=$p($g(^DHCWorkLoad(wlRowid)),"^",40)		;会计分类
	..s TarAC=$list(WLData,28)		;住院分类
	..s mTarAC=$p(^DHCTarC("IC",TarAC),"^",3)
	..s chargemoney=$list(WLData,58)	;总费用
	..s paadmrowid=$list(WLData,9)      //add by lipan 
	..s PAPMIRowID=$list(WLData,10) 
	..s patientname=$p($g(^PAPER(PAPMIRowID,"ALL")),"^")
	..;s ChargeID=$list(WLData,21)    ;医嘱项id
	..;s chargecode=$p($g(^ARCIM(+ChargeID,$p(ChargeID,"||",2),1)),"^")
	..;s chargename=$p($g(^ARCIM(+ChargeID,$p(ChargeID,"||",2),1)),"^",2)
	..s ChargeID=$list(WLData,35)    ;门诊收款员id
	..i ChargeID'=""  d
	...s chargecode=$p($g(^SSU("SSUSR",ChargeID)),"^")
	...s chargename=$p($g(^SSU("SSUSR",ChargeID)),"^",2)
	..s patienttyperowid=$p(^PAADM(paadmrowid,1),"^",7)
	
	..s deptcode=resLoc
	..s chargekindcode=mTarAC
	..s chargekindname=$p(^DHCTarC("TIC",mTarAC),"^",2)
	..s patienttypecode=patienttyperowid
	..if chargemoney>0 d
	... s isback=0
	..else  d
	... s isback=1
	..d:chargemoney'=0 OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputRow
	s chargedate=$zd(Date,3)
	s data=$lb(chargedate,deptcode,chargekindcode,chargekindname,patienttypecode,chargemoney,checkno,patientname,chargecode,chargename,beginno,endno,isback)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q $$$OK
}

ClassMethod HisChargeZYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HisChargeZYExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod HisChargeZYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HisChargeZYExecute ]
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
	;b
	Quit $$$OK
}

}
