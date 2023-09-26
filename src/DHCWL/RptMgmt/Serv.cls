Class DHCWL.RptMgmt.Serv Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("DHCWL.RptMgmt.Serv","QryRptMgmtDataUsedLike","")
Query QryRptMgmtDataUsedLike(searchValue As %String) As %Query(ROWSPEC = "ID:%Integer,AdvUser:%String, AuxiliaryMenuName:%String, CSPName:%String, CreateDate:%Date,Demo:%String, DepMaintainer:%String, Filter:%String, HisTableName:%String, KPIName:%String, MenuName:%String, ProMaintainer:%String, ProgramLogic:%String, QueryName:%String, RaqName:%String,RowColShow:%String, Spec:%String, UPdateDate:%Date,UsedByDep:%String,CellSubgrpMap:%String ")
{
}

ClassMethod QryRptMgmtDataUsedLikeExecute(ByRef qHandle As %Binary, searchValue As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s mgmtID=""
	f {
		s mgmtID=$o(^DHCWL.RptMgmt.RptCfgD(mgmtID))	
		q:+$g(mgmtID)=0
		s validFlag=1
		
		s rptObj=##class(DHCWL.RptMgmt.RptCfg).%OpenId(mgmtID)
		k proValue
		s proValue("AdvUser")=rptObj.AdvUser
		s proValue("AuxiliaryMenuName")=rptObj.AuxiliaryMenuName
		s proValue("CSPName")=rptObj.CSPName
		s proValue("CreateDate")=rptObj.CreateDate
		s proValue("Demo")=rptObj.Demo
		s proValue("DepMaintainer")=rptObj.DepMaintainer
		s proValue("Filter")=rptObj.Filter
		s proValue("HisTableName")=rptObj.HisTableName
		s proValue("KPIName")=rptObj.KPIName
		s proValue("MenuName")=rptObj.MenuName
		s proValue("ProMaintainer")=rptObj.ProMaintainer
		s proValue("ProgramLogic")=rptObj.ProgramLogic
		s proValue("QueryName")=rptObj.QueryName
		s proValue("RaqName")=rptObj.RaqName
		s proValue("RowColShow")=rptObj.RowColShow
		s proValue("Spec")=rptObj.Spec
		s proValue("UPdateDate")=rptObj.UPdateDate
		s proValue("UsedByDep")=rptObj.UsedByDep
		s proValue("CellSubgrpMap")=rptObj.CellSubgrpMap
		if searchValue'="" {
			s validFlag=0
			s proName="" 
			f {
				s proName=$o(proValue(proName))	
				q:$g(proName)=""
				s proV=proValue(proName)
				if proV[searchValue {
					s validFlag=1
					q
				}
			}
		}
		
		if validFlag=1 {
			s Data=$lb(mgmtID, rptObj.AdvUser, rptObj.AuxiliaryMenuName, rptObj.CSPName, rptObj.CreateDate, rptObj.Demo, rptObj.DepMaintainer, rptObj.Filter, rptObj.HisTableName, rptObj.KPIName, rptObj.MenuName, rptObj.ProMaintainer, rptObj.ProgramLogic, rptObj.QueryName, rptObj.RaqName, rptObj.RowColShow, rptObj.Spec, rptObj.UPdateDate, rptObj.UsedByDep,rptObj.CellSubgrpMap )
			Do OutRow		
		}
	}

    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryRptMgmtDataUsedLikeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRptMgmtDataUsedLikeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRptMgmtDataUsedLikeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRptMgmtDataUsedLikeExecute ]
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
