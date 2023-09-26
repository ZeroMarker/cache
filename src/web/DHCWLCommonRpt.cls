Class web.DHCWLCommonRpt Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator?      yw
/// CreatDate?    2014-08
/// description:  统计门诊、住院、体检医嘱费用和结算费用
/// Table?        DHC_WorkLoad  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommonRpt","GetAdmTypeFee","2013-07-10","2013-07-15")
Query GetAdmTypeFee(startDate As %String, endDate As %String, hosId As %String) As %Query(ROWSPEC = "typeDes:%String,ordfee:%Float,flagfee:%Float") [ SqlProc ]
{
}

ClassMethod GetAdmTypeFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    k ^TEMPDHCWL($j)
	q:startDate="" $$$OK
	q:endDate="" $$$OK	
	
	
	s sDate=$zdh(startDate,3)
    s eDate=$zdh(endDate,3)
	s orAnaesRowId=""
	
	f date=sDate:1:eDate  d 
 	.;统计医嘱费用
 	.s wlid=0 f  s wlid=$o(^DHCWorkLoad(0,"ORDDATE",date,wlid)) q:wlid=""  d
 	..s adm=$p(^DHCWorkLoad(wlid),"^",12)
 	..q:'$d(^PAADM(adm))
 	..s depDr=$p(^DHCWorkLoad(wlid),"^",3)
 	..s hosDr=$p(^CTLOC(depDr),"^",22)
 	..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 	..s type=$p(^PAADM(adm),"^",2)
 	..i type="E" s type="O"
 	..s fee=$p(^DHCWorkLoad(wlid),"^",16)
 	..s ^TEMPDHCWL($j,type,"OrdDate")=$g(^TEMPDHCWL($j,type,"OrdDate"))+fee
 	.;统计结算费用
 	.s wlid=0 f  s wlid=$o(^DHCWorkLoad(0,"FlagDate",date,wlid)) q:wlid=""  d
 	..s adm=$p(^DHCWorkLoad(wlid),"^",12)
 	..q:'$d(^PAADM(adm))
 	..s depDr=$p(^DHCWorkLoad(wlid),"^",3)
 	..s hosDr=$p(^CTLOC(depDr),"^",22)
 	..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 	..s type=$p(^PAADM(adm),"^",2)
 	..i type="E" s type="O"
 	..s fee=$p(^DHCWorkLoad(wlid),"^",16)
 	..s ^TEMPDHCWL($j,type,"FlagDate")=$g(^TEMPDHCWL($j,type,"FlagDate"))+fee
 
    s type=0 f  s type=$o(^TEMPDHCWL($j,type)) q:type=""  d
 	.s typeDes=$Case(type,"O":"门诊","I":"住院","H":"体检",:"其它") ;就诊类型
 	.s ordfee=$g(^TEMPDHCWL($j,type,"OrdDate"))
 	.s flagfee=$g(^TEMPDHCWL($j,type,"FlagDate"))
 	.;w typeDes_"^"_ordfee_"^"_flagfee,!
 	.d OutputRow1
 	
 	k ^TEMPDHCWL($j)
    Quit $$$OK
    	
OutputRow1
    s data=$lb(typeDes,ordfee,flagfee)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetAdmTypeFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmTypeFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmTypeFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmTypeFeeExecute ]
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

Storage Default
{
<Data name="DHCWLCommonRptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWLCommonRptD</DataLocation>
<DefaultData>DHCWLCommonRptDefaultData</DefaultData>
<IdLocation>^web.DHCWLCommonRptD</IdLocation>
<IndexLocation>^web.DHCWLCommonRptI</IndexLocation>
<StreamLocation>^web.DHCWLCommonRptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
