Class web.DHCENS.STBLL.HERP.Method.HisPreChargeZY Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 住院预交金
/// 包名之间用下划线连接，类名前用点，类名和方法名之间用下划线
/// d ##class(%ResultSet).RunQuery("web.DHCENS.Method.Query.HisPreChargeZY","AccpredepositData","2012-03-31","2012-03-31")
Query AccpredepositData(SDate As %String, EDate As %String) As %Query(ROWSPEC = "Date:%String,PayTypeRowID:%String,PayTypeCode:%String,ChargeAmount:%String,PatName:%String,CasherCode:%String,CasherName:%String,RptNo:%String,Type:%String,AdmNo:%String,AdmType:%String,RowID:%String,IsBack:%String") [ SqlProc ]
{
}

ClassMethod AccpredepositDataExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
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
	.s prtID=""
	.f  s prtID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",i,prtID)) q:prtID=""  d
	..s PrtStatus=$p($g(^DHCSFPRINTDETAIL(prtID)),"^",8)
	..q:PrtStatus=2
	..s ReportDate=$p($g(^DHCSFPRINTDETAIL(prtID)),"^",2)
	..s:ReportDate'="" Date=$zd(ReportDate,3)
	..s RptNo=$p($g(^DHCSFPRINTDETAIL(prtID)),"^",1)
	..s AdmNo=$p($g(^DHCSFPRINTDETAIL(prtID)),"^",4)
	..s NameCode=$p($g(^PAADM(AdmNo)),"^",1)
	..s PatName=$p($g(^PAPER(NameCode,"ALL")),"^",1)
	..s AdmType=$p($g(^PAADM(AdmNo)),"^",2)
	..i PrtStatus="1"  s Type="0"
	..e  s Type="1"
 	..s ChargeMethod=$p($g(^DHCSFPRINTDETAIL(prtID)),"^",9)
 	..s:ChargeMethod'="" PayTypeCode=$p($g(^CT("CTPM",ChargeMethod)),"^",2)
	..s CasherCode=$p($g(^DHCSFPRINTDETAIL(prtID)),"^",20)
	..s:CasherCode'="" CasherName=$p($g(^SSU("SSUSR",CasherCode)),"^",2)
	..s ChargeAmount=$p($g(^DHCSFPRINTDETAIL(prtID)),"^",6)
	..s RowID				= Date_"||"_ind
	..i ChargeAmount>0  d
	...s IsBack=0
	..else  d
	...s IsBack=1
	..s data=$lb(Date,ChargeMethod,PayTypeCode,ChargeAmount,PatName,CasherCode,CasherName,RptNo,Type,AdmNo,AdmType,RowID,IsBack)
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	q $$$OK
}

ClassMethod AccpredepositDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccpredepositDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AccpredepositDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccpredepositDataExecute ]
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
	Quit $$$OK
}

}
