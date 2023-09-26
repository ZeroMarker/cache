Class DHCWL.DM.I.BaseQuery Extends %RegisteredObject
{

// d ##class(DHCWL.DM.I.BaseQuery).Test()

ClassMethod Test()
{
	s cql="rs1:{"_
        "from: /workload.t,"_
        "dims :WorkLoad_Type,WorkLoad_RecDep_DR->Code,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
        "metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,"_
        "filter:  (WorkLoad_OrdDate between(2013-01-01,2013-01-01))  &&  WorkLoad_Type contain([O]) && WorkLoad_PAPMI_DR >= (4) && WorkLoad_PAPMI_DR <= (88) ,"_
        "print:true,"_
      "};"
    ;s cql=^lhh
    d ##class(%ResultSet).RunQuery("DHCWL.DM.I.BaseQuery","CQL",cql)
}

Query CQL(cqlExpression As %Text, delimiter = ",") As %Query(ROWSPEC = "RSName:%String:resultSetName,Dims:%String:DimList,Metrics:%String:MetricList") [ SqlProc ]
{
}

ClassMethod CQLExecute(ByRef qHandle As %Binary, cqlExpression As %Text, delimiter = ",") As %Status
{
	;s delimiter  = ","
	;s ^lhh=cqlExpression
	;s ^lhh(1)=delimiter
	s startTime=$p($h,",",2)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s status=$$$OK
	s parser=##class(DHCWL.DM.Core.CQLParser).%New(cqlExpression)
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	s status=executor.Execute()
	b ;1
	if status'=$$$OK{
	  d DecomposeStatus^%apiOBJ(status,.err,"-d") 
	  s errStr="" ,oneErr="" f {
	    s oneErr=$o(err(oneErr))
	    q:oneErr=""
	    s errStr=errStr_"  "_err(oneErr)
	  }
	  s ^CacheTemp(repid,ind)=$lb(errStr,"","")
      s ind=ind+1
      q $$$OK
	}
	q:status'=$$$OK status
	s endTime=$p($h,",",2)
	s ind1=$i(^temp("lhh","CQLExecute"))
    s ^temp("lhh",ind1,"PhysicalExecutor")=(endTime-startTime)
	s list=executor.GetPrintRSList()
	s len=$ll(list)
	f i=1:1:len{
	  s rs=$lg(list,i)
	  continue:rs=""
	  s it=executor.GetIterator(rs)
	  while (it.HasNext()){
		s lb=$lb(rs,$lts(it.CurDims(),delimiter),$lts(it.CurMetrics(),delimiter))	
		s ^CacheTemp(repid,ind)=lb
        s ind=ind+1
	  }
	}
	d executor.Close()
	s endTime2=$p($h,",",2)
    s ^temp("lhh",ind1,"CQLRSITE")=(endTime2-endTime)
	q status
}

ClassMethod CQLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CQLExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod CQLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CQLExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}else {				
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

}
