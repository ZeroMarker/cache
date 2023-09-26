Class web.DHCENS.STBLL.HERP.Method.HisChargeMZ Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 门诊收费日报表
/// 包名之间用下划线连接，类名前用点，类名和方法名之间用下划线
/// d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.HERP.Method.HisChargeMZ","HisChargeMZ","2014-09-16","2014-09-16")
Query HisChargeMZ(SDate As %String, EDate As %String) As %Query(ROWSPEC = "chargedate:%String,deptcode:%String,chargekindcode:%String,chargekindname:%String,patienttypecode:%String,chargemoney:%String,checkno:%String,patientname:%String,chargecode:%String,chargename:%String,beginno:%String,endno:%String,isback:%String") [ SqlProc ]
{
}

ClassMethod HisChargeMZExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
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
	..s mTarOut=$list(WLData,30)		;门诊分类
	..s mTarOutDL=$p(^DHCTarC("OC",mTarOut),"^",3)
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
	..s mDate=$p($zd(Date,3),"-",1,2)
	..s deptcode=resLoc
	..i type'="H" d
	...s chargekindcode=mTarOutDL
	...s chargekindname=$P(^DHCTarC("TOC",mTarOutDL),"^",2)  ;$p(^DHCTarC("AC",mTarAC),"^",2)
	..e  d
	...s chargekindcode="TJ"
	...s chargekindname="体检费"
	..s patienttypecode=patienttyperowid
	..if chargemoney>=0 d
	...s isback=0
	..else  d
	...s isback=1
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

ClassMethod HisChargeMZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HisChargeMZExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod HisChargeMZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HisChargeMZExecute ]
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
