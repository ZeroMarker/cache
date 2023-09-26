Import SQLUser

Class web.DHCLabCommonQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// CliDep 临床科室Query
/// LabDep 检验科室Query
/// LabMach 检验科仪器Query
/// LabUser 检验科用户Query
/// TestCode 化验项目Query  
Query GroupLoc(input As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
select CTLOC_Code,CTLOC_Desc From CT_Loc 
where CTLOC_Desc %STARTSWITH %ALPHAUP(:input)
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","wardlookup","")
Query wardlookup(desc As %String) As %Query(ROWSPEC = "ward:%String,wardid:%String") [ SqlProc ]
{
}

ClassMethod wardlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=desc
 	If $g(ind)="" Set ind=1
	s rowid=0
	s desc=$$ALPHAUP^SSUTIL4(desc)
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=desc_"%"
	&sql(declare ward cursor  for 
	select WARD_rowid,WARD_desc,ward_code from SQLUser.PAC_WARD where %UPPER(WARD_desc) like :desc)
	&sql(open ward)
	f  &sql(fetch ward into :WARDrowid,:WARDdesc,:wardcode) q:SQLCODE  d
	.I $L(desc)>1,WARDdesc'[desc Q
 	.Do OutputRow2 	 	
 	&sql(close ward)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
    i $f(WARDdesc,"-")'=0  d
    .s WARDdesc=$p(WARDdesc,"-",2)
	set Data=$lb(WARDdesc,WARDrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod wardlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = wardlookupExecute ]
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

ClassMethod wardlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = wardlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","TestCode","")
Query TestCode(tccode As %String) As %Query(ROWSPEC = "desc:%String,tc:%String") [ SqlProc ]
{
}

ClassMethod TestCodeExecute(ByRef qHandle As %Binary, tccode As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=tccode
 	If $g(ind)="" Set ind=1
	s rowid=0
	s tc=""
    S tccode=$ZCVT(tccode,"U")
 	//Do OutputRow5 
	f  s tc=$O(^TTAB("TC",tc)) Q:tc=""  D
	.S desc=$P(^TTAB("TC",tc),"\",1)
	.S desc=tc_"||"_desc
	.I $L(tccode),tc_desc'[tccode Q
	.S Data=$lb(desc,tc)
	.//b ;2
 	.Do OutputRow6 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(desc,tc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TestCodeExecute ]
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

ClassMethod TestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TestCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","TestSet","")
Query TestSet(tscode As %String) As %Query(ROWSPEC = "tsdesc:%String,ts:%String") [ SqlProc ]
{
}

ClassMethod TestSetExecute(ByRef qHandle As %Binary, tscode As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=tscode
 	If $g(ind)="" Set ind=1
	s rowid=0
	s ts=""
    S tscode=$ZCVT(tscode,"U")
 	//Do OutputRow5 
	f  s ts=$O(^TTAB("TS",ts)) Q:ts=""  D
	.S tsdesc=$P(^TTAB("TS",ts),"\",1)
	.S tsdesc=ts_"||"_tsdesc
	.I $L(tscode),ts_tsdesc'[tscode Q
	.S Data=$lb(tsdesc,ts)
	.//b ;2
 	.Do OutputRow8 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(tsdesc,ts)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TestSetExecute ]
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

ClassMethod TestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TestSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","CliDep","","QYFYZY")
Query CliDep(depcode As %String, HospitalCode As %String) As %Query(ROWSPEC = "desc:%String,dep:%String") [ SqlProc ]
{
}

ClassMethod CliDepExecute(ByRef qHandle As %Binary, depcode As %String, HospitalCode As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	S depcode=$G(depcode),HospitalCode=$G(HospitalCode)
 	S ^TQ("Xq")=depcode_","_HospitalCode
	s rowid=0
	S clidesc="全部科室"
	S clidep="null"
    S Data=$lb(clidesc,clidep)
    S depcode=$ZCVT(depcode,"U")
 	Do OutputRow5 
	s clidep="" f  s clidep=$O(^CTLOC(0,"Code",clidep)) Q:clidep=""  D
	.S rowid=$O(^CTLOC(0,"Code",clidep,""))
	.S clidesc=$P(^CTLOC(rowid),"^",2)
	.I $L(rowid) S HospID=$P(^CTLOC(rowid),"^",22)
    .I $L(HospID) S CurHospitalCode=$p(^CT("HOSP",HospID),"^",1)
    .I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Q 
    .W CurHospitalCode,!
	.I $L(depcode),clidep_clidesc'[depcode Q
	.S Data=$lb(clidesc,clidep)
 	.Do OutputRow5 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(clidesc,clidep)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CliDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CliDepExecute ]
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

ClassMethod CliDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CliDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Hosptail(USERCODE As %String) As %Query(ROWSPEC = "hospDesc:%String,hospCode:%String") [ SqlProc ]
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","Hosptail","")
ClassMethod HosptailExecute(ByRef qHandle As %Binary, USERCODE As %String) As %Status
{
 	S repid=$I(^CacheTemp)
 	I $g(ind)="" S ind=1
	S rowid=0
	I '$L(USERCODE) S USERCODE="demo"
	//S hospCode="null"
	//S hospDesc="所有医院"
	//S Data=$lb(hospDesc,hospCode)
 	//D OutputRow7
	S hospCode="" F  S hospCode=$O(^TTAB("CC",hospCode)) Q:hospCode=""  D
	.S hospFlag=$P(^TTAB("CC",hospCode),"\",13)
	.Q:'$L(hospFlag)
	.Q:'$D(^TTAB("UA",USERCODE,3,hospCode)) 
	.S hospDesc=$P(^TTAB("CC",hospCode),"\",1)
	.S Seq=$P(^TTAB("CC",hospCode),"\",9)
	.I Seq'=1 Q
	.;W hospFlag,!
	.S Data=$lb(hospDesc,hospCode)
 	.D OutputRow7 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow7
	set Data=$lb(hospDesc,hospCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod HosptailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HosptailExecute ]
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

ClassMethod HosptailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HosptailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","LabDep","")
Query LabDep(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "desc:%String,dep:%String") [ SqlProc ]
{
}

ClassMethod LabDepExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	S repid=$I(^CacheTemp)
 	S USERCODE=$G(USERCODE)
 	I '$L(USERCODE) S USERCODE="demo"
 	//S USERCODE=$G(%session.Data("LOGON.USERCODE"))
 	s ^TMP("-")=depcode_","_USERCODE
 	S UserDep=""
    S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
    .S UserDep=UserDep_dep
    S ^TMP("Ward")=depcode_","_USERCODE
 	If $g(ind)="" Set ind=1
	s rowid=0
	s dep="null"
	S desc="全部科室"
	//S depcode=$ZCVT(depcode,"U")
    S Data=$lb(desc,dep)
 	Do OutputRow1 	
 	S dep=""
	f  s dep=$O(^TTAB("DEP",dep)) Q:dep=""  D
	.I UserDep'[dep Q
	.S desc=$P(^TTAB("DEP",dep),"\",1)
	.I $L(depcode),dep_desc'[depcode Q
	.S Data=$lb(desc,dep)
 	.Do OutputRow1 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(desc,dep)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LabDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LabDepExecute ]
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

ClassMethod LabDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LabDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","LabUser","")
Query LabUser(usercode As %String) As %Query(ROWSPEC = "userdesc:%String,user:%String") [ SqlProc ]
{
}

ClassMethod LabUserExecute(ByRef qHandle As %Binary, usercode As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    //S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
 	S Config=##Class(websys.Configuration).%OpenId(1)
    S LabNameSapce=Config.LabDataNamespace
    S:'$l(LabNameSapce) LabNameSapce="LABDATA"
	s rowid=0
	s user=""
	S userdesc="全部人员"
	S Data=$lb(user,userdesc)
 	Do OutputRow4
	f  s user=$O(^[LabNameSapce]SSU("SSUSR",1,user)) Q:user=""  D
	.//I $L(usercode),user'=usercode Q
	.S userdesc=$P(^[LabNameSapce]SSU("SSUSR",1,user),"^",2)
	.I $L(usercode),user_userdesc'[usercode Q
	.S Data=$lb(userdesc,user)
 	.Do OutputRow4 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(userdesc,user)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LabUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LabUserExecute ]
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

ClassMethod LabUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LabUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","LabMach","")
Query LabMach(desc As %String) As %Query(ROWSPEC = "machdesc:%String,mach:%String") [ SqlProc ]
{
}

ClassMethod LabMachExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=desc
 	If $g(ind)="" Set ind=1
	s rowid=0
	s mach="null"
	S machdesc="全部仪器"
    S Data=$lb(machdesc,mach)
 	Do OutputRow3
 	S mach=""
	f  s mach=$O(^TMIF(mach)) Q:mach=""  D
	.S machdesc=$P(^TMIF(mach),"\",1)
	.I $L(desc),mach_machdesc'[desc Q
	.S Data=$lb(machdesc,mach)
 	.Do OutputRow3 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(machdesc,mach)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LabMachFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LabMachExecute ]
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

ClassMethod LabMachClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LabMachExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","PatType","")
Query PatType(desc As %String) As %Query(ROWSPEC = "PatTypeDesc:%String,PatTypeCode:%String") [ SqlProc ]
{
}

ClassMethod PatTypeExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=desc
 	If $g(ind)="" Set ind=1
	S rowid=0
    
	F PatTypeCode="","N","Y","P","O","GP" 
	{
		I PatTypeCode="" S PatTypeDesc="全部"
		I PatTypeCode="N" S PatTypeDesc="门诊"
		I PatTypeCode="Y" S PatTypeDesc="住院"
		I PatTypeCode="P" S PatTypeDesc="急诊"
		I PatTypeCode="O" S PatTypeDesc="体检"
		I PatTypeCode="GP" S PatTypeDesc="未上线"
		S Data=$lb(PatTypeDesc,PatTypeCode)
		Do OutputRow9 	
	} 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(PatTypeDesc,PatTypeCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatTypeExecute ]
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

ClassMethod PatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","Year","")
Query Year(desc As %String) As %Query(ROWSPEC = "YearDesc:%String,YearCode:%String") [ SqlProc ]
{
}

ClassMethod YearExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=desc
 	If $g(ind)="" Set ind=1
	S rowid=0
    S Date=+$H
    S Year=$P($ZD(Date,3),"-",1)
    S YearS=Year-20
    S YearCode=Year
    S YearDesc=YearCode_"年"
    S Data=$lb(YearDesc,YearCode)
    Do OutputRow10 
	F i=1:1:20  
	{
		Continue:Year=YearS
 		S YearCode=YearS+i
 		S YearDesc=YearCode_"年"
		S Data=$lb(YearDesc,YearCode)
		Do OutputRow10 	
	} 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow10
	set Data=$lb(YearDesc,YearCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod YearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = YearExecute ]
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

ClassMethod YearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = YearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCLabCommonQuery","Month","")
Query Month(desc As %String) As %Query(ROWSPEC = "MonthDesc:%String,MonthCode:%String") [ SqlProc ]
{
}

ClassMethod MonthExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=desc
 	If $g(ind)="" Set ind=1
	S rowid=0
	F i=1:1:12  
	{
 		S MonthCode=i
 		S MonthDesc=MonthCode_"月"
 		I MonthCode=0 S MonthDesc=" "
		S Data=$lb(MonthDesc,MonthCode)
		Do OutputRow11 	
	} 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow11
	set Data=$lb(MonthDesc,MonthCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthExecute ]
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

ClassMethod MonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
