Class web.DHCWL.V1.BKCDQry.KPIDataServ Extends %RegisteredObject
{

Query GetKpiInfo(searchV As %String, exceptKpi As %String, incDimCodes As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Name:%String,DimCodes:%String,DimDescs:%String")
{
}

ClassMethod GetKpiInfoExecute(ByRef qHandle As %Binary, searchV As %String, exceptKpi As %String, incDimCodes As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	
	k ^||TEMPDHCWL
	/*
	s ^TEMPDHCWL("GetKpiInfoExecute","searchV")=searchV
	s ^TEMPDHCWL("GetKpiInfoExecute","exceptKpi")=exceptKpi
	s ^TEMPDHCWL("GetKpiInfoExecute","incDimCodes")=incDimCodes
	*/
	if exceptKpi'="" {
		s len=$l(exceptKpi,",")
		f i=1:1:len {
			s ^||TEMPDHCWL("exceptKpi",$p(exceptKpi,",",i))=""	
		}
	}
	
	if incDimCodes'="" {
		s len=$l(incDimCodes,",")
		f i=1:1:len {
			s ^||TEMPDHCWL("dimCodes",$p(incDimCodes,",",i))=""	
		}
	}	
	
	s kpiID=""
	f {
		s kpiID=$o(^DHCWL.MKPI.MKPID(kpiID))
		q:kpiID=""
		
		if $d(^||TEMPDHCWL("exceptKpi")) && ($d(^||TEMPDHCWL("exceptKpi",kpiID))) continue
		
		s kpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(kpiID)
		s code=kpiObj.MKPICode
		s name=kpiObj.MKPIName
		
		s dimCodes=""
		s dimDescs=""		
		s order=""
		k ^||TEMPDHCWL("curDimCode")
		
		f {
			s order=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,order))
			q:order=""
			
			s kpiDimID=""
			s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,order,kpiDimID))
			q:kpiDimID=""
			
			s kpiDimObj=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(kpiDimID)
			s dimCode=kpiDimObj.MKPIDimCode
			
			s ^||TEMPDHCWL("curDimCode",dimCode)=""
			if dimCodes="" s dimCodes=dimCode
			else  s dimCodes=dimCodes_","_dimCode
			
			s dimDes=kpiDimObj.MKPIDimDes
			if dimDescs="" s dimDescs=dimDes
			else  s dimDescs=dimDescs_","_dimDes
			
			d kpiDimObj.%Close()
		}
		
		d kpiObj.%Close()
		
		if incDimCodes'="" {
			s dimC=""
			s dimIncludeFlag=0
			f {
				s dimC=$o(^||TEMPDHCWL("dimCodes",dimC))
				q:dimC=""
				
				if $d(^||TEMPDHCWL("curDimCode",dimC)) {
					s dimIncludeFlag=1
					q
				}
			}
			if dimIncludeFlag=0 continue
		}
		
		
		
		if searchV'="" {
			if kpiID'[searchV && ($SYSTEM.SQL.SQLUPPER(code)'[$SYSTEM.SQL.SQLUPPER(searchV)) && (name'[searchV) && (dimDescs'[searchV) continue 
		}
		s Data=$lb(kpiID,code,name,dimCodes,dimDescs)
		Do OutRow
	}
	
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetKpiInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKpiInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKpiInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKpiInfoExecute ]
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
