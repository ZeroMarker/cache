Class web.DHCNurTransPlan Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCNurTransPlan","FindTransPlan","2013-01-17^2014-06-18^N^Y")
Query FindTransPlan(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPlanExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s StDate=$zdh($P(parr,"^",1),3)
	s EndDate=$zdh($P(parr,"^",2),3)
	s Valid=$P(parr,"^",3)
	s Status=$P(parr,"^",4)
	f AdmDate=StDate:1:EndDate d
	.s ID="" f  s ID=$O(^DHCMGNUR.MgNurTransPlanI("Date"," "_AdmDate,ID)) q:ID=""  d
	..s a=##class(DHCMGNUR.MgNurTransPlan).%OpenId(ID)
	..s PlanValid=a.PlanValid
	..s PlanStatus=a.PlanStatus
	..q:(Status="N")&&(PlanStatus'=Status)
	..q:(Valid="N")&&(PlanValid=Valid)
	..s ret=##class(DHCMGNUR.MgNurTransPlan).getVal(ID)
	..d OutputPlanRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPlanRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransPlanExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod FindTransPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCNurTransPlan","FindNurNowLoc","")
Query FindNurNowLoc(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurNowLocExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s WardCode=$O(^CTLOC(0,"Code",$zcvt("轮转","U"),""))
	s ID="" f  s ID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardCode,ID)) q:ID=""  d
	.s nowStDate=""
	.s object=##class(DHCMGNUR.MgPersons).%OpenId(ID)
	.s PersonID=object.PersonID
	.s PersonName=object.PersonName
	.q:(parr'="")&&($F(PersonName,parr)=0)
	.s PersonTempDepDR=object.PersonTempDepDR
	.s PersonWorkDateTime=object.PersonWorkDateTime
	.i PersonTempDepDR'="" s TempWardCode=$P(^CTLOC(PersonTempDepDR),"^",1)
	.else  s TempWardCode=""
	.s TransID="" f  s TransID=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_PersonID,TransID)) q:TransID=""  d
	..s a=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransID)
	..s PerDepart=a.PerDepart
	..s PerTranEndDate=a.PerTranEndDate
	..s PerTranStDate=a.PerTranStDate
	..q:(PerTranStDate>+$h)||((PerTranEndDate<+$h)&&(PerTranEndDate'=""))
	..s PerLastDep=..FindTransDepByNur(PersonID)
	..s PerDepartCode=$P(^CTLOC(PerDepart),"^",1)
	..s nowStDate=$zd(PerTranStDate,3)
	..s TempWardCode=PerDepartCode
	.s ret="PersonID|"_PersonID_"^PersonName|"_PersonName_"^TempWardCode|"_TempWardCode_"^WorkStDate|"_$zd(PersonWorkDateTime,3)_"^NowStDate|"_nowStDate_"^PerLastDep|"_PerLastDep
	.d OutputNurRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurRow
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurNowLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurNowLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod FindNurNowLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurNowLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTransDepByNur(NurId As %String) As %String
{
	q:NurId=""
	s ret=""
	s tdid="" f  s tdid=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_NurId,tdid)) q:tdid=""  d
	.s td=##class(DHCMGNUR.MgNurTransDep).%OpenId(tdid)
	.s PerDepart=td.PerDepart
	.s PerDepartCode=$P(^CTLOC(PerDepart),"^",1)
	.s PerTranStDate=td.PerTranStDate
	.s PerTranEndDate=td.PerTranEndDate
	.s PerTranCurrent=td.PerTranCurrent
	.q:(PerTranCurrent="Y")||(PerTranStDate>+$h)||(PerTranEndDate>+$h)
	.i $F(ret,PerDepartCode)=0 d
	..i ret'="" s ret=ret_";"_PerDepartCode
	..e  s ret=PerDepartCode
	q ret
}

Query FindNurTransDep(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurTransDepExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCNurRstChangeLoc","FindNurTransDep","8869")
	s repid=$I(^CacheTemp)
	s ind=1
	if parr=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s tdid="" f  s tdid=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_parr,tdid)) q:tdid=""  d
	.s td=##class(DHCMGNUR.MgNurTransDep).%OpenId(tdid)
	.s PerDepart=td.PerDepart
	.s PerName=td.PerName
	.s PerDepartCode=$P(^CTLOC(PerDepart),"^",1)
	.s PerTranStDate=td.PerTranStDate
	.s PerTranEndDate=td.PerTranEndDate
	.s PerTranCurrent=td.PerTranCurrent
	.q:(PerTranCurrent="Y")||(PerTranStDate>+$h)||(PerTranEndDate>+$h)
	.s ret="WardCode|"_PerDepartCode_"^PersonName|"_PerName_"^PersonID|"_parr_"^StDate|"_$zd(PerTranStDate,3)_"^EndDate|"_$zd(PerTranEndDate,3)_"^ID|"_tdid
	.d OutputTDRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTDRow   
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurTransDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTransDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod FindNurTransDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTransDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCNurTransPlan).getPersonInfo("8866")
ClassMethod getPersonInfo(PersonID As %String) As %String
{
	q:PersonID=""
	s ID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_PersonID,""))
	q:ID=""
	s object=##class(DHCMGNUR.MgPersons).%OpenId(ID)
	s NowStayLocCode=object.PersonTempDepDR
	i NowStayLocCode'="" s NowStayLoc=$P(^CTLOC(NowStayLocCode),"^",1)
	else  s NowStayLoc=""
	s NowLocStDate=""
	s TransID="" f  s TransID=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_PersonID,TransID)) q:TransID=""  d
	.s a=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransID)
	.s NowStayLocCode=a.PerDepart
	.s PerTranEndDate=a.PerTranEndDate
	.s PerTranStDate=a.PerTranStDate
	.q:(PerTranStDate>+$h)||((PerTranEndDate<+$h)&&(PerTranEndDate'=""))
	.s NowStayLoc=$P(^CTLOC(NowStayLocCode),"^",1)
	.s NowLocStDate=$zd(PerTranStDate,3)
	s ret="NowStayLocCode|"_NowStayLocCode_"^"_"NowStayLoc|"_NowStayLoc_"^"_"NowLocStDate|"_NowLocStDate
	q ret
}

Query FindNurseClgLoc(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseClgLocExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s WardID=$P(parr,"^")
	s LZWard=$O(^CTLOC(0,"Code",$zcvt("轮转","U"),""))
	s TransID="" f  s TransID=$O(^DHCMGNUR.MgNurTransDepI("Dep"," "_WardID,TransID)) q:TransID=""  d
	.s a=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransID)
	.s PerID=a.PerID
	.s PerDr=a.PerDr
	.q:LZWard'=""&&PerDr.PersonDepDR'=LZWard
	.s PerName=a.PerName
	.s PerTranEndDate=a.PerTranEndDate
	.s PerTranStDate=a.PerTranStDate
	.s PerTranCurrent=a.PerTranCurrent
	.s PerDepartCode=$P(^CTLOC(WardID),"^",1)
	.q:(PerTranCurrent="Y")||(PerTranStDate>+$h)||(PerTranEndDate>+$h)
	.s ret="WardCode|"_PerDepartCode_"^PersonName|"_PerName_"^PersonID|"_PerID_"^StDate|"_$zd(PerTranStDate,3)_"^EndDate|"_$zd(PerTranEndDate,3)_"^ID|"_TransID
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseClgLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseClgLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod FindNurseClgLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseClgLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
