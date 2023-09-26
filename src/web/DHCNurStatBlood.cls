Class web.DHCNurStatBlood Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Query FindInfo(stdate As %Library.Date, enddate As %Library.Date) As %Query(ROWSPEC = "NurName:%String,ARCIMId:%String,labNo:%String")
{
}

ClassMethod FindInfoExecute(ByRef qHandle As %Binary, stdate As %Library.Date, enddate As %Library.Date) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	i $G(stdate)="" s stdate=$p($h,",")
	i $G(edate)="" s edate=$p($h,",")
	f PrtDate=stdate:1:edate  d
	.s RowId=0
	.f  s RowId=$o(^DHCOrdExec(0,"Date",PrtDate,RowId))  q:RowId=""  d
	..s OEOREDr=$p(^DHCOrdExec(RowId),"^",1)
	..;s NurId=$p(^DHCOrdExec(RowId),"^",12)
	..s oeordId=$p(OEOREDr,"||",1)
	..s oeoriSub=$p(OEOREDr,"||",2)
	..s oeoreSub=$p(OEOREDr,"||",3)
	..s NurId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",10)
	..q:NurId=""
	..s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20) //标本号
	..s ARCIMId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) //医嘱ID
	..s ^TEMPExecStat($j,"ARCIMId",NurId)=$g(^TEMPExecStat($j,"ARCIMId",NurId))+1 //医嘱数量
	..i '$d(^TEMPExecStat($j,"Lab",NurId,labNo))  d
	...s ^TEMPExecStat($j,"labNo",NurId)=$g(^TEMPExecStat($j,"labNo",NurId))+1
	...s ^TEMPExecStat($j,"Lab",NurId,labNo)=labNo
	.//k ^TEMPExecStat($j,"Lab",NurId,labNo)
	s NurId=""
	f  s NurId=$o(^TEMPExecStat($j,"ARCIMId",NurId))  q:NurId=""  d
	.s ARCIMId=$p(^TEMPExecStat($j,"ARCIMId",NurId),"^")
	.s labNo=$p(^TEMPExecStat($j,"labNo",NurId),"^")
	.s CtpcpId=$p($g(^SSU("SSUSR",NurId)),"^",14)
	.i CtpcpId=""  d
	..s NurName="测试用ID无意义"
	.e  d
	..s NurName=$p($g(^CTPCP(CtpcpId,1)),"^",2)
	.d OutputRow
	k ^TEMPExecStat
	Set qHandle=$lb(0,repid,0)
	Quit 1
OutputRow
	set Data=$lb(NurName,ARCIMId,labNo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	quit
}

ClassMethod FindInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCNurStatBloodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurStatBloodD</DataLocation>
<DefaultData>DHCNurStatBloodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNurStatBloodD</IdLocation>
<IndexLocation>^web.DHCNurStatBloodI</IndexLocation>
<StreamLocation>^web.DHCNurStatBloodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
