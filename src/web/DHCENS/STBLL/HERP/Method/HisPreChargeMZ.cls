Class web.DHCENS.STBLL.HERP.Method.HisPreChargeMZ Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 门诊预交金
/// 包名之间用下划线连接，类名前用点，类名和方法名之间用下划线
/// d ##class(%ResultSet).RunQuery("web.DHCENS.Method.Query.HisPreChargeMZ","AccpredepositDataMZ","2014-09-16","2014-09-30")
Query AccpredepositDataMZ(SDate As %String, EDate As %String) As %Query(ROWSPEC = "Date:%String,PayTypeRowID:%String,PayTypeCode:%String,ChargeAmount:%String,PatName:%String,CasherCode:%String,CasherName:%String,RptNo:%String,Type:%String,AdmNo:%String,AdmType:%String,RowID:%String,IsBack:%String") [ SqlProc ]
{
}

ClassMethod AccpredepositDataMZExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;s:(SDate="")||(SDate=$c(0)) SDate=$zd(+$h-1,3)
	;s:(EDate="")||(EDate=$c(0)) EDate=$zd(+$h-1,3)
	s:(SDate'="")&&(SDate'=$c(0)) SDate=$zdh(SDate,3)
	s:(EDate'="")&&(EDate'=$c(0)) EDate=$zdh(EDate,3)
	s:(SDate="")||(SDate=$c(0)) SDate=+$h-2
	s:(EDate="")||(EDate=$c(0)) EDate=+$h-2
	f i=SDate:1:EDate  d
	.s AccMRowID="" ;^DHCACDi("AccM",0,"APDDate",{AccPD_PreDate},{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	.f  s AccMRowID=$o(^DHCACDi("AccM",0,"APDDate",i,AccMRowID)) q:AccMRowID=""  d
	..s AccPDParRef=$p(AccMRowID,"||",1)
	..s AccMPAPMIDR=$p(^DHCACD("AccM",AccPDParRef),"^",2)
	..s PatName=$p($g(^PAPER(AccMPAPMIDR,"ALL")),"^",1)
	..s AdmNo=$o(^PAPERdr(AccMPAPMIDR,"ADM","O",""),-1)
	..s:AdmNo'="" AdmType=$p($g(^PAADM(AdmNo)),"^",2)
	..s AccPDSubID=""
	..f  s AccPDSubID=$o(^DHCACDi("AccM",0,"APDDate",i,AccMRowID,"AccPD",AccPDSubID)) q:AccPDSubID=""  d
	...s Date=$zd(i,3) ;缴费日期
	...s ReportDate=$p($g(^DHCACD("AccM",AccMRowID,"AccPD",AccPDSubID)),"^",11) ;报表日期
	...s:ReportDate'="" ReportDate=$zd(ReportDate,3)
	...s ChargeMethodAccPDDr=$o(^DHCACD("AccM",AccMRowID,"AccPD",AccPDSubID,"P",0))
	...s ChargeMethod=$p($g(^DHCACD("AccM",AccMRowID,"AccPD",AccPDSubID,"P",ChargeMethodAccPDDr)),"^",1)
	...s:ChargeMethod'="" PayTypeCode=$p($g(^CT("CTPM",ChargeMethod)),"^",2) ;收费方式
	...s RptNo=$p($g(^DHCACD("AccM",AccMRowID,"AccPD",AccPDSubID)),"^",6) ;单据号
	...s ChargeAmount=$p($g(^DHCACD("AccM",AccMRowID,"AccPD",AccPDSubID)),"^",2) ;押金金额
	...s CasherCode=$p($g(^DHCACD("AccM",AccMRowID,"AccPD",AccPDSubID)),"^",5)
	...s:CasherCode'="" CasherName=$p($g(^SSU("SSUSR",CasherCode)),"^",2) ;收费员
	...s AccPDType=$p($g(^DHCACD("AccM",AccMRowID,"AccPD",AccPDSubID)),"^",1)
	...i AccPDType="P"  s Type="0"
	...e  s Type="1"
	...s RowID				= Date_"||"_ind
	...i ChargeAmount>0  d
	....s IsBack=0
	...else  d
	....s IsBack=1
	...s data=$lb(Date,ChargeMethod,PayTypeCode,ChargeAmount,PatName,CasherCode,CasherName,RptNo,Type,AdmNo,AdmType,RowID,IsBack)
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	q $$$OK
}

ClassMethod AccpredepositDataMZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccpredepositDataMZExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AccpredepositDataMZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccpredepositDataMZExecute ]
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
