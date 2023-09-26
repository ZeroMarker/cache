Class web.DHCNURMGQUAL Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetMgQualWardExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="2009-011-18^2009-12-18"
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s loc=$P(parr,"^",3)
 	s itm=$P(parr,"^",4)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	//s loc="" //可以按科室查询
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=stdate:1:edate
    {
		s dep=""  f  s dep=$O(^User.DHCMGNURQualReportI("DepDate",dep)) q:dep=""  d
		.q:($Tr(dep," ","")'=loc)&(loc'="")
		.w !,dep_"|"
		.s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate",dep,date,rw)) q:rw=""  d
		..b
		..d out 
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,checitm,checdate,checpoint,checuser,checmem,checedperson)=""
    s a=^User.DHCMGNURQualReportD(rw)
    s depdr=$List(a,3)
    q:depdr=""
    s checpoint=$List(a,10)
    s checdate=$List(a,2)
    s checuser=$List(a,9)
    s checrpdr=$List(a,7)
    s checmem=$List(a,4)
    s checedperdr=$List(a,11)
    if checedperdr'="" d
    .s aa=^User.DHCMGPersonsD(checedperdr)
    .s checedperson=$list(aa,21)
    s a=^User.DHCNURMGQualItmD(checrpdr)
    s checitm=$List(a,4)
    s cpcode=$List(a,5)
    q:cpcode'["Qual"
    q:(checrpdr'=itm)&(itm'="")
    s checdate=$ZD(checdate,3)
  	s parr=^User.DHCMGPersonsD(checuser)
    s checuser=$list(parr,21)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,checitm,checdate,checpoint,checuser,checmem,checedperson,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgQualWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgQualWardExecute ]
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
}

ClassMethod GetMgQualWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgQualWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMgQualWard(parr As %String) As %Query(ROWSPEC = "dep,checitm,checdate,checpoint,checuser,checmem,checedperson,rw")
{
}

Query GetMgQualWardSY(parr As %String) As %Query(ROWSPEC = "dep,checitm,checdate,checpoint,checuser,checmem,checedperson,rw")
{
}

ClassMethod GetMgQualWardSYExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="2009-011-18^2009-12-18"
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s loc=$P(parr,"^",3)
 	s itm=$P(parr,"^",4)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	s nurtype=$P(parr,"^",5)
 	b //345
 	//s loc="" //可以按科室查询
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=stdate:1:edate
    {
		s dep=""  f  s dep=$O(^User.DHCMGNURQualReportI("DepDate",dep)) q:dep=""  d
		.q:($Tr(dep," ","")'=loc)&(loc'="")
		.;w !,dep_"|"
		.s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate",dep,date,rw)) q:rw=""  d
		..;b
		..s curnurtype=$Listget(^User.DHCMGNURQualReportD(rw),13)
        ..q:curnurtype'=nurtype                      ///////////
		..d outSY 
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

outSY
    s (depdes,checitm,checdate,checpoint,checuser,checmem,checedperson)=""
    s a=^User.DHCMGNURQualReportD(rw)
    s depdr=$List(a,3)
    q:depdr=""
    s checpoint=$List(a,10)
    s checdate=$List(a,2)
    s checuser=$List(a,9)
    s checrpdr=$List(a,7)
    s checmem=$List(a,4)
    s curnurtype=$Listget(a,13)
    s checedperdr=$List(a,11)
    if checedperdr'="" d
    .s aa=^User.DHCMGPersonsD(checedperdr)
    .s checedperson=$list(aa,21)
    s a=^User.DHCNURMGQualItmD(checrpdr)
    s checitm=$List(a,4)
    s cpcode=$List(a,5)
    q:cpcode'["Qual"
    q:(checrpdr'=itm)&(itm'="")
    s checdate=$ZD(checdate,3)
  	s parr=^User.DHCMGPersonsD(checuser)
    s checuser=$list(parr,21)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    d OutRowtypSY
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtypSY
	set Data=$lb(depdes,checitm,checdate,checpoint,checuser,checmem,checedperson,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgQualWardSYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgQualWardSYExecute ]
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
}

ClassMethod GetMgQualWardSYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgQualWardSYExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetNurQualItmExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s rw=""  f  s rw=$O(^User.DHCNURMGQualItmD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (title,code,point)=""
    s a=^User.DHCNURMGQualItmD(rw)
    s title=$List(a,4)
    s point=$List(a,3)
    s code=$List(a,5)
    s percent=$ListGet(a,6)
    s pass=$ListGet(a,7)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(code,title,point,percent,rw,pass)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurQualItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurQualItmExecute ]
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
}

ClassMethod GetNurQualItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurQualItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurQualItm(parr As %String) As %Query(ROWSPEC = "code,title,point,percent,rw,pass")
{
}

ClassMethod GetMgQualRpExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="2009-011-18^2009-12-18"
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s loc=$P(parr,"^",3)
 	s itm=$P(parr,"^",4)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	s loc=""
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=stdate:1:edate
    {
		s dep=""  f  s dep=$O(^User.DHCMGNURQualReportI("DepDate",dep)) q:dep=""  d
		.q:($Tr(dep," ","")'=loc)&(loc'="")
		.w !,dep_"|"
		.s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate",dep,date,rw)) q:rw=""  d
		..b
		..d out 
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,checitm,checdate,checpoint,checuser,checmem,checedperson)=""
    s a=^User.DHCMGNURQualReportD(rw)
    s depdr=$List(a,3)
    //q:depdr=""
    s checpoint=$List(a,10)
    s checdate=$List(a,2)
    s checuser=$List(a,9)
    s checrpdr=$List(a,7)
    s checmem=$List(a,4)
    s checedperdr=$List(a,11)
    if checedperdr'="" d
    .s aa=^User.DHCMGPersonsD(checedperdr)
    .s checedperson=$list(aa,21)
    s a=^User.DHCNURMGQualItmD(checrpdr)
    s checitm=$List(a,4)
    s cpcode=$List(a,5)
    q:cpcode'["CP"
    q:(checrpdr'=itm)&(itm'="")
    s checdate=$ZD(checdate,3)
  	s parr=^User.DHCMGPersonsD(checuser)
    s checuser=$list(parr,21)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,checitm,checdate,checpoint,checuser,checmem,checedperson,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgQualRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgQualRpExecute ]
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
}

ClassMethod GetMgQualRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgQualRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMgQualRp(parr As %String) As %Query(ROWSPEC = "dep,checitm,checdate,checpoint,checuser,checmem,checedperson,rw")
{
}

ClassMethod GetSSQualExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s dep=""  f  s dep=$O(^User.DHCMGNurQualRelDepI("dep",dep)) q:dep=""  d
    .
    .b
    .q:($Tr(dep," ","")'=loc)&(loc'="")
    .b
    .s rw=""  f  s rw=$O(^User.DHCMGNurQualRelDepI("dep",dep,rw)) q:rw=""  d
    ..b
    ..d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
out
    s (depdes,qual)=""
    s a=^User.DHCMGNurQualRelDepD(rw)
    s depdr=$List(a,2)
    s qudr=$List(a,3)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s a=^User.DHCNURMGQualItmD(qudr)
    s qual=$List(a,4)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,qual,qudr,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSSQualFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSQualExecute ]
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
}

ClassMethod GetSSQualClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSQualExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSSQual(parr As %String) As %Query(ROWSPEC = "dep,checitm,qudr,rw")
{
}

ClassMethod GetNurWorkItmExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s Styp("A")="Attention"
 	s Styp("H")="HisData"
 	s Styp("O")="OutIn"
 	s Styp("W")="WorkLoad"
    s Styp("Q")="Qt"
 	s RTyp("O")="OrdItm",RTyp("I")="Instruct"
 	s RTyp("H")="Hours"
 	s RTyp("P")="Persons"
 	s RTyp("N")="Num"
 	s RTyp("D")="Days"
    s typ=$P(par,"^",1)
    s rtyp=$P(par,"^",2)
    s alia=$P(par,"^",3)
    s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmD(rw)) q:rw=""  d
    .d out
    s ^TMP("web.DHCNURMGQUAL:GetNurWorkItm")=ind
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (Name,Code,styp,Reltyp,Percent,mth,flag)=""
    s a=^User.DHCMGNurWorkItmD(rw)
    s Name=$List(a,4)
    q:(Name'[alia)&(alia'="")
    s Code=$List(a,2)
    s styp=$List(a,3)
    q:(styp'=typ)&(typ'="")
    s Reltyp=$List(a,6)
    q:(Reltyp'=rtyp)&(rtyp'="")
    s percent=$ListGet(a,5)
    s mth=$ListGet(a,8)
    s flag=$List(a,7)
    if Reltyp'="" s Reltyp=RTyp(Reltyp)
    if styp'="" s styp=Styp(styp)
    d OutRowtyp 
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(Name,Code,styp,Reltyp,percent,mth,flag,rw,"false")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurWorkItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurWorkItmExecute ]
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
}

ClassMethod GetNurWorkItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurWorkItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetNurWorkItm(parr As %String) As %Query(ROWSPEC = "Name:%String,Code:%String,Styp:%String,Reltyp:%String,Percent:%String,Meth:%String,Flag:%String,rw:%String,Sel:%Boolean")
{
}

ClassMethod GetDistillRel() As %String
{
  s itm1="W|WorkLoad^A|Attention^O|OutIn^Q|Qt"
  s itm2="I|Instruct^H|Hours^D|Days^P|Persons^N|Num"
  q itm1_"!"_itm2
}

ClassMethod test()
{
		s dep=""  f  s dep=$O(^User.DHCMGNURQualReportI("DepDate",dep)) q:dep=""  d
		.w ! ,dep 
		q
}

ClassMethod GetZIP()
{
	
Getzip 
 Set pat = "5N"
 Read !,"Enter your ZIP code (5 or 9 digits): ",zip
 Set:($LENGTH(zip)=10) pat = "5N1""-""4N"
 IF zip'?@pat { 
 Write !,"Invalid ZIP code"
 GoTo Getzip
 }
}

ClassMethod GetNurItmRelExecute(ByRef qHandle As %Binary, Itm As %String = "") As %Status
{
	 //d ##class(%ResultSet).RunQuery("web.DHCNURMGQUAL","GetNurItmRel","10")
	Set repid=$I(^CacheTemp)
 	s ind=1
 
 	s Styp("H")="HisData"
 	s Styp("Q")="Qt"
 	s RTyp("O")="OrdItm",RTyp("I")="Instruct"
    //s typ=$P(par,"^",1)
    //s Itm=$P(par,"^",2)

    s a=^User.DHCMGNurWorkItmD(Itm)
    s Reltyp=$List(a,6)
    //s Reltyp=Rtyp(Reltyp)
    s rw=""  f  s rw=$O(^User.DHCMGNurWorkRelatItmI("WorkItm",Itm,rw)) q:rw=""  d
    .;b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

out
    s (ItmName)=""
    s a=^User.DHCMGNurWorkRelatItmD(rw)
    s relitm=$ListGet(a,3)
	s ARCIMRowid=$P(relitm,"||",1)
	s ARCIMSub=$P(relitm,"||",2) 
    //s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  //2012-09-04 
	
	if (Reltyp="I")
	{
	 // s ItmName=$P(^PHCIN(relitm),"^",2)
	  s relitm=$ListGet(a,4)
	  s ItmName=$P(^PHCIN(relitm),"^",2)  
	}
	else{
		s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
	}
	
    d OutRowtyp 
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutRowtyp
	set Data=$lb(ItmName,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurItmRelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurItmRelExecute ]
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
}

ClassMethod GetNurItmRelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurItmRelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurItmRel(parr As %String) As %Query(ROWSPEC = "ItmName,rw")
{
}

ClassMethod GetDepSumQual(loc, stdate, edate) As %String
{
 //合计指控 s a=##class(web.DHCNURMGQUAL).GetDepSumQual()
 //s loc="",stdate="2009-12-1",edate="2009-12-25"
 	s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)

    f date=stdate:1:edate
    {
		s dep=""  f  s dep=$O(^User.DHCMGNURQualReportI("DepDate",dep)) q:dep=""  d
		.q:($Tr(dep," ","")'=loc)&(loc'="")
		.w !,dep_"|"
		.s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate",dep,date,rw)) q:rw=""  d
        ..s a=^User.DHCMGNURQualReportD(rw)
        ..s depdr=$List(a,3)
        ..q:depdr=""
        ..s checpoint=$List(a,10)
        ..s checrpdr=$List(a,7)
        ..s TMP(depdr,checrpdr)=$G(TMP(depdr,checrpdr))+checpoint
        ..s TMPSUM(depdr)=$G(TMPSUM(depdr))+checpoint
       
    }
   s ret=##class(web.DHCMGPERSON).GetSortDep("NUR")
   s ln=$L(ret,"^")
   s datatb=""
   d ##class(User.DHCNURMGQualItm).GetQualItm("Qual",.Qual)
    s quret=""
    s colwidth=""
    s head=""
    b //
    s q="" f  s q=$O(Qual(q)) q:q=""  d
	.s colwidth=colwidth_"100|"
	.s ht=Qual(q)
	.s itmname=$P(ht,"|",1)
	.s head=head_itmname_"|"
	.b
	s head="科  室|总  分|"_head
	s colwidth="200|100|"_colwidth
    for i=1:1:ln
    {
	   s itm=$P(ret,"^",i)
       s ret1=""
	   if itm="" continue
	   s dep=$P(itm,"|",1),depdes=$P(itm,"|",2)
	   if (dep'=loc)&(loc'="") q
	   s q="" f  s q=$O(Qual(q)) q:q=""  d
	   .if $D(TMP(dep,q)) d
	   ..s ret1=ret1_TMP(dep,q)_$C(1)
	   .e  d
	   ..s ret1=ret1_$C(1)
	  s quret=quret_depdes_$C(1)_$G(TMPSUM(dep))_$C(1)_ret1_"^"
	   
    }
	s quret=head_$C(2)_colwidth_$C(2)_quret
   q quret
}

ClassMethod GetDepQual(loc, stdate, edate) As %String
{
  //s a=##class(web.DHCNURMGQUAL).GetDepQual()
   // s loc="",stdate="2009-12-1",edate="2009-12-25"
  	s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
    f date=stdate:1:edate
    {
		s dep=""  f  s dep=$O(^User.DHCMGNURQualReportI("DepDate",dep)) q:dep=""  d
		.q:($Tr(dep," ","")'=loc)&(loc'="")
		.w !,dep_"|"
		.s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate",dep,date,rw)) q:rw=""  d
        ..s a=^User.DHCMGNURQualReportD(rw)
        ..s depdr=$List(a,3)
        ..if depdr=""  q
        ..s checpoint=$List(a,10)
        ..s checrpdr=$List(a,7)
        ..s TMP(depdr,checrpdr)=$G(TMP(depdr,checrpdr))+checpoint
       
    }
   s ret=##class(web.DHCMGPERSON).GetSortDep("NUR")
   s ln=$L(ret,"^")
   s datatb=""
   s colwidth=""
   d ##class(User.DHCNURMGQualItm).GetQualItm("Qual",.Qual)
   s quret="",head=""
	   s q="" f  s q=$O(Qual(q)) q:q=""  d
       .s quitm=$P(Qual(q),"|"),percent=$P(Qual(q),"|",2)
       .//s head=head_quitm_"|"
       .//s colwidth=colwidth_"50|"
       .s itmcount=0
       .s depcount=0
       .f i=1:1:ln d
	   ..s itm=$P(ret,"^",i)
	   ..if itm="" q
	   ..s dep=$P(itm,"|",1),depdes=$P(itm,"|",2)
	   ..q:dep'=loc&(loc'="")
	   ..if $D(TMP(dep,q)) d
	   ...s quret=quret_quitm_$C(1)_depdes_$C(1)_TMP(dep,q)_"^"
	   ...s itmcount=itmcount+TMP(dep,q)
	   ...s depcount=depcount+1
	   ..e  d
	   ...s quret=quret_quitm_$C(1)_depdes_$C(1)_"^"
	   .if depcount'=0 s avg=itmcount/depcount
	   .e  s avg=""
       .s quret=quret_quitm_$C(1)_"---"_$C(1)_avg_"^"
	s head="指  标|科  室|总分|"  
	s colwidth="100|270|150"
	s quret=head_$C(2)_colwidth_$C(2)_quret
   q quret
}

ClassMethod GetNurQualDepExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s parr="2009-04-13^2009-04-13^"
 	s loc=$P(parr,"^",3)
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
     f date=stdate:1:edate
    {
		s dep=""  f  s dep=$O(^User.DHCMGNURQualReportI("DepDate",dep)) q:dep=""  d
		.q:($Tr(dep," ","")'=loc)&(loc'="")
		.w !,dep_"|"
		.s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate",dep,date,rw)) q:rw=""  d
        ..s a=^User.DHCMGNURQualReportD(rw)
        ..s depdr=$List(a,3)
        ..s checpoint=$List(a,10)
        ..s checrpdr=$List(a,7)
        ..s TMP(depdr,checrpdr)=$G(TMP(depdr,checrpdr))+checpoint
       
    }
   s ret=##class(web.DHCMGPERSON).GetSortDep("NUR")
   s ln=$L(ret,"^")
   s datatb=""
   d ##class(User.DHCNURMGQualItm).GetQualItm("Qual",.Qual)
   s quret="",head=""
	   s q="" f  s q=$O(Qual(q)) q:q=""  d
       .s quitm=$P(Qual(q),"|"),percent=$P(Qual(q),"|",2)
       .s itmcount=0
       .s depcount=0
       .f i=1:1:ln d
	   ..s itm=$P(ret,"^",i)
	   ..if itm="" q
	   ..s dep=$P(itm,"|",1),depdes=$P(itm,"|",2)
	   ..if $D(TMP(dep,q)) d
	   ...s quret=quret_quitm_$C(1)_depdes_$C(1)_TMP(dep,q)_"^"
	   ...s itmName=quitm,sumcount=TMP(dep,q)
	   ...s itmcount=itmcount+TMP(dep,q)
	   ...s depcount=depcount+1
	   ...d OutRowtyp
	   ..e  d
	   ...s itmName=quitm,sumcount=""
	   ...d OutRowtyp
	   .if depcount'=0 s avg=itmcount/depcount
	   .e  s avg=""
	   .s itmName=quitm,depdes="--",sumcount=avg
	   .d OutRowtyp
	//s head="科  室|总分|"_head  
   //	s colwidth="100|70|"_colwidth
	//s quret=head_$C(2)_colwidth_$C(2)_quret
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(itmName,depdes,sumcount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurQualDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurQualDepExecute ]
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
}

ClassMethod GetNurQualDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurQualDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetNurQualDep(parr As %String) As %Query(ROWSPEC = "QualItm,Dep,Percent")
{
}

ClassMethod GetQualDep(date, codeid) As %String
{
  //s a=##class(web.DHCNURMGQUAL).GetQualDep()
    //s loc="1099",stdate="2009-11-22",edate="2009-11-25"
   s QualCode=##class(User.DHCNURMGQualItm).GetQualCode("Qual1")
   s lqn=$L(QualCode,"^")
   s codss="",codw=""
   f i=1:1:lqn d
   .s a=$P(QualCode,"^",i)
   .q:a=""
   .s itm=$P(a,"|",1),titl=$P(a,"|",2)
   .s codss=codss_titl_"|"_itm_"|"
   .s codw=codw_"120|0|"
   b //
   s date=$ZDH(date,3)
   s ret=##class(web.DHCMGPERSON).GetSortDep("NUR")
   s ln=$L(ret,"^")
   s datatb=""
   s colwidth=""
   s quret="",head=""

       f i=1:1:ln d
	   .s itm=$P(ret,"^",i)
	   .if itm="" q
	   .s dep=$P(itm,"|",1),depdes=$P(itm,"|",2)
	   .s rt=""
	   .f j=1:1:lqn  d
       ..s a=$P(QualCode,"^",j)
       ..q:a=""
       ..s itm=$P(a,"|",1),titl=$P(a,"|",2)
	   ..s rp=..getqualpercent(dep,itm,date)
	   ..if rp'="" s rpid=$P(rp,"|",1),point=$P(rp,"|",2)
	   ..e  s rpid="",point=""
	   ..s rt=rt_point_$C(1)_rpid_$C(1)
	   .s quret=quret_dep_$C(1)_depdes_$C(1)_rt_"^"
	s head="rw|科  室|"_codss 
	s colwidth="0|270|"_codw
	s quret=head_$C(2)_colwidth_$C(2)_quret
   q quret
}

ClassMethod getqualpercent(dep, qual, date)
{
	    s ret=""
	    s dep=" "_dep
		s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate",dep,date,rw)) q:rw=""  d
        .s a=^User.DHCMGNURQualReportD(rw)
        .s checrpdr=$List(a,7)
        .q:checrpdr'=qual
        .s depdr=$List(a,3)
        .s checpoint=$List(a,10)
        .s ret=rw_"|"_checpoint
       q ret
}

ClassMethod GetMgCpRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="2009-12-1^2009-12-18"
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s itm=$P(parr,"^",3)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=stdate:1:edate
    { 
		s citm=""  f  s citm=$O(^User.DHCMGNURCPReportI("Date",date,citm)) q:citm=""  d
		.s rw=""  f  s rw=$O(^User.DHCMGNURCPReportI("Date",date,citm,rw)) q:rw=""  d
		..b
		..d out 
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (stdate,endate,cpitm,title,cpuser,cpmem,cpdate,cptime,status)=""
    s a=^User.DHCMGNURCPReportD(rw)
    s depdr=$List(a,3)
    //q:depdr=""
    s title=$List(a,11)
    s cpdate=$List(a,2)
    s cptime=$List(a,7)
    s cpuser=$List(a,10)
    q:cpuser=""
    s cpitm=$List(a,5)
    s cpmem=$List(a,8)
    s status=$List(a,9)
    s stdate=$List(a,6)
    s endate=$List(a,4)
    s stdate=$ZD(stdate,3)
    s endate=$ZD(endate,3)
    s cptime=$ZT(cptime)
    if status="N" s status="新建"
    if status="A" s status="完成"
    s b=^User.DHCNURMGQualItmD(cpitm)
    s cpitm=$List(b,4)
    s cpcode=$List(b,5)
    s cpdate=$ZD(cpdate,3)
  	s parr=^User.DHCMGPersonsD(cpuser)
    s cpuser=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(stdate,endate,cpitm,title,cpuser,cpmem,cpdate,cptime,status,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgCpRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgCpRecExecute ]
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
}

ClassMethod GetMgCpRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgCpRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMgCpRec(parr As %String) As %Query(ROWSPEC = "stdate,endate,cpitm,title,cpuser,cpmem,cpdate,cptime,cpstatus,rw")
{
}

ClassMethod GetAverage(CRepId, loc) As %String
{
  //s a=##class(web.DHCNURMGQUAL).GetAverage
      s rw="" f  s rw=$O(^User.DHCMGNURQualReportI("CP",CRepId,rw)) q:rw=""  d
     .s a=^User.DHCMGNURQualReportD(rw)
     .s point=$ListGet(a,10),cnurse=$ListGet(a,11)
     .s parr=^User.DHCMGPersonsD(cnurse)
     .s dep=$listget(parr,7)
     .q:dep=""!(cnurse="")
     .s AVE(dep,cnurse)=$G(AVE(dep,cnurse))+point
     .s AVECount(dep,cnurse)=$G(AVECount(dep,cnurse))+1
    
      s ret=##class(web.DHCMGPERSON).GetSortDep("NUR")
      s ln=$L(ret,"^")
      s n=1
      s data=""
     f i=1:1:ln
     {
	  s itm=$P(ret,"^",i)
	  
	  s dep=$P(itm,"|"),depdes=$P(itm,"|",2)
	  q:dep=""
	  q:(loc'=dep)&(loc'="")
      s per="" f  s per=$O(AVE(dep,per)) q:per=""  d
      .b
      .s sum=AVE(dep,per),count=AVECount(dep,per) 
      .s average=sum/count
      .s parr=^User.DHCMGPersonsD(per)
      .s nurse=$list(parr,21)
      .s data=data_depdes_$c(1)_nurse_$C(1)_average_$C(1)_count_$C(1)_sum_$C(1)_n_"^"
      .s n=n+1
     }
     s head="科室|被测人|平均分|份数|总分|序号|"
     s colwid="200|100|100|100|100|50|"
     s data=head_$C(2)_colwid_$C(2)_data
     q data
}

ClassMethod GetMgNurTurnExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="2009-12-1^2009-12-18"
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=stdate:1:edate
    { 
		s rw=""  f  s rw=$O(^User.DHCMGTurnPlanI("Date",date,rw)) q:rw=""  d
		.b
		.d out 
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (stdate,endate,cpuser,cpmem,cpdate,cptime,cpstatus)=""
    s a=^User.DHCMGTurnPlanD(rw)
    //q:depdr=""
    s cpdate=$List(a,2)
    s cptime=$List(a,4)
    s cpuser=$List(a,3)
    q:cpuser=""
    s cpmem=$List(a,7)
    s cpstatus=$Listget(a,8)
    if cpstatus="A" s cpstatus="完成"
    e  s cpstatus="新建"
    s stdate=$List(a,6)
    s endate=$List(a,5)
    s stdate=$ZD(stdate,3)
    s endate=$ZD(endate,3)
    s cptime=$ZT(cptime)
    s cpdate=$ZD(cpdate,3)
  	s parr=^User.DHCMGPersonsD(cpuser)
    s cpuser=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(stdate,endate,cpuser,cpmem,cpdate,cptime,cpstatus,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgNurTurnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgNurTurnExecute ]
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
}

ClassMethod GetMgNurTurnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgNurTurnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMgNurTurn(parr As %String) As %Query(ROWSPEC = "stdate,endate,cpuser,cpmem,cpdate,cptime,cpstatus,rw")
{
}

/// Creator:	wxl
/// CreatDate: 	2010-06-01
/// Description:取工作量项目对应的科室
/// Table：		User.DHCMGNurWorkRelatDep
/// Input：		Itm:工作量项目ID
/// Return：	DepName:科室名称,DepPercent:分值,rw:ROWID
ClassMethod GetItmRelDepExecute(ByRef qHandle As %Binary, Itm As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCNURMGQUAL","GetItmRelDep","1")
    s DepName="",DepPercent=""
    s rw=""  f  s rw=$O(^User.DHCMGNurWorkRelatDepI("WorkItm",Itm,rw)) q:rw=""  d
    .s a=^User.DHCMGNurWorkRelatDepD(rw)
    .s RelDepId=$ListGet(a,3)
    .i RelDepId'="" s DepName=$P(^CTLOC(RelDepId),"^",2)
    .e  s DepName=""
    .s DepPercent=$ListGet(a,4)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepName,DepPercent,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetItmRelDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItmRelDepExecute ]
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
}

ClassMethod GetItmRelDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItmRelDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetItmRelDep(Itm As %String) As %Query(ROWSPEC = "DepName,DepPercent,rw")
{
}

Query GetMgQualBQ(parr2 As %String) As %Query(ROWSPEC = "dep,WZTHJC,WZTHHGL,WZTHPJF,WZPTJC,WZPTPJF,WZPTHGL,JCHLJC,JCHLPJF,JCHLHGL,JKJYJC,JKJYPJF,JKJYHGL,HLBLJC,HLBLPJF,HLBLHGL,XDGLJC,XDGLPJF,XDGLHGL,QJWPPJF,JSCZPJF,GWYQPJF,BFGLPJF,CZWTINFO")
{
}

ClassMethod GetMgQualBQExecute(ByRef qHandle As %Binary, parr2 As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^tmpe123(1)=parr2
 	//补贴调节记录
 	//s parr="2009-011-18^2009-12-18"
 	s stdate=$P(parr2,"^",1)
 	s edate=$P(parr2,"^",2)
 	s loc=$P(parr2,"^",3)
 	s itm=$P(parr2,"^",4)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	s nurtype=$P(parr2,"^",5)
 	s UserCode=$P(parr2,"^",6)
 	q:nurtype=""
 	s factnurtype=##class(Nur.DHCNURLocData).gettype(UserCode)
 	i nurtype="科护士长" d
 	.s depKnurstring=##class(web.DHCNURMGQUAL).getlocBigSY(UserCode)
 	
 	
 	;s depdes="科室"
 	s depdes=""
    s WZTHJC="检查例数"
    s WZTHPJF="平均分"
    s WZTHHGL="合格率"
    
    s WZPTJC="检查例数"
    s WZPTPJF="平均分"
    s WZPTHGL="合格率"
  
    s JCHLJC="检查例数"
    s JCHLPJF="平均分"
    s JCHLHGL="合格率"
    s JKJYJC="检查例数"
    s JKJYPJF="平均分"
    s JKJYHGL="合格率"
    s HLBLJC="检查例数"
    s HLBLPJF="平均分"
    s HLBLHGL="合格率"
    s XDGLJC="检查例数"
    s XDGLPJF="平均分"
    s XDGLHGL="合格率"
    s QJWPPJF="平均分数"
    s JSCZPJF="平均分数"
    s GWYQPJF="平均分数"
    s BFGLPJF="平均分数"
    s CZWTINFO=""

 	d OutRowtypSY2
 	
 	s typ="BQQUAL"
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s BQrw=""  f  s BQrw=$O(^User.DHCMGArrangPerSortI("Typ"," "_typ,BQrw)) q:BQrw=""  d
    .s dep=$List(^User.DHCMGArrangPerSortD(BQrw),4)
    .q:(nurtype="护士长")&(loc'=dep)
    .s deptmp2="^"_dep_"^"
    .s depKnurstring=$g(depKnurstring)
    .;q:(nurtype="科护士长")&(depKnurstring'[deptmp2)
    .q:(nurtype="科护士长")&(depKnurstring'[deptmp2)&(factnurtype'="护理部")
    .q:(nurtype="科护士长")&(factnurtype="护理部")&(loc'=dep)
    .s curWZTHLS=0,curWZTHZF=0,curWZTHJG=0
    .s curWZPTLS=0,curWZPTZF=0,curWZPTJG=0
    .s curJCHLLS=0,curJCHLZF=0,curJCHLJG=0
    .s curJKJYLS=0,curJKJYZF=0,curJKJYJG=0
    .s curHLBLLS=0,curHLBLZF=0,curHLBLJG=0
    .s curXDGLLS=0,curXDGLZF=0,curXDGLJG=0
    .s curQJWPLS=0,curQJWPZF=0
    .s curJSCZLS=0,curJSCZZF=0
    .s curGWYQLS=0,curGWYQZF=0
    .s curBFGLLS=0,curBFGLZF=0
    .s WZTHCZWT="",WZPTCZWT="",JCHLCZWT="",JKJYCZWT="",HLBLCZWT=""
    .s XDGLCZWT="",QJWPCZWT="",JSCZCZWT="",GWYQCZWT="",BFGLCZWT=""
    .f date=stdate:1:edate  d
	..s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate"," "_dep,date,rw)) q:rw=""  d
	...s cururtype=$Listget(^User.DHCMGNURQualReportD(rw),13)
    ...q:cururtype'=nurtype                     ///////////
    ...s checrpdr=$Listget(^User.DHCMGNURQualReportD(rw),7)
    ...s a=^User.DHCNURMGQualItmD(checrpdr)
    ...s cpcode=$List(a,5)
    ...q:cpcode'["Qual"
    ...s tmppoint=$Listget(^User.DHCMGNURQualReportD(rw),10)
    ...s tmpmem=$Listget(^User.DHCMGNURQualReportD(rw),4)
    ...i cpcode="Qual20" d
    ....s curWZTHLS=curWZTHLS+1
    ....s WZTHpoint=$Listget(a,7)
    ....i tmppoint'<WZTHpoint s curWZTHJG=curWZTHJG+1
    ....s curWZTHZF=curWZTHZF+tmppoint
    ....i WZTHCZWT="" s WZTHCZWT="危重病人(-):"_tmpmem
    ....e  s WZTHCZWT=WZTHCZWT_","_tmpmem 
    ...;;;;;;;;;;;;
    ...i cpcode="Qual21" d
    ....s curWZPTLS=curWZPTLS+1
    ....s WZPTpoint=$Listget(a,7)
    ....i tmppoint'<WZPTpoint s curWZPTJG=curWZPTJG+1
    ....s curWZPTZF=curWZPTZF+tmppoint
    ....i WZPTCZWT="" s WZPTCZWT="危重病人(二):"_tmpmem
    ....e  s WZPTCZWT=WZPTCZWT_","_tmpmem
    ...;;;;;;;
    ...i cpcode="Qual22" d
    ....s curJCHLLS=curJCHLLS+1
    ....s JCHLpoint=$Listget(a,7)
    ....i tmppoint'<JCHLpoint s curJCHLJG=curJCHLJG+1
    ....s curJCHLZF=curJCHLZF+tmppoint
    ....i JCHLCZWT="" s JCHLCZWT="基础护理:"_tmpmem
    ....e  s JCHLCZWT=JCHLCZWT_","_tmpmem
    ...;;;;
    ...i cpcode="Qual23" d
    ....s curJKJYLS=curJKJYLS+1
    ....s JKJYpoint=$Listget(a,7)
    ....i tmppoint'<JKJYpoint s curJKJYJG=curJKJYJG+1
    ....s curJKJYZF=curJKJYZF+tmppoint
    ....i JKJYCZWT="" s JKJYCZWT="健康教育:"_tmpmem
    ....e  s JKJYCZWT=JKJYCZWT_","_tmpmem
    ...;;;;;
    ...i cpcode="Qual24" d
    ....s curHLBLLS=curHLBLLS+1
    ....s HLBLpoint=$Listget(a,7)
    ....i tmppoint'<HLBLpoint s curHLBLJG=curHLBLJG+1
    ....s curHLBLZF=curHLBLZF+tmppoint
    ....i HLBLCZWT="" s HLBLCZWT="护理病历:"_tmpmem
    ....e  s HLBLCZWT=HLBLCZWT_","_tmpmem
    ...;;;
    ...i cpcode="Qual25" d
    ....s curXDGLLS=curXDGLLS+1
    ....s XDGLpoint=$Listget(a,7)
    ....i tmppoint'<XDGLpoint s curXDGLJG=curXDGLJG+1
    ....s curXDGLZF=curXDGLZF+tmppoint
    ....i XDGLCZWT="" s XDGLCZWT="消毒隔离:"_tmpmem
    ....e  s XDGLCZWT=XDGLCZWT_","_tmpmem
    ...;
    ...i cpcode="Qual26" d
    ....s curQJWPLS=curQJWPLS+1
    ....s curQJWPZF=curQJWPZF+tmppoint
    ....i QJWPCZWT="" s QJWPCZWT="抢救物品:"_tmpmem
    ....e  s QJWPCZWT=QJWPCZWT_","_tmpmem
    ...;
    ...i cpcode="Qual27" d
    ....s curJSCZLS=curJSCZLS+1
    ....s curJSCZZF=curJSCZZF+tmppoint
    ....i JSCZCZWT="" s JSCZCZWT="技术操作:"_tmpmem
    ....e  s JSCZCZWT=JSCZCZWT_","_tmpmem
    ...;
    ...i cpcode="Qual28" d
    ....s curGWYQLS=curGWYQLS+1
    ....s curGWYQZF=curGWYQZF+tmppoint
    ....i GWYQCZWT="" s GWYQCZWT="岗位要求:"_tmpmem
    ....e  s GWYQCZWT=GWYQCZWT_","_tmpmem
    ...;
    ...i cpcode="Qual29" d
    ....s curBFGLLS=curBFGLLS+1
    ....s curBFGLZF=curBFGLZF+tmppoint
    ....i BFGLCZWT="" s BFGLCZWT="病房管理:"_tmpmem
    ....e  s BFGLCZWT=BFGLCZWT_","_tmpmem
    .s depdes=$P(^CTLOC(dep),"^",2)
    .i depdes["-" s depdes=$p(depdes,"-",2)
    .s WZTHJC=curWZTHLS
    .i WZTHJC=0 d
    ..s WZTHPJF=0
    ..s WZTHHGL=0 
    .e  s WZTHPJF=$Fn(curWZTHZF/curWZTHLS,"",1)
    .i curWZTHJG=0 d
    ..s WZTHHGL=0
    .e  d
    ..i (curWZTHJG'=0)&(WZTHJC'=0) d
    ...s WZTHHGL=$fn(curWZTHJG/WZTHJC,"",2)
    ...i WZTHHGL="1.00" s WZTHHGL="100"_"%"
    ...e  s WZTHHGL=$p(WZTHHGL,".",2)_"%"
    ...;;;;;;;;;;;;;;;;;;
    .s WZPTJC=curWZPTLS
    .i WZPTJC=0 d
    ..s WZPTPJF=0
    ..s WZPTHGL=0 
    .e  s WZPTPJF=$Fn(curWZPTZF/curWZPTLS,"",1)
    .i curWZPTJG=0 d
    ..s WZPTHGL=0
    .e  d
    ..i (curWZPTJG'=0)&(WZPTJC'=0) d
    ...s WZPTHGL=$fn(curWZPTJG/WZPTJC,"",2)
    ...i WZPTHGL="1.00" s WZPTHGL="100"_"%"
    ...e  s WZPTHGL=$p(WZPTHGL,".",2)_"%"
    .;;;;;;;;;;
    .s JCHLJC=curJCHLLS
    .i JCHLJC=0 d
    ..s JCHLPJF=0
    ..s JCHLGL=0 
    .e  s JCHLPJF=$Fn(curJCHLZF/curJCHLLS,"",1)
    .i curJCHLJG=0 d
    ..s JCHLGL=0
    .e  d
    ..i (curJCHLJG'=0)&(JCHLJC'=0) d
    ...s JCHLHGL=$fn(curJCHLJG/JCHLJC,"",2)
    ...i JCHLHGL="1.00" s JCHLHGL="100"_"%"
    ...e  s JCHLHGL=$p(JCHLHGL,".",2)_"%"
    .;;;;;;
    .s JKJYJC=curJKJYLS
    .i JKJYJC=0 d
    ..s JKJYPJF=0
    ..s JKJYGL=0 
    .e  s JKJYPJF=$Fn(curJKJYZF/curJKJYLS,"",1)
    .i curJKJYJG=0 d
    ..s JKJYHGL=0
    .e  d
    ..i (curJKJYJG'=0)&(JKJYJC'=0) d
    ...s JKJYHGL=$fn(curJKJYJG/JKJYJC,"",2)
    ...i JKJYHGL="1.00" s JKJYHGL="100"_"%"
    ...e  s JKJYHGL=$p(JKJYHGL,".",2)_"%"
    .;;;;;;;;;;;;
    .s HLBLJC=curHLBLLS
    .i HLBLJC=0 d
    ..s HLBLPJF=0
    ..s HLBLGL=0 
    .e  s HLBLPJF=$Fn(curHLBLZF/curHLBLLS,"",1)
    .i curHLBLJG=0 d
    ..s HLBLHGL=0
    .e  d
    ..i (curHLBLJG'=0)&(HLBLJC'=0) d
    ...s HLBLHGL=$fn(curHLBLJG/HLBLJC,"",2)
    ...i HLBLHGL="1.00" s HLBLHGL="100"_"%"
    ...e  s HLBLHGL=$p(HLBLHGL,".",2)_"%"
    .;
    .s XDGLJC=curXDGLLS
    .i XDGLJC=0 d
    ..s XDGLPJF=0
    ..s XDGLGL=0 
    .e  s XDGLPJF=$Fn(curXDGLZF/curXDGLLS,"",1)
    .i curXDGLJG=0 d
    ..s XDGLHGL=0
    .e  d
    ..i (curXDGLJG'=0)&(XDGLJC'=0) d
    ...s XDGLHGL=$fn(curXDGLJG/XDGLJC,"",2)
    ...i XDGLHGL="1.00" s XDGLHGL="100"_"%"
    ...e  s XDGLHGL=$p(XDGLHGL,".",2)_"%"
    .;
    .s QJWPJC=curQJWPLS
    .i QJWPJC=0 d
    ..s QJWPPJF=0
    .e  s QJWPPJF=$Fn(curQJWPZF/curQJWPLS,"",1)
    .;
    .s JSCZJC=curJSCZLS
    .i JSCZJC=0 d
    ..s JSCZPJF=0
    .e  s JSCZPJF=$Fn(curJSCZZF/curJSCZLS,"",1)
    .;
    .s GWYQJC=curGWYQLS
    .i GWYQJC=0 d
    ..s GWYQPJF=0
    .e  s GWYQPJF=$Fn(curGWYQZF/curGWYQLS,"",1)
    .;
    .s BFGLJC=curBFGLLS
    .i BFGLJC=0 d
    ..s BFGLPJF=0
    .e  s BFGLPJF=$Fn(curBFGLZF/curBFGLLS,"",1)
    .s CZWTINFO=WZTHCZWT_" "_WZPTCZWT_" "_JCHLCZWT_" "_JKJYCZWT_" "_HLBLCZWT_" "_XDGLCZWT_" "_QJWPCZWT_" "_JSCZCZWT_" "_GWYQCZWT_" "_BFGLCZWT

    .d OutRowtypSY2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK


  
OutRowtypSY2
	set Data=$lb(depdes,WZTHJC,WZTHHGL,WZTHPJF,WZPTJC,WZPTPJF,WZPTHGL,JCHLJC,JCHLPJF,JCHLHGL,JKJYJC,JKJYPJF,JKJYHGL,HLBLJC,HLBLPJF,HLBLHGL,XDGLJC,XDGLPJF,XDGLHGL,QJWPPJF,JSCZPJF,GWYQPJF,BFGLPJF,CZWTINFO)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgQualBQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgQualBQExecute ]
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
}

ClassMethod GetMgQualBQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgQualBQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getlocBigSY(UserId As %String) As %String
{
  s ret=""
	q:UserId=""
	s UserId=$zconvert(UserId,"U")
	s rw="" s rw=$o(^Nur.DHCNURLocDataI("UserId"," "_UserId,rw))
	i rw'="" d
	.s chl="" f  s chl=$o(^Nur.DHCNURLocDataSubD(rw,chl)) q:chl=""  d
	..s rowid=rw_"||"_chl
	..s obj=##class(Nur.DHCNURLocDataSub).%OpenId(rowid)
	..s loc=obj.Loc
	..q:loc=""
	..i ret="" s ret="^"_loc_"^"
	..e  s ret=ret_"^"_loc_"^"
	q ret
}

Query GetMgQualMZ(parr2 As %String) As %Query(ROWSPEC = "dep,ZHPJF,XDGLPJF,CZWTINFO")
{
}

ClassMethod GetMgQualMZExecute(ByRef qHandle As %Binary, parr2 As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCNURMGQUAL","GetMgQualBQ","2013-01-23^2013-01-23^195^^科护士长^xcr")
 	//s ^tmpe123(1)=parr2   
 	//s parr="2009-011-18^2009-12-18"
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s stdate=$P(parr2,"^",1)
 	s edate=$P(parr2,"^",2)
 	s loc=$P(parr2,"^",3)
 	s itm=$P(parr2,"^",4)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	s nurtype=$P(parr2,"^",5)
 	s UserCode=$P(parr2,"^",6)
 	q:nurtype=""
 	s factnurtype=##class(Nur.DHCNURLocData).gettype(UserCode)
 	i nurtype="科护士长" d
 	.s depKnurstring=##class(web.DHCNURMGQUAL).getlocBigSY(UserCode)
 	s dep=""
 	s ZHPJF="平均分"
 	s XDGLPJF="平均分"
    s CZWTINFO=""
 	d OutRowtypSY3
 	
 	s typ="MZQUAL"
 	s BQrw=""  f  s BQrw=$O(^User.DHCMGArrangPerSortI("Typ"," "_typ,BQrw)) q:BQrw=""  d
    .s depdr=$List(^User.DHCMGArrangPerSortD(BQrw),4)
    .q:(nurtype="护士长")&(loc'=depdr)
    .s deptmp2="^"_depdr_"^"
    .s depKnurstring=$g(depKnurstring)
    .;q:(nurtype="科护士长")&(depKnurstring'[deptmp2)
    .q:(nurtype="科护士长")&(depKnurstring'[deptmp2)&(factnurtype'="护理部")
    .q:(nurtype="科护士长")&(factnurtype="护理部")&(loc'=depdr)
    .s curXDGLLS=0,curXDGLZF=0
    .s curZHLS=0,curZHZF=0
    .s XDGLCZWT="",ZHCZWT=""
    .f date=stdate:1:edate  d
	..s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate"," "_depdr,date,rw)) q:rw=""  d
	...s cururtype=$Listget(^User.DHCMGNURQualReportD(rw),13)
    ...q:cururtype'=nurtype                     ///////////
    ...s checrpdr=$Listget(^User.DHCMGNURQualReportD(rw),7)
    ...s a=^User.DHCNURMGQualItmD(checrpdr)
    ...s cpcode=$List(a,5)
    ...q:cpcode'["Qual"
    ...s tmppoint=$Listget(^User.DHCMGNURQualReportD(rw),10)
    ...s tmpmem=$Listget(^User.DHCMGNURQualReportD(rw),4)
    ...i cpcode="Qual25" d
    ....s curXDGLLS=curXDGLLS+1
    ....s XDGLpoint=$Listget(a,7)
    ....i tmppoint'<XDGLpoint s curXDGLJG=curXDGLJG+1
    ....s curXDGLZF=curXDGLZF+tmppoint
    ....i XDGLCZWT="" s XDGLCZWT="消毒隔离:"_tmpmem
    ....e  s XDGLCZWT=XDGLCZWT_","_tmpmem
    ...e  d
    ....s curZHLS=curZHLS+1
    ....s curZHZF=curZHZF+tmppoint
    ....i ZHCZWT="" s ZHCZWT="综合质量:"_tmpmem
    ....e  s ZHCZWT=ZHCZWT+tmppoint
    .s dep=$P(^CTLOC(depdr),"^",2)
    .i dep["-" s dep=$p(dep,"-",2)
    .;S dep=depdes
    .;
    .i curZHLS=0 d
    ..s ZHPJF=0
    ..e  s ZHPJF=$Fn(curZHZF/curZHLS,"",1)
    .;
    .s XDGLJC=curXDGLLS
    .i XDGLJC=0 d
    ..s XDGLPJF=0
    ..e  s XDGLPJF=$Fn(curXDGLZF/curXDGLLS,"",1)
    .;
    .s CZWTINFO=ZHCZWT
    .i CZWTINFO="" d
    ..s CZWTINFO=CZWTINFO_","_XDGLCZWT
    .d OutRowtypSY3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtypSY3
	set Data=$lb(dep,ZHPJF,XDGLPJF,CZWTINFO)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgQualMZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgQualMZExecute ]
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
}

ClassMethod GetMgQualMZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgQualMZExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMgQualTS(parr2 As %String) As %Query(ROWSPEC = "dep,ZHPJF,XDGLPJF,CZWTINFO")
{
}

ClassMethod GetMgQualTSExecute(ByRef qHandle As %Binary, parr2 As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s ^tmpe123(1)=parr2   
 	//s parr="2009-011-18^2009-12-18"
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s stdate=$P(parr2,"^",1)
 	s edate=$P(parr2,"^",2)
 	s loc=$P(parr2,"^",3)
 	s itm=$P(parr2,"^",4)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	s nurtype=$P(parr2,"^",5)
 	s UserCode=$P(parr2,"^",6)
 	q:nurtype=""
 	s factnurtype=##class(Nur.DHCNURLocData).gettype(UserCode)
 	i nurtype="科护士长" d
 	.s depKnurstring=##class(web.DHCNURMGQUAL).getlocBigSY(UserCode)
 	s dep=""
 	s ZHPJF="平均分"
 	s XDGLPJF="平均分"
    s CZWTINFO=""
 	d OutRowtypSY5
 	
 	s typ="TSCQUAL"
 	s BQrw=""  f  s BQrw=$O(^User.DHCMGArrangPerSortI("Typ"," "_typ,BQrw)) q:BQrw=""  d
    .s depdr=$List(^User.DHCMGArrangPerSortD(BQrw),4)
    .q:(nurtype="护士长")&(loc'=depdr)
    .s deptmp2="^"_depdr_"^"
    .s depKnurstring=$g(depKnurstring)
    .;q:(nurtype="科护士长")&(depKnurstring'[deptmp2)
    .q:(nurtype="科护士长")&(depKnurstring'[deptmp2)&(factnurtype'="护理部")
    .q:(nurtype="科护士长")&(factnurtype="护理部")&(loc'=depdr)
    .s curXDGLLS=0,curXDGLZF=0
    .s curZHLS=0,curZHZF=0
    .s XDGLCZWT="",ZHCZWT=""
    .f date=stdate:1:edate  d
	..s rw=""  f  s rw=$O(^User.DHCMGNURQualReportI("DepDate"," "_depdr,date,rw)) q:rw=""  d
	...s cururtype=$Listget(^User.DHCMGNURQualReportD(rw),13)
    ...q:cururtype'=nurtype                     ///////////
    ...s checrpdr=$Listget(^User.DHCMGNURQualReportD(rw),7)
    ...s a=^User.DHCNURMGQualItmD(checrpdr)
    ...s cpcode=$List(a,5)
    ...q:cpcode'["Qual"
    ...s tmppoint=$Listget(^User.DHCMGNURQualReportD(rw),10)
    ...s tmpmem=$Listget(^User.DHCMGNURQualReportD(rw),4)
    ...i cpcode="Qual25" d
    ....s curXDGLLS=curXDGLLS+1
    ....s XDGLpoint=$Listget(a,7)
    ....i tmppoint'<XDGLpoint s curXDGLJG=curXDGLJG+1
    ....s curXDGLZF=curXDGLZF+tmppoint
    ....i XDGLCZWT="" s XDGLCZWT="消毒隔离:"_tmpmem
    ....e  s XDGLCZWT=XDGLCZWT_","_tmpmem
    ...e  d
    ....s curZHLS=curZHLS+1
    ....s curZHZF=curZHZF+tmppoint
    ....i ZHCZWT="" s ZHCZWT="综合质量:"_tmpmem
    ....e  s ZHCZWT=ZHCZWT+tmppoint
    .s dep=$P(^CTLOC(depdr),"^",2)
    .i dep["-" s dep=$p(dep,"-",2)
    .;S dep=depdes
    .;
    .i curZHLS=0 d
    ..s ZHPJF=0
    ..e  s ZHPJF=$Fn(curZHZF/curZHLS,"",1)
    .;
    .s XDGLJC=curXDGLLS
    .i XDGLJC=0 d
    ..s XDGLPJF=0
    ..e  s XDGLPJF=$Fn(curXDGLZF/curXDGLLS,"",1)
    .;
    .s CZWTINFO=ZHCZWT
    .i CZWTINFO="" d
    ..s CZWTINFO=CZWTINFO_","_XDGLCZWT
    .d OutRowtypSY5
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtypSY5
	set Data=$lb(dep,ZHPJF,XDGLPJF,CZWTINFO)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgQualTSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgQualTSExecute ]
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
}

ClassMethod GetMgQualTSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgQualTSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCNURMGQUALDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNURMGQUALD</DataLocation>
<DefaultData>DHCNURMGQUALDefaultData</DefaultData>
<IdLocation>^web.DHCNURMGQUALD</IdLocation>
<IndexLocation>^web.DHCNURMGQUALI</IndexLocation>
<StreamLocation>^web.DHCNURMGQUALS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
