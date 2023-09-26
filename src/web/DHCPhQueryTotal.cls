Class web.DHCPhQueryTotal Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod PerQueryClose(ByRef QHandle As %Binary, locdesc As %String) As %Status [ PlaceAfter = PerQueryExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod PerQueryExecute(ByRef QHandle As %Binary, CLocDesc As %Library.String = "") As %Status
{
	
 Set repid=$I(^CacheTemp)
	s ind=1
	s loc=""
	s loc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(CLocDesc),""))
	set myrowid=0
 for  s myrowid=$o(^SSU("SSUSR",myrowid)) q:myrowid=""  d
 .s ctloctype="",ctloc="",usecode="",usename="",useid=""
 .s tr=0
 .s ctloc=+$p(^SSU("SSUSR",myrowid),"^",4)
 .i ctloc=loc s tr=tr+1
 .i tr=0  d
 ..	s othusr="0",th=0
	     ..f  s othusr=$o(^SSU("SSUSR",myrowid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
	       ...s othloc="",CTDesc=""
	       ...s othloc=+$p(^SSU("SSUSR",myrowid,"OTHLL",othusr),"^",1)
	       ...s ctloctype=""
 ...s ctloctype=$p(^CTLOC(othloc),"^",13)
 ...q:ctloctype'["D"
 ...q:othloc'=loc
 ...s tr=tr+1
 .q:tr=0
 .s usecode=$p(^SSU("SSUSR",myrowid),"^",1)
 .s usename=$p(^SSU("SSUSR",myrowid),"^",2)
 .s useid=myrowid
 .set Data=$lb(usename,usecode,useid)
 .Set ^CacheTemp(repid,ind)=Data	
 .Set ind=ind+1
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod PerQueryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PerQueryExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryChFyClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryChFyExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCPhQueryTotal","QueryChFy","308","6262","FY")
ClassMethod QueryChFyExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", userid As %Library.String = "", flag As %Library.String = "") As %Status
{
	S ^tmpdhy("QueryChFyExecute")=ctloc_","_userid_","_flag
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1 
	s loc=""
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" Quit $$$OK
	s php="",getphp=""
	f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
	.s phyp=""
	.s phyp=+$p(^DHCPHPER(php),"^",3)
	.q:phyp'=phl
	.s getphp=php
	i getphp="" Quit $$$OK
	s phlp=""
	f  s phlp=$o(^DHCPHPER(phlp)) q:phlp=""  d
	.s phwl="",phwdesc=""
	.s phwl=+$p(^DHCPHPER(phlp),"^",3)
	.q:phwl'=phl
	.s userfyflag=$p(^DHCPHPER(phlp),"^",1)
	.q:(userfyflag'=1)&&(flag="FY")			;无发药权限
	.s userpyflag=$p(^DHCPHPER(phlp),"^",6)
	.q:(userpyflag'=1)&&(flag="PY")			;无配药权限
	.s use=""
	.s use=$p(^DHCPHPER(phlp),"^",9)
	.q:use="1"
	.s phwdesc=$p(^DHCPHPER(phlp),"^",2)
	.s Data=$lb(phwdesc,phlp,getphp)
	.S ^CacheTemp(repid,ind)=Data	
	.S ind=ind+1
	S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryChFyFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryChFyExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryChWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryChWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryChWinExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	s loc=""
	s php=""
	s phpdr=""
	s phl="",phw="0",byfs=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" Set QHandle=$lb(0,repid,0) Quit $$$OK 
	s byfs=$p(^DHCPHLOC(phl),"^",5)
	i byfs'="1" d
	  .f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="0")!(phw="")  d
	     ..s okflag="",useflag=""
	     ..s okflag=$p(^DHCPHWIN(phw),"^",3)
	     ..q:okflag'="1"
	     ..s useflag=$p(^DHCPHWIN(phw),"^",4)
	     ..q:useflag="1"
	     ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	     ..set Data=$lb(phwdesc,phw,phl)
 ..Set ^CacheTemp(repid,ind)=Data	
 ..Set ind=ind+1
 e  d
 .f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="")!(phw="0")  d
	    ..s phwp="",useflag=""
	    ..s phwp=$o(^DHCPHWPi("WINDOW",phl,phw,""))
	    ..s phwdesc="",doflag=""
	    ..;q:phwp=""
	    ..;s doflag=$p(^DHCPHWP(phwp),"^",1)
	    ..;q:doflag="1" 
	    ..s useflag=$p(^DHCPHWIN(phw),"^",4)
	    ..q:useflag="1"
	    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	    ..s ^TPP(ind)=phw
	    ..set Data=$lb(phwdesc,phw,phl)
 ..Set ^CacheTemp(repid,ind)=Data	
 ..Set ind=ind+1
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryChWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryChWinExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocExecute(ByRef QHandle As %Binary, userid As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=0
	s ctloc="",ctlocdesc=""
 i userid="" Set QHandle=$lb(0,repid,0)	Quit $$$OK 
 s ctloc=+$p(^SSU("SSUSR",userid),"^",4)
 s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
 set Data=$lb(ctlocdesc,ctloc)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	s othusr="0",th=0
	f  s othusr=$o(^SSU("SSUSR",userid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
	   .s loc="",CTDesc=""
	   .s loc=+$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",1)
	   .s ctloctype=""
 .s ctloctype=$p(^CTLOC(loc),"^",13)
 .q:ctloctype'["D"
 .s CTDesc=$p($g(^CTLOC(loc)),"^",2)
 .set Data=$lb(CTDesc,loc)
 .Set ^CacheTemp(repid,ind)=Data	
 .Set ind=ind+1
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryMathClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryMathExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryMathExecute(ByRef QHandle As %Binary) As %Status
{
	New repid, ind
	New CTCode,CTDesc
	///do ResetVariables
	
 Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=1
 s CTCode=myrowid
 if myrowid=1  s CTDesc="按照次序"
 Do MathOutputRow
 s CTCode=2
 s CTDesc="按照工作量"
 Do MathOutputRow

 Set QHandle=$lb(0,repid,0)

	Quit $$$OK
MathOutputRow
	set Data=$lb(CTDesc,CTCode)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
MathResetVariables
	///set (repid)=0
	set (CTCode,CTDesc)=""
	quit
}

ClassMethod QueryMathFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryPerTypeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPerTypeExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPerTypeExecute(ByRef QHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	s sex="0"
	f  s sex=$o(^CT("SS",sex)) q:(sex="")!(sex="0")  d
	  .s desc="",sexid=""
	  .s desc=$p(^CT("SS",sex),"^",2)
	  .s Data=$lb(desc,sex)
 .S ^CacheTemp(repid,ind)=Data	
 .S ind=ind+1
 S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPerTypeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPerTypeExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryPhlClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhlExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhlExecute(ByRef QHandle As %Binary, userid As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=0
 for  s myrowid=$o(^DHCPHLOC(myrowid)) q:myrowid=""  d
 .s ctloctype="",ctloc="",pp=0
 .s ctloc=+$p(^DHCPHLOC(myrowid),"^",1)
 .s othusr="0",th=0
	   .f  s othusr=$o(^SSU("SSUSR",userid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
	     ..s loc="",CTDesc=""
	     ..s loc=+$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",1)
	     ..s ctloctype=""
 ..s ctloctype=$p(^CTLOC(loc),"^",13)
 ..q:ctloc'=loc
 ..q:ctloctype'["D"
 ..s pp=pp+1
 .s defaultloc=""
 .s defaultloc=+$p(^SSU("SSUSR",userid),"^",4)
 .i defaultloc=ctloc  s pp=pp+1
 .q:pp=0
 .s CTCode=myrowid
 .s CTDesc=$p($g(^CTLOC(ctloc)),"^",2)
 .Do PhlOutputRow

 Set QHandle=$lb(0,repid,0)

	Quit $$$OK
PhlOutputRow
	set Data=$lb(CTDesc,CTCode)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
PhlResetVariables
	///set (repid)=0
	set (CTCode,CTDesc)=""
	quit
}

ClassMethod QueryPhlFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhlExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySexClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QuerySexExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QuerySexExecute(ByRef QHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	s sex="0"
	f  s sex=$o(^CT("SEX",sex)) q:(sex="")!(sex="0")  d
	  .s desc="",sexid=""
	  .s desc=$p(^CT("SEX",sex),"^",2)
	  .s Data=$lb(desc,sex)
 .S ^CacheTemp(repid,ind)=Data	
 .S ind=ind+1
 S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QuerySexFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySexExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryWinDoFlagClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryWinDoFlagExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryWinDoFlagExecute(ByRef QHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	s ctloc=""
	s phl=""
	s desc="",flag="",wp=""
	i ctloc="" s Data=$lb(desc,flag,wp),^CacheTemp(repid,ind)=Data,QHandle=$lb(0,repid,0) Quit $$$OK
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  S QHandle=$lb(0,repid,0)	Quit $$$OK
	s phw=""
	f  s phw=$o(^DHCPHWIN(phw)) q:phw=""  d
	  .s phwp="",phwl=""
	  .s phwl=+$p(^DHCPHWIN(phw),"^",2)
	  .q:phwl'=phl
	  .s useflag="",phw="",phwdesc="",doflag=""
	  .s useflag=$p(^DHCPHWIN(phw),"^",4)
	  .q:useflag="1"
	  .s phwp=$o(^DHCPHWPi("WINDOW",phl,phw,""))
	  .i phwp=""  d
	   ..&sql(insert into SQLUser.dhc_phwper (phwp_phl_dr,phwp_phw_dr) values(:phl,:phw))
	   ..s phwp=$o(^DHCPHWPi("WINDOW",phl,phw,""))
	  .s doflag=+$p(^DHCPHWP(phwp),"^",1)
	  .i doflag="1" s doflag="有人" 
	  .e  s doflag="无人"
 .s phwdesc=$p(^DHCPHPER(phw),"^",2)
 .s Data=$lb(phwdesc,doflag,phwp)
 .S ^CacheTemp(repid,ind)=Data	
 .S ind=ind+1
 S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryWinDoFlagFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWinDoFlagExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryWinPosClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryWinPosExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryWinPosExecute(ByRef QHandle As %Binary) As %Status
{
	New repid, ind
	New CTCode,CTDesc
 Set repid=$I(^CacheTemp)
	s ind=1
	set myrowid=1
 s CTCode="E"
 s CTDesc="东侧"
 Do WinPosOutputRow
 s CTCode="W"
 s CTDesc="西侧"
 Do WinPosOutputRow
 s CTCode="O"
 s CTDesc="无位"
 Do WinPosOutputRow

 Set QHandle=$lb(0,repid,0)

	Quit $$$OK
WinPosOutputRow
	set Data=$lb(CTDesc,CTCode)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
WinPosResetVariables
	///set (repid)=0
	set (CTCode,CTDesc)=""
	quit
}

ClassMethod QueryWinPosFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWinPosExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query PerQuery(CLocDesc As %String) As %Query(ROWSPEC = "用户:%String,用户代码:%String,用户ID:%String")
{
}

Query QueryChFy(ctloc As %String, userid As %String) As %Query(ROWSPEC = "姓名:%String,ID:%String,药房ID:%String")
{
}

Query QueryChWin(ctloc As %String) As %Query(ROWSPEC = "窗口:%String,窗口代码:%String,药房代码:%String")
{
}

Query QueryLoc(userid As %String) As %Query(ROWSPEC = "名称:%String,代码:%String") [ SqlProc ]
{
}

Query QueryMath() As %Query(ROWSPEC = "名称:%String,代码:%String") [ SqlProc ]
{
}

Query QueryPerType() As %Query(ROWSPEC = "类型:%String,代码:%String")
{
}

Query QueryPhl(userid As %String) As %Query(ROWSPEC = "科室:%String,代码:%String") [ SqlProc ]
{
}

Query QuerySex() As %Query(ROWSPEC = "性别:%String,代码:%String")
{
}

Query QueryWinDoFlag() As %Query(ROWSPEC = "窗口:%String,开放:%String,代码:%String")
{
}

Query QueryWinPos() As %Query(ROWSPEC = "名称:%String,代码:%String") [ SqlProc ]
{
}

ClassMethod QueryWinCodeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryWinCodeExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryWinCodeExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CPmiNo As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 i ctloc="" s QHandle=$lb(0,repid,0) Quit $$$OK
 s phl=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 i phl=""  s QHandle=$lb(0,repid,0)	Quit $$$OK
 s patno=""
 f  s patno=$o(^DHCPHTodayWinCode(+$h,phl,patno)) q:patno=""  d
   .q:(patno'=CPmiNo)&(CPmiNo'="")
   .s presc=""
   .f  s presc=$o(^DHCPHTodayWinCode(+$h,phl,patno,presc)) q:presc=""  d
   ..s patname="",wincode="",phw="",phwdesc=""
   ..s patname=$p(^DHCPHTodayWinCode(+$h,phl,patno,presc),"^",1)
   ..s wincode=$p(^DHCPHTodayWinCode(+$h,phl,patno,presc),"^",2)
   ..s phw=$p(^DHCPHTodayWinCode(+$h,phl,patno,presc),"^",3)
   ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
   ..s Data=$lb(patname,patno,phwdesc,wincode)
   ..S ^CacheTemp(repid,ind)=Data	
   ..S ind=ind+1
 S QHandle=$lb(0,repid,0)
 Quit $$$OK
}

ClassMethod QueryWinCodeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWinCodeExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 ;^DHCPHTodayWinCode(+$h,phl,pmino,prescno)
 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryWinCode(ctloc As %String, CPmiNo As %String) As %Query(ROWSPEC = "TPatName:%String,TPatNo:%String,TPhwDesc:%String,TWinCode:%String")
{
}

}
