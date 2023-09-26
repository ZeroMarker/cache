Import sqluser

Class DHCBILL.Diet.DHCIPMealItemSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod FindItemSetDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemSetDetailExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindItemSetDetailExecute(ByRef qHandle As %Binary, ItmSetDR As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItemSet","FindItemSetDetail","5747")
    Set repid=$I(^CacheTemp)
    s ind=1
    s ItmSetDR=$g(ItmSetDR)
    i ItmSetDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s MISRowID="0"
    f  s MISRowID=$o(^DHCIPMEALITEMSET(0,"SET",ItmSetDR,MISRowID)) q:MISRowID=""  d
    .s s=$g(^DHCIPMEALITEMSET(MISRowID))
    .s ItmSubDR=$p(s,"^",6)
    .s Status=$p(s,"^",4)
    .s CreatorDR=$p(s,"^",1)
    .s Creator=""
    .i CreatorDR'="" s Creator=$p(^SSU("SSUSR",CreatorDR),"^",2) 
    .s CreatDate=$p(s,"^",2)
    .s:CreatDate'="" CreatDateDesc=$zd(CreatDate,3) 
    .s CreatTime=$p(s,"^",3)
    .s:CreatTime'="" CreatTimeDesc=$zt(CreatTime,1)
    .s AbortUser=$p(s,"^",7)
    .s AbortUserName=""
    .i AbortUser'="" s AbortUserName=$p(^SSU("SSUSR",AbortUser),"^",2) 
    .s AbortDate=$p(s,"^",8)
    .s:AbortDate'="" AbortDateDesc=$zd(AbortDate,3) 
    .s AbortTime=$p(s,"^",9)
    .s:AbortTime'="" AbortTimeDesc=$zt(AbortTime,1)
    .;q:Status="A"	;过滤作废的明细 
    .i Status="A" s StatusDesc="作废"
    .e  s StatusDesc="正常"
    .q:('$d(^DHCIPMEALITEM(ItmSubDR)))
    .s ss=$g(^DHCIPMEALITEM(ItmSubDR))
    .s ItmDesc=$p(ss,"^",2)
    .s ItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(ItmSubDR,+$h)
    .s ItmUomID=$p(ss,"^",5)
    .i ItmUomID'="" s ItmUom=$p($g(^DHCIPMEALUOM(ItmUomID)),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(MISRowID,ItmSetDR,ItmSubDR,ItmDesc,ItmUom,ItmPrice,StatusDesc,$g(Creator),$g(CreatDateDesc),$g(CreatTimeDesc),$g(AbortUserName),$g(AbortDateDesc),$g(AbortTimeDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindItemSetDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemSetDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Query FindItemSetDetail(ItmSetDR As %String) As %Query(ROWSPEC = "rowid:%String,itemsetdr:%String,itemsubdr:%String,itmdesc:%String,uom:%String,price:%String,status:%String,creator:%String,creatdate:%String,creattime:%String,abortuser:%String,abortdate:%String,aborttime:%String")
{
}

/// Lid
/// 2012-03-08
/// 套餐明细插入
/// w ##class(DHCBILL.Diet.DHCIPMealItemSet).Insert(5751,"5740^5743^5774","1","")
ClassMethod Insert(ItmSetDR As %String, ItmInfo As %String, Guser As %String, ExpStr As %String = "")
{
	n (ItmSetDR,ItmInfo,Guser,ExpStr)
	;
	q:+ItmSetDR=0 "-1"
	;q:'$d(^DHCIPMEALITEMSET(0,"SET",ItmSetDR)) "-2"
	Tstart
	s DHCMISRowID=""
	s RetVal=0
	f i=1:1:$l(ItmInfo,"^") d  q:RetVal'=0
	.s ItmSubDR=$p(ItmInfo,"^",i)
	.q:+ItmSubDR=0
	.k PLIST
	.q:($d(^DHCIPMEALITEMSET(0,"ITMSET",ItmSetDR,"ITMSUB",ItmSubDR)))
	.s PLIST(2)=Guser,PLIST(3)=+$h,PLIST(4)=$p($h,",",2)
	.S PLIST(5)="",PLIST(6)=ItmSetDR,PLIST(7)=ItmSubDR
	.&sql(INSERT INTO DHC_IPMealItemSet Values PLIST())
	.s RetVal=SQLCODE
	;
	i RetVal=0 tcommit
	e  trollback
	q RetVal
}

/// Lid
/// 2012-03-08
/// 套餐明细删除
/// w ##class(DHCBILL.Diet.DHCIPMealItemSet).Abort(3,"1","")
ClassMethod Abort(DHCMISDR As %String, Guser As %String, ExpStr As %String = "")
{
	n (DHCMISDR,Guser,ExpStr)
	q:+DHCMISDR=0 "-1"
	q:'$d(^DHCIPMEALITEMSET(DHCMISDR)) "-2"
	Tstart
	s RetVal=0
	k PLIST
	s RetVal=..SELECT(DHCMISDR)
	i +RetVal=0{
		k PLIST(1)
		s PLIST(5)="A"	
		s PLIST(8)=Guser
		s PLIST(9)=+$h
		s PLIST(10)=$p($h,",",2)
		s RetVal=..UPDATE(DHCMISDR)	
	}
	;
	i RetVal=0 tcommit
	e  trollback
	q RetVal
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_IPMealItemSet WHERE DHCMIS_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	&sql(UPDATE DHC_IPMealItemSet VALUES PLIST() WHERE DHCMIS_RowID= :RowId)
	q SQLCODE
	;
}

Storage Default
{
<Data name="DHCIPMealItemSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCBILL.Diet.DHCIPMealItemSetD</DataLocation>
<DefaultData>DHCIPMealItemSetDefaultData</DefaultData>
<IdLocation>^DHCBILL.Diet.DHCIPMealItemSetD</IdLocation>
<IndexLocation>^DHCBILL.Diet.DHCIPMealItemSetI</IndexLocation>
<StreamLocation>^DHCBILL.Diet.DHCIPMealItemSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
