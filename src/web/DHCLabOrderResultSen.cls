Class web.DHCLabOrderResultSen Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod QueryResultSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryResultSenExecute(ByRef qHandle As %Binary, TSRowId As %String, TC As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s OrderID=$g(TSRowId)
	i '$l(OrderID) q ""
	s TSId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	i '$l(TSId) q ""
	s epis=$p(TSId,"||",1)
	s ts=$p(TSId,"||",2)
	s tscnt=$p(TSId,"||",3)
	s ant="" 
	f {
		s ant=$o(^TEPI(epis,1,ts,tscnt,"DATA",TC,"ANT",ant)) 
		q:ant=""
		s temStr=^(ant)
		s antName=""
		i $d(^TTAB("ANT",ant)) s antName=$p(^TTAB("ANT",ant),"\",1)
		///Antibiotics Extra Information 20081121
		s (engName,senResDesc,mic,mm,dosage,surem)=""
		i $d(^DHCANTIBIOTICS(ant)){
			s engName=$p(^DHCANTIBIOTICS(ant),"\",1)
			s dosage=$p(^DHCANTIBIOTICS(ant),"\",4)
			s surem=$p(^DHCANTIBIOTICS(ant),"\",5)
		}
		s senResDr=$p(temStr,"\",1)
		i $l(senResDr),$d(^TTAB("SENS",senResDr)){
			s senResDesc=$p(^TTAB("SENS",senResDr),"\",1)
		}
		s report=$p(temStr,"\",2)
		i report="Y"{
			s mic=$p(temStr,"\",3)
			s mm=$p(temStr,"\",4)
			i $e(mic,1)="." s mic="0"_mic
			i $e(mm,1)="." s mm="0"_mm
			Do OutPut
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	Set Data=$lb(ant,antName,engName,senResDesc,mic,mm,dosage,surem)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryResultSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultSenExecute ]
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

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据报告ID和项目得到药敏结果
/// Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：        报告ID和项目代码
/// Output：       抗生物代码,抗生素名称,抗生素英文名称,药敏结果,mic,mm,用法,尿液浓度用法
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryResultSen(TSRowId As %String, TC As %String) As %Query(ROWSPEC = "AntiCode:%String,AntiName:%String,AntiSyn:%String,Result:%String,MIC:%String,mm:%String,Dosage:%String,Surem:%String")
{
}

}
