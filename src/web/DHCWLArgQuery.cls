Class web.DHCWLArgQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetAdmType")
Query GetAdmType() As %Query(ROWSPEC = "type:%String,ret:%String") [ SqlProc ]
{
}

ClassMethod GetAdmTypeExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   s insId=0 f  s insId = $o( ^BLC("INSPAT",insId)) q:insId=""  d
   .s type = $p(^BLC("INSPAT",insId),"^",1)
   .s ret = $case(type,"I":"住院","O":"门诊","E":"急诊","H":"体检",:"其它")
   .d outputRow1
	Quit $$$OK
	
outputRow1
 s row=$listbuild(type,ret)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAdmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmTypeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmTypeExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetCTHospital")
Query GetCTHospital() As %Query(ROWSPEC = "hospId:%String,hospDesc:%String") [ SqlProc ]
{
}

ClassMethod GetCTHospitalExecute(ByRef qHandle As %Binary) As %Status
{
   n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   s hospId=0 f  s hospId= $o(^CT("HOSP",hospId)) q:hospId=""  d
   .s hospDesc = $p(^CT("HOSP",hospId),"^",2)
   .d outputRow2
	Quit $$$OK
	
outputRow2
 s row=$listbuild(hospId,hospDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetCTHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTHospitalExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTHospitalExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetOneHospital","1,2")
Query GetOneHospital(hos As %String) As %Query(ROWSPEC = "hospId:%String,hospDesc:%String") [ SqlProc ]
{
}

ClassMethod GetOneHospitalExecute(ByRef qHandle As %Binary, hos As %String) As %Status
{
   n (qHandle,hos)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:hos="" 1
 	s hosLen = $l(hos,",")
 	f index = 1:1:hosLen  d
 	.s hosStr = $p(hos,",",index)
    .s hospStr = $p(^CT("HOSP",hosStr),"^",2)
    .s hospDesc=  $g(hospDesc)_","_hospStr
    s hospDesc = $e(hospDesc,2,$l(hospDesc))
    d outputRow3
	Quit $$$OK
	
outputRow3
 s row=$listbuild(hospId,hospDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOneHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOneHospitalExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOneHospitalExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetOneLoc","")
Query GetOneLoc(loc As %String) As %Query(ROWSPEC = "locId:%String,locDesc:%String") [ SqlProc ]
{
}

ClassMethod GetOneLocExecute(ByRef qHandle As %Binary, loc As %String) As %Status
{
   n (qHandle,loc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	i loc=""  s locDesc=""  d outputRow4
  s locId=0 f  s locId= $o(^CTLOC(locId)) q:locId=""  d
   .q:loc'=locId
   .s locDesc = $p(^CTLOC(locId),"^",2)
   .i locDesc [ "-"  s locDesc = $p(locDesc,"-",2)
   .d outputRow4
	Quit $$$OK
	
outputRow4
 s row=$listbuild(locId,locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOneLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOneLocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOneLocExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetOneArcim","葡萄糖")
Query GetOneArcim(arcDesc As %String) As %Query(ROWSPEC = "arcId:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod GetOneArcimExecute(ByRef qHandle As %Binary, arcDesc As %String) As %Status
{
   n (qHandle,arcDesc)
   Set repid=$I(^CacheTemp)
   Set qHandle=$lb(0,repid,0)
   Set ind=1
   s sql = "SELECT ARCIM_RowId, ARCIM_Desc FROM arc_itmmast WHERE ARCIM_Desc LIKE '%"_arcDesc_"%'"
 	s rs = ##class(%ResultSet).%New()
 	s sc = rs.Prepare(sql)
 	s sc = rs.Execute()
	 while rs.Next() {
	 s arcId = rs.Data("ARCIM_RowId") 
	 s desc = rs.Data("ARCIM_Desc") 
	 d outputRow5
	 }
   
	Quit $$$OK
	
outputRow5
 s row=$listbuild(arcId,desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOneArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOneArcimExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOneArcimExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetOneTarItem","挂号费")
Query GetOneTarItem(tarDesc As %String) As %Query(ROWSPEC = "tarId:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod GetOneTarItemExecute(ByRef qHandle As %Binary, tarDesc As %String) As %Status
{
  n (qHandle,tarDesc)
   Set repid=$I(^CacheTemp)
   Set qHandle=$lb(0,repid,0)
   Set ind=1
   s sql = "SELECT TARI_RowId, TARI_Desc FROM DHC_TarItem WHERE TARI_Desc LIKE '%"_tarDesc_"%'"
 	s rs = ##class(%ResultSet).%New()
 	s sc = rs.Prepare(sql)
 	s sc = rs.Execute()
	 while rs.Next() {
	 s tarId = rs.Data("TARI_RowId") 
	 s desc = rs.Data("TARI_Desc") 
	 d outputRow6
	 }
   
	Quit $$$OK
	
outputRow6
 s row=$listbuild(tarId,desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOneTarItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOneTarItemExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneTarItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOneTarItemExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetCTLOC")
Query GetCTLOC() As %Query(ROWSPEC = "loc:%String,locDesc:%String") [ SqlProc ]
{
}

ClassMethod GetCTLOCExecute(ByRef qHandle As %Binary) As %Status
{
  n (qHandle,tarDesc)
   Set repid=$I(^CacheTemp)
   Set qHandle=$lb(0,repid,0)
   Set ind=1
   s loc=0 f  s loc = $o(^CTLOC(loc)) q:loc=""  d
   .s locDesc = $p(^CTLOC(loc),"^",2)
   .i locDesc [ "-"  s locDesc = $p(locDesc,"-",2)
   .d outputRow7
 Quit $$$OK
	
outputRow7
 s row=$listbuild(loc,locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetCTLOCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTLOCExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTLOCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTLOCExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetTarAcInfo")
Query GetTarAcInfo() As %Query(ROWSPEC = "linkDesc:%String,acId:%String,acDesc:%String") [ SqlProc ]
{
}

ClassMethod GetTarAcInfoExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s acId = 0 f  s acId = $o(^DHCTarC("AC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("AC",acId),"^",2)
    .s linkDesc = "WorkLoad_TarAC_Dr"
    .d outputRow8
    s acId = 0 f  s acId = $o(^DHCTarC("EC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("EC",acId),"^",2)
    .s linkDesc = "WorkLoad_TarEC_Dr"
    .d outputRow8
    s acId = 0 f  s acId = $o(^DHCTarC("IC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("IC",acId),"^",2)
    .s linkDesc = "WorkLoad_TarIC_Dr"
    .d outputRow8
    s acId = 0 f  s acId = $o(^DHCTarC("OC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("OC",acId),"^",2)
    .s linkDesc = "WorkLoad_TarOut_Dr"
    .d outputRow8
    s acId = 0 f  s acId = $o(^DHCTarC("SC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("SC",acId),"^",2)
    .s linkDesc = "WorkLoad_TarSC_Dr"
    .d outputRow8
    s acId = 0 f  s acId = $o( ^DHCTarC("TMCNew",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("TMCNew",acId),"^",2)
    .s linkDesc = "WorkLoad_TarMC_Dr"
    .d outputRow8
	Quit $$$OK
	
outputRow8
 s row=$listbuild(linkDesc,acId,acDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetTarAcInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarAcInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTarAcInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarAcInfoExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetSomeDiag","操作中胆管损伤")
Query GetSomeDiag(diagDesc As %String) As %Query(ROWSPEC = "icd9:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod GetSomeDiagExecute(ByRef qHandle As %Binary, diagDesc As %String) As %Status
{
	n (qHandle,diagDesc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s mrId=0 f  s mrId = $O(^MRC("ID",mrId)) q:mrId=""  d
    .s desc = $p(^MRC("ID",mrId),"^",2)
    .q:desc'[diagDesc
    .s icd9 = $p(^MRC("ID",mrId),"^",4)
    .d outputRow9
	Quit $$$OK
	
outputRow9
 s row=$listbuild(icd9,desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetSomeDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSomeDiagExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSomeDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSomeDiagExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetSomeOper","尿道镜下尿道病损电切术")
Query GetSomeOper(operDesc As %String) As %Query(ROWSPEC = "icd10:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod GetSomeOperExecute(ByRef qHandle As %Binary, operDesc As %String) As %Status
{
	n (qHandle,operDesc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s mrId=0 f  s mrId = $O(^ORC("OPER",mrId)) q:mrId=""  d
    .s desc = $p(^ORC("OPER",mrId),"^",2)
    .q:desc'[operDesc
    .s icd10 = $p(^ORC("OPER",mrId),"^",14)
    .d outputRow10
	Quit $$$OK
	
outputRow10
 s row=$listbuild(icd10,desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetSomeOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSomeOperExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSomeOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSomeOperExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetGrpCategory")
Query GetGrpCategory() As %Query(ROWSPEC = "grpCode:%String,grpDesc:%String") [ SqlProc ]
{
}

ClassMethod GetGrpCategoryExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,startDate,endDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s grp=0 f  s grp = $o(^DHCWL.CodeCfg.GroupD(grp)) q:grp=""  d
 	.s grpCode = $li(^DHCWL.CodeCfg.GroupD(grp),2)
 	.s grpDesc = $li(^DHCWL.CodeCfg.GroupD(grp),3)
    .d outputRow11
	Quit $$$OK
	
outputRow11
 s row=$listbuild(grpCode,grpDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetGrpCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGrpCategoryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGrpCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGrpCategoryExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetPaType","O,H")
Query GetPaType(paType As %String) As %Query(ROWSPEC = "retStr:%String") [ SqlProc ]
{
}

ClassMethod GetPaTypeExecute(ByRef qHandle As %Binary, paType As %String) As %Status
{
	n (qHandle,paType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:paType="" 1
 	s len = $l(paType,",")
 	f index = 1:1:len  d
 	.s value = $p(paType,",",index)
 	.s ret = $case(value,"O":"门诊","E":"急诊","I":"住院","H":"体检")
 	.s str = $g(str)_","_ret
 	s retStr = $e(str,2,$l(str))
    d outputRow12
	Quit $$$OK
	
outputRow12
 s row=$listbuild(retStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetPaTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaTypeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaTypeExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetUserOtherDep","2267")
Query GetUserOtherDep(userId As %String) As %Query(ROWSPEC = "ctloc,ctlocDesc") [ SqlProc ]
{
}

ClassMethod GetUserOtherDepExecute(ByRef qHandle As %Binary, userId As %String) As %Status
{
 n (qHandle,userId)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s subId=0 f  s subId = $o(^SSU("SSUSR",userId,"OTHLL",subId)) q:subId=""  d
 .s ctloc = $p(^SSU("SSUSR",userId,"OTHLL",subId),"^",1)
 .s ctlocDesc = $p(^CTLOC(ctloc),"^",2)
 .d outputRow13
 Quit $$$OK
	
outputRow13
 s row=$listbuild(ctloc,ctlocDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetUserOtherDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserOtherDepExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserOtherDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserOtherDepExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetArcType")
Query GetArcType() As %Query(ROWSPEC = "icId,category,desc") [ SqlProc ]
{
}

ClassMethod GetArcTypeExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s icId=0 f  s icId =$o(^ARC("IC",icId)) q:icId=""  d
 	.s orderType = $p(^ARC("IC",icId),"^",7)
 	.q:(orderType="R")!(orderType="M")
 	.s desc = $p(^ARC("IC",icId),"^",2)
 	.s category="SmallItem"
    .d outputRow14
    s icId=0 f  s icId =$o(^OEC("ORCAT",icId)) q:icId=""  d
 	.s desc = $p(^OEC("ORCAT",icId),"^",2)
 	.q:desc["药"
 	.s category="BigItem"
    .d outputRow14
	Quit $$$OK
	
outputRow14
 s row=$listbuild(icId,category,desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetArcTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcTypeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetArcTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcTypeExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetTarXcType")
Query GetTarXcType() As %Query(ROWSPEC = "desc:%String") [ SqlProc ]
{
}

ClassMethod GetTarXcTypeExecute(ByRef qHandle As %Binary) As %Status
{
 n (qHandle)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s desc = $g(^DHCWLTarDesc("tarDesc"))
 d outputRow15
 Quit $$$OK
	
outputRow15
 s row=$listbuild(desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetTarXcTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarXcTypeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTarXcTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarXcTypeExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// 获取病人身份
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgQuery","GetReason")
Query GetReason() As %Query(ROWSPEC = "rea,reaDesc") [ SqlProc ]
{
}

ClassMethod GetReasonExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s rea=0 f  s rea = $o(^PAC("ADMREA",rea)) q:rea=""  d
 	.s reaDesc= $p(^PAC("ADMREA",rea),"^",2)
    .d outputRow16
	Quit $$$OK
	
outputRow16
 s row=$listbuild(rea,reaDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReasonExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReasonExecute ]
{
	n (qHandle,Row,AtEnd)
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
